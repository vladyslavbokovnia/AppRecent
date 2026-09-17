.class Lcom/statusoverlay/app/MainActivity$1;
.super Landroid/widget/ArrayAdapter;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/statusoverlay/app/MainActivity;->updateHiddenAppsList()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/widget/ArrayAdapter<",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/statusoverlay/app/MainActivity;


# direct methods
.method constructor <init>(Lcom/statusoverlay/app/MainActivity;Landroid/content/Context;ILjava/util/List;)V
    .locals 0
    .param p1, "this$0"    # Lcom/statusoverlay/app/MainActivity;
    .param p2, "arg0"    # Landroid/content/Context;
    .param p3, "arg1"    # I

    .line 102
    .local p4, "arg2":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    iput-object p1, p0, Lcom/statusoverlay/app/MainActivity$1;->this$0:Lcom/statusoverlay/app/MainActivity;

    invoke-direct {p0, p2, p3, p4}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;ILjava/util/List;)V

    return-void
.end method


# virtual methods
.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 6
    .param p1, "position"    # I
    .param p2, "convertView"    # Landroid/view/View;
    .param p3, "parent"    # Landroid/view/ViewGroup;

    .line 105
    invoke-super {p0, p1, p2, p3}, Landroid/widget/ArrayAdapter;->getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 106
    .local v0, "view":Landroid/view/View;
    invoke-virtual {p0, p1}, Lcom/statusoverlay/app/MainActivity$1;->getItem(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 108
    .local v1, "pkg":Ljava/lang/String;
    const v2, 0x1020014

    :try_start_0
    iget-object v3, p0, Lcom/statusoverlay/app/MainActivity$1;->this$0:Lcom/statusoverlay/app/MainActivity;

    invoke-static {v3}, Lcom/statusoverlay/app/MainActivity;->-$$Nest$fgetpackageManager(Lcom/statusoverlay/app/MainActivity;)Landroid/content/pm/PackageManager;

    move-result-object v3

    const/4 v4, 0x0

    invoke-virtual {v3, v1, v4}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v3

    .line 109
    .local v3, "info":Landroid/content/pm/ApplicationInfo;
    invoke-virtual {v0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v4

    check-cast v4, Landroid/widget/TextView;

    iget-object v5, p0, Lcom/statusoverlay/app/MainActivity$1;->this$0:Lcom/statusoverlay/app/MainActivity;

    invoke-static {v5}, Lcom/statusoverlay/app/MainActivity;->-$$Nest$fgetpackageManager(Lcom/statusoverlay/app/MainActivity;)Landroid/content/pm/PackageManager;

    move-result-object v5

    invoke-virtual {v5, v3}, Landroid/content/pm/PackageManager;->getApplicationLabel(Landroid/content/pm/ApplicationInfo;)Ljava/lang/CharSequence;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 112
    .end local v3    # "info":Landroid/content/pm/ApplicationInfo;
    goto :goto_0

    .line 110
    :catch_0
    move-exception v3

    .line 111
    .local v3, "e":Ljava/lang/Exception;
    invoke-virtual {v0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 113
    .end local v3    # "e":Ljava/lang/Exception;
    :goto_0
    new-instance v2, Lcom/statusoverlay/app/MainActivity$1$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0, v1}, Lcom/statusoverlay/app/MainActivity$1$$ExternalSyntheticLambda0;-><init>(Lcom/statusoverlay/app/MainActivity$1;Ljava/lang/String;)V

    invoke-virtual {v0, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 119
    return-object v0
.end method

.method synthetic lambda$getView$0$com-statusoverlay-app-MainActivity$1(Ljava/lang/String;Landroid/view/View;)V
    .locals 4
    .param p1, "pkg"    # Ljava/lang/String;
    .param p2, "v"    # Landroid/view/View;

    .line 114
    new-instance v0, Ljava/util/HashSet;

    iget-object v1, p0, Lcom/statusoverlay/app/MainActivity$1;->this$0:Lcom/statusoverlay/app/MainActivity;

    invoke-static {v1}, Lcom/statusoverlay/app/MainActivity;->-$$Nest$fgethidePrefs(Lcom/statusoverlay/app/MainActivity;)Landroid/content/SharedPreferences;

    move-result-object v1

    new-instance v2, Ljava/util/HashSet;

    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V

    const-string v3, "hidden_list"

    invoke-interface {v1, v3, v2}, Landroid/content/SharedPreferences;->getStringSet(Ljava/lang/String;Ljava/util/Set;)Ljava/util/Set;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 115
    .local v0, "newHidden":Ljava/util/Set;, "Ljava/util/Set<Ljava/lang/String;>;"
    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 116
    iget-object v1, p0, Lcom/statusoverlay/app/MainActivity$1;->this$0:Lcom/statusoverlay/app/MainActivity;

    invoke-static {v1}, Lcom/statusoverlay/app/MainActivity;->-$$Nest$fgethidePrefs(Lcom/statusoverlay/app/MainActivity;)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1, v3, v0}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 117
    iget-object v1, p0, Lcom/statusoverlay/app/MainActivity$1;->this$0:Lcom/statusoverlay/app/MainActivity;

    invoke-static {v1}, Lcom/statusoverlay/app/MainActivity;->-$$Nest$mupdateHiddenAppsList(Lcom/statusoverlay/app/MainActivity;)V

    .line 118
    return-void
.end method
