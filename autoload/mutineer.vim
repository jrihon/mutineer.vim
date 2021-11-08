"===========================================================================================================================================================
"                                                       Mutineer - Simplifies commenting and uncommenting lines of code for every filetype
"
" Maintainer: Jérôme Rihon<jeromerihon@gmail.com>
" Version: 0.1
" License: MIT
" Website: https://github.com/jrihon/mutineer.vim
"===========================================================================================================================================================
"
"
"---------------------------------------------
"                    START
"---------------------------------------------
" In this file, we do not need to check if the mutineer_global exists, since we already sourced the file.vim in the plugin folder
" 
" start of the file
" compatibility options. Save them and reset them. At the end, save them again to their defaulted value
let s:save_cpo = &cpo
set cpo&vim

" SECTION: helper functions {{{1
"================================================================
" Retrieves the first character(s) from the line.
function! mutineer#FirstCharactersOfLine(commentStr, linenr) abort
    let l:LineString = getline(a:linenr) 
    let l:Length = len(a:commentStr)
    return l:LineString[0:l:Length- 1]
endfunction


" Return the line without the comments in it
function! mutineer#ReturnUncommentedChars(commentStr, linenr) abort
    let l:LineString = getline(a:linenr) 
    let l:Length = len(a:commentStr)

    " Return the first characters of the line that are not comments
    let l:offsetLine = l:Length
    let l:indexuntil = l:Length + l:Length - 1
    return l:LineString[l:offsetLine:l:indexuntil]
endfunction


" retrieve the filetype of the current file
function! mutineer#RetrieveFileTypeForCommentSymbol() abort
    let l:ft = &filetype
    " This variable is set in the plugin/mutineer.vim
    return g:MutineerCommentSymbolDictionaryPerLanguage[l:ft]
endfunction


" comments the line with the $commentSymbol
function! mutineer#CommentALine(comment, FirstChar, linenr) abort
    let l:linesub = substitute(getline(a:linenr), a:FirstChar, a:comment . a:FirstChar, "")
    call setline(a:linenr, linesub)
endfunction


" uncomments the line with the $commentSymbol
function! mutineer#UncommentALine(comment, FirstChar, linenr) abort
    let l:linesub = substitute(getline(a:linenr), a:comment . a:FirstChar, a:FirstChar, "")
    call setline(a:linenr, linesub)
endfunction


" comment/uncomment single line
function! mutineer#SingleLine(commentStr, linenr) abort
    let l:FirstChar = mutineer#FirstCharactersOfLine(a:commentStr, a:linenr)
    
    if a:commentStr !=? FirstChar " not equal, case insensitive
        call mutineer#CommentALine(a:commentStr, FirstChar, a:linenr) 
        if g:SpasticCursorMovementToggle 
            execute "normal! 1h"
        endif
    
    elseif a:commentStr ==? FirstChar " equal, case insensitive
        let l:UncommentedChars = mutineer#ReturnUncommentedChars(a:commentStr, a:linenr)
        call mutineer#UncommentALine(a:commentStr, UncommentedChars, a:linenr) 
        if g:SpasticCursorMovementToggle 
            execute "normal! 1h"
        endif

    endif
endfunction


" comment/uncomment range of lines
function! mutineer#MultipleLines(commentStr, l1, l2) abort
    let l:rangeList = range(a:l1, a:l2)

    " This has been set up like this for later coding of block commenting
    for l:linenr in l:rangeList
        " start of the range
        if l:linenr == a:l1
            call mutineer#SingleLine(a:commentStr, linenr)
        " end of the range
        elseif l:linenr == a:l2
            call mutineer#SingleLine(a:commentStr, linenr)
        else
            call mutineer#SingleLine(a:commentStr, linenr)
        endif
    endfor
endfunction


" SECTION: main {{{1
"================================================================
function! mutineer#MutineerMain(range, l1, l2) abort
    let l:commentSymbol = mutineer#RetrieveFileTypeForCommentSymbol()

    " If <range> has not been activated
    if a:range == 0
        let l:currentline = line(".")
        call mutineer#SingleLine(commentSymbol, currentline)

    " If a <range> has been prompted
    else
        call mutineer#MultipleLines(commentSymbol, a:l1, a:l2)
    endif
endfunction


" end of the file
let &cpo = s:save_cpo
unlet s:save_cpo

"---------------------------------------------
"                    FIN
"---------------------------------------------
