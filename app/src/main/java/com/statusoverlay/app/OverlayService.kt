package com.statusoverlay.app

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.Intent
import android.graphics.drawable.Drawable
import android.net.Uri
import android.provider.Settings
import android.view.Gravity
import android.view.WindowManager
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Apps
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import android.widget.ImageView
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import androidx.lifecycle.setViewTreeLifecycleOwner
import kotlinx.coroutines.delay

class OverlayService : AccessibilityService() {
    private lateinit var windowManager: WindowManager
    private lateinit var store: AppStore
    private lateinit var repository: AppRepository
    private var overlay: ComposeView? = null
    private var visible by mutableStateOf(true)
    private var entries by mutableStateOf(emptyList<AppEntry>())
    private var refreshTick by mutableIntStateOf(0)
    private lateinit var composeLifecycleOwner: ServiceLifecycleOwner

    override fun onServiceConnected() { super.onServiceConnected(); windowManager = getSystemService(WINDOW_SERVICE) as WindowManager; store = AppStore(this); repository = AppRepository(this, store); composeLifecycleOwner = ServiceLifecycleOwner(); refresh(); createOverlay() }
    override fun onAccessibilityEvent(event: android.view.accessibility.AccessibilityEvent?) {}
    override fun onInterrupt() {}
    override fun onDestroy() { if (::composeLifecycleOwner.isInitialized) composeLifecycleOwner.destroy(); overlay?.let { runCatching { windowManager.removeView(it) } }; overlay = null; super.onDestroy() }
    private fun refresh() { entries = repository.load(); refreshTick++ }
    private fun createOverlay() {
        overlay = ComposeView(this).apply { setViewTreeLifecycleOwner(composeLifecycleOwner); setContent { OverlayPanel() } }
        val lp = WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT, 76.dpPx(), WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, android.graphics.PixelFormat.TRANSLUCENT).apply { gravity = Gravity.TOP; y = 20.dpPx() }
        windowManager.addView(overlay, lp)
    }
    private fun launch(entry: AppEntry) { store.launched(entry.packageName); packageManager.getLaunchIntentForPackage(entry.packageName)?.let { it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); startActivity(it) }; refresh() }
    private fun Int.dpPx() = (this * resources.displayMetrics.density).toInt()

    @OptIn(ExperimentalFoundationApi::class)
    @Composable private fun OverlayPanel() {
        val state = rememberLazyListState(); var menuFor by remember { mutableStateOf<String?>(null) }; var page by remember { mutableIntStateOf(0) }; val mode = store.renderMode()
        LaunchedEffect(refreshTick) { if (entries.isNotEmpty()) state.animateScrollToItem(entries.lastIndex) }
        LaunchedEffect(Unit) { while (true) { delay(4000); refresh() } }
        if (!visible) return
        Surface(color = Color(0xEE151A22), tonalElevation = 6.dp) {
            Row(Modifier.fillMaxSize().padding(horizontal = 6.dp), verticalAlignment = Alignment.CenterVertically) {
                IconButton({ visible = false }) { Icon(Icons.Default.Close, "Скрыть") }
                if (mode == RenderMode.VISIBLE) {
                    LazyRow(state = state, horizontalArrangement = Arrangement.spacedBy(6.dp), modifier = Modifier.weight(1f)) { items(entries, key = { it.packageName }) { entry -> AppTile(entry, menuFor == entry.packageName, { menuFor = entry.packageName }, { menuFor = null }) { launch(entry) } } }
                } else {
                    val pages = entries.chunked(5); val visiblePage = pages.getOrNull(page.coerceIn(0, (pages.size - 1).coerceAtLeast(0))).orEmpty()
                    IconButton({ page = (page - 1).coerceAtLeast(0) }) { Icon(Icons.Default.ArrowBack, "Предыдущая страница") }
                    Row(Modifier.weight(1f), horizontalArrangement = Arrangement.spacedBy(6.dp)) { visiblePage.forEach { entry -> AppTile(entry, menuFor == entry.packageName, { menuFor = entry.packageName }, { menuFor = null }) { launch(entry) } } }
                    IconButton({ page = (page + 1).coerceAtMost((pages.size - 1).coerceAtLeast(0)) }) { Icon(Icons.Default.Apps, "Следующая страница") }
                }
            }
        }
    }

    @OptIn(ExperimentalFoundationApi::class)
    @Composable private fun AppTile(entry: AppEntry, menuOpen: Boolean, openMenu: () -> Unit, closeMenu: () -> Unit, onLaunch: () -> Unit) {
        Box(Modifier.width(62.dp).height(64.dp).combinedClickable(onClick = onLaunch, onLongClick = openMenu), contentAlignment = Alignment.Center) {
            AppIcon(entry.packageName)
            DropdownMenu(expanded = menuOpen, onDismissRequest = closeMenu) {
                DropdownMenuItem(text = { Text("← Предыдущая позиция") }, onClick = { store.movePrevious(entry.packageName, entries); closeMenu(); refresh() })
                DropdownMenuItem(text = { Text("Скрыть приложение") }, onClick = { store.setHidden(entry.packageName, true); closeMenu(); refresh() })
                DropdownMenuItem(text = { Text("Настройки приложения") }, onClick = { startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:${entry.packageName}")).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)); closeMenu() })
            }
        }
    }
    @Composable private fun AppIcon(packageName: String) {
        val custom = store.customIcon(packageName); val drawable = remember(packageName, custom) { loadIcon(packageName, custom) }
        AndroidView(factory = { ImageView(it).apply { scaleType = ImageView.ScaleType.FIT_CENTER; setPadding(3, 3, 3, 3) } }, update = { it.setImageDrawable(drawable) }, modifier = Modifier.fillMaxSize())
    }
    private fun loadIcon(packageName: String, custom: String?): Drawable? = runCatching { if (custom != null) contentResolver.openInputStream(Uri.parse(custom)).use { android.graphics.drawable.Drawable.createFromStream(it, custom) } else packageManager.getApplicationIcon(packageName) }.getOrNull()

    private class ServiceLifecycleOwner : LifecycleOwner {
        private val registry = LifecycleRegistry(this)
        init { registry.currentState = Lifecycle.State.RESUMED }
        override val lifecycle: Lifecycle get() = registry
        fun destroy() { registry.currentState = Lifecycle.State.DESTROYED }
    }
}
