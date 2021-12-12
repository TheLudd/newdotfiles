if !exists('g:loaded_lspsaga')
  finish
endif

lua << EOF
local saga = require 'lspsaga'

EOF

nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
