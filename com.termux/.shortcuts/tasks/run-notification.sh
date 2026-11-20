#!/data/data/com.termux/files/usr/bin/sh

#termux-toast "$@"

[ $1 = "am" ] && am start \
    --user 0 \
    -a android.intent.action.VIEW \
    -n com.termux/com.termux.app.TermuxActivity \
    -f 276824064 com.termux

[ $2 = "1" ] && sleep 1

termux-notification \
    --ongoing \
    --id notification \
    --group notification \
    --priority high \
    --action "exec "$0" "am" "1"" \
    --on-delete "" \
    --button1 "proxy" \
    --button1-action "exec ~/.shortcuts/tasks/run-geo.sh" \
    --button3 "todo" \
    --button3-action "exec ~/.shortcuts/tasks/run-todo.sh" \
    --button2 "search" \
    --button2-action "am start -a android.intent.action.VIEW -d content://com.termux.documents/tree/%2Fdata%2Fdata%2Fcom.termux%2Ffiles%2Fhome/document/%2Fdata%2Fdata%2Fcom.termux%2Ffiles%2Fhome%2Fstorage%2Fshared%2FDocuments%2Fmarkor%2Fnote%2Fbackups%2FHTTPShortcuts%2Fsearchlog.txt -t text/plain -n io.github.muntashirakon.AppManager/.editor.EditorActivity" \
    --title "日常任务(点击打开 Termux)" \
    --content "tasks: proxy, search, todo"
