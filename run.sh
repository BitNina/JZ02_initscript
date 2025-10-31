#!/bin/bash

set -e  # 遇到错误立即退出

# 1. 安装必要软件包
sudo apt-get update
sudo apt-get install -y cpufrequtils apt-transport-https ca-certificates
sudo cpufreq-set -u 1.2ghz
# 2. 备份原始 sources.list（可选但推荐）
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 3. 写入新的 sources.list 内容（使用清华镜像）
cat <<EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
EOF

# 4. 更新并升级系统
sudo apt update && sudo apt upgrade -y
sudo apt autoremove
# 5. 删除自身（使用 $0 获取当前脚本路径）
# 由于脚本可能被 bash 直接读取，需确保删除的是文件本身
rm -- "$0"