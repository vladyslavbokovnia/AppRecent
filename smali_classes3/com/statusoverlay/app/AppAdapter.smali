.class public Lcom/statusoverlay/app/AppAdapter;
.super Landroidx/recyclerview/widget/RecyclerView$Adapter;
.source "AppAdapter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;,
        Lcom/statusoverlay/app/AppAdapter$AppViewHolder;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/recyclerview/widget/RecyclerView$Adapter<",
        "Lcom/statusoverlay/app/AppAdapter$AppViewHolder;",
        ">;"
    }
.end annotation


# instance fields
.field private final actionListener:Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;

.field private final context:Landroid/content/Context;

.field private final executorService:Ljava/util/concurrent/ExecutorService;

.field private final iconCache:Landroid/util/LruCache;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/LruCache<",
            "Ljava/lang/String;",
            "Landroid/graphics/drawable/Drawable;",
            ">;"
        }
    .end annotation
.end field

.field private final iconPrefs:Landroid/content/SharedPreferences;

.field private final mainHandler:Landroid/os/Handler;

.field private final packageManager:Landroid/content/pm/PackageManager;

.field private final packageNames:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Landroid/content/Context;Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;)V
    .locals 4
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "listener"    # Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;

    .line 45
    invoke-direct {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;-><init>()V

    .line 30
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->packageNames:Ljava/util/List;

    .line 37
    const/4 v0, 0x4

    invoke-static {v0}, Ljava/util/concurrent/Executors;->newFixedThreadPool(I)Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->executorService:Ljava/util/concurrent/ExecutorService;

    .line 38
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->mainHandler:Landroid/os/Handler;

    .line 46
    iput-object p1, p0, Lcom/statusoverlay/app/AppAdapter;->context:Landroid/content/Context;

    .line 47
    iput-object p2, p0, Lcom/statusoverlay/app/AppAdapter;->actionListener:Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;

    .line 48
    invoke-virtual {p1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->packageManager:Landroid/content/pm/PackageManager;

    .line 49
    const-string v0, "custom_icons"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->iconPrefs:Landroid/content/SharedPreferences;

    .line 51
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Runtime;->maxMemory()J

    move-result-wide v0

    const-wide/16 v2, 0x400

    div-long/2addr v0, v2

    long-to-int v0, v0

    .line 52
    .local v0, "maxMemory":I
    div-int/lit8 v1, v0, 0x8

    .line 53
    .local v1, "cacheSize":I
    new-instance v2, Lcom/statusoverlay/app/AppAdapter$1;

    invoke-direct {v2, p0, v1}, Lcom/statusoverlay/app/AppAdapter$1;-><init>(Lcom/statusoverlay/app/AppAdapter;I)V

    iput-object v2, p0, Lcom/statusoverlay/app/AppAdapter;->iconCache:Landroid/util/LruCache;

    .line 62
    return-void
.end method

.method static synthetic lambda$loadIconAsync$2(Ljava/lang/String;Lcom/statusoverlay/app/AppAdapter$AppViewHolder;Landroid/graphics/drawable/Drawable;)V
    .locals 1
    .param p0, "pkg"    # Ljava/lang/String;
    .param p1, "holder"    # Lcom/statusoverlay/app/AppAdapter$AppViewHolder;
    .param p2, "icon"    # Landroid/graphics/drawable/Drawable;

    .line 105
    iget-object v0, p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;->packageName:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 106
    iget-object v0, p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;->appIcon:Landroid/widget/ImageView;

    invoke-virtual {v0, p2}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 108
    :cond_0
    return-void
.end method

.method private loadIconAsync(Lcom/statusoverlay/app/AppAdapter$AppViewHolder;Ljava/lang/String;)V
    .locals 2
    .param p1, "holder"    # Lcom/statusoverlay/app/AppAdapter$AppViewHolder;
    .param p2, "pkg"    # Ljava/lang/String;

    .line 100
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->executorService:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p2, p1}, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;-><init>(Lcom/statusoverlay/app/AppAdapter;Ljava/lang/String;Lcom/statusoverlay/app/AppAdapter$AppViewHolder;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 111
    return-void
.end method

.method private loadIconSync(Ljava/lang/String;)Landroid/graphics/drawable/Drawable;
    .locals 4
    .param p1, "packageName"    # Ljava/lang/String;

    .line 114
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->iconPrefs:Landroid/content/SharedPreferences;

    const/4 v1, 0x0

    invoke-interface {v0, p1, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 115
    .local v0, "customUri":Ljava/lang/String;
    if-eqz v0, :cond_1

    .line 117
    :try_start_0
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    .line 118
    .local v1, "uri":Landroid/net/Uri;
    iget-object v2, p0, Lcom/statusoverlay/app/AppAdapter;->context:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v2, v1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v2

    .line 119
    .local v2, "is":Ljava/io/InputStream;
    invoke-virtual {v1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/graphics/drawable/Drawable;->createFromStream(Ljava/io/InputStream;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object v3
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 120
    .local v3, "d":Landroid/graphics/drawable/Drawable;
    if-eqz v3, :cond_0

    return-object v3

    .line 123
    .end local v1    # "uri":Landroid/net/Uri;
    .end local v2    # "is":Ljava/io/InputStream;
    .end local v3    # "d":Landroid/graphics/drawable/Drawable;
    :cond_0
    goto :goto_0

    .line 121
    :catch_0
    move-exception v1

    .line 122
    .local v1, "e":Ljava/lang/Exception;
    iget-object v2, p0, Lcom/statusoverlay/app/AppAdapter;->iconPrefs:Landroid/content/SharedPreferences;

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2, p1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 126
    .end local v1    # "e":Ljava/lang/Exception;
    :cond_1
    :goto_0
    :try_start_1
    iget-object v1, p0, Lcom/statusoverlay/app/AppAdapter;->packageManager:Landroid/content/pm/PackageManager;

    invoke-virtual {v1, p1}, Landroid/content/pm/PackageManager;->getApplicationIcon(Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object v1
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return-object v1

    .line 127
    :catch_1
    move-exception v1

    .line 128
    .restart local v1    # "e":Ljava/lang/Exception;
    iget-object v2, p0, Lcom/statusoverlay/app/AppAdapter;->context:Landroid/content/Context;

    const v3, 0x1080093

    invoke-virtual {v2, v3}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v2

    return-object v2
.end method


# virtual methods
.method public getItemCount()I
    .locals 1

    .line 134
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->packageNames:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    return v0
.end method

.method synthetic lambda$loadIconAsync$3$com-statusoverlay-app-AppAdapter(Ljava/lang/String;Lcom/statusoverlay/app/AppAdapter$AppViewHolder;)V
    .locals 3
    .param p1, "pkg"    # Ljava/lang/String;
    .param p2, "holder"    # Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

    .line 101
    invoke-direct {p0, p1}, Lcom/statusoverlay/app/AppAdapter;->loadIconSync(Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    .line 102
    .local v0, "icon":Landroid/graphics/drawable/Drawable;
    if-eqz v0, :cond_0

    .line 103
    iget-object v1, p0, Lcom/statusoverlay/app/AppAdapter;->iconCache:Landroid/util/LruCache;

    invoke-virtual {v1, p1, v0}, Landroid/util/LruCache;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 104
    iget-object v1, p0, Lcom/statusoverlay/app/AppAdapter;->mainHandler:Landroid/os/Handler;

    new-instance v2, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;

    invoke-direct {v2, p1, p2, v0}, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;-><init>(Ljava/lang/String;Lcom/statusoverlay/app/AppAdapter$AppViewHolder;Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 110
    :cond_0
    return-void
.end method

.method synthetic lambda$onBindViewHolder$0$com-statusoverlay-app-AppAdapter(Ljava/lang/String;Landroid/view/View;)V
    .locals 1
    .param p1, "pkg"    # Ljava/lang/String;
    .param p2, "v"    # Landroid/view/View;

    .line 92
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->actionListener:Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;

    invoke-interface {v0, p1}, Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;->onAppClick(Ljava/lang/String;)V

    return-void
.end method

.method synthetic lambda$onBindViewHolder$1$com-statusoverlay-app-AppAdapter(Ljava/lang/String;Landroid/view/View;)Z
    .locals 1
    .param p1, "pkg"    # Ljava/lang/String;
    .param p2, "v"    # Landroid/view/View;

    .line 94
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->actionListener:Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;

    invoke-interface {v0, p2, p1}, Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;->onAppLongClick(Landroid/view/View;Ljava/lang/String;)V

    .line 95
    const/4 v0, 0x1

    return v0
.end method

.method public bridge synthetic onBindViewHolder(Landroidx/recyclerview/widget/RecyclerView$ViewHolder;I)V
    .locals 0

    .line 27
    check-cast p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

    invoke-virtual {p0, p1, p2}, Lcom/statusoverlay/app/AppAdapter;->onBindViewHolder(Lcom/statusoverlay/app/AppAdapter$AppViewHolder;I)V

    return-void
.end method

.method public onBindViewHolder(Lcom/statusoverlay/app/AppAdapter$AppViewHolder;I)V
    .locals 6
    .param p1, "holder"    # Lcom/statusoverlay/app/AppAdapter$AppViewHolder;
    .param p2, "position"    # I

    .line 79
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->packageNames:Ljava/util/List;

    invoke-interface {v0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 80
    .local v0, "pkg":Ljava/lang/String;
    iput-object v0, p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;->packageName:Ljava/lang/String;

    iget-object v1, p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;->itemView:Landroid/view/View;

    iget-object v2, p0, Lcom/statusoverlay/app/AppAdapter;->packageManager:Landroid/content/pm/PackageManager;

    const/4 v3, 0x0

    invoke-virtual {v2, v0, v3}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v4

    invoke-virtual {v2, v4}, Landroid/content/pm/PackageManager;->getApplicationLabel(Landroid/content/pm/ApplicationInfo;)Ljava/lang/CharSequence;

    move-result-object v5

    invoke-virtual {v1, v5}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 83
    iget-object v1, p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;->appIcon:Landroid/widget/ImageView;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 85
    iget-object v1, p0, Lcom/statusoverlay/app/AppAdapter;->iconCache:Landroid/util/LruCache;

    invoke-virtual {v1, v0}, Landroid/util/LruCache;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/graphics/drawable/Drawable;

    .line 86
    .local v1, "cachedIcon":Landroid/graphics/drawable/Drawable;
    if-eqz v1, :cond_0

    .line 87
    iget-object v2, p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;->appIcon:Landroid/widget/ImageView;

    invoke-virtual {v2, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    goto :goto_0

    .line 89
    :cond_0
    invoke-direct {p0, p1, v0}, Lcom/statusoverlay/app/AppAdapter;->loadIconAsync(Lcom/statusoverlay/app/AppAdapter$AppViewHolder;Ljava/lang/String;)V

    .line 92
    :goto_0
    iget-object v2, p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;->itemView:Landroid/view/View;

    new-instance v3, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda1;

    invoke-direct {v3, p0, v0}, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda1;-><init>(Lcom/statusoverlay/app/AppAdapter;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 93
    iget-object v2, p1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;->itemView:Landroid/view/View;

    new-instance v3, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda2;

    invoke-direct {v3, p0, v0}, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda2;-><init>(Lcom/statusoverlay/app/AppAdapter;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnLongClickListener(Landroid/view/View$OnLongClickListener;)V

    .line 97
    return-void
.end method

.method public bridge synthetic onCreateViewHolder(Landroid/view/ViewGroup;I)Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
    .locals 0

    .line 27
    invoke-virtual {p0, p1, p2}, Lcom/statusoverlay/app/AppAdapter;->onCreateViewHolder(Landroid/view/ViewGroup;I)Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

    move-result-object p1

    return-object p1
.end method

.method public onCreateViewHolder(Landroid/view/ViewGroup;I)Lcom/statusoverlay/app/AppAdapter$AppViewHolder;
    .locals 3
    .param p1, "parent"    # Landroid/view/ViewGroup;
    .param p2, "viewType"    # I

    .line 73
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->context:Landroid/content/Context;

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lcom/statusoverlay/app/R$layout;->item_app_icon:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, p1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object v0

    .line 74
    .local v0, "view":Landroid/view/View;
    new-instance v1, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

    invoke-direct {v1, v0}, Lcom/statusoverlay/app/AppAdapter$AppViewHolder;-><init>(Landroid/view/View;)V

    return-object v1
.end method

.method public setApps(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 65
    .local p1, "newApps":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->iconCache:Landroid/util/LruCache;

    invoke-virtual {v0}, Landroid/util/LruCache;->evictAll()V

    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->packageNames:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 66
    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter;->packageNames:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 67
    invoke-virtual {p0}, Lcom/statusoverlay/app/AppAdapter;->notifyDataSetChanged()V

    .line 68
    return-void
.end method
