package com.statusoverlay.app

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.view.Gravity
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView

class IconPickerActivity : Activity() {
    companion object { const val EXTRA_PACKAGE_NAME = "package_name" }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val pkg = intent.getStringExtra(EXTRA_PACKAGE_NAME).orEmpty()
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(32, 32, 32, 32)
            setBackgroundColor(Color.rgb(16, 19, 26))
        }
        val title = TextView(this).apply {
            text = "Выберите изображение иконки"
            setTextColor(Color.WHITE)
            textSize = 18f
            gravity = Gravity.CENTER
        }
        val choose = Button(this).apply {
            text = "Открыть галерею"
            setOnClickListener { openPicker(pkg) }
        }
        val reset = Button(this).apply {
            text = "Использовать системную иконку"
            setOnClickListener { AppStore(this@IconPickerActivity).setCustomIcon(pkg, null); finish() }
        }
        root.addView(title, LinearLayout.LayoutParams(-1, -2))
        root.addView(choose, LinearLayout.LayoutParams(-1, -2))
        root.addView(reset, LinearLayout.LayoutParams(-1, -2))
        setContentView(root)
    }

    private fun openPicker(pkg: String) {
        startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            type = "image/*"
            addCategory(Intent.CATEGORY_OPENABLE)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            putExtra(EXTRA_PACKAGE_NAME, pkg)
        }, 10)
    }

    @Deprecated("Android activity result compatibility")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 10 && resultCode == RESULT_OK) {
            data?.data?.let { uri ->
                runCatching { contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION) }
                AppStore(this).setCustomIcon(intent.getStringExtra(EXTRA_PACKAGE_NAME).orEmpty(), uri.toString())
            }
            finish()
        }
    }
}
