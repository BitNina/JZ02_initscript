#!/bin/bash
# cpufreq-set -u 1800MHz

MAX_CHECKS=10     
CHECK_INTERVAL=1  
WIFI_IFACE="wlan0" 
USB_ROLE_PATH="/sys/kernel/debug/usb/ci_hdrc.0/role" 
cpufreq-set -u 1.2ghz
echo N | sudo tee /sys/class/tty/ttyMSM0/console

is_wifi_connected() {
  if ip addr show "$WIFI_IFACE" | grep -q "inet "; then
    return 0
  else
    return 1
  fi
}
kill_adbd() {
    # 查找 adbd 进程的 PID（排除 grep 自身）
    pid=$(ps aux | grep "adbd" | grep -v "grep" | awk '{print $2}')

    if [ -z "$pid" ]; then
        echo "No adbd process found."
        return 0
    fi

    # 使用 sudo 强制终止进程
    sudo kill -9 $pid
    echo "Killed adbd process (PID: $pid)"
}
# 主循环
for ((i=1; i<=MAX_CHECKS; i++)); do
  if is_wifi_connected; then
    kill_adbd
    echo "$(date '+%Y-%m-%d %H:%M:%S') WiFi已连接，执行USB角色切换"
    echo "host" > "$USB_ROLE_PATH"
    echo none > /sys/class/leds/green:internet/trigger
    echo none > /sys/class/leds/mmc0::/trigger
    echo none > /sys/class/leds/blue:wifi/trigger
    echo none > /sys/class/leds/red:os/trigger

    systemctl disable serial-getty@ttyMSM0.service
    systemctl stop serial-getty@ttyMSM0.service
    systemctl disable serial-getty@tty1.service
    systemctl stop serial-getty@tty1.service
    sleep 1
    mount -t vfat -o rw,umask=000,uid=$(id -u) UUID=68CC-C5D2 /mnt/usb
    exit 0
  fi
  echo "$(date '+%Y-%m-%d %H:%M:%S') 第${i}次检测: WiFi未就绪"
  sleep "$CHECK_INTERVAL"
done

echo "$(date '+%Y-%m-%d %H:%M:%S') 超过${MAX_CHECKS}次检测未连接，放弃操作"
exit 0