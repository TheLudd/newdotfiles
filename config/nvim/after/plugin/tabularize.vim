" align tabs each time | is entered
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

autocmd BufWritePre *.template,*.feature-template :call AlignBars()
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
