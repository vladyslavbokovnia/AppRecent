.class Lcom/statusoverlay/app/OverlayService$AppSortInfo;
.super Ljava/lang/Object;
.source "OverlayService.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/statusoverlay/app/OverlayService;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "AppSortInfo"
.end annotation


# instance fields
.field final packageName:Ljava/lang/String;

.field final time:J


# direct methods
.method constructor <init>(Ljava/lang/String;J)V
    .locals 0
    .param p1, "pkg"    # Ljava/lang/String;
    .param p2, "t"    # J

    .line 425
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/statusoverlay/app/OverlayService$AppSortInfo;->packageName:Ljava/lang/String;

    iput-wide p2, p0, Lcom/statusoverlay/app/OverlayService$AppSortInfo;->time:J

    return-void
.end method
