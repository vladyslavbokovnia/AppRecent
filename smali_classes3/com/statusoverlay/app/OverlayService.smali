.class public Lcom/statusoverlay/app/OverlayService;
.super Landroid/accessibilityservice/AccessibilityService;
.source "OverlayService.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/statusoverlay/app/OverlayService$AppSortInfo;
    }
.end annotation


# static fields
.field public static final ACTION_STOP:Ljava/lang/String; = "com.statusoverlay.app.STOP"

.field private static final CHANNEL_ID:Ljava/lang/String; = "overlay_channel"

.field private static final NOTIFICATION_ID:I = 0x1

.field private static final REFRESH_INTERVAL_MS:J = 0x2710L


# instance fields
.field private appAdapter:Lcom/statusoverlay/app/AppAdapter;

.field private appsOverlay:Landroid/view/View;

.field private final batteryReceiver:Landroid/content/BroadcastReceiver;

.field private batteryView:Landroid/view/View;

.field private hidePrefs:Landroid/content/SharedPreferences;

.field private isVisible:Z

.field private packageManager:Landroid/content/pm/PackageManager;

.field private recyclerView:Landroidx/recyclerview/widget/RecyclerView;

.field private refreshHandler:Landroid/os/Handler;

.field private refreshRunnable:Ljava/lang/Runnable;

.field private settingsPrefs:Landroid/content/SharedPreferences;

.field private sideScrollView:Landroid/view/View;

.field private usageStatsManager:Landroid/app/usage/UsageStatsManager;

.field private vibrator:Landroid/os/Vibrator;

.field private windowManager:Landroid/view/WindowManager;


# direct methods
.method static bridge synthetic -$$Nest$fgetappsOverlay(Lcom/statusoverlay/app/OverlayService;)Landroid/view/View;
    .locals 0

    iget-object p0, p0, Lcom/statusoverlay/app/OverlayService;->appsOverlay:Landroid/view/View;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetisVisible(Lcom/statusoverlay/app/OverlayService;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/statusoverlay/app/OverlayService;->isVisible:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetrecyclerView(Lcom/statusoverlay/app/OverlayService;)Landroidx/recyclerview/widget/RecyclerView;
    .locals 0

    iget-object p0, p0, Lcom/statusoverlay/app/OverlayService;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetrefreshHandler(Lcom/statusoverlay/app/OverlayService;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/statusoverlay/app/OverlayService;->refreshHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetsettingsPrefs(Lcom/statusoverlay/app/OverlayService;)Landroid/content/SharedPreferences;
    .locals 0

    iget-object p0, p0, Lcom/statusoverlay/app/OverlayService;->settingsPrefs:Landroid/content/SharedPreferences;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mlaunchApp(Lcom/statusoverlay/app/OverlayService;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/statusoverlay/app/OverlayService;->launchApp(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mrefreshAppList(Lcom/statusoverlay/app/OverlayService;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/statusoverlay/app/OverlayService;->refreshAppList(Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mscrollToRecent(Lcom/statusoverlay/app/OverlayService;)V
    .locals 0

    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->scrollToRecent()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mshowPopupMenu(Lcom/statusoverlay/app/OverlayService;Landroid/view/View;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/statusoverlay/app/OverlayService;->showPopupMenu(Landroid/view/View;Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtoggleVisibility(Lcom/statusoverlay/app/OverlayService;)V
    .locals 0

    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->toggleVisibility()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateBatteryIndicator(Lcom/statusoverlay/app/OverlayService;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/statusoverlay/app/OverlayService;->updateBatteryIndicator(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mvibrate(Lcom/statusoverlay/app/OverlayService;)V
    .locals 0

    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->vibrate()V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 48
    invoke-direct {p0}, Landroid/accessibilityservice/AccessibilityService;-><init>()V

    .line 68
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/statusoverlay/app/OverlayService;->isVisible:Z

    .line 70
    new-instance v0, Lcom/statusoverlay/app/OverlayService$1;

    invoke-direct {v0, p0}, Lcom/statusoverlay/app/OverlayService$1;-><init>(Lcom/statusoverlay/app/OverlayService;)V

    iput-object v0, p0, Lcom/statusoverlay/app/OverlayService;->batteryReceiver:Landroid/content/BroadcastReceiver;

    return-void
.end method

.method private buildNotification()Landroid/app/Notification;
    .locals 2

    .line 415
    new-instance v0, Landroidx/core/app/NotificationCompat$Builder;

    const-string v1, "overlay_channel"

    invoke-direct {v0, p0, v1}, Landroidx/core/app/NotificationCompat$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    const-string v1, "\u041e\u0432\u0435\u0440\u043b\u0435\u0439 \u0430\u043a\u0442\u0438\u0432\u0435\u043d"

    invoke-virtual {v0, v1}, Landroidx/core/app/NotificationCompat$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v0

    const v1, 0x108004a

    invoke-virtual {v0, v1}, Landroidx/core/app/NotificationCompat$Builder;->setSmallIcon(I)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroidx/core/app/NotificationCompat$Builder;->setOngoing(Z)Landroidx/core/app/NotificationCompat$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroidx/core/app/NotificationCompat$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    return-object v0
.end method

.method private createAppsOverlay()V
    .locals 3

    .line 144
    :try_start_0
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lcom/statusoverlay/app/R$layout;->overlay_view:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/OverlayService;->appsOverlay:Landroid/view/View;

    .line 145
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->appsOverlay:Landroid/view/View;

    sget v1, Lcom/statusoverlay/app/R$id;->appsRecyclerView:I

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroidx/recyclerview/widget/RecyclerView;

    iput-object v0, p0, Lcom/statusoverlay/app/OverlayService;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 146
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    if-nez v0, :cond_0

    return-void

    .line 148
    :cond_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    new-instance v1, Landroidx/recyclerview/widget/LinearLayoutManager;

    const/4 v2, 0x0

    invoke-direct {v1, p0, v2, v2}, Landroidx/recyclerview/widget/LinearLayoutManager;-><init>(Landroid/content/Context;IZ)V

    invoke-virtual {v0, v1}, Landroidx/recyclerview/widget/RecyclerView;->setLayoutManager(Landroidx/recyclerview/widget/RecyclerView$LayoutManager;)V

    .line 149
    new-instance v0, Lcom/statusoverlay/app/AppAdapter;

    new-instance v1, Lcom/statusoverlay/app/OverlayService$3;

    invoke-direct {v1, p0}, Lcom/statusoverlay/app/OverlayService$3;-><init>(Lcom/statusoverlay/app/OverlayService;)V

    invoke-direct {v0, p0, v1}, Lcom/statusoverlay/app/AppAdapter;-><init>(Landroid/content/Context;Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;)V

    iput-object v0, p0, Lcom/statusoverlay/app/OverlayService;->appAdapter:Lcom/statusoverlay/app/AppAdapter;

    .line 162
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    iget-object v1, p0, Lcom/statusoverlay/app/OverlayService;->appAdapter:Lcom/statusoverlay/app/AppAdapter;

    invoke-virtual {v0, v1}, Landroidx/recyclerview/widget/RecyclerView;->setAdapter(Landroidx/recyclerview/widget/RecyclerView$Adapter;)V

    .line 164
    const/16 v0, 0x40

    invoke-direct {p0, v0}, Lcom/statusoverlay/app/OverlayService;->dpToPx(I)I

    move-result v0

    const/16 v1, 0x30

    invoke-direct {p0, v0, v1}, Lcom/statusoverlay/app/OverlayService;->createLayoutParams(II)Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    .line 165
    .local v0, "lp":Landroid/view/WindowManager$LayoutParams;
    iget-object v1, p0, Lcom/statusoverlay/app/OverlayService;->windowManager:Landroid/view/WindowManager;

    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->appsOverlay:Landroid/view/View;

    invoke-interface {v1, v2, v0}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 166
    const/4 v1, 0x1

    invoke-direct {p0, v1}, Lcom/statusoverlay/app/OverlayService;->refreshAppList(Z)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .end local v0    # "lp":Landroid/view/WindowManager$LayoutParams;
    goto :goto_0

    .line 167
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 168
    return-void
.end method

.method private createBatteryView()V
    .locals 7

    .line 172
    :try_start_0
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lcom/statusoverlay/app/R$layout;->battery_overlay:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/OverlayService;->batteryView:Landroid/view/View;

    .line 173
    new-instance v0, Landroid/view/WindowManager$LayoutParams;

    const/4 v2, -0x1

    .line 174
    const/4 v1, 0x4

    invoke-direct {p0, v1}, Lcom/statusoverlay/app/OverlayService;->dpToPx(I)I

    move-result v3

    const/16 v4, 0x7f0

    const/16 v5, 0x118

    const/4 v6, -0x3

    move-object v1, v0

    invoke-direct/range {v1 .. v6}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V

    .line 178
    .local v0, "lp":Landroid/view/WindowManager$LayoutParams;
    const/16 v1, 0x50

    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    .line 179
    iget-object v1, p0, Lcom/statusoverlay/app/OverlayService;->windowManager:Landroid/view/WindowManager;

    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->batteryView:Landroid/view/View;

    invoke-interface {v1, v2, v0}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .end local v0    # "lp":Landroid/view/WindowManager$LayoutParams;
    goto :goto_0

    .line 180
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 181
    return-void
.end method

.method private createLayoutParams(II)Landroid/view/WindowManager$LayoutParams;
    .locals 7
    .param p1, "height"    # I
    .param p2, "gravity"    # I

    .line 216
    new-instance v6, Landroid/view/WindowManager$LayoutParams;

    const/4 v1, -0x1

    const/16 v3, 0x7f0

    const/16 v4, 0x308

    const/4 v5, -0x3

    move-object v0, v6

    move v2, p1

    invoke-direct/range {v0 .. v5}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V

    .line 221
    .local v0, "lp":Landroid/view/WindowManager$LayoutParams;
    iput p2, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    .line 222
    return-object v0
.end method

.method private createNotificationChannel()V
    .locals 4

    .line 407
    nop

    .line 408
    new-instance v0, Landroid/app/NotificationChannel;

    const-string v1, "Overlay Service"

    const/4 v2, 0x2

    const-string v3, "overlay_channel"

    invoke-direct {v0, v3, v1, v2}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    .line 409
    .local v0, "channel":Landroid/app/NotificationChannel;
    const-class v1, Landroid/app/NotificationManager;

    invoke-virtual {p0, v1}, Lcom/statusoverlay/app/OverlayService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/NotificationManager;

    .line 410
    .local v1, "nm":Landroid/app/NotificationManager;
    if-eqz v1, :cond_0

    invoke-virtual {v1, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    .line 412
    .end local v0    # "channel":Landroid/app/NotificationChannel;
    .end local v1    # "nm":Landroid/app/NotificationManager;
    :cond_0
    return-void
.end method

.method private createSideScrollView()V
    .locals 7

    .line 185
    :try_start_0
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lcom/statusoverlay/app/R$layout;->side_scroll_overlay:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/OverlayService;->sideScrollView:Landroid/view/View;

    .line 186
    new-instance v0, Landroid/view/WindowManager$LayoutParams;

    .line 187
    const/16 v1, 0xf

    invoke-direct {p0, v1}, Lcom/statusoverlay/app/OverlayService;->dpToPx(I)I

    move-result v2

    const/4 v3, -0x1

    const/16 v4, 0x7f0

    const/16 v5, 0x108

    const/4 v6, -0x3

    move-object v1, v0

    invoke-direct/range {v1 .. v6}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V

    .line 191
    .local v0, "lp":Landroid/view/WindowManager$LayoutParams;
    const v1, 0x800005

    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    .line 193
    new-instance v1, Landroid/view/GestureDetector;

    new-instance v2, Lcom/statusoverlay/app/OverlayService$4;

    invoke-direct {v2, p0}, Lcom/statusoverlay/app/OverlayService$4;-><init>(Lcom/statusoverlay/app/OverlayService;)V

    invoke-direct {v1, p0, v2}, Landroid/view/GestureDetector;-><init>(Landroid/content/Context;Landroid/view/GestureDetector$OnGestureListener;)V

    .line 210
    .local v1, "gestureDetector":Landroid/view/GestureDetector;
    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->sideScrollView:Landroid/view/View;

    new-instance v3, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda7;

    invoke-direct {v3, v1}, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda7;-><init>(Landroid/view/GestureDetector;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 211
    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->windowManager:Landroid/view/WindowManager;

    iget-object v3, p0, Lcom/statusoverlay/app/OverlayService;->sideScrollView:Landroid/view/View;

    invoke-interface {v2, v3, v0}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .end local v0    # "lp":Landroid/view/WindowManager$LayoutParams;
    .end local v1    # "gestureDetector":Landroid/view/GestureDetector;
    goto :goto_0

    .line 212
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 213
    return-void
.end method

.method private dpToPx(I)I
    .locals 2
    .param p1, "dp"    # I

    .line 419
    int-to-float v0, p1

    invoke-virtual {p0}, Lcom/statusoverlay/app/OverlayService;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr v0, v1

    const/high16 v1, 0x3f000000    # 0.5f

    add-float/2addr v0, v1

    float-to-int v0, v0

    return v0
.end method

.method private getSortedAppsByInstallDate()Ljava/util/List;
    .locals 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 362
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 364
    .local v0, "result":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :try_start_0
    iget-object v1, p0, Lcom/statusoverlay/app/OverlayService;->hidePrefs:Landroid/content/SharedPreferences;

    const-string v2, "hidden_list"

    new-instance v3, Ljava/util/HashSet;

    invoke-direct {v3}, Ljava/util/HashSet;-><init>()V

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;

    move-result-object v1

    .line 365
    .local v1, "hidden":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.intent.action.MAIN"

    const/4 v4, 0x0

    invoke-direct {v2, v3, v4}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 366
    .local v2, "mainIntent":Landroid/content/Intent;
    const-string v3, "android.intent.category.LAUNCHER"

    invoke-virtual {v2, v3}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    .line 367
    iget-object v3, p0, Lcom/statusoverlay/app/OverlayService;->packageManager:Landroid/content/pm/PackageManager;

    const/4 v4, 0x0

    invoke-virtual {v3, v2, v4}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object v3

    .line 369
    .local v3, "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    .line 370
    .local v5, "sortList":Ljava/util/List;, "Ljava/util/List<Lcom/statusoverlay/app/OverlayService$AppSortInfo;>;"
    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :goto_0
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_1

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/content/pm/ResolveInfo;

    .line 371
    .local v7, "info":Landroid/content/pm/ResolveInfo;
    iget-object v8, v7, Landroid/content/pm/ResolveInfo;->activityInfo:Landroid/content/pm/ActivityInfo;

    iget-object v8, v8, Landroid/content/pm/ActivityInfo;->packageName:Ljava/lang/String;

    .line 372
    .local v8, "pkg":Ljava/lang/String;
    invoke-virtual {p0}, Lcom/statusoverlay/app/OverlayService;->getPackageName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_0

    invoke-interface {v1, v8}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v9
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    if-nez v9, :cond_0

    .line 374
    :try_start_1
    iget-object v9, p0, Lcom/statusoverlay/app/OverlayService;->packageManager:Landroid/content/pm/PackageManager;

    invoke-virtual {v9, v8, v4}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v9

    iget-wide v9, v9, Landroid/content/pm/PackageInfo;->firstInstallTime:J

    .line 375
    .local v9, "installTime":J
    new-instance v11, Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    invoke-direct {v11, v8, v9, v10}, Lcom/statusoverlay/app/OverlayService$AppSortInfo;-><init>(Ljava/lang/String;J)V

    invoke-interface {v5, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 378
    .end local v9    # "installTime":J
    goto :goto_1

    .line 376
    :catch_0
    move-exception v9

    .line 377
    .local v9, "e":Ljava/lang/Exception;
    :try_start_2
    new-instance v10, Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    const-wide/16 v11, 0x0

    invoke-direct {v10, v8, v11, v12}, Lcom/statusoverlay/app/OverlayService$AppSortInfo;-><init>(Ljava/lang/String;J)V

    invoke-interface {v5, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 380
    .end local v7    # "info":Landroid/content/pm/ResolveInfo;
    .end local v8    # "pkg":Ljava/lang/String;
    .end local v9    # "e":Ljava/lang/Exception;
    :cond_0
    :goto_1
    goto :goto_0

    .line 381
    :cond_1
    new-instance v4, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda1;

    invoke-direct {v4}, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda1;-><init>()V

    invoke-static {v5, v4}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 382
    invoke-interface {v5}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_2
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_2

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    .local v6, "info":Lcom/statusoverlay/app/OverlayService$AppSortInfo;
    iget-object v7, v6, Lcom/statusoverlay/app/OverlayService$AppSortInfo;->packageName:Ljava/lang/String;

    invoke-interface {v0, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_2

    .end local v1    # "hidden":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    .end local v2    # "mainIntent":Landroid/content/Intent;
    .end local v3    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    .end local v5    # "sortList":Ljava/util/List;, "Ljava/util/List<Lcom/statusoverlay/app/OverlayService$AppSortInfo;>;"
    .end local v6    # "info":Lcom/statusoverlay/app/OverlayService$AppSortInfo;
    :cond_2
    goto :goto_3

    .line 383
    :catch_1
    move-exception v1

    :goto_3
    nop

    .line 384
    return-object v0
.end method

.method private getSortedAppsByUsage()Ljava/util/List;
    .locals 18
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 330
    move-object/from16 v1, p0

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    move-object v2, v0

    .line 332
    .local v2, "result":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :try_start_0
    iget-object v0, v1, Lcom/statusoverlay/app/OverlayService;->hidePrefs:Landroid/content/SharedPreferences;

    const-string v3, "hidden_list"

    new-instance v4, Ljava/util/HashSet;

    invoke-direct {v4}, Ljava/util/HashSet;-><init>()V

    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;

    move-result-object v0

    .line 333
    .local v0, "hidden":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    new-instance v3, Landroid/content/Intent;

    const-string v4, "android.intent.action.MAIN"

    const/4 v5, 0x0

    invoke-direct {v3, v4, v5}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 334
    .local v3, "mainIntent":Landroid/content/Intent;
    const-string v4, "android.intent.category.LAUNCHER"

    invoke-virtual {v3, v4}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    .line 335
    iget-object v4, v1, Lcom/statusoverlay/app/OverlayService;->packageManager:Landroid/content/pm/PackageManager;

    const/4 v5, 0x0

    invoke-virtual {v4, v3, v5}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object v4

    .line 336
    .local v4, "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    new-instance v5, Ljava/util/HashMap;

    invoke-direct {v5}, Ljava/util/HashMap;-><init>()V

    .line 337
    .local v5, "usageMap":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/Long;>;"
    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :goto_0
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_0

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/content/pm/ResolveInfo;

    .local v7, "info":Landroid/content/pm/ResolveInfo;
    iget-object v8, v7, Landroid/content/pm/ResolveInfo;->activityInfo:Landroid/content/pm/ActivityInfo;

    iget-object v8, v8, Landroid/content/pm/ActivityInfo;->packageName:Ljava/lang/String;

    const-wide/16 v9, 0x0

    invoke-static {v9, v10}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v9

    invoke-interface {v5, v8, v9}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 339
    .end local v7    # "info":Landroid/content/pm/ResolveInfo;
    :cond_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    .line 340
    .local v6, "endTime":J
    const-wide/32 v8, 0x240c8400

    sub-long v14, v6, v8

    .line 341
    .local v14, "startTime":J
    iget-object v8, v1, Lcom/statusoverlay/app/OverlayService;->usageStatsManager:Landroid/app/usage/UsageStatsManager;

    const/4 v9, 0x4

    move-wide v10, v14

    move-wide v12, v6

    invoke-virtual/range {v8 .. v13}, Landroid/app/usage/UsageStatsManager;->queryUsageStats(IJJ)Ljava/util/List;

    move-result-object v8

    .line 342
    .local v8, "stats":Ljava/util/List;, "Ljava/util/List<Landroid/app/usage/UsageStats;>;"
    if-eqz v8, :cond_2

    .line 343
    invoke-interface {v8}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :goto_1
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v10

    if-eqz v10, :cond_2

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Landroid/app/usage/UsageStats;

    .line 344
    .local v10, "s":Landroid/app/usage/UsageStats;
    invoke-virtual {v10}, Landroid/app/usage/UsageStats;->getPackageName()Ljava/lang/String;

    move-result-object v11

    invoke-interface {v5, v11}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_1

    .line 345
    invoke-virtual {v10}, Landroid/app/usage/UsageStats;->getLastTimeUsed()J

    move-result-wide v11

    .line 346
    .local v11, "lastUsed":J
    invoke-virtual {v10}, Landroid/app/usage/UsageStats;->getPackageName()Ljava/lang/String;

    move-result-object v13

    invoke-interface {v5, v13}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Ljava/lang/Long;

    invoke-virtual {v13}, Ljava/lang/Long;->longValue()J

    move-result-wide v16

    cmp-long v13, v11, v16

    if-lez v13, :cond_1

    invoke-virtual {v10}, Landroid/app/usage/UsageStats;->getPackageName()Ljava/lang/String;

    move-result-object v13

    invoke-static {v11, v12}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-interface {v5, v13, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 348
    .end local v10    # "s":Landroid/app/usage/UsageStats;
    .end local v11    # "lastUsed":J
    :cond_1
    move-object/from16 v1, p0

    goto :goto_1

    .line 350
    :cond_2
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 351
    .local v1, "sortList":Ljava/util/List;, "Ljava/util/List<Lcom/statusoverlay/app/OverlayService$AppSortInfo;>;"
    invoke-interface {v5}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v9

    invoke-interface {v9}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :goto_2
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v10

    if-eqz v10, :cond_4

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/util/Map$Entry;

    .line 352
    .local v10, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/Long;>;"
    invoke-interface {v10}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Ljava/lang/String;

    invoke-interface {v10}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v11

    invoke-interface {v0, v11}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v11

    if-nez v11, :cond_3

    .line 353
    new-instance v11, Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    invoke-interface {v10}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Ljava/lang/String;

    invoke-interface {v10}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Ljava/lang/Long;

    move-object/from16 v16, v3

    move-object/from16 v17, v4

    .end local v3    # "mainIntent":Landroid/content/Intent;
    .end local v4    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    .local v16, "mainIntent":Landroid/content/Intent;
    .local v17, "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    invoke-virtual {v13}, Ljava/lang/Long;->longValue()J

    move-result-wide v3

    invoke-direct {v11, v12, v3, v4}, Lcom/statusoverlay/app/OverlayService$AppSortInfo;-><init>(Ljava/lang/String;J)V

    invoke-interface {v1, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_3

    .line 352
    .end local v16    # "mainIntent":Landroid/content/Intent;
    .end local v17    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    .restart local v3    # "mainIntent":Landroid/content/Intent;
    .restart local v4    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    :cond_3
    move-object/from16 v16, v3

    move-object/from16 v17, v4

    .line 354
    .end local v3    # "mainIntent":Landroid/content/Intent;
    .end local v4    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    .end local v10    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/Long;>;"
    .restart local v16    # "mainIntent":Landroid/content/Intent;
    .restart local v17    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    :goto_3
    move-object/from16 v3, v16

    move-object/from16 v4, v17

    goto :goto_2

    .line 355
    .end local v16    # "mainIntent":Landroid/content/Intent;
    .end local v17    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    .restart local v3    # "mainIntent":Landroid/content/Intent;
    .restart local v4    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    :cond_4
    move-object/from16 v16, v3

    move-object/from16 v17, v4

    .end local v3    # "mainIntent":Landroid/content/Intent;
    .end local v4    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    .restart local v16    # "mainIntent":Landroid/content/Intent;
    .restart local v17    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    new-instance v3, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda6;

    invoke-direct {v3}, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda6;-><init>()V

    invoke-static {v1, v3}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 356
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_4
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_5

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    .local v4, "info":Lcom/statusoverlay/app/OverlayService$AppSortInfo;
    iget-object v9, v4, Lcom/statusoverlay/app/OverlayService$AppSortInfo;->packageName:Ljava/lang/String;

    invoke-interface {v2, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_4

    .end local v0    # "hidden":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    .end local v1    # "sortList":Ljava/util/List;, "Ljava/util/List<Lcom/statusoverlay/app/OverlayService$AppSortInfo;>;"
    .end local v4    # "info":Lcom/statusoverlay/app/OverlayService$AppSortInfo;
    .end local v5    # "usageMap":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/Long;>;"
    .end local v6    # "endTime":J
    .end local v8    # "stats":Ljava/util/List;, "Ljava/util/List<Landroid/app/usage/UsageStats;>;"
    .end local v14    # "startTime":J
    .end local v16    # "mainIntent":Landroid/content/Intent;
    .end local v17    # "allLaunchable":Ljava/util/List;, "Ljava/util/List<Landroid/content/pm/ResolveInfo;>;"
    :cond_5
    goto :goto_5

    .line 357
    :catch_0
    move-exception v0

    :goto_5
    nop

    .line 358
    return-object v2
.end method

.method private hideApp(Ljava/lang/String;)V
    .locals 4
    .param p1, "packageName"    # Ljava/lang/String;

    .line 283
    const-string v0, "hidden_list"

    :try_start_0
    new-instance v1, Ljava/util/HashSet;

    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->hidePrefs:Landroid/content/SharedPreferences;

    new-instance v3, Ljava/util/HashSet;

    invoke-direct {v3}, Ljava/util/HashSet;-><init>()V

    invoke-interface {v2, v0, v3}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 284
    .local v1, "hidden":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    invoke-interface {v1, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 285
    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->hidePrefs:Landroid/content/SharedPreferences;

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2, v0, v1}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 286
    const/4 v0, 0x0

    invoke-direct {p0, v0}, Lcom/statusoverlay/app/OverlayService;->refreshAppList(Z)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .end local v1    # "hidden":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    goto :goto_0

    .line 287
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 288
    return-void
.end method

.method static synthetic lambda$createSideScrollView$0(Landroid/view/GestureDetector;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 1
    .param p0, "gestureDetector"    # Landroid/view/GestureDetector;
    .param p1, "v"    # Landroid/view/View;
    .param p2, "event"    # Landroid/view/MotionEvent;

    .line 210
    invoke-virtual {p0, p2}, Landroid/view/GestureDetector;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    return v0
.end method

.method static synthetic lambda$getSortedAppsByInstallDate$7(Lcom/statusoverlay/app/OverlayService$AppSortInfo;Lcom/statusoverlay/app/OverlayService$AppSortInfo;)I
    .locals 4
    .param p0, "a"    # Lcom/statusoverlay/app/OverlayService$AppSortInfo;
    .param p1, "b"    # Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    .line 381
    iget-wide v0, p1, Lcom/statusoverlay/app/OverlayService$AppSortInfo;->time:J

    iget-wide v2, p0, Lcom/statusoverlay/app/OverlayService$AppSortInfo;->time:J

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Long;->compare(JJ)I

    move-result v0

    return v0
.end method

.method static synthetic lambda$getSortedAppsByUsage$6(Lcom/statusoverlay/app/OverlayService$AppSortInfo;Lcom/statusoverlay/app/OverlayService$AppSortInfo;)I
    .locals 4
    .param p0, "a"    # Lcom/statusoverlay/app/OverlayService$AppSortInfo;
    .param p1, "b"    # Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    .line 355
    iget-wide v0, p1, Lcom/statusoverlay/app/OverlayService$AppSortInfo;->time:J

    iget-wide v2, p0, Lcom/statusoverlay/app/OverlayService$AppSortInfo;->time:J

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Long;->compare(JJ)I

    move-result v0

    return v0
.end method

.method private launchApp(Ljava/lang/String;)V
    .locals 2
    .param p1, "pkg"    # Ljava/lang/String;

    .line 389
    :try_start_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->packageManager:Landroid/content/pm/PackageManager;

    invoke-virtual {v0, p1}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v0

    .line 390
    .local v0, "intent":Landroid/content/Intent;
    if-eqz v0, :cond_0

    .line 391
    const/high16 v1, 0x10000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 392
    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/OverlayService;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 394
    .end local v0    # "intent":Landroid/content/Intent;
    :catch_0
    move-exception v0

    :cond_0
    :goto_0
    nop

    .line 395
    return-void
.end method

.method private refreshAppList(Z)V
    .locals 6
    .param p1, "forceScroll"    # Z

    .line 304
    :try_start_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->settingsPrefs:Landroid/content/SharedPreferences;

    const-string v1, "sort_mode"

    const-string v2, "usage"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 306
    .local v0, "sortMode":Ljava/lang/String;
    const-string v1, "install"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 307
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->getSortedAppsByInstallDate()Ljava/util/List;

    move-result-object v1

    .local v1, "apps":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    goto :goto_0

    .line 309
    .end local v1    # "apps":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :cond_0
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->getSortedAppsByUsage()Ljava/util/List;

    move-result-object v1

    .line 311
    .restart local v1    # "apps":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :goto_0
    invoke-static {v1}, Ljava/util/Collections;->reverse(Ljava/util/List;)V

    .line 312
    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->appAdapter:Lcom/statusoverlay/app/AppAdapter;

    if-eqz v2, :cond_1

    .line 313
    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->appAdapter:Lcom/statusoverlay/app/AppAdapter;

    invoke-virtual {v2, v1}, Lcom/statusoverlay/app/AppAdapter;->setApps(Ljava/util/List;)V

    .line 314
    if-eqz p1, :cond_1

    .line 315
    new-instance v2, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v3, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda0;

    invoke-direct {v3, p0}, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda0;-><init>(Lcom/statusoverlay/app/OverlayService;)V

    const-wide/16 v4, 0xc8

    invoke-virtual {v2, v3, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 318
    .end local v0    # "sortMode":Ljava/lang/String;
    .end local v1    # "apps":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :catch_0
    move-exception v0

    :cond_1
    :goto_1
    nop

    .line 319
    return-void
.end method

.method private removeView(Landroid/view/View;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 137
    if-eqz p1, :cond_0

    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->windowManager:Landroid/view/WindowManager;

    if-eqz v0, :cond_0

    .line 138
    :try_start_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->windowManager:Landroid/view/WindowManager;

    invoke-interface {v0, p1}, Landroid/view/WindowManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 140
    :cond_0
    :goto_0
    return-void
.end method

.method private scrollToRecent()V
    .locals 2

    .line 323
    :try_start_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->appAdapter:Lcom/statusoverlay/app/AppAdapter;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->appAdapter:Lcom/statusoverlay/app/AppAdapter;

    invoke-virtual {v0}, Lcom/statusoverlay/app/AppAdapter;->getItemCount()I

    move-result v0

    if-lez v0, :cond_0

    .line 324
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->recyclerView:Landroidx/recyclerview/widget/RecyclerView;

    iget-object v1, p0, Lcom/statusoverlay/app/OverlayService;->appAdapter:Lcom/statusoverlay/app/AppAdapter;

    invoke-virtual {v1}, Lcom/statusoverlay/app/AppAdapter;->getItemCount()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    invoke-virtual {v0, v1}, Landroidx/recyclerview/widget/RecyclerView;->smoothScrollToPosition(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 326
    :catch_0
    move-exception v0

    :cond_0
    :goto_0
    nop

    .line 327
    return-void
.end method

.method private showPopupMenu(Landroid/view/View;Ljava/lang/String;)V
    .locals 7
    .param p1, "anchor"    # Landroid/view/View;
    .param p2, "packageName"    # Ljava/lang/String;

    .line 237
    :try_start_0
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lcom/statusoverlay/app/R$layout;->popup_menu:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 238
    .local v0, "popupView":Landroid/view/View;
    new-instance v1, Landroid/widget/PopupWindow;

    const/4 v2, 0x1

    const/4 v3, -0x2

    invoke-direct {v1, v0, v3, v3, v2}, Landroid/widget/PopupWindow;-><init>(Landroid/view/View;IIZ)V

    .line 240
    .local v1, "popupWindow":Landroid/widget/PopupWindow;
    sget v3, Lcom/statusoverlay/app/R$id;->menuEditIcon:I

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    new-instance v4, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;

    invoke-direct {v4, p0, v1, p2}, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;-><init>(Lcom/statusoverlay/app/OverlayService;Landroid/widget/PopupWindow;Ljava/lang/String;)V

    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 248
    sget v3, Lcom/statusoverlay/app/R$id;->menuHideApp:I

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    new-instance v4, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda3;

    invoke-direct {v4, p0, v1, p2}, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda3;-><init>(Lcom/statusoverlay/app/OverlayService;Landroid/widget/PopupWindow;Ljava/lang/String;)V

    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 253
    sget v3, Lcom/statusoverlay/app/R$id;->menuSortToggle:I

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    new-instance v4, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda4;

    invoke-direct {v4, p0, v1}, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda4;-><init>(Lcom/statusoverlay/app/OverlayService;Landroid/widget/PopupWindow;)V

    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 258
    sget v3, Lcom/statusoverlay/app/R$id;->menuSettings:I

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    new-instance v4, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda5;

    invoke-direct {v4, p0, v1, p2}, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda5;-><init>(Lcom/statusoverlay/app/OverlayService;Landroid/widget/PopupWindow;Ljava/lang/String;)V

    invoke-virtual {v3, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 266
    const/4 v3, 0x2

    new-array v3, v3, [I

    .line 267
    .local v3, "location":[I
    invoke-virtual {p1, v3}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 268
    const/4 v4, 0x0

    aget v5, v3, v4

    aget v2, v3, v2

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v6

    add-int/2addr v2, v6

    invoke-virtual {v1, p1, v4, v5, v2}, Landroid/widget/PopupWindow;->showAtLocation(Landroid/view/View;III)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .end local v0    # "popupView":Landroid/view/View;
    .end local v1    # "popupWindow":Landroid/widget/PopupWindow;
    .end local v3    # "location":[I
    goto :goto_0

    .line 269
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 270
    return-void
.end method

.method private toggleSortMode()V
    .locals 5

    .line 273
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->settingsPrefs:Landroid/content/SharedPreferences;

    const-string v1, "sort_mode"

    const-string v2, "usage"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 274
    .local v0, "currentMode":Ljava/lang/String;
    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    const-string v3, "install"

    goto :goto_0

    :cond_0
    move-object v3, v2

    .line 275
    .local v3, "newMode":Ljava/lang/String;
    :goto_0
    iget-object v4, p0, Lcom/statusoverlay/app/OverlayService;->settingsPrefs:Landroid/content/SharedPreferences;

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    invoke-interface {v4, v1, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 276
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "\u0421\u043e\u0440\u0442\u0438\u0440\u043e\u0432\u043a\u0430: \u041d\u0435\u0434\u0430\u0432\u043d\u0438\u0435"

    goto :goto_1

    :cond_1
    const-string v1, "\u0421\u043e\u0440\u0442\u0438\u0440\u043e\u0432\u043a\u0430: \u041f\u043e \u0434\u0430\u0442\u0435 \u0443\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0438"

    .line 277
    .local v1, "msg":Ljava/lang/String;
    :goto_1
    const/4 v2, 0x0

    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    .line 278
    const/4 v2, 0x1

    invoke-direct {p0, v2}, Lcom/statusoverlay/app/OverlayService;->refreshAppList(Z)V

    .line 279
    return-void
.end method

.method private toggleVisibility()V
    .locals 4

    .line 227
    :try_start_0
    iget-boolean v0, p0, Lcom/statusoverlay/app/OverlayService;->isVisible:Z

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-nez v0, :cond_0

    move v0, v1

    goto :goto_0

    :cond_0
    move v0, v2

    :goto_0
    iput-boolean v0, p0, Lcom/statusoverlay/app/OverlayService;->isVisible:Z

    .line 228
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->appsOverlay:Landroid/view/View;

    if-eqz v0, :cond_2

    .line 229
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->appsOverlay:Landroid/view/View;

    iget-boolean v3, p0, Lcom/statusoverlay/app/OverlayService;->isVisible:Z

    if-eqz v3, :cond_1

    goto :goto_1

    :cond_1
    const/16 v2, 0x8

    :goto_1
    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 230
    iget-boolean v0, p0, Lcom/statusoverlay/app/OverlayService;->isVisible:Z

    if-eqz v0, :cond_2

    invoke-direct {p0, v1}, Lcom/statusoverlay/app/OverlayService;->refreshAppList(Z)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    .line 232
    :catch_0
    move-exception v0

    :cond_2
    :goto_2
    nop

    .line 233
    return-void
.end method

.method private updateBatteryIndicator(II)V
    .locals 5
    .param p1, "level"    # I
    .param p2, "scale"    # I

    .line 292
    :try_start_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->batteryView:Landroid/view/View;

    if-nez v0, :cond_0

    return-void

    .line 293
    :cond_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->batteryView:Landroid/view/View;

    sget v1, Lcom/statusoverlay/app/R$id;->batteryProgress:I

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 294
    .local v0, "progress":Landroid/view/View;
    if-nez v0, :cond_1

    return-void

    .line 295
    :cond_1
    int-to-float v1, p1

    int-to-float v2, p2

    div-float/2addr v1, v2

    .line 296
    .local v1, "pct":F
    invoke-virtual {p0}, Lcom/statusoverlay/app/OverlayService;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    iget v2, v2, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 297
    .local v2, "screenWidth":I
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    int-to-float v4, v2

    mul-float/2addr v4, v1

    float-to-int v4, v4

    iput v4, v3, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 298
    invoke-virtual {v0}, Landroid/view/View;->requestLayout()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .end local v0    # "progress":Landroid/view/View;
    .end local v1    # "pct":F
    .end local v2    # "screenWidth":I
    goto :goto_0

    .line 299
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 300
    return-void
.end method

.method private vibrate()V
    .locals 4

    .line 399
    :try_start_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->vibrator:Landroid/os/Vibrator;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->vibrator:Landroid/os/Vibrator;

    invoke-virtual {v0}, Landroid/os/Vibrator;->hasVibrator()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 400
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->vibrator:Landroid/os/Vibrator;

    const-wide/16 v1, 0x14

    const/4 v3, -0x1

    invoke-static {v1, v2, v3}, Landroid/os/VibrationEffect;->createOneShot(JI)Landroid/os/VibrationEffect;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Vibrator;->vibrate(Landroid/os/VibrationEffect;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 403
    :catch_0
    move-exception v0

    :cond_0
    :goto_0
    nop

    .line 404
    return-void
.end method


# virtual methods
.method synthetic lambda$refreshAppList$5$com-statusoverlay-app-OverlayService()V
    .locals 0

    .line 315
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->scrollToRecent()V

    return-void
.end method

.method synthetic lambda$showPopupMenu$1$com-statusoverlay-app-OverlayService(Landroid/widget/PopupWindow;Ljava/lang/String;Landroid/view/View;)V
    .locals 2
    .param p1, "popupWindow"    # Landroid/widget/PopupWindow;
    .param p2, "packageName"    # Ljava/lang/String;
    .param p3, "v"    # Landroid/view/View;

    .line 241
    invoke-virtual {p1}, Landroid/widget/PopupWindow;->dismiss()V

    .line 242
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/statusoverlay/app/IconPickerActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 243
    .local v0, "intent":Landroid/content/Intent;
    const-string v1, "package_name"

    invoke-virtual {v0, v1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 244
    const/high16 v1, 0x10000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 245
    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/OverlayService;->startActivity(Landroid/content/Intent;)V

    .line 246
    return-void
.end method

.method synthetic lambda$showPopupMenu$2$com-statusoverlay-app-OverlayService(Landroid/widget/PopupWindow;Ljava/lang/String;Landroid/view/View;)V
    .locals 0
    .param p1, "popupWindow"    # Landroid/widget/PopupWindow;
    .param p2, "packageName"    # Ljava/lang/String;
    .param p3, "v"    # Landroid/view/View;

    .line 249
    invoke-virtual {p1}, Landroid/widget/PopupWindow;->dismiss()V

    .line 250
    invoke-direct {p0, p2}, Lcom/statusoverlay/app/OverlayService;->hideApp(Ljava/lang/String;)V

    .line 251
    return-void
.end method

.method synthetic lambda$showPopupMenu$3$com-statusoverlay-app-OverlayService(Landroid/widget/PopupWindow;Landroid/view/View;)V
    .locals 0
    .param p1, "popupWindow"    # Landroid/widget/PopupWindow;
    .param p2, "v"    # Landroid/view/View;

    .line 254
    invoke-virtual {p1}, Landroid/widget/PopupWindow;->dismiss()V

    .line 255
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->toggleSortMode()V

    .line 256
    return-void
.end method

.method synthetic lambda$showPopupMenu$4$com-statusoverlay-app-OverlayService(Landroid/widget/PopupWindow;Ljava/lang/String;Landroid/view/View;)V
    .locals 3
    .param p1, "popupWindow"    # Landroid/widget/PopupWindow;
    .param p2, "packageName"    # Ljava/lang/String;
    .param p3, "v"    # Landroid/view/View;

    .line 259
    invoke-virtual {p1}, Landroid/widget/PopupWindow;->dismiss()V

    .line 260
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.APPLICATION_DETAILS_SETTINGS"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 261
    .local v0, "intent":Landroid/content/Intent;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "package:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    .line 262
    const/high16 v1, 0x10000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 263
    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/OverlayService;->startActivity(Landroid/content/Intent;)V

    .line 264
    return-void
.end method

.method public onAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V
    .locals 0
    .param p1, "event"    # Landroid/view/accessibility/AccessibilityEvent;

    .line 82
    return-void
.end method

.method public onDestroy()V
    .locals 2

    .line 128
    invoke-super {p0}, Landroid/accessibilityservice/AccessibilityService;->onDestroy()V

    .line 129
    :try_start_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->batteryReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p0, v0}, Lcom/statusoverlay/app/OverlayService;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 130
    :goto_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->refreshHandler:Landroid/os/Handler;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->refreshHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/statusoverlay/app/OverlayService;->refreshRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 131
    :cond_0
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->appsOverlay:Landroid/view/View;

    invoke-direct {p0, v0}, Lcom/statusoverlay/app/OverlayService;->removeView(Landroid/view/View;)V

    .line 132
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->batteryView:Landroid/view/View;

    invoke-direct {p0, v0}, Lcom/statusoverlay/app/OverlayService;->removeView(Landroid/view/View;)V

    .line 133
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService;->sideScrollView:Landroid/view/View;

    invoke-direct {p0, v0}, Lcom/statusoverlay/app/OverlayService;->removeView(Landroid/view/View;)V

    .line 134
    return-void
.end method

.method public onInterrupt()V
    .locals 0

    .line 85
    return-void
.end method

.method protected onServiceConnected()V
    .locals 6

    .line 89
    invoke-super {p0}, Landroid/accessibilityservice/AccessibilityService;->onServiceConnected()V

    .line 91
    const/4 v0, 0x1

    :try_start_0
    const-string v1, "window"

    invoke-virtual {p0, v1}, Lcom/statusoverlay/app/OverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    iput-object v1, p0, Lcom/statusoverlay/app/OverlayService;->windowManager:Landroid/view/WindowManager;

    .line 92
    invoke-virtual {p0}, Lcom/statusoverlay/app/OverlayService;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    iput-object v1, p0, Lcom/statusoverlay/app/OverlayService;->packageManager:Landroid/content/pm/PackageManager;

    .line 93
    const-string v1, "usagestats"

    invoke-virtual {p0, v1}, Lcom/statusoverlay/app/OverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/usage/UsageStatsManager;

    iput-object v1, p0, Lcom/statusoverlay/app/OverlayService;->usageStatsManager:Landroid/app/usage/UsageStatsManager;

    .line 94
    const-string v1, "vibrator"

    invoke-virtual {p0, v1}, Lcom/statusoverlay/app/OverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/Vibrator;

    iput-object v1, p0, Lcom/statusoverlay/app/OverlayService;->vibrator:Landroid/os/Vibrator;

    .line 95
    const-string v1, "hidden_apps"

    const/4 v2, 0x0

    invoke-virtual {p0, v1, v2}, Lcom/statusoverlay/app/OverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    iput-object v1, p0, Lcom/statusoverlay/app/OverlayService;->hidePrefs:Landroid/content/SharedPreferences;

    .line 96
    const-string v1, "settings"

    invoke-virtual {p0, v1, v2}, Lcom/statusoverlay/app/OverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    iput-object v1, p0, Lcom/statusoverlay/app/OverlayService;->settingsPrefs:Landroid/content/SharedPreferences;

    .line 98
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/statusoverlay/app/OverlayService;->refreshHandler:Landroid/os/Handler;

    .line 99
    new-instance v1, Lcom/statusoverlay/app/OverlayService$2;

    invoke-direct {v1, p0}, Lcom/statusoverlay/app/OverlayService$2;-><init>(Lcom/statusoverlay/app/OverlayService;)V

    iput-object v1, p0, Lcom/statusoverlay/app/OverlayService;->refreshRunnable:Ljava/lang/Runnable;

    .line 111
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->createNotificationChannel()V

    .line 112
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->buildNotification()Landroid/app/Notification;

    move-result-object v1

    invoke-virtual {p0, v0, v1}, Lcom/statusoverlay/app/OverlayService;->startForeground(ILandroid/app/Notification;)V

    .line 114
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->createAppsOverlay()V

    .line 115
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->createBatteryView()V

    .line 116
    invoke-direct {p0}, Lcom/statusoverlay/app/OverlayService;->createSideScrollView()V

    .line 118
    new-instance v1, Landroid/content/IntentFilter;

    const-string v2, "android.intent.action.BATTERY_CHANGED"

    invoke-direct {v1, v2}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 119
    .local v1, "filter":Landroid/content/IntentFilter;
    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->batteryReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p0, v2, v1}, Lcom/statusoverlay/app/OverlayService;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 120
    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService;->refreshHandler:Landroid/os/Handler;

    iget-object v3, p0, Lcom/statusoverlay/app/OverlayService;->refreshRunnable:Ljava/lang/Runnable;

    const-wide/16 v4, 0x3e8

    invoke-virtual {v2, v3, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 123
    nop

    .end local v1    # "filter":Landroid/content/IntentFilter;
    goto :goto_0

    .line 121
    :catch_0
    move-exception v1

    .line 122
    .local v1, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u041e\u0448\u0438\u0431\u043a\u0430 \u0437\u0430\u043f\u0443\u0441\u043a\u0430: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {p0, v2, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 124
    .end local v1    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method
