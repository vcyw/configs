#!/data/data/com.termux/files/usr/bin/bash

# 显式设置 PREFIX 和 PATH
export PREFIX=/data/data/com.termux/files/usr
export PATH=$PREFIX/bin:$PATH

# 现在可以直接使用命令了
CONTENT=$(termux-clipboard-get)
echo "$CONTENT"
termux-notification \
    --id todoist \
    --group vpn \
    --priority high \
    --action "termux-open-url http-shortcuts://9977de48-5008-49c1-bbe2-45a14d677e62" \
    --on-delete "exec "$0" "$@"" \
    --button2 "refresh" \
    --button2-action "exec "$0" "$@"" \
    --button3 "toggle" \
    --button3-action "" \
    --button1 "copy" \
    --button1-action "" \
    --title "Todoist" \
    --content "$CONTENT"