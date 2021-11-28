" SECTION: helper functions {{{1
"================================================================
"
" retrieve the filetype of the current file to prompt the correct $commentSymbol(s)
function! utilities#mutineer_utilities#RetrieveFileTypeForCommentSymbol(method) abort
    let l:ft = &filetype
    " This variable is set in the plugin/mutineer.vim
    if a:method == "line"
        if has_key(g:MutineerCommentSymbolDictionaryPerLanguage, l:ft)
            return g:MutineerCommentSymbolDictionaryPerLanguage[l:ft]
        elseif !empty(g:MutineerCommentSymbolDictionaryPerLanguageExtended)
            if has_key(g:MutineerCommentSymbolDictionaryPerLanguageExtended, l:ft)
                return g:MutineerCommentSymbolDictionaryPerLanguageExtended[l:ft]
            endif
        else
            echoerr "E69 Key does not exist! Add your &filetype to g:MutineerCommentSymbolDictionaryPerLanguageExtended "
        endif
    elseif a:method == "block"
        if has_key(g:MutineerCommentSymbolDictionaryPerLanguageBLOCK, l:ft)
            return g:MutineerCommentSymbolDictionaryPerLanguageBLOCK[l:ft]
        elseif !empty(g:MutineerCommentSymbolDictionaryPerLanguageBLOCKExtended)
            if has_key(g:MutineerCommentSymbolDictionaryPerLanguageBLOCKExtended, l:ft)
                return g:MutineerCommentSymbolDictionaryPerLanguageBLOCKExtended[l:ft]
            endif
        else
            echoerr "E69 Key does not exist! Add your &filetype to g:MutineerCommentSymbolDictionaryPerLanguageBLOCKExtended "
        endif
    endif
endfunction


" Retrieves the first character(s) from the line, along the size of the prompted $commentSymbol(s)
function! utilities#mutineer_utilities#FirstCharactersOfLine(commentStr, linenr) abort
    let l:LineString = getline(a:linenr) 
    let l:Length = len(a:commentStr)
    return l:LineString[0:l:Length- 1]
endfunction


" Returns the commented line without the $commentSymbol in it
function! utilities#mutineer_utilities#ReturnUncommentedChars(commentStr, linenr) abort
    let l:LineString = getline(a:linenr) 
    let l:Length = len(a:commentStr)

    " Return the first characters of the line that are not comments
    let l:offsetLine = l:Length
    let l:indexuntil = l:Length + l:Length - 1
    return l:LineString[l:offsetLine:l:indexuntil]
endfunction


" Comments the line with the $commentSymbol(s)
function! utilities#mutineer_utilities#CommentALine(comment, FirstChar, linenr) abort
    execute 'normal! ' . a:linenr . 'G'
    let l:linesub = substitute(getline(a:linenr), a:FirstChar, a:comment . a:FirstChar, "")
    call setline(a:linenr, linesub)
endfunction


" Uncomments the line with the $commentSymbol(s)
function! utilities#mutineer_utilities#UncommentALine(comment, FirstChar, linenr) abort
    execute 'normal! ' . a:linenr . 'G'
    let l:linesub = substitute(getline(a:linenr), a:comment . a:FirstChar, a:FirstChar, "")
    call setline(a:linenr, linesub)
endfunction





" SECTION: Refactoring functions {{{1
"================================================================
" Comment/Uncomment SINGLE line
function! utilities#mutineer_utilities#SingleLine(commentStr, linenr) abort
    " Check if the line has been commented before with a $commentSymbol(s)
    let l:FirstChar = utilities#mutineer_utilities#FirstCharactersOfLine(a:commentStr, a:linenr)
    
    if a:commentStr !=? FirstChar " not equal, case insensitive
        call utilities#mutineer_utilities#CommentALine(a:commentStr, FirstChar, a:linenr) 
        if g:SpasticCursorMovementToggle
            execute "normal! 1h"
        endif
    
    elseif a:commentStr ==? FirstChar " equal, case insensitive
        let l:UncommentedChars = utilities#mutineer_utilities#ReturnUncommentedChars(a:commentStr, a:linenr)
        call utilities#mutineer_utilities#UncommentALine(a:commentStr, UncommentedChars, a:linenr) 
        if g:SpasticCursorMovementToggle
            execute "normal! 1h"
        endif

    endif
endfunction



" Comment/Uncomment RANGE of lines
function! utilities#mutineer_utilities#MultipleLines(commentStr, l1, l2) abort
    let l:rangeList = range(a:l1, a:l2)

    " This is for all the lines in the prompted range
    for l:linenr in l:rangeList
        call utilities#mutineer_utilities#SingleLine(a:commentStr, linenr)

    endfor

endfunction



" Get the first characters of a the start and last line, to see if you highlighted the correct lines for BLOCK commenting/uncommenting
function! utilities#mutineer_utilities#SliceFirstAndLastLine(commentSymbolList, l1, l2) abort
    let l:lengthFirstSymbol = len(a:commentSymbolList[0])
    let l:lengthLastSymbol = len(a:commentSymbolList[2])

    " Get the full line
    let l:FirstLine = getline(a:l1)
    let l:LastLine = getline(a:l2)
    " Slice the full lines to the length of the blockComment symbol
    let l:sliceFirstLine = l:FirstLine[0:lengthFirstSymbol - 1]
    let l:sliceLastLine = l:LastLine[0:lengthLastSymbol - 1]

    " if both lines contain the block comment
    if l:sliceFirstLine ==? a:commentSymbolList[0] && l:sliceLastLine ==? a:commentSymbolList[2]
        return 1
    " if either line contains a block comment
    elseif l:sliceFirstLine ==? a:commentSymbolList[0] || l:sliceLastLine ==? a:commentSymbolList[2]
        return 2
    else
        return 0
    endif

endfunction
