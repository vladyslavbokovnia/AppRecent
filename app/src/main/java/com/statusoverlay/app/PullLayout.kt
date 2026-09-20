package com.statusoverlay.app

import android.content.Context
import android.view.MotionEvent
import android.view.ViewConfiguration
import android.view.ViewGroup
import android.widget.LinearLayout
import kotlin.math.abs

/** Корневой контейнер оверлея: ловит вертикальный "pull" раньше горизонтальной прокрутки. */
class PullLayout(
    context: Context,
    private val pullEnabled: () -> Boolean,
    private val isExpanded: () -> Boolean,
    private val onPull: (expand: Boolean) -> Unit
) : LinearLayout(context) {

    private val slop = ViewConfiguration.get(context).scaledTouchSlop * 2
    private var downX = 0f
    private var downY = 0f
    private var captured = false

    // 0 = игнорировать, 1 = раскрыть, 2 = свернуть
    private fun direction(dy: Float): Int {
        if (!pullEnabled()) return 0
        return if (!isExpanded()) {
            if (dy > 0f) 1 else 0
        } else {
            if (dy >= 0f) 0 else {
                // свайп вверх сворачивает только если список нельзя листать дальше
                val list = (getChildAt(0) as? ViewGroup)?.getChildAt(0)
                if (list != null && list.canScrollVertically(1)) 0 else 2
            }
        }
    }

    private fun probe(ev: MotionEvent): Boolean {
        val dx = ev.x - downX
        val dy = ev.y - downY
        if (abs(dy) < slop || abs(dy) <= abs(dx)) return false
        val dir = direction(dy)
        if (dir == 0) return false
        captured = true
        post { onPull(dir == 1) }
        return true
    }

    override fun onInterceptTouchEvent(ev: MotionEvent): Boolean {
        when (ev.actionMasked) {
            MotionEvent.ACTION_DOWN -> { downX = ev.x; downY = ev.y; captured = false }
            MotionEvent.ACTION_MOVE -> return captured || probe(ev)
        }
        return false
    }

    override fun onTouchEvent(ev: MotionEvent): Boolean {
        when (ev.actionMasked) {
            MotionEvent.ACTION_DOWN -> { downX = ev.x; downY = ev.y; captured = false }
            MotionEvent.ACTION_MOVE -> if (!captured) probe(ev)
            MotionEvent.ACTION_OUTSIDE -> if (isExpanded()) post { onPull(false) }
            else -> captured = false
        }
        return true
    }
}
