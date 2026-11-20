#!/data/data/com.termux/files/usr/bin/bash

termux-notification \
    --id todoist \
    --group vpn \
    --priority high \
    --action "termux-open-url http-shortcuts://9977de48-5008-49c1-bbe2-45a14d677e62" \
    --on-delete "exec "$0" "$@"" \
    --button2 "refresh" \
    --button2-action "" \
    --button3 "toggle" \
    --button3-action "" \
    --button1 "create" \
    --button1-action "termux-open-url http-shortcuts://9977de48-5008-49c1-bbe2-45a14d677e62" \
    --title "Todoist" \
    --content "$(termux-clipboard-get)"

exit 0

content=$(termux-clipboard-get | node -e "
let data = '';
process.stdin.on('data', (chunk) => { data += chunk; });
process.stdin.on('end', () => {
  // 去除末尾可能的换行符
  const cleanData = data.replace(/\n$/, '');
  console.log(encodeURIComponent(cleanData));
});
")
content=$(termux-clipboard-get)
termux-open-url todoist:\/\/addtask?content=$content
