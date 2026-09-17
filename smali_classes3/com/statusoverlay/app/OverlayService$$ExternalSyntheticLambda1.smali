.class public final synthetic Lcom/statusoverlay/app/OverlayService$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/util/Comparator;


# direct methods
.method public synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    check-cast p1, Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    check-cast p2, Lcom/statusoverlay/app/OverlayService$AppSortInfo;

    invoke-static {p1, p2}, Lcom/statusoverlay/app/OverlayService;->lambda$getSortedAppsByInstallDate$7(Lcom/statusoverlay/app/OverlayService$AppSortInfo;Lcom/statusoverlay/app/OverlayService$AppSortInfo;)I

    move-result p1

    return p1
.end method
