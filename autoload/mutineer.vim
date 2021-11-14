"===========================================================================================================================================================
"                                                       Mutineer - Simplifies commenting and uncommenting lines of code for every filetype
"
" Maintainer: Jérôme Rihon<jeromerihon@gmail.com>
" Version: 0.2
" License: MIT
" Website: https://github.com/jrihon/mutineer
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


" SECTION: Line Commenting{{{1
"================================================================
function! mutineer#MutineerLine(range, l1, l2) abort
    let l:commentSymbol = utilities#mutineer_utilities#RetrieveFileTypeForCommentSymbol("line")

    " If <range> has not been activated
    if a:range ==? 0
        let l:currentline = line(".")
        call utilities#mutineer_utilities#SingleLine(commentSymbol, currentline)

    " If a <range> has been prompted
    else
        call utilities#mutineer_utilities#MultipleLines(commentSymbol, a:l1, a:l2)
    endif
endfunction



" SECTION: Block Commenting {{{1
"================================================================
function! mutineer#MutineerBlock(range, l1, l2) abort
    let l:commentSymbolList = utilities#mutineer_utilities#RetrieveFileTypeForCommentSymbol("block")

    " slice the a:l1 and a:l2 to see if these lines are block commented
    let l:continueBlockComment = utilities#mutineer_utilities#SliceFirstAndLastLine(l:commentSymbolList, a:l1, a:l2)
    
    " If this returns 0, then this is not a block-commented range, which means we block-comment out the selection of lines
    if l:continueBlockComment == 0

        " Define your range
        let l:start = a:l1
        let l:end = a:l2 + 1
        let l:rangeList = range(l:start, l:end)

        " essentially you add a line to the range, since doing a put! messes up the initial range to where your first line is now the second line.
        for l:linenr in l:rangeList

            " start of the range
            if l:linenr ==? l:start
                execute 'normal! ' . l:start .'G'
                put! = l:commentSymbolList[0]

            " any line that is not start and end
            elseif l:linenr !=? l:start && l:linenr !=? l:end
                if len(l:commentSymbolList[1]) != 0
                    call utilities#mutineer_utilities#SingleLine(l:commentSymbolList[1], linenr)
                endif

            " end of the range
            elseif l:linenr ==? l:end
                execute 'normal! ' . l:end .'G'
                call utilities#mutineer_utilities#SingleLine(l:commentSymbolList[1], linenr)
                put = l:commentSymbolList[2]

            endif

        endfor

    " If this returns 1, then this is a block-commented range, which means we block-comment out the selection of lines
    elseif l:continueBlockComment == 1

        " Define your range
        let l:start = a:l1
        let l:end = a:l2 - 1
        let l:rangeList = range(l:start, l:end)

        " A quick note; the ' "_ ' is the black register. It is the same as /dev/null . It's to throw away stuff and not let unnamed registers get cluttered
        for l:linenr in l:rangeList

            " start of the range
            if l:linenr ==? l:start
                " If there is a middle symbol, take it out before deleting the first line moves the entire document up a row and then the following line gets skipped,
                " since it becomes the first line
                if len(l:commentSymbolList[1]) != 0
                    call utilities#mutineer_utilities#SingleLine(l:commentSymbolList[1], linenr + 1)
                endif

                " delete the line with the block comment symbol; start
                execute 'normal! ' . l:start .'G'
                execute 'normal! V"_d'
                
            " any line that is not start or end of the range
            elseif l:linenr !=? l:start && l:linenr !=? l:end
                " only if there is a block-comment symbol for between the bigger symbols, then use it
                if len(l:commentSymbolList[1]) != 0
                    call utilities#mutineer_utilities#SingleLine(l:commentSymbolList[1], linenr)
                endif

            " end of the range
            elseif l:linenr ==? l:end
                " delete the line with the block comment symbol; end
                execute 'normal! ' . l:end .'G'
                execute 'normal! V"_d'

            endif
        endfor

    " If this returns 2, then do not do anything and return nothing
    elseif l:continueBlockComment == 2
        " Quit the function and prompt this error message
        echoerr "E420 : MutineerBlockImproper range; include either both or no block comment symbols at start and end of selection!"
        return
    endif

endfunction


" end of the file
let &cpo = s:save_cpo
unlet s:save_cpo

"---------------------------------------------
"                    FIN
"---------------------------------------------
