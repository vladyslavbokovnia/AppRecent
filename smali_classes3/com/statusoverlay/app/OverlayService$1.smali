.class Lcom/statusoverlay/app/OverlayService$1;
.super Landroid/content/BroadcastReceiver;
.source "OverlayService.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/statusoverlay/app/OverlayService;
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

    .line 70
    iput-object p1, p0, Lcom/statusoverlay/app/OverlayService$1;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "intent"    # Landroid/content/Intent;

    .line 74
    :try_start_0
    const-string v0, "level"

    const/4 v1, -0x1

    invoke-virtual {p2, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    .line 75
    .local v0, "level":I
    const-string v2, "scale"

    invoke-virtual {p2, v2, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v2

    .line 76
    .local v2, "scale":I
    if-eq v0, v1, :cond_0

    if-eq v2, v1, :cond_0

    iget-object v1, p0, Lcom/statusoverlay/app/OverlayService$1;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v1, v0, v2}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mupdateBatteryIndicator(Lcom/statusoverlay/app/OverlayService;II)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 77
    .end local v0    # "level":I
    .end local v2    # "scale":I
    :catch_0
    move-exception v0

    :cond_0
    :goto_0
    nop

    .line 78
    return-void
.end method
