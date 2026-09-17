from pathlib import Path
p=Path('/home/ubuntu/AppRecent/app/src/main/java/com/statusoverlay/app/OverlayService.kt')
s=p.read_text()
s=s.replace('import android.view.Gravity\nimport android.view.View\n', 'import android.view.Gravity\nimport android.view.GestureDetector\nimport android.view.MotionEvent\nimport android.view.View\n')
s=s.replace('import android.os.Looper\n', 'import android.os.Looper\nimport android.content.BroadcastReceiver\nimport android.content.IntentFilter\n')
s=s.replace('    private var pageIndicator: TextView? = null\n', '''    private var pageIndicator: TextView? = null
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
''')
s=s.replace('            createOverlay()\n            refreshList(true)', '            createOverlay()\n            createBatteryOverlay()\n            createEdgeHandle()\n            registerReceiver(batteryReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))\n            refreshList(true)')
s=s.replace('        handler.removeCallbacksAndMessages(null)\n        root?.let', '        handler.removeCallbacksAndMessages(null)\n        runCatching { unregisterReceiver(batteryReceiver) }\n        root?.let')
s=s.replace('        root?.let { runCatching { windowManager.removeView(it) } }\n        root = null; scroll = null; content = null', '        root?.let { runCatching { windowManager.removeView(it) } }\n        batteryBar?.let { runCatching { windowManager.removeView(it) } }\n        edgeHandle?.let { runCatching { windowManager.removeView(it) } }\n        root = null; scroll = null; content = null')
needle='''    private fun refreshList(scrollToEnd: Boolean) {
'''
insert='''    private fun createBatteryOverlay() {
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

'''+needle
s=s.replace(needle,insert)
s=s.replace('''        menu.menu.add("Скрыть").setIcon(android.R.drawable.ic_menu_view).setOnMenuItemClickListener { store.setHidden(entry.packageName, true); refreshList(false); true }
''','''        menu.menu.add("Скрыть").setIcon(android.R.drawable.ic_menu_view).setOnMenuItemClickListener { store.setHidden(entry.packageName, true); refreshList(false); true }
        menu.menu.add("Переключить сортировку").setIcon(android.R.drawable.ic_menu_sort_by_size).setOnMenuItemClickListener { val mode = store.toggleSortMode(); Toast.makeText(this, if (mode == SortMode.RECENT) "Сортировка: Недавние" else "Сортировка: По дате установки", Toast.LENGTH_SHORT).show(); page = 0; refreshList(true); true }
''')
p.write_text(s)
PY
python3 /home/ubuntu/AppRecent/scripts/patch_original_features.py
rm /home/ubuntu/AppRecent/scripts/patch_original_features.py
