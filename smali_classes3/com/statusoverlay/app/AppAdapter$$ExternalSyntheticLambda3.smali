.class public final synthetic Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Ljava/lang/String;

.field public final synthetic f$1:Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

.field public final synthetic f$2:Landroid/graphics/drawable/Drawable;


# direct methods
.method public synthetic constructor <init>(Ljava/lang/String;Lcom/statusoverlay/app/AppAdapter$AppViewHolder;Landroid/graphics/drawable/Drawable;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;->f$0:Ljava/lang/String;

    iput-object p2, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;->f$1:Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

    iput-object p3, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;->f$2:Landroid/graphics/drawable/Drawable;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;->f$0:Ljava/lang/String;

    iget-object v1, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;->f$1:Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

    iget-object v2, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda3;->f$2:Landroid/graphics/drawable/Drawable;

    invoke-static {v0, v1, v2}, Lcom/statusoverlay/app/AppAdapter;->lambda$loadIconAsync$2(Ljava/lang/String;Lcom/statusoverlay/app/AppAdapter$AppViewHolder;Landroid/graphics/drawable/Drawable;)V

    return-void
.end method
