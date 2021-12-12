" For a paranoia.
" Normally `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

" Open tests along with regular files
source $XDG_CONFIG_HOME/nvim/test-split.vim

" Basic config
syntax enable
" set noswapfile
" Sane completion in command mode
set wildmenu
set wildmode=list:longest
" Find files deep using :find, ignore generated folders
set path+=**
set wildignore+=*/node_modules/*,*/dist/*
" Detect file types for plugins/omni completion etc
filetype plugin indent on
" Highlight search matches while typing
set incsearch
" Use relative line numbers
set relativenumber
set number
" search with smartcase
set ignorecase
set smartcase

" Allow switching to buffers before save
set hidden

" Visualize preview of search/replace
set inccommand=split

" No Ex Mode
nnoremap Q <Nop>

" Leader commands, leader is '
let mapleader = "ä"

function! TabIsEmpty()
    return winnr('$') == 1 && len(expand('%')) == 0 && line2byte(line('$') + 1) <= 2
endfunction
function! EditFile(path)
    if TabIsEmpty()
        :execute "e " . a:path
    else
        :execute "tabe " . a:path
    endif
endfunction
" Edit vimrc
nnoremap <leader>ev :call EditFile("$MYVIMRC")<cr>
" Source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" Plugins
" Install Vim Plug if not installed

if empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
  silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data') . '/site/vim-plug_plugins')

nnoremap <leader>mu :source $MYVIMRC<cr>:PlugUpdate<cr>
nnoremap <leader>mc :source $MYVIMRC<cr>:PlugClean<cr>

" Use colorscheme jellybeans
Plug 'nanotech/jellybeans.vim'

" Surround plugin
Plug 'tpope/vim-surround'

" Case insensitive search/replace and spell correction
Plug 'tpope/vim-abolish'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Multi language plugin
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['javascriptreact']
let g:vim_markdown_new_list_item_indent = 0

" " Linter
" Plug 'dense-analysis/ale'
" let g:ale_linters = { 'json': [ 'jq' ] }
" let g:ale_fixers = {'javascript': ['eslint', 'prettier'], 'typescript': ['eslint'], 'javascriptreact': [ 'eslint' ], 'typescriptreact': [ 'eslint' ], 'json': ['jq'] }
" let g:ale_lint_delay = 500
" let g:ale_pattern_options = {
" \   '.*node_modules.*$': {'ale_enabled': 0},
" \   '.*dist.*$': {'ale_enabled': 0},
" \   '.*-config.js$': {'ale_enabled': 0},
" \}
" " autofix
" nnoremap <leader>l :ALEFix<cr>
" " error navigation
" noremap <leader>n :ALENextWrap<cr>
" noremap <leader>N :ALEPreviousWrap<cr>
" function! ALEIgnore()
"   let codes = []
"   for d in getloclist(0)
"     if (d.lnum==line('.'))
"       let code = split(d.text,':')[0]
"       if index(codes, code) == -1
"         call add(codes, code)
"       endif
"     endif
"   endfor
"   if len(codes)
"     let l = line(".")
"     let c = col(".")
"     exe 'normal O// eslint-disable-next-line ' . join(codes, ', ')
"     call cursor(l + 1, c)
"   endif
" endfunction
" noremap <leader>I :call ALEIgnore()<cr>

" Ctrl-P
Plug 'kien/ctrlp.vim'
let g:ctrlp_custom_ignore = '\v[\/](\.git|node_modules|dist)$'
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }

" exchange
Plug 'tommcdo/vim-exchange'

" splitjoin
Plug 'AndrewRadev/splitjoin.vim'

" UltiSnips
Plug 'SirVer/ultisnips', { 'rev': 'f95ce29' }
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsSnippetsDir = stdpath('data') . '/UltiSnips/'
let g:UltiSnipsSnippetDirectories = [ stdpath('data') . '/UltiSnips/' ]

" cucumber
Plug 'tpope/vim-cucumber'

" emmet
Plug 'mattn/emmet-vim'

" ack - fast search
Plug 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
cnoreabbrev Ack Ack
nnoremap <leader>w :Ack <C-r><C-w> . -r <CR>
nnoremap <leader>W :Ack<Space>

" Auto pairs
Plug 'jiangmiao/auto-pairs'

" Fugitive - git plugin
Plug 'tpope/vim-fugitive'
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gsm :Gvsplit master:%<cr>
nnoremap <leader>gd :Gdelete<cr>
nnoremap <leader>gR :Gread master:%<cr>
nnoremap <leader>gch :Gread<cr>
nnoremap <leader>gca :Git commit --all<cr>
nnoremap <leader>gco :Git commit %<cr>
nnoremap <leader>gm :Gmove
nnoremap <leader>ga :Git add --all<cr>
nnoremap <leader>gA :Git add %<cr>

" Tabularize
Plug 'godlygeek/tabular'
" align tabs each time | is entered
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" generic snippets
Plug 'honza/vim-snippets'

" airline
Plug 'vim-airline/vim-airline'
let g:airline_section_y = ''
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ }
let g:airline_section_z = ''

" Increment/decrement dates
Plug 'tpope/vim-speeddating'

" Unix commands in vim
Plug 'tpope/vim-eunuch'

" Comment on/off
Plug 'tpope/vim-commentary'
autocmd FileType crontab setlocal commentstring=#\ %s

" Database mappings
Plug 'tpope/vim-dadbod'

" repeat - adds dot command support for speeddating
Plug 'tpope/vim-repeat'

" tmux
Plug 'tmux-plugins/vim-tmux'

" Supposedly better find and stuff
Plug 'tpope/vim-apathy'

" tpope/vim-dispatch
Plug 'tpope/vim-dispatch'

" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'   }
let g:mkdp_auto_close = 0

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

" Initialize plugin system
call plug#end()

" lua require'lspconfig'.tsserver.setup{}

:silent! colorscheme jellybeans

" Mappings

" Move easily between windows
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Move lines up and down
nnoremap - :normal ddp<CR>
nnoremap _ @='kddpk'<CR>

" Yank rest of line
nnoremap Y y$

" Move letters right/left
nnoremap <Right> xp
nnoremap <Left> hxph

" Use same command for upper/lower case
cnoreabbrev W w
cnoreabbrev Wa wa
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev X x
cnoreabbrev Xa xa
cnoreabbrev ya Start! yarn add

" Open/close files
cnoreabbrev tc tabclose
cnoreabbrev t tabedit

" search file with ctrl s
nnoremap <C-s> :%s/

" copy visual selection to clipboard
vnoremap <C-c> "+y

function! TabCloseRight(bang)
    let cur=tabpagenr()
    while cur < tabpagenr('$')
        exe 'tabclose' . a:bang . ' ' . (cur + 1)
    endwhile
endfunction

function! TabCloseLeft(bang)
    while tabpagenr() > 1
        exe 'tabclose' . a:bang . ' 1'
    endwhile
endfunction

command! -bang Tcr call TabCloseRight('<bang>')
command! -bang Tcl call TabCloseLeft('<bang>')

" Clear search with space
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Remove trailing whitespace when saving
function! <SID>StripTrailingWhitespaces()
    if exists('b:noStripWhitespace')
        return
    endif

    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre *.snippets let b:noStripWhitespace=1
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Indentation preferences
function! Indent2Spaces()
    setlocal expandtab
    setlocal shiftwidth=2
    setlocal softtabstop=2
endfunction
au BufRead,BufNewFile *.coffee,*.ts,*.tsx,*.feature,*.js,*.jsx,*.json,*.html,*.less,*.feature-template,.feature.md :call Indent2Spaces()
au BufRead,BufNewFile *.feature-template :set filetype=cucumber
au BufWritePost ~/code/dwm/config.h :Start! make && sudo make install && kill -15 $(pidof dwm)
au BufWritePost ~/code/dwmblocks/blocks.h :Start! make && sudo make install && kill $(pidof dwmblocks)

" Javascript leader commands
" Import chai assert
noremap <Leader>c ^yiwggOimport { assert } from 'chai'}oconst { 0 } = assertF}b*:nohlsearch<Bar>:echo<CR>
" Add to chai assert
noremap <Leader>C ^ye?assertF?{wPa, G?"
" Change test to use proxyquire
noremap <Leader>p 0wyeceproxyquiref'ci'proxy/describe:nohlsearch<Bar>:echo<CR>oconst 0 = proxy()i''Pla, {}O
" Remove { return } in arrow functon
noremap <Leader>q [{r(/returndaw]}r):nohlsearch<Bar>:echo<CR>
" Curry function
noremap <Leader>h $?function<CR>ceconstea =f(icurry(f)a =>f{]}a)?curry^:nohlsearch<Bar>:echo<CR>
" noremap <Leader>h ^ceconstea =f(icurry(f)a =>f{]}a)?curry^:nohlsearch<Bar>:echo<CR>
" Uncurry function
noremap <Leader>g ^/currydf($]}lx[{BdaWF=daw^cefunction:nohlsearch<Bar>:echo<CR>
" turn function into arrow function
noremap <Leader>a ^ceconstea =f)a =>
" turn arrow function into function
noremap <Leader>f ^cefunctionf=daw;.
" make value of amend definition
noremap <Leader>v 0f:wC{o},ko"require": "o"type": "value"
" import -> require
noremap <Leader>r :s/import\(.*\)from \(.*\)/const\1= require(\2)<CR>:nohlsearch<CR>
" require -> import
noremap <Leader>i :s/const\(.*\)= require(\('.*'\))/import\1from \2<CR>:nohlsearch<CR>
" install dependency
noremap <Leader>ya yi':Start! yarn add <C-R>" <CR>
" install devDependency
noremap <Leader>yd yi':Start! yarn add --dev <C-R>" <CR>
" split and sort a destructed object
noremap <Leader>S ci}<CR><CR><ESC>kP:s/ *$/,/<CR>:s/, /,\r/g<CR>:nohlsearch<CR>=i}vi}:sort<CR>
" sort a destructed object
noremap <Leader>so vi}:sort<CR>
" create file under cursor
:noremap <leader>gf :e <cfile><cr>

map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
map ,t :tabe <C-R>=expand("%:p:h") . "/" <CR>
map ,s :split <C-R>=expand("%:p:h") . "/" <CR>

function! GetTestImportPath ()
  let path = substitute(expand('%:r'), '^./', '', '')
  let file = expand('%:t:r')
  let parts = split(path, '/')
  let nbrParts = len(parts)

  let outParts = []
  let removals = 0
  for p in parts
    if p == 'test'
      :call add(outParts, '../lib')
      let removals += 1
    elseif p != file
      :call insert(outParts, '..', 0)
    endif

    if p == 'unit' || p == 'it'
      let removals += 1
    endif
  endfor
  let allParts = extend(outParts, parts[removals:nbrParts])
  return join(allParts, '/') . '.js'
endfunction
