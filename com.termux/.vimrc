set nocompatible " be iMproved, required
filetype off " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'

" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'

" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}


" UltiSnips is the Ultimate solution for snippets under Vim.
" 1. Track the engine.
Plugin 'SirVer/ultisnips'

" 2. Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" 3. Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" 4. If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Syntax highlighting, matching rules and mappings for the original Markdown and extensions.
Plugin 'godlygeek/tabular'
Plugin 'preservim/vim-markdown'

" lean & mean status/tabline for vim that’s light as air
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

let g:airline#extensions#tabline#enabled=1 " 开启 tab 栏

" The NERDTree is a file system explorer for the Vim editor. Using this plugin, users can visually browse complex directory hierarchies, quickly open files for reading or editing, and perform basic file system operations.
Plugin 'preservim/nerdtree'

let g:NERDTreeFileLines = 1

" post install (yarn install | npm install) then load plugin only for editing supported files
Plugin 'prettier/vim-prettier'

" A vim plugin to display the indention levels with thin vertical lines
"Plugin 'Yggdroot/indentLine'

"let g:indentLine_enabled = 1
"let g:indentLine_char = '┆'
"let g:indentLine_first_char = '┆'
"let g:indentLine_showFirstIndentLevel = 1
"let g:indentLine_color_term = 239
"set tabstop=2
"set softtabstop=2
"set shiftwidth=2
"set expandtab

"Plugin 'preservim/nerdcommenter'
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

Plugin 'tpope/vim-commentary'


" All of your Plugins must be added before the following line
call vundle#end() " required

filetype plugin indent on " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList - lists configured plugins
" :PluginInstall - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean - confirms removal of unused plugins; append `!` to
" auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" 显示行号
set number

" 自动折行，即太长的行分成几行显示
set wrap
set linebreak

" 打开文件监视。如果在编辑过程中文件发生外部改变（比如被别的编辑器编辑了），就会发出提示
set autoread
" au CursorHold,CursorHoldI * checktime

" 搜索时，高亮显示匹配结果
set hlsearch

" 是否显示状态栏（0 表示不显示，1 表示只在多窗口时显示，2 表示显示）
set laststatus=2 " 始终显示状态栏

" 命令模式下，在底部显示，当前键入的指令
set showcmd

" 在底部显示，当前处于命令模式还是插入模式
set showmode

" 自动切换工作目录
set autochdir
