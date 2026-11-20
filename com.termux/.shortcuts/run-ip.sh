#!/data/data/com.termux/files/usr/bin/bash

# 此脚本用于判断 ADB 当前连接类型以及设备是否支持/启用 IPv6
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE} ADB Connection & IPv6 Status Checker ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

#检查 adb 是否可用
if ! command -v adb &>/dev/null; then
    echo -e "${RED}错误:未找到adb命令。请确保AndroidSDKPlatform−Tools已安装并添加到PATH。${NC}"
    exit 1
fi

#获取设备列表
DEVICES=$(adb devices | grep -w "device" | awk '{print $1}')

if [ -z "$DEVICES" ]; then
    echo −e "${YELLOW}警告: 未检测到任何连接的 ADB 设备。${NC}"
    echo "请连接设备并确保已开启 USB 调试。"
    exit 1
fi

for SERIAL in $DEVICES; do

    echo -e "${GREEN}正在检查设备: $SERIAL ${NC}"
    echo "----------------------------------------"

    # 1. 判断当前连接类型 (USB vs TCP/IP)
    # 使用 adb devices -l 获取详细信息
    DEVICE_INFO=$(adb -s "$SERIAL" devices -l | grep "$SERIAL")
    if echo "$DEVICE_INFO" | grep -q "usb:"; then
        echo -e "连接类型: ${YELLOW}USB${NC}"
        CONNECT_TYPE="USB"
    elif echo "$DEVICE_INFO" | grep -q "tcp:"; then
        echo -e "连接类型: ${GREEN}TCP/IP${NC}"
        # 提取 IP 地址
        IP_ADDR=$(echo "$DEVICE_INFO" | grep -oP 'tcp:\K[^\s]+')
        echo -e "远程地址: ${IP_ADDR}"
        CONNECT_TYPE="TCP"

        # 简单判断是否为 IPv6 地址 (包含冒号)
        if [[ "$IP_ADDR" == *":"* ]]; then
            echo -e "协议版本: ${GREEN}IPv6${NC}"
        else
            echo -e "协议版本: ${BLUE}IPv4${NC}"
        fi
    else
        echo -e "连接类型: ${YELLOW}未知 (可能是模拟器或特殊传输)${NC}"
        CONNECT_TYPE="UNKNOWN"
    fi

    # 2. 检查设备内部的 IPv6 配置
    echo -e "\n${BLUE}--- 设备内部网络配置检查 ---${NC}"

    # 尝试获取 IPv6 地址列表
    # 使用 ip -6 addr show 替代过时的 ifconfig
    IPV6_ADDRS=$(adb -s "$SERIAL" shell "ip -6 addr show dev wlan0 2>/dev/null" || echo "")

    if [ -z "$IPV6_ADDRS" ]; then
        # 如果 ip 命令失败，尝试 ifconfig
        IPV6_ADDRS=$(adb -s "$SERIAL" shell "ifconfig 2>/dev/null | grep inet6" || echo "")
    fi

    if [ -n "$IPV6_ADDRS" ]; then
        echo -e "IPv6 支持: ${GREEN}已启用${NC}"

        # 提取全局单播地址 (Global Unicast, 通常以 2 或 3 开头，非 fe80)
        GLOBAL_IPV6=$(echo "$IPV6_ADDRS" | grep -oP 'inet6 \K(?!fe80:)[0-9a-f:]+' | head -n 1)
        LINK_LOCAL_IPV6=$(echo "$IPV6_ADDRS" | grep -oP 'inet6 \Kfe80:[0-9a-f:]+' | head -n 1)

        if [ -n "$GLOBAL_IPV6" ]; then
            echo -e "全局 IPv6 地址: ${GREEN}${GLOBAL_IPV6}${NC}"
        elif [ -n "$LINK_LOCAL_IPV6" ]; then
            echo -e "链路本地 IPv6 地址: ${YELLOW}${LINK_LOCAL_IPV6}${NC}"
            echo -e "(注意: 链路本地地址仅在局域网内有效，无法用于远程公网调试)"
        fi
    else
        echo -e "IPv6 支持: ${RED}未检测到 IPv6 地址${NC}"
        echo "设备可能禁用了 IPv6 或当前网络未分配 IPv6 地址。"
    fi

    # 3. 连通性测试 (仅当检测到 IPv6 地址时尝试)
    if [ -n "$GLOBAL_IPV6" ] || [ -n "$LINK_LOCAL_IPV6" ]; then
        echo -e "\n${BLUE}--- 连通性测试 ---${NC}"
        TARGET_IP=""
        if [ -n "$GLOBAL_IPV6" ]; then
            TARGET_IP="$GLOBAL_IPV6"
        else
            TARGET_IP="$LINK_LOCAL_IPV6"
        fi

        echo "正在尝试 Ping IPv6 地址: $TARGET_IP ..."
        # 注意：adb shell ping6 可能需要 root 权限或在某些系统上不可用
        # 这里我们尝试 ping google 的 IPv6 地址来测试外网连通性
        PING_RESULT=$(adb -s "$SERIAL" shell "ping6 -c 2 -W 2 2400:cb00:2048:1::c629:d7a2 2>/dev/null" || echo "FAIL")

        if echo "$PING_RESULT" | grep -q "64 bytes from"; then
            echo -e "外网 IPv6 连通性: ${GREEN}正常${NC}"
        else
            echo -e "外网 IPv6 连通性: ${YELLOW}失败或超时${NC}"
            echo "(可能是防火墙限制、网络不支持或设备权限不足)"
        fi
    fi

    echo ""
    echo "========================================"

done

echo -e "\n${BLUE}提示:${NC}"
echo "若要通过 IPv6 进行 ADB 远程调试，请确保："
echo "1. 设备和主机在同一 IPv6 网络下。"
echo "2. 使用命令: adb tcpip 5555"
echo "3. 使用命令: adb connect [IPv6地址]:5555 (注意方括号)"
