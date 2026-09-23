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
    private var vScroll: ScrollView? = null
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
    private var renderedIconAlpha = -1
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
        // Keep the existing larger collapsed touch-catching window unchanged.
        val collapsedWindowHeight = maxOf(overlayHeight * 3, dp(160))
        val panel = PullLayout(
            this,
            pullEnabled = { store.expandRows() },
            isExpanded = { expandedNow },
            onPull = { expand -> toggleExpand(expand) }
        ).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.TOP
            setBackgroundColor(Color.TRANSPARENT)
            setPadding(0, 0, 0, 0)
        }
        val horizontal = HorizontalScrollView(this).apply {
            isHorizontalScrollBarEnabled = false
            overScrollMode = View.OVER_SCROLL_NEVER
            isSmoothScrollingEnabled = true
            setBackgroundColor(Color.TRANSPARENT)
        }
        val items = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        val vertical = ScrollView(this).apply {
            isVerticalScrollBarEnabled = false
            overScrollMode = View.OVER_SCROLL_NEVER
            // Follow the overlay size when the panel expands.
            addView(items, FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT))
        }
        horizontal.addView(vertical, FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
        panel.addView(horizontal, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT))
        root = panel
        scroll = horizontal
        vScroll = vertical
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
                if (root?.visibility != View.VISIBLE) return true
                if (expandedNow) vScroll?.scrollBy(0, if (store.invertScroll()) -dy.toInt() * 2 else dy.toInt() * 2)
                else scroll?.scrollBy(if (store.invertScroll()) dy.toInt() * 2 else -dy.toInt() * 2, 0)
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

    private fun toggleExpand(expand: Boolean) {
        if (!active) return
        expandedNow = expand
        applyList(entries, false)
        if (expand) vScroll?.post { vScroll?.fullScroll(View.FOCUS_DOWN) }
    }

    private fun applyList(loaded: List<AppEntry>, scrollToEnd: Boolean) {
        val oldPackages = entries.map { it.packageName }
        entries = loaded
        val target = content ?: return
        val newPackages = loaded.map { it.packageName }
        val iconSize = store.iconSize()
        val gradientAlpha = store.bottomGradientAlpha()
        if (newPackages == oldPackages && iconSize == renderedIconSize && gradientAlpha == renderedGradientAlpha && expandedNow == renderedExpanded && store.expandedBackgroundAlpha() == renderedExpandedBgAlpha && store.iconAlpha() == renderedIconAlpha) return
        target.removeAllViews()
        val paged = false
        pageCount = 1
        page = 0
        val display = entries
        target.orientation = if (expandedNow) LinearLayout.VERTICAL else LinearLayout.HORIZONTAL
        if (expandedNow) {
            val perRow = 3
            val screenWidth = resources.displayMetrics.widthPixels
            val baseColWidth = screenWidth / perRow
            val colWidths = IntArray(perRow) { i ->
                if (i == perRow - 1) screenWidth - baseColWidth * (perRow - 1) else baseColWidth
            }
            val rowHeight = dp(iconSize)
            val ordered = display.reversed()
            ordered.chunked(perRow).forEachIndexed { rowIndex, chunk ->
                noFade = (rowIndex + 1) * perRow < ordered.size
                val row = LinearLayout(this).apply { orientation = LinearLayout.HORIZONTAL; gravity = Gravity.CENTER_VERTICAL }
                chunk.forEachIndexed { i, entry ->
                    row.addView(createAppView(entry), LinearLayout.LayoutParams(colWidths[i], rowHeight))
                }
                target.addView(row, LinearLayout.LayoutParams(screenWidth, rowHeight))
            }
            target.setBackgroundColor(Color.argb(store.expandedBackgroundAlpha(), 0, 0, 0))
            noFade = false
            val rows = maxOf(1, (ordered.size + perRow - 1) / perRow)
            val maxRows = maxOf(1, (resources.displayMetrics.heightPixels / 2) / rowHeight)
            val visibleHeight = minOf(rows, maxRows) * rowHeight
            target.layoutParams = target.layoutParams.apply { width = screenWidth; height = rows * rowHeight }
            resizeOverlay(visibleHeight)
        } else {
            target.setBackgroundColor(Color.TRANSPARENT)
            noFade = false
            display.forEach { target.addView(createAppView(it), LinearLayout.LayoutParams(dp(iconSize), overlayHeightPx).apply { leftMargin = 0; rightMargin = 0; topMargin = 0; bottomMargin = 0 }) }
            target.layoutParams = target.layoutParams.apply { width = ViewGroup.LayoutParams.WRAP_CONTENT; height = overlayHeightPx }
            resizeOverlay(overlayHeightPx)
        }
        renderedIconSize = iconSize
        renderedGradientAlpha = gradientAlpha
        renderedExpanded = expandedNow
        renderedExpandedBgAlpha = store.expandedBackgroundAlpha()
        renderedIconAlpha = store.iconAlpha()
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

    private fun createAppView(entry: AppEntry): View {
        val custom = store.customIcon(entry.packageName)
        val fade = if (noFade) 0 else store.bottomGradientAlpha()
        return AlphaIconView(this, loadIcon(entry.packageName), custom == null, fade, store.iconAlpha()).apply {
            setOnClickListener { launch(entry) }
            setOnLongClickListener { showMenu(this, entry); true }
            contentDescription = entry.label
        }
    }

    private class AlphaIconView(context: android.content.Context, private val icon: Drawable?, private val cropSystemIcon: Boolean, private val fadeAmount: Int, private val overallAlpha: Int) : View(context) {
        private val maskPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply { xfermode = PorterDuffXfermode(PorterDuff.Mode.DST_IN) }
        private val layerPaint = Paint(Paint.ANTI_ALIAS_FLAG)
        private var cached: android.graphics.Bitmap? = null

        override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
            super.onSizeChanged(w, h, oldw, oldh)
            if (w != oldw || h != oldh) cached = null
        }

        override fun onDraw(canvas: android.graphics.Canvas) {
            super.onDraw(canvas)
            if (width <= 0 || height <= 0) return
            val bitmap = cached ?: renderBitmap().also { cached = it }
            canvas.drawBitmap(bitmap, 0f, 0f, null)
        }

        private fun renderBitmap(): android.graphics.Bitmap {
            val bmp = android.graphics.Bitmap.createBitmap(width, height, android.graphics.Bitmap.Config.ARGB_8888)
            val bmpCanvas = android.graphics.Canvas(bmp)
            val radius = 12f * resources.displayMetrics.density
            val path = android.graphics.Path().apply { addRoundRect(RectF(0f, 0f, width.toFloat(), height.toFloat()), floatArrayOf(0f, 0f, 0f, 0f, radius, radius, radius, radius), android.graphics.Path.Direction.CW) }
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
            layerPaint.alpha = overallAlpha
            bmpCanvas.saveLayer(0f, 0f, width.toFloat(), height.toFloat(), layerPaint)
            bmpCanvas.clipPath(path)
            icon?.alpha = 255
            icon?.draw(bmpCanvas)
            if (fadeAmount > 0) {
                maskPaint.shader = LinearGradient(0f, 0f, 0f, height.toFloat(), Color.WHITE, Color.argb(255 - fadeAmount, 255, 255, 255), Shader.TileMode.CLAMP)
                bmpCanvas.drawRect(0f, 0f, width.toFloat(), height.toFloat(), maskPaint)
            }
            bmpCanvas.restore()
            return bmp
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
    private val refreshFromEvent = Runnable { page = 0; refreshList(true) }
    private fun packageNameOfSelf(): String = applicationContext.packageName
}
