package com.statusoverlay.app

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.view.MotionEvent
import android.view.View
import kotlin.math.cos
import kotlin.math.sin

class ArcMenuView(context: Context, private val actions: List<(View) -> Unit>) : View(context) {
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = Color.WHITE; style = Paint.Style.STROKE; strokeWidth = 3f; strokeCap = Paint.Cap.ROUND }
    private val labels = listOf("previous", "hide", "sort", "icon", "settings")
    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val cx = width / 2f; val cy = height * .92f; val radius = width * .34f
        for (i in labels.indices) drawGlyph(canvas, labels[i], cx + cos(Math.toRadians((200 + i * 35).toDouble())).toFloat() * radius, cy + sin(Math.toRadians((200 + i * 35).toDouble())).toFloat() * radius)
    }
    private fun drawGlyph(c: Canvas, type: String, x: Float, y: Float) {
        when (type) {
            "previous" -> { c.drawLine(x + 10, y, x - 7, y, paint); c.drawLine(x - 7, y, x + 1, y - 8, paint); c.drawLine(x - 7, y, x + 1, y + 8, paint) }
            "hide" -> { c.drawOval(RectF(x - 12, y - 7, x + 12, y + 7), paint); c.drawLine(x - 10, y - 10, x + 10, y + 10, paint) }
            "sort" -> { c.drawLine(x - 9, y - 8, x + 9, y - 8, paint); c.drawLine(x - 9, y, x + 5, y, paint); c.drawLine(x - 9, y + 8, x, y + 8, paint) }
            "icon" -> { c.drawRect(x - 11, y - 9, x + 11, y + 9, paint); c.drawCircle(x - 4, y - 3, 2f, paint); c.drawLine(x - 9, y + 6, x - 1, y - 1, paint); c.drawLine(x - 1, y - 1, x + 8, y + 6, paint) }
            "settings" -> { c.drawCircle(x, y, 9f, paint); c.drawCircle(x, y, 3f, paint); for (i in 0 until 8) { val a = i * Math.PI / 4; c.drawLine(x + cos(a).toFloat() * 10, y + sin(a).toFloat() * 10, x + cos(a).toFloat() * 13, y + sin(a).toFloat() * 13, paint) } }
        }
    }
    override fun onTouchEvent(event: MotionEvent): Boolean {
        if (event.action == MotionEvent.ACTION_UP) {
            val cx = width / 2f; val cy = height * .92f; val radius = width * .34f
            val angle = Math.toDegrees(kotlin.math.atan2(event.y - cy, event.x - cx).toDouble())
            val index = (((angle - 200 + 360) % 360) / 35).toInt()
            if (index in actions.indices) actions[index](this)
            (parent as? android.view.ViewGroup)?.let { it.removeView(this) }
        }
        return true
    }
}
