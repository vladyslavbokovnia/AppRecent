.class public final synthetic Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/statusoverlay/app/AppAdapter;

.field public final synthetic f$1:Ljava/lang/String;

.field public final synthetic f$2:Lcom/statusoverlay/app/AppAdapter$AppViewHolder;


# direct methods
.method public synthetic constructor <init>(Lcom/statusoverlay/app/AppAdapter;Ljava/lang/String;Lcom/statusoverlay/app/AppAdapter$AppViewHolder;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;->f$0:Lcom/statusoverlay/app/AppAdapter;

    iput-object p2, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;->f$1:Ljava/lang/String;

    iput-object p3, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;->f$2:Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;->f$0:Lcom/statusoverlay/app/AppAdapter;

    iget-object v1, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;->f$1:Ljava/lang/String;

    iget-object v2, p0, Lcom/statusoverlay/app/AppAdapter$$ExternalSyntheticLambda0;->f$2:Lcom/statusoverlay/app/AppAdapter$AppViewHolder;

    invoke-virtual {v0, v1, v2}, Lcom/statusoverlay/app/AppAdapter;->lambda$loadIconAsync$3$com-statusoverlay-app-AppAdapter(Ljava/lang/String;Lcom/statusoverlay/app/AppAdapter$AppViewHolder;)V

    return-void
.end method
