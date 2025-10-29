" LSP and diagnostics
hi! link LspReferenceText Visual
hi! link LspReferenceRead Visual
hi! link LspReferenceWrite Visual

hi DiagnosticError ctermfg=Red guifg=#ff5f5f
hi DiagnosticWarn  ctermfg=Yellow guifg=#ffd75f
hi DiagnosticInfo  ctermfg=Cyan guifg=#5fd7ff
hi DiagnosticHint  ctermfg=Blue guifg=#87afff
hi DiagnosticOk    ctermfg=Green guifg=#5fd75f

" Treesitter (TS*) groups
hi! link @variable Normal
hi! link @field Identifier
hi! link @property Identifier
hi! link @function Function
hi! link @method Function
hi! link @keyword Statement
hi! link @type Type
hi! link @string String
hi! link @number Constant
hi! link @comment Comment
hi! link @punctuation Delimiter

hi NormalFloat ctermbg=236 guibg=#1c1c1c
hi FloatBorder ctermfg=245 guifg=#666666 guibg=#1c1c1c
hi FloatTitle  ctermfg=Yellow guifg=#ffd700 guibg=#1c1c1c
hi PmenuThumb  ctermfg=Grey ctermbg=DarkGrey

hi CursorLineNr ctermfg=White ctermbg=237
hi WinSeparator ctermfg=240 guifg=#404040
hi MsgArea guibg=NONE ctermbg=NONE
hi Search cterm=reverse gui=reverse
hi IncSearch cterm=reverse gui=reverse

hi CursorLine ctermbg=236 guibg=#2a2a2a
hi CursorLineNr ctermfg=White ctermbg=DarkGray
hi LineNr ctermfg=245
hi PmenuSel ctermfg=0 ctermbg=7

" --- Remove black boxes in LSP hovers ---
hi LspReferenceText  ctermbg=NONE guibg=NONE cterm=underline gui=underline
hi LspReferenceRead  ctermbg=NONE guibg=NONE cterm=underline gui=underline
hi LspReferenceWrite ctermbg=NONE guibg=NONE cterm=underline gui=underline

" --- eliminate black boxes inside LSP hovers and docs ---
" make all float layers transparent or consistent

hi NormalFloat      ctermbg=237 guibg=#262626
hi FloatBorder      ctermfg=244 guifg=#666666 guibg=#262626
hi FloatShadow      ctermbg=NONE guibg=NONE
hi FloatShadowThrough ctermbg=NONE guibg=NONE

" force hover contents to inherit properly
hi! link NormalNC Normal
hi! link Pmenu NormalFloat

" remove background from all diagnostic/semantic virtual text
hi LspReferenceText  ctermbg=NONE guibg=NONE cterm=underline gui=underline
hi LspReferenceRead  ctermbg=NONE guibg=NONE cterm=underline gui=underline
hi LspReferenceWrite ctermbg=NONE guibg=NONE cterm=underline gui=underline

hi DiagnosticVirtualTextError ctermbg=NONE guibg=NONE
hi DiagnosticVirtualTextWarn  ctermbg=NONE guibg=NONE
hi DiagnosticVirtualTextInfo  ctermbg=NONE guibg=NONE
hi DiagnosticVirtualTextHint  ctermbg=NONE guibg=NONE

" safety: prevent 0-bg from leaking into semantic tokens
hi link @variable Normal
hi link @text Normal
hi link @text.literal Normal
hi link @text.reference Normal
hi link @namespace Normal

" --- Consistent dark hover panel style (Tokyo-like) ---
hi NormalFloat  ctermfg=White  ctermbg=0   guifg=#e8e8d3 guibg=#000000
hi FloatBorder  ctermfg=240    ctermbg=0   guifg=#444444 guibg=#000000
hi FloatTitle   ctermfg=220    ctermbg=0   guifg=#ffd75f guibg=#000000

" unify hover-related layers
hi! link Pmenu NormalFloat
hi! link NormalNC Normal
hi FloatShadow         ctermbg=0 guibg=#000000
hi FloatShadowThrough  ctermbg=0 guibg=#000000
