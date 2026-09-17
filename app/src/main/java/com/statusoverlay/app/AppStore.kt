package com.statusoverlay.app

import android.content.Context
import android.content.SharedPreferences

enum class RenderMode { VISIBLE, PAGED }
enum class SortMode { RECENT, INSTALL }

data class AppEntry(val packageName: String, val label: String, val lastUsed: Long, val installTime: Long)

class AppStore(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("app_recent", Context.MODE_PRIVATE)
    fun hidden(): Set<String> = prefs.getStringSet("hidden", emptySet())?.toSet() ?: emptySet()
    fun setHidden(packageName: String, value: Boolean) { val set = hidden().toMutableSet(); if (value) set += packageName else set -= packageName; prefs.edit().putStringSet("hidden", set).apply() }
    fun customIcon(packageName: String): String? = prefs.getString("icon_$packageName", null)
    fun setCustomIcon(packageName: String, uri: String?) = prefs.edit().apply { if (uri == null) remove("icon_$packageName") else putString("icon_$packageName", uri) }.apply()
    fun renderMode(): RenderMode = runCatching { RenderMode.valueOf(prefs.getString("render_mode", RenderMode.VISIBLE.name)!!) }.getOrDefault(RenderMode.VISIBLE)
    fun setRenderMode(mode: RenderMode) = prefs.edit().putString("render_mode", mode.name).apply()
    fun sortMode(): SortMode = runCatching { SortMode.valueOf(prefs.getString("sort_mode", SortMode.RECENT.name)!!) }.getOrDefault(SortMode.RECENT)
    fun setSortMode(mode: SortMode) = prefs.edit().putString("sort_mode", mode.name).apply()
    fun invertScroll(): Boolean = prefs.getBoolean("invert_scroll", false)
    fun setInvertScroll(value: Boolean) = prefs.edit().putBoolean("invert_scroll", value).apply()
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
