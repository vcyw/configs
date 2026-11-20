# cd ~/storage/shared/Documents/markor/gh/docs-learning

# ~/.shortcuts/run-browser-sync.sh

###############
# Pet
###############

### 
function pet-select() {
  BUFFER=$(pet search --query "$READLINE_LINE" --color)
  READLINE_LINE=$BUFFER
  READLINE_POINT=${#BUFFER}
}
bind -x '"\C-x\C-r": pet-select'

### 
function pkgf() {
  read -p "输入内容: " input
  if [ -z "$input" ]; then
    echo "输入为空，退出"
    #exit 1
  else
    echo $(dpkg -S $(which $input))
    pkg f $(dpkg -S $(which $input) | grep -oP "^[^:]+")
  fi
}

###############
# History
###############

### Ensure history is loaded correctly
#if [ -f ~/.bash_history ]; then
#  history -r ~/.bash_history
#fi

#echo $HISTFILE
#set +o history
#unset HISTFILE
history -r ~/.bash_history
#export HISTFILE=/dev/null
export HISTFILE=~/.bash_history_tmp
export PROMPT_COMMAND="history -a"

###############
# 命令提示符
###############

#换行：\n
#重置：\[\e[0m\]
#浅红色：\[\e[0;31m\]
#红色：\[\e[1;31m\]
#浅绿色：\[\e[0;32m\]
#绿色：\[\e[1;32m\]
#浅蓝色：\[\e[0;34m\]
#蓝色：\[\e[1;34m\]
#白色：\[\e[0;97m\]
#青色背景：\[\e[1;46m\]

#PS1="\[\e[0;31m\]\u\[\e[0m\]@\h \[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] "
#PS1="\[\e[1;46m\]\u\[\e[0m\]@\h \[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] "

# 如果退出码非0，显示红色错误码；否则显示正常颜色
#PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]$(if [ $? -ne 0 ]; then echo " \[\e[1;31m\][FAIL:$?]\[\e[0m\]"; fi) \$ '

# 如果退出码非0，显示红色错误码；否则显示正常颜色
#PS1='$(date "+%Y-%m-%d %H:%M:%S") \[\e[01;32m\]\u@\h \[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]$(if [ $? -ne 0 ]; then echo " \[\e[01;31m\][FAIL:$?]\[\e[00m\]"; fi) \$ '

#PS1='\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]$(if [ $? -ne 0 ]; then echo " \[\e[01;31m\][FAIL:$?]\[\e[00m\]"; fi)($(date "+%d %H:%M"))\$ '

export PS1='\n\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]$(RETVAL=$?; if [ $RETVAL -ne 0 ]; then echo " \[\e[1;31m\][FAIL:$RETVAL]\[\e[0m\]"; fi) \\\[\e[1;30m\]$(date "+%d日%H:%M")\[\e[0m\]\\\n\$ '

# 定义颜色变量（可选，使配置更清晰）
GRAY='\[\033[01;30m\]' # 灰色
RED='\[\033[01;31m\]' # 红色
GREEN='\[\033[01;32m\]' # 绿色
BLUE='\[\033[01;34m\]' # 蓝色
RESET='\[\033[00m\]' # 重置颜色

# 设置 PS1
# 第一行：绿色用户名@蓝色主机名:蓝色路径
# 第二行：重置颜色后的 $ 符号
#PS1="\n${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}\n\$ "

#PS1='$(RETVAL=$?; if [ $RETVAL -ne 0 ]; then echo " ${RED}[FAIL:$RETVAL]${RESET}"; fi)\n${GREEN}\u@\h${RESET}:${BLUE}\w${RESET} ${GRAY}$(date "+%d日%H:%M")${RESET}\n\$ '

###############
# McFly
###############
#eval "$(mcfly init bash)"

###############
# NPM
###############
export PATH=$PATH:~/bin
