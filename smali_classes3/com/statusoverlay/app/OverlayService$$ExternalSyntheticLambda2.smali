.class public final synthetic Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field public final synthetic f$0:Lcom/statusoverlay/app/OverlayService;

.field public final synthetic f$1:Landroid/widget/PopupWindow;

.field public final synthetic f$2:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/statusoverlay/app/OverlayService;Landroid/widget/PopupWindow;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;->f$0:Lcom/statusoverlay/app/OverlayService;

    iput-object p2, p0, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;->f$1:Landroid/widget/PopupWindow;

    iput-object p3, p0, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;->f$2:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/view/View;)V
    .locals 3

    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;->f$0:Lcom/statusoverlay/app/OverlayService;

    iget-object v1, p0, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;->f$1:Landroid/widget/PopupWindow;

    iget-object v2, p0, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda2;->f$2:Ljava/lang/String;

    invoke-virtual {v0, v1, v2, p1}, Lcom/statusoverlay/app/OverlayService;->lambda$showPopupMenu$1$com-statusoverlay-app-OverlayService(Landroid/widget/PopupWindow;Ljava/lang/String;Landroid/view/View;)V

    return-void
.end method
