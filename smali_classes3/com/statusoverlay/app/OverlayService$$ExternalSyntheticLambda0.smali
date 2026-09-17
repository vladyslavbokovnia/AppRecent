.class public final synthetic Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/statusoverlay/app/OverlayService;


# direct methods
.method public synthetic constructor <init>(Lcom/statusoverlay/app/OverlayService;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda0;->f$0:Lcom/statusoverlay/app/OverlayService;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda0;->f$0:Lcom/statusoverlay/app/OverlayService;

    invoke-virtual {v0}, Lcom/statusoverlay/app/OverlayService;->lambda$refreshAppList$5$com-statusoverlay-app-OverlayService()V

    return-void
.end method
