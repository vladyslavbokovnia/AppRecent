.class Lcom/statusoverlay/app/OverlayService$3;
.super Ljava/lang/Object;
.source "OverlayService.java"

# interfaces
.implements Lcom/statusoverlay/app/AppAdapter$OnAppActionListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/statusoverlay/app/OverlayService;->createAppsOverlay()V
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

    .line 149
    iput-object p1, p0, Lcom/statusoverlay/app/OverlayService$3;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method synthetic lambda$onAppClick$0$com-statusoverlay-app-OverlayService$3()V
    .locals 1

    .line 154
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$3;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mscrollToRecent(Lcom/statusoverlay/app/OverlayService;)V

    return-void
.end method

.method public onAppClick(Ljava/lang/String;)V
    .locals 4
    .param p1, "packageName"    # Ljava/lang/String;

    .line 152
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$3;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mvibrate(Lcom/statusoverlay/app/OverlayService;)V

    .line 153
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$3;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0, p1}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mlaunchApp(Lcom/statusoverlay/app/OverlayService;Ljava/lang/String;)V

    .line 154
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$3;->this$0:Lcom/statusoverlay/app/OverlayService;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mrefreshAppList(Lcom/statusoverlay/app/OverlayService;Z)V

    .line 155
    return-void
.end method

.method public onAppLongClick(Landroid/view/View;Ljava/lang/String;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;
    .param p2, "packageName"    # Ljava/lang/String;

    .line 158
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$3;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mvibrate(Lcom/statusoverlay/app/OverlayService;)V

    .line 159
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$3;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0, p1, p2}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mshowPopupMenu(Lcom/statusoverlay/app/OverlayService;Landroid/view/View;Ljava/lang/String;)V

    .line 160
    return-void
.end method
