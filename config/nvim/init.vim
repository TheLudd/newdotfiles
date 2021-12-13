if empty(glob('$XDG_DATA_HOME/nvim/site/pack/paqs/start/paq-nvim'))
  silent !git clone --depth=1 https://github.com/savq/paq-nvim.git ${XDG_DATA_HOME}/nvim/site/pack/paqs/start/paq-nvim
  autocmd VimEnter * PaqInstall
endif

lua << EOF
  require('plug')
EOF

" colorscheme
:silent! colorscheme jellybeans

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

" No command line history
nnoremap q: <Nop>

" Leader commands, leader is '
let mapleader = "ä"

" Edit/source vimrc
nnoremap <leader>ev :call EditFile("$MYVIMRC")<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

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

" Open/close files
cnoreabbrev tc tabclose

" search file with ctrl s
nnoremap <C-s> :%s/

" copy visual selection to clipboard
vnoremap <C-c> "+y

" Clear search with space
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" edit files in current file directory
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
map ,t :tabe <C-R>=expand("%:p:h") . "/" <CR>
map ,s :split <C-R>=expand("%:p:h") . "/" <CR>

autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100)
