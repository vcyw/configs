#!/data/data/com.termux/files/usr/bin/bash

if [[ -f "/data/data/com.termux/files/usr/var/service/run_curl/down" ]]; then
    echo "exists"
    sv-enable /data/data/com.termux/files/usr/var/service/run_curl
else
    sv-disable /data/data/com.termux/files/usr/var/service/run_curl
fi

# 尝试执行 return，如果失败则说明是独立执行
(return 0) 2>/dev/null
if [ $? -ne 0 ]; then
    echo "脚本是独立执行的 (bash/./)，不能使用 return 退出整个脚本，应使用 exit"
    exit 0
else
    echo "脚本是被 source 的，可以使用 return 退出"
    return 0
fi

# 判断逻辑
if [[ "${BASH_SOURCE}" != "$0" ]]; then
    echo "脚本是通过 source 或 . 执行的"
else
    echo "脚本是通过 bash 或 ./ 独立执行的"
fi

# 定义要检查的服务路径
SERVICE_PATH="/data/data/com.termux/files/usr/var/service/run_curl"

# 1. 执行 sv stat 并捕获标准输出和标准错误
# 使用变量捕获输出，以便后续分析
OUTPUT=$(sv stat "$SERVICE_PATH" 2>&1)
EXIT_CODE=$?

# 2. 判断 sv stat 命令本身是否执行成功
if [ $EXIT_CODE -ne 0 ]; then
    echo "FAIL: sv stat command execution failed."
    echo "Error Output: $OUTPUT"
    exit 2
fi

# 3. 判断输出是否为空（极端情况防护）
if [ -z "$OUTPUT" ]; then
    echo "FAIL: sv stat returned empty output."
    exit 2
fi

# 4. 解析输出内容，判断服务实际状态
# sv stat 正常输出格式示例: "/service/myservice: up (pid 1234) 10 seconds"
if echo "$OUTPUT" | grep -q "^up"; then
    echo "SUCCESS: Service is running."
    echo "Details: $OUTPUT"
    exit 0
elif echo "$OUTPUT" | grep -q "^down"; then
    echo "WARNING: Service is down."
    echo "Details: $OUTPUT"
    exit 1
else
    # 处理其他可能的状态或未知格式
    echo "UNKNOWN: Unexpected status format."
    echo "Details: $OUTPUT"
    exit 3
fi
