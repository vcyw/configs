#!/data/data/com.termux/files/usr/bin/bash
##in case one is already running
#killall node
#browser-sync
###in case one is already running
cd ~/storage/shared/Documents/markor/gh/docs-learning/ && browser-sync start --server --files "**/**.*"
