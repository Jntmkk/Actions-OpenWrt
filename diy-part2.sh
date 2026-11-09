#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Fix mt7621-vendor hnat_mcast.c compilation error on Linux 6.18
# The issue: sock->ops->bind expects different pointer type in newer kernels
if [ -f target/linux/ramips/patches-6.18/999-fix-hnat-mcast.patch ]; then
  echo "Patch file already exists"
else
  cat > target/linux/ramips/patches-6.18/999-fix-hnat-mcast.patch << 'EOF'
--- a/drivers/net/ethernet/mt7621-vendor/mtk_hnat/hnat_mcast.c
+++ b/drivers/net/ethernet/mt7621-vendor/mtk_hnat/hnat_mcast.c
@@ -241,7 +241,7 @@
 	}

 	ret = sock->ops->bind(sock,
-			      (struct sockaddr *)&hnat_mcast_addr, 0);
+			      (struct sockaddr *)&hnat_mcast_addr);
 	if (ret < 0) {
 		pr_err("%s: bind socket failed\n", __func__);
 		goto err_bind;
EOF
fi
