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
"
if !exists(':Tabularize')
  finish
endif

let p = '^\s*|\s.*\s|\s*$'

" Clean up: restore previous search history, and cursor position
function! AlignBars()
  let originalLine = line(".")
  let originalCol = col(".")
  let line = 1
  let lastLine = line('$')
  call cursor(line, 1)
  while line < lastLine
    call cursor(line, 1)
    Tabularize/|/l1
    let line = line + 1
  endwhile
  call cursor(originalLine, originalCol)
endfunction

autocmd BufWritePre *.template,*.feature-template,*.feature :call AlignBars()
