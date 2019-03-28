"set autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set laststatus=2
set cmdheight=2
set showcmd
set title
set wildmenu
set number

"set fileencodings
:set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
:set fileformats=unix,dos,mac

"Search
set ignorecase
set smartcase 
set incsearch 
set hlsearch  

"auto escape
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

"edit
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed 
else
    set clipboard& clipboard+=unnamed
endif

" disable swap file
set nowritebackup
set nobackup
set noswapfile

" display setting
set number
set nowrap

" disable screen bell
set t_vb=
set novisualbell
set listchars=

"マクロ関連"
inoremap jj <Esc>
inoremap JJ <Esc>

" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" vを二回で行末まで選択
vnoremap v $h

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

let mapleader = "\<Space>"


" quick-run
nnoremap <C-e> :write<CR>:QuickRun -mode n<CR>

if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

let s:use_denite=0
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/vimproc.vim', {
        \ 'build': {
        \     'windows' : 'tools\\update-dll-mingw',
        \     'cygwin'  : 'make -f make_cygwin.mak',
        \     'mac'     : 'make -f make_mac.mak',
        \     'linux'   : 'make',
        \     'unix'    : 'gmake',
        \    },
        \ })
  call dein#add('Shougo/vimproc.vim',{'build':'make'})
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('deoplete-plugins/deoplete-jedi')
  call dein#add('thinca/vim-quickrun')
  call dein#add('itchyny/lightline.vim')
  call dein#add('tpope/vim-surround')
  call dein#add('cohama/lexima.vim')
  call dein#add('zebult/auto-gtags.vim')
  call dein#add('tomasr/molokai')
  call dein#add('soramugi/auto-ctags.vim')
  call dein#add('tpope/vim-fugitive')

  if s:use_denite
    call dein#add('Shougo/denite.nvim')
    call dein#add('ozelentok/denite-gtags')
  else
    call dein#add('Shougo/unite.vim')
    call dein#add('hewes/unite-gtags')
  endif

  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

if s:use_denite
    nnoremap ua :DeniteCursorWord -mode=normal -buffer-name=gtags_context gtags_context<cr>
    nnoremap ud :DeniteCursorWord -mode=normal -buffer-name=gtags_def gtags_def<cr>
    nnoremap ur :DeniteCursorWord -mode=normal -buffer-name=gtags_ref gtags_ref<cr>
    nnoremap ucg :DeniteCursorWord -mode=normal -buffer-name=gtags_grep gtags_grep<cr>
    nnoremap uo :Denite -buffer-name=denite_outline outline<cr>
    nnoremap ug :Denite -mode=normal -buffer-name=gtags_grep gtags_grep:
else
    noremap <silent>uo :Unite outline<CR>
    noremap <silent>ub :Unite bookmark<CR>
    noremap <silent>ud :Unite gtags/def<CR><c-r>=expand("<cword>")<CR><CR>
    noremap <silent>ur :Unite gtags/ref<CR><c-r>=expand("<cword>")<CR><CR>
    noremap <silent>ug :Unite gtags/grep<CR>
    noremap <silent>ucg :Unite gtags/grep<CR><c-r>=expand("<cword>")<CR><CR>
endif

let g:python3_host_prog = $PYENV_ROOT.'/versions/3.6.8/bin/python'

"deoplete
let g:deoplete#enable_at_startup = 1

" Ctrl p
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

 " Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"auto gtags
let g:auto_gtags = 1

"auto ctags
let g:auto_ctags = 1

"color
colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1

filetype plugin indent on
