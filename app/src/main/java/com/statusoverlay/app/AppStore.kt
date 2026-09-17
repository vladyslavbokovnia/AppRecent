package com.statusoverlay.app

import android.content.Context
import android.content.SharedPreferences

enum class RenderMode { VISIBLE, PAGED }
enum class SortMode { RECENT, INSTALL }

data class AppEntry(val packageName: String, val label: String, val lastUsed: Long, val installTime: Long)

class AppStore(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("settings", Context.MODE_PRIVATE)
    private val hiddenPrefs: SharedPreferences = context.getSharedPreferences("hidden_apps", Context.MODE_PRIVATE)
    private val iconPrefs: SharedPreferences = context.getSharedPreferences("custom_icons", Context.MODE_PRIVATE)
    fun hidden(): Set<String> = hiddenPrefs.getStringSet("hidden_list", emptySet())?.toSet() ?: emptySet()
    fun setHidden(packageName: String, value: Boolean) { val set = hidden().toMutableSet(); if (value) set += packageName else set -= packageName; hiddenPrefs.edit().putStringSet("hidden_list", set).apply() }
    fun customIcon(packageName: String): String? = iconPrefs.getString(packageName, null)
    fun setCustomIcon(packageName: String, uri: String?) = iconPrefs.edit().apply { if (uri == null) remove(packageName) else putString(packageName, uri) }.apply()
    fun renderMode(): RenderMode = runCatching { RenderMode.valueOf(prefs.getString("render_mode", RenderMode.VISIBLE.name)!!) }.getOrDefault(RenderMode.VISIBLE)
    fun setRenderMode(mode: RenderMode) = prefs.edit().putString("render_mode", mode.name).apply()
    fun sortMode(): SortMode = if (prefs.getString("sort_mode", "usage") == "install") SortMode.INSTALL else SortMode.RECENT
    fun setSortMode(mode: SortMode) = prefs.edit().putString("sort_mode", if (mode == SortMode.INSTALL) "install" else "usage").apply()
    fun toggleSortMode(): SortMode { val next = if (sortMode() == SortMode.RECENT) SortMode.INSTALL else SortMode.RECENT; setSortMode(next); return next }
    fun invertScroll(): Boolean = prefs.getBoolean("invert_scroll", false)
    fun setInvertScroll(value: Boolean) = prefs.edit().putBoolean("invert_scroll", value).apply()
    fun iconSize(): Int = prefs.getInt("icon_size", 96)
    fun setIconSize(value: Int) = prefs.edit().putInt("icon_size", value.coerceIn(48, 92)).apply()
    fun activePackage(): String? = prefs.getString("active_package", null)
    fun setActivePackage(packageName: String) = prefs.edit().putString("active_package", packageName).apply()
    fun overrides(): List<String> = prefs.getString("order_overrides", "")!!.split('|').filter(String::isNotBlank)
    fun setOverrides(order: List<String>) = prefs.edit().putString("order_overrides", order.distinct().joinToString("|")).apply()

    fun applyManualOrder(entries: List<AppEntry>): List<AppEntry> {
        val byPackage = entries.associateBy { it.packageName }
        val manual = overrides().mapNotNull(byPackage::get)
        return manual + entries.filterNot { it.packageName in manual.map(AppEntry::packageName).toSet() }
    }
    fun movePrevious(packageName: String, entries: List<AppEntry>) {
        val order = applyManualOrder(entries).map(AppEntry::packageName).toMutableList()
        val index = order.indexOf(packageName)
        if (index > 0) { val item = order.removeAt(index); order.add(index - 1, item); setOverrides(order) }
    }
    fun launched(packageName: String) { setOverrides(overrides().filterNot { it == packageName }) }
}
