#!/bin/bash
# wget https://raw.githubusercontent.com/BitNina/JZ02_initscript/refs/heads/main/run.sh && chmod +x run.sh && ./run.sh
set -e
cat <<EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
EOF

sudo apt-get update
sudo apt-get install --reinstall debian-archive-keyring
sudo apt-get install -y cpufrequtils apt-transport-https ca-certificates
sudo cpufreq-set -u 1.2ghz

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

cat <<EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
EOF

sudo apt update && sudo apt upgrade -y
sudo apt autoremove
rm -- "$0"
