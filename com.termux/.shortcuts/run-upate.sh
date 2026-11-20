#!/data/data/com.termux/files/usr/bin/bash

# 设置遇到错误立即退出
#set -e

echo "========================================="
echo "开始执行 apt update"
echo "========================================="

# 1. 执行 apt update
# 使用 -y 自动确认（虽然 update 通常不需要确认，但保持习惯一致）
apt update

# 统计可更新包的数量
count=$(apt list --upgradable 2>/dev/null | grep -c "^")
if [ "$count" -gt 1 ]; then
    apt list --upgradable
    echo "有 $((count-1)) 个软件包可更新" # 减去标题行
else
    echo "系统是最新的"
fi

echo "========================================="
echo "apt update 完成，开始执行 ncu"
echo "========================================="

# 2. 执行 ncu
# 注意：ncu 通常需要指定具体的分析命令或参数
# 如果只是想验证 ncu 是否可用，可以运行 ncu --version
# 如果是为了运行性能分析，请替换下方的 ncu 命令为实际需要的指令
# 例如: ncu --set full ./your_application

if command -v ncu &> /dev/null; then
    # 这里以查看版本为例，确保 ncu 可执行
    # 请根据实际需求修改此行，例如直接运行 ncu 进行分析
    echo "npm version: $(npm -v)"
    echo "node version: $(node -v)"
    echo "ncu version: $(ncu -v)"
    ncu -g
    echo "ncu 执行完毕。"
else
    echo "错误: 未找到 ncu 命令。请确认 NVIDIA Nsight Compute 已正确安装并添加到 PATH 中。"
    exit 1
fi

echo "========================================="
echo "所有操作已完成。"
echo "========================================="

read -n 1 -s -p "完成，按任意键关闭..."
#read -p "完成，按回车关闭..."
