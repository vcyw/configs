#!/data/data/com.termux/files/usr/bin/bash

#cd ~/storage/shared/Documents/markor/gh/docs-learning

am startservice --user 0 -n com.termux/com.termux.app.RunCommandService \
    -a com.termux.RUN_COMMAND \
    --es com.termux.RUN_COMMAND_PATH '/data/data/com.termux/files/usr/bin/login' \
    --es com.termux.RUN_COMMAND_WORKDIR '/data/data/com.termux/files/home/storage/shared/Documents/markor/gh/' \
    --ez com.termux.RUN_COMMAND_BACKGROUND 'false' \
    --es com.termux.RUN_COMMAND_SESSION_ACTION '0'
