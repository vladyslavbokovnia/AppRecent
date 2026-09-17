#!/usr/bin/env bash
set -euo pipefail
grep -q 'android:scaleType="fitCenter"' res/layout/item_app_icon.xml
grep -q 'menuMovePrevious' res/layout/popup_menu.xml
# The usage sorter must not contain the old self-package exclusion sequence.
! grep -q 'invoke-virtual {v11, v12}, Ljava/lang/String;->equals' smali_classes3/com/statusoverlay/app/OverlayService.smali
