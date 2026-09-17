package com.statusoverlay.app

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.provider.Settings
import android.view.Gravity
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.HorizontalScrollView
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.PopupMenu
import android.widget.TextView
import android.widget.Toast
import android.os.Handler
import android.os.Looper
import android.content.BroadcastReceiver
import android.content.IntentFilter

class OverlayService : AccessibilityService() {
    private lateinit var windowManager: WindowManager
    private lateinit var store: AppStore
    private lateinit var repository: AppRepository
    private val handler = Handler(Looper.getMainLooper())
    private var root: LinearLayout? = null
    private var scroll: HorizontalScrollView? = null
    private var content: LinearLayout? = null
    private var entries: List<AppEntry> = emptyList()
    private var active = false
    private var page = 0
    private var pageCount = 1
    private var pageIndicator: TextView? = null
    private var batteryBar: View? = null
    private var edgeHandle: View? = null
    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: android.content.Context?, intent: Intent?) {
            val level = intent?.getIntExtra("level", -1) ?: return
            val scale = intent.getIntExtra("scale", -1)
            if (level >= 0 && scale > 0) batteryBar?.let { bar ->
                bar.layoutParams = bar.layoutParams.apply { width = (resources.displayMetrics.widthPixels * level.toFloat() / scale).toInt() }
                bar.requestLayout()
            }
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
        runCatching { unregisterReceiver(batteryReceiver) }
        root?.let { runCatching { windowManager.removeView(it) } }
        batteryBar?.let { runCatching { windowManager.removeView(it) } }
        edgeHandle?.let { runCatching { windowManager.removeView(it) } }
        root = null; scroll = null; content = null
        super.onDestroy()
    }

    private fun createOverlay() {
        val panel = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setBackgroundColor(Color.argb(170, 0, 0, 0))
            setPadding(0, 0, 0, 0)
        }
        val horizontal = HorizontalScrollView(this).apply {
            isHorizontalScrollBarEnabled = false
            overScrollMode = View.OVER_SCROLL_NEVER
            setBackgroundColor(Color.TRANSPARENT)
        }
        val items = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        horizontal.addView(items, LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, dp(128)))
        panel.addView(horizontal, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(128)))
        root = panel
        scroll = horizontal
        content = items
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            dp(128),
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            android.graphics.PixelFormat.TRANSLUCENT
        ).apply { gravity = Gravity.TOP }
        windowManager.addView(panel, params)
    }

    private fun createBatteryOverlay() {
        batteryBar = View(this).apply { setBackgroundColor(Color.rgb(70, 210, 130)) }
        val lp = WindowManager.LayoutParams(0, dp(4), WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE, android.graphics.PixelFormat.TRANSLUCENT).apply { gravity = Gravity.BOTTOM }
        windowManager.addView(batteryBar, lp)
    }

    private fun createEdgeHandle() {
        val handle = View(this).apply { setBackgroundColor(Color.TRANSPARENT) }
        val detector = GestureDetector(this, object : GestureDetector.SimpleOnGestureListener() {
            override fun onDown(event: MotionEvent) = true
            override fun onLongPress(event: MotionEvent) { toggleVisibility() }
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
        root?.let { view -> view.visibility = if (view.visibility == View.VISIBLE) View.GONE else View.VISIBLE; if (view.visibility == View.VISIBLE) refreshList(true) }
    }

    private fun refreshList(scrollToEnd: Boolean) {
        if (!active) return
        entries = runCatching { repository.load() }.getOrDefault(emptyList())
        val target = content ?: return
        target.removeAllViews()
        val pageSize = 6
        val paged = store.renderMode() == RenderMode.PAGED
        pageCount = if (paged) ((entries.size + pageSize - 1) / pageSize).coerceAtLeast(1) else 1
        page = page.coerceIn(0, pageCount - 1)
        val display = if (paged) entries.drop(page * pageSize).take(pageSize) else entries
        val iconSize = store.iconSize()
        display.forEach { target.addView(createAppView(it), LinearLayout.LayoutParams(dp(iconSize), dp(128)).apply { leftMargin = 0; rightMargin = 0; topMargin = 0; bottomMargin = 0 }) }
        pageIndicator?.text = if (paged) "${page + 1}/$pageCount" else "•"
        if (scrollToEnd && !paged) scroll?.post {
            val destination = scroll?.getChildAt(0)?.width ?: 0
            if (store.renderMode() == RenderMode.SMOOTH) scroll?.smoothScrollTo(destination, 0) else scroll?.scrollTo(destination, 0)
        }
    }

    private fun createAppView(entry: AppEntry): View = ImageView(this).apply {
        val custom = store.customIcon(entry.packageName)
        scaleType = if (custom == null) ImageView.ScaleType.CENTER_CROP else ImageView.ScaleType.FIT_CENTER
        if (custom == null) setPadding(dp((store.iconSize() * 0.05f).toInt()), dp((128 * 0.10f).toInt()), dp((store.iconSize() * 0.05f).toInt()), dp((128 * 0.10f).toInt())) else setPadding(0, 0, 0, 0)
        contentDescription = entry.label
        background = ColorDrawable(Color.TRANSPARENT); setImageDrawable(loadIcon(entry.packageName))
        setOnClickListener { launch(entry) }; setOnLongClickListener { showMenu(this, entry); true }
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
        store.launched(entry.packageName)
        packageManager.getLaunchIntentForPackage(entry.packageName)?.also { it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); startActivity(it) }
        handler.postDelayed({ page = 0; refreshList(true) }, 250L)
    }

    private fun iconButton(icon: Int, description: String, action: () -> Unit) = ImageButton(this).apply {
        setImageResource(icon); setColorFilter(Color.WHITE); contentDescription = description; setBackgroundColor(Color.TRANSPARENT); setPadding(dp(9), dp(9), dp(9), dp(9)); setOnClickListener { action() }
    }

    private fun loadIcon(packageName: String): Drawable? = runCatching {
        val custom = store.customIcon(packageName)
        if (custom == null) packageManager.getApplicationIcon(packageName) else contentResolver.openInputStream(Uri.parse(custom)).use { Drawable.createFromStream(it, custom) }
    }.getOrNull()
    private fun dp(value: Int): Int = (value * resources.displayMetrics.density + 0.5f).toInt()
    private val refreshFromEvent = Runnable { page = 0; refreshList(true) }
    private fun packageNameOfSelf(): String = applicationContext.packageName
}
