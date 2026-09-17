.class Lcom/statusoverlay/app/OverlayService$2;
.super Ljava/lang/Object;
.source "OverlayService.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/statusoverlay/app/OverlayService;->onServiceConnected()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/statusoverlay/app/OverlayService;


# direct methods
.method constructor <init>(Lcom/statusoverlay/app/OverlayService;)V
    .locals 0
    .param p1, "this$0"    # Lcom/statusoverlay/app/OverlayService;

    .line 99
    iput-object p1, p0, Lcom/statusoverlay/app/OverlayService$2;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 103
    :try_start_0
    return-void
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 107
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 108
    return-void
.end method
