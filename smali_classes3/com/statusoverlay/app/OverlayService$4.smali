.class Lcom/statusoverlay/app/OverlayService$4;
.super Landroid/view/GestureDetector$SimpleOnGestureListener;
.source "OverlayService.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/statusoverlay/app/OverlayService;->createSideScrollView()V
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

    .line 193
    iput-object p1, p0, Lcom/statusoverlay/app/OverlayService$4;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-direct {p0}, Landroid/view/GestureDetector$SimpleOnGestureListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onLongPress(Landroid/view/MotionEvent;)V
    .locals 1
    .param p1, "e"    # Landroid/view/MotionEvent;

    .line 196
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$4;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mvibrate(Lcom/statusoverlay/app/OverlayService;)V

    .line 197
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$4;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$mtoggleVisibility(Lcom/statusoverlay/app/OverlayService;)V

    .line 198
    return-void
.end method

.method public onScroll(Landroid/view/MotionEvent;Landroid/view/MotionEvent;FF)Z
    .locals 5
    .param p1, "e1"    # Landroid/view/MotionEvent;
    .param p2, "e2"    # Landroid/view/MotionEvent;
    .param p3, "distanceX"    # F
    .param p4, "distanceY"    # F

    .line 201
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$4;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$fgetisVisible(Lcom/statusoverlay/app/OverlayService;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$4;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$fgetrecyclerView(Lcom/statusoverlay/app/OverlayService;)Landroidx/recyclerview/widget/RecyclerView;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 202
    iget-object v0, p0, Lcom/statusoverlay/app/OverlayService$4;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v0}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$fgetsettingsPrefs(Lcom/statusoverlay/app/OverlayService;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "invert_scroll"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    .line 203
    .local v0, "invert":Z
    if-eqz v0, :cond_0

    const/high16 v1, 0x40000000    # 2.0f

    goto :goto_0

    :cond_0
    const/high16 v1, -0x40000000    # -2.0f

    .line 204
    .local v1, "factor":F
    :goto_0
    iget-object v3, p0, Lcom/statusoverlay/app/OverlayService$4;->this$0:Lcom/statusoverlay/app/OverlayService;

    invoke-static {v3}, Lcom/statusoverlay/app/OverlayService;->-$$Nest$fgetrecyclerView(Lcom/statusoverlay/app/OverlayService;)Landroidx/recyclerview/widget/RecyclerView;

    move-result-object v3

    mul-float v4, p4, v1

    float-to-int v4, v4

    invoke-virtual {v3, v4, v2}, Landroidx/recyclerview/widget/RecyclerView;->scrollBy(II)V

    .line 206
    .end local v0    # "invert":Z
    .end local v1    # "factor":F
    :cond_1
    const/4 v0, 0x1

    return v0
.end method
