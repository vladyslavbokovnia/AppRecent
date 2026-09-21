package com.statusoverlay.app

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.RectF
import android.graphics.Shader
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.net.Uri
import android.provider.Settings
import android.view.Gravity
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.HorizontalScrollView
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.FrameLayout
import android.widget.PopupMenu
import android.widget.ScrollView
import android.widget.TextView
import android.widget.Toast
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.content.BroadcastReceiver
import android.content.IntentFilter
import android.os.BatteryManager
import java.util.concurrent.Executors

class OverlayService : AccessibilityService() {
    private lateinit var windowManager: WindowManager
    private lateinit var store: AppStore
    private lateinit var repository: AppRepository
    private val handler = Handler(Looper.getMainLooper())
    private val bgExecutor = Executors.newSingleThreadExecutor()
    private var refreshGeneration = 0
    private val iconCache = android.util.LruCache<String, Drawable.ConstantState>(300)
    private var root: PullLayout? = null
    private var scroll: HorizontalScrollView? = null
    private var content: LinearLayout? = null
    private var entries: List<AppEntry> = emptyList()
    private var active = false
    private var page = 0
    private var pageCount = 1
    private var pageIndicator: TextView? = null
    private var overlayHeightPx = 128
    private var renderedIconSize = -1
    private var renderedGradientAlpha = -1
    private var renderedExpanded = false
    private var renderedExpandedBgAlpha = -1
    private var expandedNow = false
    private var noFade = false
    private var batteryBar: BatteryBarView? = null
    private var batteryCharging = false
    private var edgeHandle: View? = null
    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: android.content.Context?, intent: Intent?) {
            val level = intent?.getIntExtra("level", -1) ?: return
            val scale = intent.getIntExtra("scale", -1)
            val status = intent.getIntExtra("status", BatteryManager.BATTERY_STATUS_UNKNOWN)
            batteryCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL
            updateBatteryAnimation()
            if (level >= 0 && scale > 0) batteryBar?.setLevel(level.toFloat() / scale.toFloat())
        }
    }

    private val refreshTask = object : Runnable {
        override fun run() { if (active) { refreshList(false); handler.postDelayed(this, 4000L) } }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        try {
            windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
            store = AppStore(this)
            repository = AppRepository(this, store)
            active = true
            expandedNow = false
            createOverlay()
            createBatteryOverlay()
            createEdgeHandle()
            registerReceiver(batteryReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            refreshList(true)
            handler.postDelayed(refreshTask, 4000L)
        } catch (_: Throwable) {
            active = false
            Toast.makeText(this, "AppRecent: не удалось запустить панель", Toast.LENGTH_LONG).show()
        }
    }

    override fun onAccessibilityEvent(event: android.view.accessibility.AccessibilityEvent?) {
        val packageName = event?.packageName?.toString() ?: return
        if (packageName == packageNameOfSelf()) return
        if (event.eventType == android.view.accessibility.AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            store.setActivePackage(packageName)
            handler.removeCallbacks(refreshFromEvent)
            handler.postDelayed(refreshFromEvent, 80L)
        }
    }
    override fun onInterrupt() = Unit

    override fun onDestroy() {
        active = false
        handler.removeCallbacksAndMessages(null)
        bgExecutor.shutdownNow()
        runCatching { unregisterReceiver(batteryReceiver) }
        root?.let { runCatching { windowManager.removeView(it) } }
        batteryBar?.let { runCatching { windowManager.removeView(it) } }
        edgeHandle?.let { runCatching { windowManager.removeView(it) } }
        root = null; scroll = null; content = null
        super.onDestroy()
    }

    private fun createOverlay() {
        val overlayHeight = statusBarHeightPx()
        overlayHeightPx = overlayHeight
        val collapsedWindowHeight = pullCatchHeightPx(overlayHeight)
        val panel = PullLayout(
            this,
            pullEnabled = { store.expandRows() },
            isExpanded = { expandedNow },
            onPull = { expand ->
                expandedNow = expand
                refreshList(false)
            }
        ).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.TOP
            setLayerType(View.LAYER_TYPE_HARDWARE, null)
            setBackgroundColor(Color.TRANSPARENT)
            setPadding(0, 0, 0, 0)
        }
        val horizontal = HorizontalScrollView(this).apply {
            isHorizontalScrollBarEnabled = false
            overScrollMode = View.OVER_SCROLL_NEVER
            isSmoothScrollingEnabled = true
            setLayerType(View.LAYER_TYPE_HARDWARE, null)
            setBackgroundColor(Color.TRANSPARENT)
        }
        val items = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setLayerType(View.LAYER_TYPE_HARDWARE, null)
        }
        val vertical = ScrollView(this).apply {
            isVerticalScrollBarEnabled = false
            overScrollMode = View.OVER_SCROLL_NEVER
            addView(items, FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, overlayHeight))
        }
        horizontal.addView(vertical, FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.MATCH_PARENT))
        panel.addView(horizontal, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, overlayHeight))
        root = panel
        scroll = horizontal
        content = items
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            collapsedWindowHeight,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS or WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
            android.graphics.PixelFormat.TRANSLUCENT
        ).apply { gravity = Gravity.TOP }
        windowManager.addView(panel, params)
    }

    private fun statusBarHeightPx(): Int {
        val id = resources.getIdentifier("status_bar_height", "dimen", "android")
        return if (id != 0) resources.getDimensionPixelSize(id) * 2 else dp(48)
    }

    private fun createBatteryOverlay() {
        val flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
        batteryBar = BatteryBarView(this)
        val lp = WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT, dp(4), WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY, flags or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS or WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN, android.graphics.PixelFormat.TRANSLUCENT).apply {
            gravity = Gravity.BOTTOM
            y = 0
        }
        windowManager.addView(batteryBar, lp)
    }

    private fun updateBatteryAnimation() {
        batteryBar?.setPulsing(batteryCharging)
    }

    private class BatteryBarView(context: android.content.Context) : View(context) {
        private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        private var level = 0f
        private var whiteAlpha = 1f
        private var pulsing = false
        fun setLevel(value: Float) { level = value.coerceIn(0f, 1f); invalidate() }
        fun setPulsing(value: Boolean) {
            pulsing = value
            if (!value) whiteAlpha = 1f
            invalidate()
        }
        override fun onDraw(canvas: android.graphics.Canvas) {
            if (pulsing) {
                val t = (SystemClock.uptimeMillis() % 2400L) / 2400f
                val p = if (t < 0.5f) t * 2f else (1f - t) * 2f
                whiteAlpha = 1f - 0.88f * (p * p * (3f - 2f * p))
            }
            paint.style = Paint.Style.FILL
            paint.color = Color.BLACK
            canvas.drawRect(0f, 0f, width.toFloat(), height.toFloat(), paint)
            paint.color = Color.WHITE
            paint.alpha = (whiteAlpha * 255f).toInt()
            canvas.drawRect(0f, 0f, width * level, height.toFloat(), paint)
            paint.alpha = 255
            if (pulsing) postInvalidateOnAnimation()
        }
    }

    private fun createEdgeHandle() {
        val handle = View(this).apply { setBackgroundColor(Color.TRANSPARENT) }
        val detector = GestureDetector(this, object : GestureDetector.SimpleOnGestureListener() {
            override fun onDown(event: MotionEvent) = true
            override fun onSingleTapUp(event: MotionEvent): Boolean { toggleVisibility(); return true }
            override fun onScroll(first: MotionEvent?, current: MotionEvent, dx: Float, dy: Float): Boolean {
                if (root?.visibility == View.VISIBLE) scroll?.scrollBy(if (store.invertScroll()) dy.toInt() * 2 else -dy.toInt() * 2, 0)
                return true
            }
        })
        handle.setOnTouchListener { _, event -> detector.onTouchEvent(event) }
        edgeHandle = handle
        val lp = WindowManager.LayoutParams(dp(18), -1, WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, android.graphics.PixelFormat.TRANSLUCENT).apply { gravity = Gravity.END }
        windowManager.addView(handle, lp)
    }

    private fun toggleVisibility() {
        root?.let { view ->
            view.visibility = if (view.visibility == View.VISIBLE) View.GONE else View.VISIBLE
            if (view.visibility == View.VISIBLE) { expandedNow = false; refreshList(true) }
        }
    }

    private fun refreshList(scrollToEnd: Boolean) {
        if (!active) return
        val generation = ++refreshGeneration
        bgExecutor.execute {
            val loaded = runCatching { repository.load() }.getOrDefault(emptyList())
            loaded.forEach { entry ->
                if (iconCache.get(entry.packageName) == null && store.customIcon(entry.packageName) == null) {
                    runCatching { iconCache.put(entry.packageName, packageManager.getApplicationIcon(entry.packageName).constantState) }
                }
            }
            handler.post {
                if (!active || generation != refreshGeneration) return@post
                applyList(loaded, scrollToEnd)
            }
        }
    }

    private fun applyList(loaded: List<AppEntry>, scrollToEnd: Boolean) {
        val oldPackages = entries.map { it.packageName }
        entries = loaded
        val target = content ?: return
        val newPackages = loaded.map { it.packageName }
        val iconSize = store.iconSize()
        val gradientAlpha = store.bottomGradientAlpha()
        if (newPackages == oldPackages && iconSize == renderedIconSize && gradientAlpha == renderedGradientAlpha && expandedNow == renderedExpanded && store.expandedBackgroundAlpha() == renderedExpandedBgAlpha) return
        target.removeAllViews()
        val paged = false
        pageCount = 1
        page = 0
        val display = entries
        target.orientation = if (expandedNow) LinearLayout.VERTICAL else LinearLayout.HORIZONTAL
        if (expandedNow) {
            val perRow = maxOf(1, resources.displayMetrics.widthPixels / dp(iconSize))
            display.chunked(perRow).forEachIndexed { rowIndex, chunk ->
                noFade = (rowIndex + 1) * perRow < entries.size
                val row = LinearLayout(this).apply { orientation = LinearLayout.HORIZONTAL; gravity = Gravity.CENTER_VERTICAL }
                chunk.forEach { row.addView(createAppView(it), LinearLayout.LayoutParams(dp(iconSize), overlayHeightPx)) }
                target.addView(row, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, overlayHeightPx))
            }
            target.setBackgroundColor(Color.argb(store.expandedBackgroundAlpha(), 0, 0, 0))
            noFade = false
            val rows = maxOf(1, (display.size + perRow - 1) / perRow)
            val maxRows = maxOf(1, (resources.displayMetrics.heightPixels / 2) / overlayHeightPx)
            val visibleHeight = minOf(rows, maxRows) * overlayHeightPx
            target.layoutParams = target.layoutParams.apply { height = rows * overlayHeightPx }
            resizeOverlay(visibleHeight)
        } else {
            target.setBackgroundColor(Color.TRANSPARENT)
            noFade = false
            display.forEach { target.addView(createAppView(it), LinearLayout.LayoutParams(dp(iconSize), overlayHeightPx).apply { leftMargin = 0; rightMargin = 0; topMargin = 0; bottomMargin = 0 }) }
            target.layoutParams = target.layoutParams.apply { height = overlayHeightPx }
            scroll?.layoutParams = scroll?.layoutParams?.apply { this.height = overlayHeightPx }
            resizeOverlayWindow(pullCatchHeightPx(overlayHeightPx))
        }
        renderedIconSize = iconSize
        renderedGradientAlpha = gradientAlpha
        renderedExpanded = expandedNow
        renderedExpandedBgAlpha = store.expandedBackgroundAlpha()
        pageIndicator?.text = if (paged) "${page + 1}/$pageCount" else "•"
        if (scrollToEnd && !paged && !expandedNow) scroll?.post {
            if (store.renderMode() == RenderMode.SMOOTH) scroll?.smoothScrollTo(0, 0) else scroll?.scrollTo(0, 0)
        }
    }

    private fun resizeOverlay(height: Int) {
        scroll?.layoutParams = scroll?.layoutParams?.apply { this.height = height }
        root?.layoutParams = root?.layoutParams?.apply { this.height = height }
        root?.let { runCatching { windowManager.updateViewLayout(it, it.layoutParams) } }
    }

    private fun resizeOverlayWindow(height: Int) {
        root?.layoutParams = root?.layoutParams?.apply { this.height = height }
        root?.let { runCatching { windowManager.updateViewLayout(it, it.layoutParams) } }
    }

    private fun createAppView(entry: AppEntry): View {
        val custom = store.customIcon(entry.packageName)
        val fade = if (noFade) 0 else store.bottomGradientAlpha()
        return AlphaIconView(this, loadIcon(entry.packageName), custom == null, fade).apply {
            setOnClickListener { launch(entry) }
            setOnLongClickListener { showMenu(this, entry); true }
            contentDescription = entry.label
        }
    }

    private class AlphaIconView(context: android.content.Context, private val icon: Drawable?, private val cropSystemIcon: Boolean, private val fadeAmount: Int) : View(context) {
        private val maskPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply { xfermode = PorterDuffXfermode(PorterDuff.Mode.DST_IN) }
        override fun onDraw(canvas: android.graphics.Canvas) {
            super.onDraw(canvas)
            val radius = 12f * resources.displayMetrics.density
            val path = android.graphics.Path().apply { addRoundRect(RectF(0f, 0f, width.toFloat(), height.toFloat()), floatArrayOf(0f, 0f, 0f, 0f, radius, radius, radius, radius), android.graphics.Path.Direction.CW) }
            canvas.saveLayer(0f, 0f, width.toFloat(), height.toFloat(), null)
            canvas.clipPath(path)
            val boxW = if (cropSystemIcon) width / .80f else width.toFloat()
            val boxH = height.toFloat()
            val iw = icon?.intrinsicWidth?.takeIf { it > 0 }?.toFloat() ?: boxW
            val ih = icon?.intrinsicHeight?.takeIf { it > 0 }?.toFloat() ?: boxH
            val scale = if (cropSystemIcon) maxOf(boxW / iw, boxH / ih) else minOf(boxW / iw, boxH / ih)
            val drawW = iw * scale
            val drawH = ih * scale
            val left = (width - drawW) / 2f
            val top = (height - drawH) / 2f
            icon?.setBounds(left.toInt(), top.toInt(), (left + drawW).toInt(), (top + drawH).toInt())
            icon?.draw(canvas)
            maskPaint.shader = LinearGradient(0f, 0f, 0f, height.toFloat(), Color.WHITE, Color.argb(255 - fadeAmount, 255, 255, 255), Shader.TileMode.CLAMP)
            canvas.drawRect(0f, 0f, width.toFloat(), height.toFloat(), maskPaint)
            canvas.restore()
        }
    }

    private fun showMenu(anchor: View, entry: AppEntry) {
        lateinit var menu: ArcMenuView
        menu = ArcMenuView(this, listOf(
            { store.movePrevious(entry.packageName, entries); refreshList(false) },
            { store.setHidden(entry.packageName, true); refreshList(false) },
            { store.toggleSortMode(); refreshList(true) },
            { chooseIcon(entry.packageName) },
            { startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:${entry.packageName}")).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)) }
        )) { runCatching { windowManager.removeView(menu) } }
        val lp = WindowManager.LayoutParams(dp(250), dp(170), WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, android.graphics.PixelFormat.TRANSLUCENT).apply { gravity = Gravity.TOP or Gravity.START; x = anchor.left; y = dp(86) }
        windowManager.addView(menu, lp)
    }

    private fun chooseIcon(packageName: String) {
        val intent = Intent(this, IconPickerActivity::class.java).apply { addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); putExtra(IconPickerActivity.EXTRA_PACKAGE_NAME, packageName) }
        runCatching { startActivity(intent) }.onFailure { Toast.makeText(this, "Выбор изображения недоступен", Toast.LENGTH_SHORT).show() }
    }

    private fun launch(entry: AppEntry) {
        expandedNow = false
        store.launched(entry.packageName)
        packageManager.getLaunchIntentForPackage(entry.packageName)?.also { it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); startActivity(it) }
        handler.postDelayed({ page = 0; refreshList(true) }, 250L)
    }

    private fun iconButton(icon: Int, description: String, action: () -> Unit) = ImageButton(this).apply {
        setImageResource(icon); setColorFilter(Color.WHITE); contentDescription = description; setBackgroundColor(Color.TRANSPARENT); setPadding(dp(9), dp(9), dp(9), dp(9)); setOnClickListener { action() }
    }

    private fun loadIcon(packageName: String): Drawable? = runCatching {
        val custom = store.customIcon(packageName)
        if (custom != null) return@runCatching contentResolver.openInputStream(Uri.parse(custom)).use { Drawable.createFromStream(it, custom) }
        iconCache.get(packageName)?.newDrawable(resources) ?: packageManager.getApplicationIcon(packageName).also { iconCache.put(packageName, it.constantState) }
    }.getOrNull()
    private fun dp(value: Int): Int = (value * resources.displayMetrics.density + 0.5f).toInt()
    private fun pullCatchHeightPx(base: Int): Int = maxOf(base * 3, dp(160))
    private val refreshFromEvent = Runnable { page = 0; refreshList(true) }
    private fun packageNameOfSelf(): String = applicationContext.packageName
}
