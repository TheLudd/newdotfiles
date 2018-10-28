" Import chai assert
:noremap <Leader>c ggOimport { assert } from 'chai'<ESC>0?\<import\><CR>o<CR>assert<ESC>Ic<TAB>
" Change test to use proxyquire
:noremap <Leader>p 0wyeceproxyquiref'ci'proxy/describeoconst 0 = proxy()i''Pla, {}O
" Remove { return } in arrow functon
:noremap <Leader>q [{r(/returndaw]}r)
" Curry function
:noremap <Leader>h ^ceconstea =f(icurry(f)a =>f{]}a)?curry^
" Uncurry function
:noremap <Leader>g ^/currydf($]}lx[{BdaWF=daw^cefunction
" turn function into arrow function
:noremap <Leader>a ^ceconstea =f)a =>
" turn arrow function into function
:noremap <Leader>f ^cefunctionf=daw;.
