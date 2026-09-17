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
            orientation = LinearLayout.HORIZONTAL; gravity = Gravity.CENTER_VERTICAL
            setPadding(dp(3), dp(3), dp(3), dp(3)); setBackgroundColor(Color.argb(238, 21, 26, 34))
        }
        panel.addView(iconButton(android.R.drawable.ic_menu_close_clear_cancel, "Скрыть панель") { panel.visibility = View.GONE }, LinearLayout.LayoutParams(dp(42), dp(68)))
        val back = iconButton(android.R.drawable.ic_media_previous, "Предыдущая страница") { page = (page - 1).coerceAtLeast(0); refreshList(true) }
        panel.addView(back, LinearLayout.LayoutParams(dp(40), dp(68)))
        val horizontal = HorizontalScrollView(this).apply { isHorizontalScrollBarEnabled = false; overScrollMode = View.OVER_SCROLL_NEVER }
        val items = LinearLayout(this).apply { orientation = LinearLayout.HORIZONTAL; gravity = Gravity.CENTER_VERTICAL }
        horizontal.addView(items, LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.MATCH_PARENT))
        panel.addView(horizontal, LinearLayout.LayoutParams(0, dp(68), 1f))
        val next = iconButton(android.R.drawable.ic_media_next, "Следующая страница") { page = (page + 1).coerceAtMost(pageCount - 1); refreshList(true) }
        panel.addView(next, LinearLayout.LayoutParams(dp(40), dp(68)))
        val indicator = TextView(this).apply { setTextColor(Color.LTGRAY); textSize = 11f; gravity = Gravity.CENTER; contentDescription = "Индикатор страницы" }
        pageIndicator = indicator
        panel.addView(indicator, LinearLayout.LayoutParams(dp(34), dp(68)))
        root = panel; scroll = horizontal; content = items
        val params = WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT, dp(76), WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, android.graphics.PixelFormat.TRANSLUCENT).apply { gravity = Gravity.TOP; y = dp(20) }
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
        display.forEach { target.addView(createAppView(it), LinearLayout.LayoutParams(dp(iconSize), dp(iconSize))) }
        pageIndicator?.text = if (paged) "${page + 1}/$pageCount" else "•"
        if (scrollToEnd && !paged) scroll?.post { scroll?.smoothScrollTo(scroll?.getChildAt(0)?.width ?: 0, 0) }
    }

    private fun createAppView(entry: AppEntry): View = ImageView(this).apply {
        scaleType = ImageView.ScaleType.FIT_CENTER; setPadding(dp(4), dp(4), dp(4), dp(4)); contentDescription = entry.label
        background = ColorDrawable(Color.TRANSPARENT); setImageDrawable(loadIcon(entry.packageName))
        setOnClickListener { launch(entry) }; setOnLongClickListener { showMenu(this, entry); true }
    }

    private fun showMenu(anchor: View, entry: AppEntry) {
        val menu = PopupMenu(this, anchor)
        menu.menu.add("Предыдущая позиция").setIcon(android.R.drawable.ic_media_previous).setOnMenuItemClickListener { store.movePrevious(entry.packageName, entries); refreshList(false); true }
        menu.menu.add("Скрыть").setIcon(android.R.drawable.ic_menu_view).setOnMenuItemClickListener { store.setHidden(entry.packageName, true); refreshList(false); true }
        menu.menu.add("Переключить сортировку").setIcon(android.R.drawable.ic_menu_sort_by_size).setOnMenuItemClickListener { val mode = store.toggleSortMode(); Toast.makeText(this, if (mode == SortMode.RECENT) "Сортировка: Недавние" else "Сортировка: По дате установки", Toast.LENGTH_SHORT).show(); page = 0; refreshList(true); true }
        menu.menu.add("Переключить сортировку").setIcon(android.R.drawable.ic_menu_sort_by_size).setOnMenuItemClickListener { val mode = store.toggleSortMode(); Toast.makeText(this, if (mode == SortMode.RECENT) "Сортировка: Недавние" else "Сортировка: По дате установки", Toast.LENGTH_SHORT).show(); page = 0; refreshList(true); true }
        menu.menu.add("Изменить иконку").setIcon(android.R.drawable.ic_menu_gallery).setOnMenuItemClickListener { chooseIcon(entry.packageName); true }
        menu.menu.add("Настройки приложения").setIcon(android.R.drawable.ic_menu_preferences).setOnMenuItemClickListener { startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:${entry.packageName}")).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)); true }
        menu.show()
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
