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

" Find test path based on file path and type and open both
function! OpenWithTest(filePath, type)
    let parts = split(a:filePath, '/')
    let l = len(parts)
    let file = parts[l - 1]
    let fileParts = split(file, '\.')
    let fileName = fileParts[0]
    if fileName == 'index'
        let fileName = parts[l -2]
    endif
    if a:type == ''
        let fullPathParts = ['test'] + parts[1:l-2] + [fileName]
	let end = '.js'
    elseif a:type == 'abstract'
        let fullPathParts = ['test'] + [ 'abstract-' . fileName ]
	let end = '-test.coffee'
    else
        let fullPathParts = ['test', a:type ] + parts[1:l-2] + [fileName]
	let end = '-test.coffee'
    endif
    let fullPath = join(fullPathParts, '/')
    let testPath = fullPath . end
    let current = expand('%')
    if current == a:filePath
	:execute "vsplit " . testPath
    else
    	call OpenBoth(testPath, a:filePath)
    endif
endfunction

" Open mediatool unit test
function! OpenUnit(filePath)
    call OpenWithTest(a:filePath, 'unit')
endfunction
command! -complete=file -nargs=1 U call OpenUnit(<f-args>)

" Open mediatool integration test
function! OpenIt(filePath)
    call OpenWithTest(a:filePath, 'it')
endfunction
command! -complete=file -nargs=1 I call OpenIt(<f-args>)

" Open mediatool abstract test
function! OpenAbstractTest(filePath)
    call OpenWithTest(a:filePath, 'abstract')
endfunction
command! -complete=file -nargs=1 A call OpenAbstractTest(<f-args>)

" Open test with same name as file
function! OpenFlatTest(filePath)
    call OpenWithTest(a:filePath, '')
endfunction
command! -complete=file -nargs=1 T call OpenFlatTest(<f-args>)
