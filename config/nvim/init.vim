if empty(glob('$XDG_DATA_HOME/nvim/site/pack/packer/start/packer.nvim'))
  silent !git clone --depth=1 https://github.com/wbthomason/packer.nvim ${XDG_DATA_HOME}/nvim/site/pack/packer/start/packer.nvim
  autocmd VimEnter * PackerSync
endif

lua << EOF
  require('user.options')
  require('user.keymaps')
  require('plug')
EOF

" colorscheme
:silent! colorscheme jellybeans

" No Ex Mode
nnoremap Q <Nop>

" No command line history
nnoremap q: <Nop>

" Leader commands, leader is '
let mapleader = "ä"

" Edit/source vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>
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
cnoreabbrev ls Telescope buffers

" search file with ctrl s
nnoremap <C-s> :%s/

" copy visual selection to clipboard
vnoremap <C-c> "+y

" Clear search with space
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" edit files in current file directory
map ,e :e <C-R>=expand("%:h") . "/" <CR>
map ,t :tabe <C-R>=expand("%:h") . "/" <CR>
map ,s :split <C-R>=expand("%:h") . "/" <CR>
map ,s :vsplit <C-R>=expand("%:h") . "/" <CR>


autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100)
au BufRead,BufNewFile *.feature-template :set filetype=cucumber
au BufWritePost ~/code/dwm/config.h :! make && sudo make install && kill -15 $(pidof dwm)
au BufWritePost ~/code/dwmblocks/blocks.h :! make && sudo make install && kill $(pidof dwmblocks)

nnoremap <leader>w <cmd>Telescope lsp_references<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>

let g:gitblame_message_template = '<date> • <author> • <summary>'
let g:gitblame_date_format = '%d/%m-%y'
nnoremap <leader>cs :GitBlameCopySHA<cr>

function! TabIsEmpty()
    return winnr('$') == 1 && len(expand('%')) == 0 && line2byte(line('$') + 1) <= 2
endfunction

function! AddTestSuffix(filepath)
    return substitute(a:filepath, '\(\.\w\+\)$', '-test\1', '')
endfunction

function! RemoveTestAndSuffix()
	return substitute(expand("%:t:r"), '-test$', '', '')
endfunction

function! RemoveTest(filepath)
	return substitute(a:filepath, '-test', '', '')
endfunction

function! RemoveTestAddJSSuffix()
	return substitute(expand("%:t:r"), '-test$', '.js', '')
endfunction

function! FindCodePath(filepath)
    let codePath = RemoveTest(a:filepath)
    let endsWithX = a:filepath =~ 'x$'
    if endsWithX
        let withoutX = substitute(codePath, 'x$', '', '')
        if !empty(glob(withoutX))
            return withoutX
        endif
    endif

    return codePath
endfunction

function! FindTestPath (filepath) 
    let testPath = AddTestSuffix(a:filepath)
    let testXPath = testPath . "x"
    if !empty(glob(testXPath))
        return testXPath
    else 
        return testPath
    endif
endfunction

" Open two files, split vertically
function! OpenBoth(left, right)
    if TabIsEmpty()
        :execute ":e " . a:right
    else
        :execute ":tabedit " . a:right
    endif
    if empty(glob(a:right))
        :execute ":w"
    endif
    :execute ":vsplit " . a:left
    if empty(glob(a:left))
        :execute "silent :w"
    endif
endfunction

function! OpenWithTest(filepath)
    call OpenBoth(FindTestPath(a:filepath), a:filepath)
endfunction

command! -complete=file -nargs=1 T call OpenWithTest(<f-args>)

" jump to code file file
nnoremap <silent> gce :execute "edit " . FindCodePath(expand("%"))<CR>
nnoremap <silent> gcs :execute "botright vsplit " . FindCodePath(expand("%"))<CR>

" make value of amend definition
noremap <Leader>v 0f:wC{o},ko"require": "o"type": "value"
