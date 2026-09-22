plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
}

android { namespace = "com.statusoverlay.app"; compileSdk = 35
    defaultConfig { applicationId = "com.statusoverlay.app"; minSdk = 26; targetSdk = 35; versionCode = 4; versionName = "2.2"; testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner" }
    signingConfigs { create("stable") { storeFile = file("../apprecent-release.jks"); storePassword = "AppRecentRelease2026"; keyAlias = "apprecent"; keyPassword = "AppRecentRelease2026" } }
    buildTypes { debug { signingConfig = signingConfigs.getByName("stable") }; release { signingConfig = signingConfigs.getByName("stable"); isMinifyEnabled = false; proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro") } }
    compileOptions { sourceCompatibility = JavaVersion.VERSION_17; targetCompatibility = JavaVersion.VERSION_17 }
    kotlinOptions { jvmTarget = "17" }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2024.12.01"))
    implementation("androidx.activity:activity-compose:1.10.0")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.7")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.8.7")
    implementation("androidx.core:core-ktx:1.15.0")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.9.0")
    testImplementation("junit:junit:4.13.2")
}
