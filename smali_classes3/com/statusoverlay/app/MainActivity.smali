.class public Lcom/statusoverlay/app/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"


# instance fields
.field private btnGrantOverlay:Landroid/widget/Button;

.field private btnGrantUsage:Landroid/widget/Button;

.field private btnToggleOverlay:Landroid/widget/Button;

.field private cbInvertScroll:Landroid/widget/CheckBox;

.field private hidePrefs:Landroid/content/SharedPreferences;

.field private lvHiddenApps:Landroid/widget/ListView;

.field private packageManager:Landroid/content/pm/PackageManager;

.field private settingsPrefs:Landroid/content/SharedPreferences;

.field private tvOverlayStatus:Landroid/widget/TextView;

.field private tvUsageStatus:Landroid/widget/TextView;


# direct methods
.method static bridge synthetic -$$Nest$fgethidePrefs(Lcom/statusoverlay/app/MainActivity;)Landroid/content/SharedPreferences;
    .locals 0

    iget-object p0, p0, Lcom/statusoverlay/app/MainActivity;->hidePrefs:Landroid/content/SharedPreferences;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetpackageManager(Lcom/statusoverlay/app/MainActivity;)Landroid/content/pm/PackageManager;
    .locals 0

    iget-object p0, p0, Lcom/statusoverlay/app/MainActivity;->packageManager:Landroid/content/pm/PackageManager;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mupdateHiddenAppsList(Lcom/statusoverlay/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/statusoverlay/app/MainActivity;->updateHiddenAppsList()V

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 29
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method private hasUsageStatsPermission()Z
    .locals 4

    .line 126
    const-string v0, "appops"

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AppOpsManager;

    .line 127
    .local v0, "appOps":Landroid/app/AppOpsManager;
    invoke-static {}, Landroid/os/Process;->myUid()I

    move-result v1

    invoke-virtual {p0}, Lcom/statusoverlay/app/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v2

    const-string v3, "android:get_usage_stats"

    invoke-virtual {v0, v3, v1, v2}, Landroid/app/AppOpsManager;->checkOpNoThrow(Ljava/lang/String;ILjava/lang/String;)I

    move-result v1

    .line 128
    .local v1, "mode":I
    if-nez v1, :cond_0

    const/4 v2, 0x1

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    :goto_0
    return v2
.end method

.method private isAccessibilityServiceEnabled()Z
    .locals 6

    .line 132
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/statusoverlay/app/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-class v1, Lcom/statusoverlay/app/OverlayService;

    invoke-virtual {v1}, Ljava/lang/Class;->getCanonicalName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 133
    .local v0, "service":Ljava/lang/String;
    const/4 v1, 0x0

    .line 135
    .local v1, "accessibilityEnabled":I
    :try_start_0
    invoke-virtual {p0}, Lcom/statusoverlay/app/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    const-string v3, "accessibility_enabled"

    invoke-static {v2, v3}, Landroid/provider/Settings$Secure;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;)I

    move-result v2
    :try_end_0
    .catch Landroid/provider/Settings$SettingNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    move v1, v2

    goto :goto_0

    .line 136
    :catch_0
    move-exception v2

    :goto_0
    nop

    .line 137
    const/4 v2, 0x1

    if-ne v1, v2, :cond_1

    .line 138
    invoke-virtual {p0}, Lcom/statusoverlay/app/MainActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const-string v4, "enabled_accessibility_services"

    invoke-static {v3, v4}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 139
    .local v3, "settingValue":Ljava/lang/String;
    if-eqz v3, :cond_1

    .line 140
    new-instance v4, Landroid/text/TextUtils$SimpleStringSplitter;

    const/16 v5, 0x3a

    invoke-direct {v4, v5}, Landroid/text/TextUtils$SimpleStringSplitter;-><init>(C)V

    .line 141
    .local v4, "splitter":Landroid/text/TextUtils$SimpleStringSplitter;
    invoke-virtual {v4, v3}, Landroid/text/TextUtils$SimpleStringSplitter;->setString(Ljava/lang/String;)V

    .line 142
    :cond_0
    invoke-virtual {v4}, Landroid/text/TextUtils$SimpleStringSplitter;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_1

    .line 143
    invoke-virtual {v4}, Landroid/text/TextUtils$SimpleStringSplitter;->next()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_0

    return v2

    .line 147
    .end local v3    # "settingValue":Ljava/lang/String;
    .end local v4    # "splitter":Landroid/text/TextUtils$SimpleStringSplitter;
    :cond_1
    const/4 v2, 0x0

    return v2
.end method

.method private updateHiddenAppsList()V
    .locals 4

    .line 100
    iget-object v0, p0, Lcom/statusoverlay/app/MainActivity;->hidePrefs:Landroid/content/SharedPreferences;

    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    const-string v2, "hidden_list"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;

    move-result-object v0

    .line 101
    .local v0, "hiddenSet":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 102
    .local v1, "hiddenList":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    new-instance v2, Lcom/statusoverlay/app/MainActivity$1;

    const v3, 0x1090003

    invoke-direct {v2, p0, p0, v3, v1}, Lcom/statusoverlay/app/MainActivity$1;-><init>(Lcom/statusoverlay/app/MainActivity;Landroid/content/Context;ILjava/util/List;)V

    .line 122
    .local v2, "adapter":Landroid/widget/ArrayAdapter;, "Landroid/widget/ArrayAdapter<Ljava/lang/String;>;"
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->lvHiddenApps:Landroid/widget/ListView;

    invoke-virtual {v3, v2}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 123
    return-void
.end method

.method private updatePermissionStatus()V
    .locals 10

    .line 80
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z

    move-result v0

    .line 81
    .local v0, "overlay":Z
    invoke-direct {p0}, Lcom/statusoverlay/app/MainActivity;->hasUsageStatsPermission()Z

    move-result v1

    .line 82
    .local v1, "usage":Z
    invoke-direct {p0}, Lcom/statusoverlay/app/MainActivity;->isAccessibilityServiceEnabled()Z

    move-result v2

    .line 84
    .local v2, "acc":Z
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->tvOverlayStatus:Landroid/widget/TextView;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u25cf \u041d\u0430\u043b\u043e\u0436\u0435\u043d\u0438\u0435 \u043f\u043e\u0432\u0435\u0440\u0445: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\u041e\u041a"

    const-string v6, "\u041d\u0415\u0422"

    if-eqz v0, :cond_0

    move-object v7, v5

    goto :goto_0

    :cond_0
    move-object v7, v6

    :goto_0
    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 85
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->tvOverlayStatus:Landroid/widget/TextView;

    const v4, -0x9495

    const v7, -0xb350b0

    if-eqz v0, :cond_1

    move v8, v7

    goto :goto_1

    :cond_1
    move v8, v4

    :goto_1
    invoke-virtual {v3, v8}, Landroid/widget/TextView;->setTextColor(I)V

    .line 87
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->tvUsageStatus:Landroid/widget/TextView;

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "\u25cf \u0421\u0442\u0430\u0442\u0438\u0441\u0442\u0438\u043a\u0430: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    if-eqz v1, :cond_2

    goto :goto_2

    :cond_2
    move-object v5, v6

    :goto_2
    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 88
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->tvUsageStatus:Landroid/widget/TextView;

    if-eqz v1, :cond_3

    move v4, v7

    :cond_3
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    .line 90
    if-eqz v2, :cond_4

    .line 91
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->btnToggleOverlay:Landroid/widget/Button;

    const-string v4, "\u0421\u043b\u0443\u0436\u0431\u0430 \u0430\u043a\u0442\u0438\u0432\u043d\u0430"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 92
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->btnToggleOverlay:Landroid/widget/Button;

    invoke-static {v7}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setBackgroundTintList(Landroid/content/res/ColorStateList;)V

    goto :goto_3

    .line 94
    :cond_4
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->btnToggleOverlay:Landroid/widget/Button;

    const-string v4, "\u0412\u043a\u043b\u044e\u0447\u0438\u0442\u044c \u0421\u043f\u0435\u0446. \u0432\u043e\u0437\u043c\u043e\u0436\u043d\u043e\u0441\u0442\u0438"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 95
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity;->btnToggleOverlay:Landroid/widget/Button;

    const v4, -0x16baa0

    invoke-static {v4}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setBackgroundTintList(Landroid/content/res/ColorStateList;)V

    .line 97
    :goto_3
    return-void
.end method


# virtual methods
.method synthetic lambda$onCreate$0$com-statusoverlay-app-MainActivity(Landroid/widget/CompoundButton;Z)V
    .locals 2
    .param p1, "buttonView"    # Landroid/widget/CompoundButton;
    .param p2, "isChecked"    # Z

    .line 58
    iget-object v0, p0, Lcom/statusoverlay/app/MainActivity;->settingsPrefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "invert_scroll"

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 59
    const-string v0, "\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0430 \u0441\u043a\u0440\u043e\u043b\u043b\u0430 \u043e\u0431\u043d\u043e\u0432\u043b\u0435\u043d\u0430"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 60
    return-void
.end method

.method synthetic lambda$onCreate$1$com-statusoverlay-app-MainActivity(Landroid/view/View;)V
    .locals 3
    .param p1, "v"    # Landroid/view/View;

    .line 63
    new-instance v0, Landroid/content/Intent;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "package:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0}, Lcom/statusoverlay/app/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    const-string v2, "android.settings.action.MANAGE_OVERLAY_PERMISSION"

    invoke-direct {v0, v2, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 64
    .local v0, "intent":Landroid/content/Intent;
    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->startActivity(Landroid/content/Intent;)V

    .line 65
    return-void
.end method

.method synthetic lambda$onCreate$2$com-statusoverlay-app-MainActivity(Landroid/view/View;)V
    .locals 2
    .param p1, "v"    # Landroid/view/View;

    .line 67
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.USAGE_ACCESS_SETTINGS"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method synthetic lambda$onCreate$3$com-statusoverlay-app-MainActivity(Landroid/view/View;)V
    .locals 2
    .param p1, "v"    # Landroid/view/View;

    .line 69
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.ACCESSIBILITY_SETTINGS"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 41
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 42
    sget v0, Lcom/statusoverlay/app/R$layout;->activity_main:I

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->setContentView(I)V

    .line 44
    sget v0, Lcom/statusoverlay/app/R$id;->btnGrantOverlay:I

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->btnGrantOverlay:Landroid/widget/Button;

    .line 45
    sget v0, Lcom/statusoverlay/app/R$id;->btnGrantUsage:I

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->btnGrantUsage:Landroid/widget/Button;

    .line 46
    sget v0, Lcom/statusoverlay/app/R$id;->btnToggleOverlay:I

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->btnToggleOverlay:Landroid/widget/Button;

    .line 47
    sget v0, Lcom/statusoverlay/app/R$id;->tvOverlayStatus:I

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->tvOverlayStatus:Landroid/widget/TextView;

    .line 48
    sget v0, Lcom/statusoverlay/app/R$id;->tvUsageStatus:I

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->tvUsageStatus:Landroid/widget/TextView;

    .line 49
    sget v0, Lcom/statusoverlay/app/R$id;->lvHiddenApps:I

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ListView;

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->lvHiddenApps:Landroid/widget/ListView;

    .line 50
    sget v0, Lcom/statusoverlay/app/R$id;->cbInvertScroll:I

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/CheckBox;

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->cbInvertScroll:Landroid/widget/CheckBox;

    .line 52
    const-string v0, "hidden_apps"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Lcom/statusoverlay/app/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->hidePrefs:Landroid/content/SharedPreferences;

    .line 53
    const-string v0, "settings"

    invoke-virtual {p0, v0, v1}, Lcom/statusoverlay/app/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->settingsPrefs:Landroid/content/SharedPreferences;

    .line 54
    invoke-virtual {p0}, Lcom/statusoverlay/app/MainActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/MainActivity;->packageManager:Landroid/content/pm/PackageManager;

    .line 56
    iget-object v0, p0, Lcom/statusoverlay/app/MainActivity;->cbInvertScroll:Landroid/widget/CheckBox;

    iget-object v2, p0, Lcom/statusoverlay/app/MainActivity;->settingsPrefs:Landroid/content/SharedPreferences;

    const-string v3, "invert_scroll"

    invoke-interface {v2, v3, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/CheckBox;->setChecked(Z)V

    .line 57
    iget-object v0, p0, Lcom/statusoverlay/app/MainActivity;->cbInvertScroll:Landroid/widget/CheckBox;

    new-instance v1, Lcom/statusoverlay/app/MainActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/statusoverlay/app/MainActivity$$ExternalSyntheticLambda0;-><init>(Lcom/statusoverlay/app/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 62
    iget-object v0, p0, Lcom/statusoverlay/app/MainActivity;->btnGrantOverlay:Landroid/widget/Button;

    new-instance v1, Lcom/statusoverlay/app/MainActivity$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lcom/statusoverlay/app/MainActivity$$ExternalSyntheticLambda1;-><init>(Lcom/statusoverlay/app/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 67
    iget-object v0, p0, Lcom/statusoverlay/app/MainActivity;->btnGrantUsage:Landroid/widget/Button;

    new-instance v1, Lcom/statusoverlay/app/MainActivity$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lcom/statusoverlay/app/MainActivity$$ExternalSyntheticLambda2;-><init>(Lcom/statusoverlay/app/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 69
    iget-object v0, p0, Lcom/statusoverlay/app/MainActivity;->btnToggleOverlay:Landroid/widget/Button;

    new-instance v1, Lcom/statusoverlay/app/MainActivity$$ExternalSyntheticLambda3;

    invoke-direct {v1, p0}, Lcom/statusoverlay/app/MainActivity$$ExternalSyntheticLambda3;-><init>(Lcom/statusoverlay/app/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 70
    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 74
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onResume()V

    .line 75
    invoke-direct {p0}, Lcom/statusoverlay/app/MainActivity;->updatePermissionStatus()V

    .line 76
    invoke-direct {p0}, Lcom/statusoverlay/app/MainActivity;->updateHiddenAppsList()V

    .line 77
    return-void
.end method
