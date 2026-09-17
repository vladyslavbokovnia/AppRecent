package com.statusoverlay.app

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Process
import android.provider.Settings
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.ExperimentalMaterial3Api

class MainActivity : ComponentActivity() {
    private lateinit var store: AppStore
    override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState); store = AppStore(this); setContent { SettingsScreen() } }
    override fun onResume() { super.onResume() }
    private fun open(action: String, data: Uri? = null) { startActivity(Intent(action).apply { data?.let(::setData) }) }
    @OptIn(ExperimentalMaterial3Api::class)
    @Composable private fun SettingsScreen() {
        var render by remember { mutableStateOf(store.renderMode()) }; var sort by remember { mutableStateOf(store.sortMode()) }; var invert by remember { mutableStateOf(store.invertScroll()) }
        MaterialTheme(colorScheme = darkColorScheme(background = Color(0xFF10131A), surface = Color(0xFF191E28), primary = Color(0xFF9DB7FF))) {
            Scaffold(topBar = { TopAppBar(title = { Text("AppRecent") }, navigationIcon = { androidx.compose.material3.Icon(Icons.Default.Settings, "Настройки") }) }) { pad ->
                Column(Modifier.fillMaxSize().padding(pad).padding(20.dp).verticalScroll(rememberScrollState()), verticalArrangement = Arrangement.spacedBy(14.dp)) {
                    Text("Панель быстрого запуска", style = MaterialTheme.typography.headlineSmall); Text("Настройте отображение приложений и плавность прокрутки.", color = MaterialTheme.colorScheme.onSurfaceVariant)
                    PermissionCard("Наложение поверх других приложений", Settings.canDrawOverlays(this@MainActivity)) { open(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName")) }
                    PermissionCard("Статистика использования", usageGranted()) { open(Settings.ACTION_USAGE_ACCESS_SETTINGS) }
                    PermissionCard("Служба специальных возможностей", accessibilityGranted()) { open(Settings.ACTION_ACCESSIBILITY_SETTINGS) }
                    Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                        Text("Способ рендеринга прокрутки", style = MaterialTheme.typography.titleMedium)
                        Choice("Все видимые на экране", render == RenderMode.VISIBLE) { render = RenderMode.VISIBLE; store.setRenderMode(render) }
                        Choice("Постраничный", render == RenderMode.PAGED) { render = RenderMode.PAGED; store.setRenderMode(render) }
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) { Text("Инвертировать прокрутку по краю"); Switch(checked = invert, onCheckedChange = { invert = it; store.setInvertScroll(it) }) }
                    } }
                    Card(Modifier.fillMaxWidth()) { Column(Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) { Text("Порядок приложений", style = MaterialTheme.typography.titleMedium); Choice("Недавние — активное приложение в конце", sort == SortMode.RECENT) { sort = SortMode.RECENT; store.setSortMode(sort) }; Choice("По дате установки", sort == SortMode.INSTALL) { sort = SortMode.INSTALL; store.setSortMode(sort) } } }
                    Button(onClick = { open(Settings.ACTION_ACCESSIBILITY_SETTINGS) }, modifier = Modifier.fillMaxWidth()) { Text("Запустить / настроить панель") }
                    Spacer(Modifier.height(24.dp))
                }
            }
        }
    }
    @Composable private fun Choice(text: String, selected: Boolean, onClick: () -> Unit) { Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) { RadioButton(selected, onClick); Text(text) } }
    @Composable private fun PermissionCard(title: String, granted: Boolean, action: () -> Unit) { Card(Modifier.fillMaxWidth()) { Row(Modifier.fillMaxWidth().padding(14.dp), verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.SpaceBetween) { Column(Modifier.weight(1f)) { Text(title); Text(if (granted) "Разрешено" else "Требуется разрешение", color = if (granted) Color(0xFF75D69A) else MaterialTheme.colorScheme.error) }; Button(action) { Text(if (granted) "Открыть" else "Разрешить") } } } }
    private fun usageGranted(): Boolean { val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager; return appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), packageName) == AppOpsManager.MODE_ALLOWED }
    private fun accessibilityGranted(): Boolean { val enabled = Settings.Secure.getString(contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES) ?: return false; return enabled.contains("$packageName/${OverlayService::class.java.name}") }
}
