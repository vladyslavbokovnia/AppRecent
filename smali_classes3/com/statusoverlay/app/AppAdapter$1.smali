.class Lcom/statusoverlay/app/AppAdapter$1;
.super Landroid/util/LruCache;
.source "AppAdapter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/statusoverlay/app/AppAdapter;-><init>(Landroid/content/Context;Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/util/LruCache<",
        "Ljava/lang/String;",
        "Landroid/graphics/drawable/Drawable;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/statusoverlay/app/AppAdapter;


# direct methods
.method constructor <init>(Lcom/statusoverlay/app/AppAdapter;I)V
    .locals 0
    .param p1, "this$0"    # Lcom/statusoverlay/app/AppAdapter;
    .param p2, "arg0"    # I

    .line 53
    iput-object p1, p0, Lcom/statusoverlay/app/AppAdapter$1;->this$0:Lcom/statusoverlay/app/AppAdapter;

    invoke-direct {p0, p2}, Landroid/util/LruCache;-><init>(I)V

    return-void
.end method


# virtual methods
.method protected bridge synthetic sizeOf(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    .line 53
    check-cast p1, Ljava/lang/String;

    check-cast p2, Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0, p1, p2}, Lcom/statusoverlay/app/AppAdapter$1;->sizeOf(Ljava/lang/String;Landroid/graphics/drawable/Drawable;)I

    move-result p1

    return p1
.end method

.method protected sizeOf(Ljava/lang/String;Landroid/graphics/drawable/Drawable;)I
    .locals 1
    .param p1, "key"    # Ljava/lang/String;
    .param p2, "value"    # Landroid/graphics/drawable/Drawable;

    .line 56
    instance-of v0, p2, Landroid/graphics/drawable/BitmapDrawable;

    if-eqz v0, :cond_0

    .line 57
    move-object v0, p2

    check-cast v0, Landroid/graphics/drawable/BitmapDrawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/BitmapDrawable;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v0

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getByteCount()I

    move-result v0

    div-int/lit16 v0, v0, 0x400

    return v0

    .line 59
    :cond_0
    const/4 v0, 0x1

    return v0
.end method
