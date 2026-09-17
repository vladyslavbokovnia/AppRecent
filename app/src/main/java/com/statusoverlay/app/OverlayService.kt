package com.statusoverlay.app

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.provider.Settings
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.HorizontalScrollView
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.PopupMenu
import android.widget.Toast
import android.os.Handler
import android.os.Looper

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
            refreshList(true)
            handler.postDelayed(refreshTask, 4000L)
        } catch (error: Throwable) {
            active = false
            Toast.makeText(this, "AppRecent: ошибка запуска панели", Toast.LENGTH_LONG).show()
        }
    }

    override fun onAccessibilityEvent(event: android.view.accessibility.AccessibilityEvent?) = Unit
    override fun onInterrupt() = Unit

    override fun onDestroy() {
        active = false
        handler.removeCallbacksAndMessages(null)
        root?.let { view -> runCatching { windowManager.removeView(view) } }
        root = null
        scroll = null
        content = null
        super.onDestroy()
    }

    private fun createOverlay() {
        val panel = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(dp(4), dp(4), dp(4), dp(4))
            setBackgroundColor(Color.argb(238, 21, 26, 34))
        }
        val hide = ImageView(this).apply {
            setImageResource(android.R.drawable.ic_menu_close_clear_cancel)
            setColorFilter(Color.WHITE)
            contentDescription = "Скрыть панель"
            setPadding(dp(8), dp(8), dp(8), dp(8))
            setOnClickListener { panel.visibility = View.GONE }
        }
        panel.addView(hide, LinearLayout.LayoutParams(dp(44), dp(64)))
        val horizontal = HorizontalScrollView(this).apply {
            isHorizontalScrollBarEnabled = false
            overScrollMode = View.OVER_SCROLL_NEVER
        }
        val items = LinearLayout(this).apply { orientation = LinearLayout.HORIZONTAL; gravity = Gravity.CENTER_VERTICAL }
        horizontal.addView(items, LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.MATCH_PARENT))
        panel.addView(horizontal, LinearLayout.LayoutParams(0, dp(68), 1f))
        root = panel; scroll = horizontal; content = items
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT, dp(76),
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            android.graphics.PixelFormat.TRANSLUCENT
        ).apply { gravity = Gravity.TOP; y = dp(20) }
        windowManager.addView(panel, params)
    }

    private fun refreshList(scrollToEnd: Boolean) {
        if (!active) return
        val loaded = runCatching { repository.load() }.getOrDefault(emptyList())
        entries = loaded
        val target = content ?: return
        target.removeAllViews()
        val display = if (store.renderMode() == RenderMode.PAGED) loaded.take(6) else loaded
        display.forEach { entry -> target.addView(createAppView(entry)) }
        if (scrollToEnd) scroll?.post { scroll?.fullScroll(HorizontalScrollView.FOCUS_RIGHT) }
    }

    private fun createAppView(entry: AppEntry): View {
        val image = ImageView(this).apply {
            scaleType = ImageView.ScaleType.FIT_CENTER
            setPadding(dp(4), dp(4), dp(4), dp(4))
            contentDescription = entry.label
            background = ColorDrawable(Color.TRANSPARENT)
            setImageDrawable(loadIcon(entry.packageName))
            setOnClickListener { launch(entry) }
            setOnLongClickListener { showMenu(this, entry); true }
        }
        return image
    }

    private fun showMenu(anchor: View, entry: AppEntry) {
        val menu = PopupMenu(this, anchor)
        menu.menu.add("← Предыдущая позиция").setOnMenuItemClickListener { store.movePrevious(entry.packageName, entries); refreshList(false); true }
        menu.menu.add("Скрыть приложение").setOnMenuItemClickListener { store.setHidden(entry.packageName, true); refreshList(false); true }
        menu.menu.add("Настройки приложения").setOnMenuItemClickListener { startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:${entry.packageName}")).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)); true }
        menu.setOnDismissListener { anchor.clearFocus() }
        menu.show()
    }

    private fun launch(entry: AppEntry) {
        store.launched(entry.packageName)
        packageManager.getLaunchIntentForPackage(entry.packageName)?.also { intent -> intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); startActivity(intent) }
        handler.postDelayed({ refreshList(true) }, 250L)
    }

    private fun loadIcon(packageName: String): Drawable? = runCatching {
        val custom = store.customIcon(packageName)
        if (custom == null) packageManager.getApplicationIcon(packageName)
        else contentResolver.openInputStream(Uri.parse(custom)).use { Drawable.createFromStream(it, custom) }
    }.getOrNull()

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density + 0.5f).toInt()
}
