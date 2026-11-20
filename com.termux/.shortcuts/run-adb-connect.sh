#!/data/data/com.termux/files/usr/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 
am start -n com.android.settings/com.android.settings.SubSettings --es :settings:show_fragment com.android.settings.development.WirelessDebuggingFragment > /dev/null
#read -e -p "pkg files " package; pkg f $package;

# 父 shell 等待子 shell 完成并获取结果
result=$(
    #read -p $'\033[32m请输入您的姓名: \033[0m' name
    read -p $'\e[1;4;94m请输入无线调试的 IP 地址和端口: \e[0m' input
    echo "$input"  # 必须通过 stdout 输出
)
echo "父shell收到: $result"

# 示例：在子 shell 中连接远程设备
(
    echo "正在尝试连接设备..."
    # 执行连接命令
    adb connect $result && adb devices -l && adb tcpip 5555 && adb kill-server && sleep 3 && adb devices -l && sleep 3 && am start -n moe.shizuku.privileged.api/moe.shizuku.manager.MainActivity -f 8388608
 
    # 验证连接结果
    if adb devices | grep -q "192.168.1.100:5555"; then
        echo "连接成功"
    else
        echo "连接失败"
        exit 1
    fi
)
# 子 shell 结束后，这里的代码继续执行
echo "主脚本继续运行"
