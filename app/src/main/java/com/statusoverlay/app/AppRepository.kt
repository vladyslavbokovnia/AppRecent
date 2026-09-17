package com.statusoverlay.app

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager

class AppRepository(private val context: Context, private val store: AppStore = AppStore(context)) {
    private val pm: PackageManager = context.packageManager
    fun load(): List<AppEntry> {
        val launcher = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        val packages = pm.queryIntentActivities(launcher, PackageManager.MATCH_ALL).map { it.activityInfo.packageName }.distinct()
        val hidden = store.hidden()
        val now = System.currentTimeMillis()
        val usage = (context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager)?.queryUsageStats(UsageStatsManager.INTERVAL_WEEKLY, now - 7 * 24 * 60 * 60 * 1000L, now).orEmpty().associate { it.packageName to it.lastTimeUsed }
        val result = packages.filterNot { it in hidden }.mapNotNull { pkg -> runCatching {
            val info = pm.getApplicationInfo(pkg, 0); val pi = pm.getPackageInfo(pkg, 0)
            AppEntry(pkg, pm.getApplicationLabel(info).toString(), usage[pkg] ?: 0L, pi.firstInstallTime)
        }.getOrNull() }
        val sorted = when (store.sortMode()) {
            SortMode.INSTALL -> result.sortedWith(compareByDescending<AppEntry> { it.installTime }.thenBy { it.label.lowercase() })
            SortMode.RECENT -> result.sortedWith(compareByDescending<AppEntry> { it.lastUsed }.thenBy { it.label.lowercase() })
        }
        val ordered = store.applyManualOrder(sorted).toMutableList()
        val active = store.activePackage()
        if (store.sortMode() == SortMode.RECENT && active != null) {
            val activeEntry = ordered.firstOrNull { it.packageName == active }
            if (activeEntry != null) { ordered.remove(activeEntry); ordered.add(activeEntry) }
        }
        return ordered
    }
}
