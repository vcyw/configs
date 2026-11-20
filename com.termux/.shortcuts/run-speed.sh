#!/data/data/com.termux/files/usr/bin/bash
IFACE="wlan0"
while true; do
    RX1=$(cat /proc/net/dev | grep $IFACE | awk '{print $2}')
    TX1=$(cat /proc/net/dev | grep $IFACE | awk '{print $10}')
    sleep 1
    RX2=$(cat /proc/net/dev | grep $IFACE | awk '{print $2}')
    TX2=$(cat /proc/net/dev | grep $IFACE | awk '{print $10}')
    RX_SPEED=$(( ($RX2 - $RX1) / 1024 ))
    TX_SPEED=$(( ($TX2 - $TX1) / 1024 ))
    clear
    echo "实时网速 下载: ${RX_SPEED} KB/s | 上传: ${TX_SPEED} KB/s"
done
