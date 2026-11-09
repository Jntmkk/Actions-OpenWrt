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
# Method: Modify the source code directly to fix the bind() call
HNAT_FILE="target/linux/ramips/files-6.18/drivers/net/ethernet/mt7621-vendor/mtk_hnat/hnat_mcast.c"
if [ -f "$HNAT_FILE" ]; then
  sed -i 's/sock->ops->bind(sock,/sock->ops->bind(sock,/' "$HNAT_FILE"
  # Remove the third argument (addrlen) if it exists
  sed -i 's/(struct sockaddr \*)&hnat_mcast_addr, 0)/(struct sockaddr *)&hnat_mcast_addr)/' "$HNAT_FILE"
  echo "Fixed hnat_mcast.c bind() call"
else
  echo "Warning: hnat_mcast.c not found at $HNAT_FILE"
fi
