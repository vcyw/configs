#!/data/data/com.termux/files/usr/bin/sh

#sleep 1

file=~/todo.txt
content="$(cat $file)"
line="$(wc -l < $file)"
termux-notification \
    --alert-once \
    --group todo \
    --priority max \
    --action "exec "$0" "$@"" \
    --button1 "Add" \
    --button1-action "echo \$REPLY >> "$file" && exit" \
    --button3 "open" \
    --button3-action "am start -a android.intent.action.VIEW -d content://com.termux.documents/tree/%2Fdata%2Fdata%2Fcom.termux%2Ffiles%2Fhome/document/%2Fdata%2Fdata%2Fcom.termux%2Ffiles%2Fhome%2Ftodo.txt -t text/plain -n io.github.muntashirakon.AppManager/.editor.EditorActivity" \
    --button2 "code" \
    --button2-action "am start -a android.intent.action.VIEW -d content://com.termux.documents/tree/%2Fdata%2Fdata%2Fcom.termux%2Ffiles%2Fhome/document/%2Fdata%2Fdata%2Fcom.termux%2Ffiles%2Fhome%2F.shortcuts%2Ftasks%2Frun-todo.sh -t text/plain -n io.github.muntashirakon.AppManager/.editor.EditorActivity" \
    --title "待办事项($line) - $(date +%T) " \
    --content "$content"
