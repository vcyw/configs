#!/data/data/com.termux/files/usr/bin/bash

# 1. 设置环境
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

# 设置超时时间为 5 秒
#curl --max-time 5
RESULT=$(curl --connect-timeout 5 --max-time 8 -s ifconfig.co/json)

# 获取退出码
EXIT_CODE=$?
if [ $EXIT_CODE -eq 28 ]; then
    echo "请求超时 (Timeout)"
    content="请求超时 (Timeout)"
elif [ $EXIT_CODE -ne 0 ]; then
    echo "其他错误，退出码: $EXIT_CODE"
    content="其他错误，退出码: $EXIT_CODE"
else
    echo "请求成功"
    echo "$RESULT" | jq '.'
    declare -A flags=(
        [China]="🇨🇳"
        [Germany]="🇩🇪"
        [France]="🇫🇷"
    )
    country="$(echo "$RESULT" | jq -r '.country')"
    flag=${flags["$country"]}
    #content="$(echo $RESULT | jq -r --arg local_ip "$IP" '"公网 IP: \(.country) (\(.ip))\n内网 IP: \($local_ip)" // "xxx"')"
    content="$flag$(echo "$RESULT" | jq -r '"\(.country) (\(.ip))" // "xxx"')"
    #termux-notification --button1 "start" -t "COUNTRY" -c "$(echo '{"name": "Alice", "city": "Beijing"}' | jq -r '"\(.name)\ (\(.city))"')"
fi

# 获取内网地址
IP_WLAN0=$(adb shell ifconfig wlan0 | awk -F '[ :]+' '/inet addr/ {print $4}')
IP_CCMNI0=$(adb shell ifconfig ccmni0 | awk -F '[ :]+' '/inet addr/ {print $4}')
IP_CCMNI1=$(adb shell ifconfig ccmni1 | awk -F '[ :]+' '/inet addr/ {print $4}')
IP_CCMNI2=$(adb shell ifconfig ccmni2 | awk -F '[ :]+' '/inet addr/ {print $4}')
IP=${IP_WLAN0:-${IP_CCMNI0:-${IP_CCMNI1:-${IP_CCMNI2:-未连接网络}}}}

# 检查是否支持 IPv6
if [ -n "$IP_WLAN0" ]; then
    DEV="wlan0"
elif [ -n "$IP_CCMNI0" ]; then
    DEV="ccmni0"
elif [ -n "$IP_CCMNI1" ]; then
    DEV="ccmni1"
elif [ -n "$IP_CCMNI2" ]; then
    DEV="ccmni2"
fi
IPV6_ADDRS=$(adb shell "ip -6 addr show dev $DEV 2>/dev/null" || echo "")
GLOBAL_IPV6=$(echo "$IPV6_ADDRS" | grep -oP 'inet6 \K(?!fe80:)[0-9a-f:]+' | head -n 1)
IPV6_FLAG=""
if [ -n "$GLOBAL_IPV6" ]; then
    echo -e "全局 IPv6 地址: ${GLOBAL_IPV6}"
    IPV6_FLAG="ⁱᵖᵛ⁶"
else
    echo -e "(注意: 链路本地地址仅在局域网内有效，无法用于远程公网调试)"
fi

termux-notification \
    --id ip \
    --image-path ~/git-repos/docs-learning/_media/bunny-color.png \
    --group vpn \
    --priority high \
    --action "exec "$0" "$@"" \
    --on-delete "" \
    --button2 "refresh" \
    --button2-action "exec "$0" "$@"" \
    --button3 "toggle" \
    --button3-action "am start -a com.github.metacubex.clash.meta.action.TOGGLE_CLASH -n com.github.metacubex.clash.meta/com.github.kr328.clash.ExternalControlActivity" \
    --button1 "copy" \
    --button1-action "termux-clipboard-set $IP" \
    --title "$IP $IPV6_FLAG - $(date +%T) " \
    --content "$content"

exit

echo vs <<<‌：

# echo "$var" | jq .：通用，兼容所有 Shell。
# jq . <<< "$var"：Bash/Zsh 特有，效率略高，且能更好地处理包含特殊字符或空行的内容。

# 2. 使用 jq 格式化输出变量内容
# 注意：必须使用 echo 或 <<< 将变量内容传给 jq
echo "$response" | jq .

# 或者使用 Here String (更推荐，避免子进程开销)
jq . <<<"$response"

#!/bin/bash

URL="https://api.github.com/users/octocat"

# 获取响应
response=$(curl -s --max-time 5 "$URL")
curl_exit_code=$?

# 1. 检查 curl 是否成功
if [ $curl_exit_code -ne 0 ]; then
    echo "错误: Curl 请求失败，退出码: $curl_exit_code"
    exit 1
fi

# 2. 检查响应是否为空
if [ -z "$response" ]; then
    echo "错误: 响应内容为空"
    exit 1
fi

# 3. 尝试使用 jq 解析，如果解析失败则报错
# jq 如果解析失败会返回非零退出码
formatted_json=$(echo "$response" | jq . 2>/dev/null)
jq_exit_code=$?

if [ $jq_exit_code -ne 0 ]; then
    echo "错误: 响应不是有效的 JSON 格式"
    echo "原始响应前100字符: ${response:0:100}"
    exit 1
else
    echo "JSON 格式化成功:"
    echo "$formatted_json"

    # 示例：提取字段
    name=$(echo "$response" | jq -r '.name // "未知用户"')
    echo "名称: $name"
fi
