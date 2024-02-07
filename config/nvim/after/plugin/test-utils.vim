function! RemoveTestAndRetainSuffix()
	return substitute(expand("%:t"), '-test\(\.[^.]\+\)\?$', '\1', '')
endfunction

function! RemoveTestAndSuffix()
	return substitute(expand("%:t:r"), '-test$', '', '')
endfunction

function! RemoveTestAddJSSuffix()
	return substitute(expand("%:t:r"), '-test$', '.js', '')
endfunction
