package com.statusoverlay.app

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager

class AppRepository(private val context: Context, private val store: AppStore = AppStore(context)) {
    private val pm: PackageManager = context.packageManager
    fun hiddenEntries(): List<AppEntry> = store.hidden().mapNotNull { pkg -> runCatching { val info = pm.getApplicationInfo(pkg, 0); AppEntry(pkg, pm.getApplicationLabel(info).toString(), 0L, pm.getPackageInfo(pkg, 0).firstInstallTime) }.getOrNull() }.sortedBy { it.label.lowercase() }
    fun load(): List<AppEntry> {
        val launcher = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        val queried = pm.queryIntentActivities(launcher, PackageManager.MATCH_ALL).map { it.activityInfo.packageName }
        val installedLaunchable = pm.getInstalledApplications(PackageManager.MATCH_ALL)
            .filter { it.enabled && pm.getLaunchIntentForPackage(it.packageName) != null }
            .map { it.packageName }
        val hidden = store.hidden()
        val packages = (queried + installedLaunchable + packageNameOfSelf()).distinct().filterNot { it in hidden }
        val now = System.currentTimeMillis()
        val usage = mutableMapOf<String, Long>()
        (context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager)
            ?.queryUsageStats(UsageStatsManager.INTERVAL_YEARLY, now - 365L * 24 * 60 * 60 * 1000L, now)
            ?.forEach { stat -> usage[stat.packageName] = maxOf(usage[stat.packageName] ?: 0L, stat.lastTimeUsed) }
        store.activePackage()?.let { usage[it] = maxOf(usage[it] ?: 0L, now) }
        val result = packages.mapNotNull { pkg -> runCatching {
            val info = pm.getApplicationInfo(pkg, 0); val pi = pm.getPackageInfo(pkg, 0)
            AppEntry(pkg, pm.getApplicationLabel(info).toString(), usage[pkg] ?: 0L, pi.firstInstallTime)
        }.getOrNull() }
        val sorted = when (store.sortMode()) {
            SortMode.INSTALL -> result.sortedWith(compareByDescending<AppEntry> { it.installTime }.thenBy { it.label.lowercase() })
            SortMode.RECENT -> result.sortedWith(compareBy<AppEntry> { it.lastUsed }.thenBy { it.label.lowercase() })
        }
        return sorted
    }

    private fun packageNameOfSelf(): String = context.packageName
}
