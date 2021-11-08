"===========================================================================================================================================================
"                                                       Mutineer - Simplifies commenting and uncommenting lines of code for every filetype
"
" Maintainer: Jérôme Rihon<jeromerihon@gmail.com>
" Version: 0.1
" License: MIT
" Website: https://github.com/jrihon/mutineer.vim
" 
"                                                                    __  __       _   _                      
"                                                                   |  \/  |_   _| |_(_)_ __   ___  ___ _ __ 
"                                                                   | |\/| | | | | __| | '_ \ / _ \/ _ \ '__|
"                                                                   | |  | | |_| | |_| | | | |  __/  __/ |   
"                                                                   |_|  |_|\__,_|\__|_|_| |_|\___|\___|_|  
"                                        
"===========================================================================================================================================================

" start of the file
" If the variable is not loaded into memory (from autoload script), then we can succesfully source this file.
" This is a type of sentinel, where we don't unneccesarily load the same script multiple times and 'keep vim from spazzing out' @NERDtree/plugin/NERD_tree.vim
if exists('g:loaded_mutineer_global')
    finish
endif

let g:loaded_mutineer_global = 1
" compatibility options. Save them and reset them. At the end, save them again to their defaulted value
let s:save_cpo = &cpo
set cpo&vim


"SECTION: MutineerGlobalVar {{{1
"================================================================
let g:MutineerCommentSymbolDictionaryPerLanguage = {
                                                \'c' : '//',
                                                \'cpp' : '//',
                                                \'cs' : '//',
                                                \'csh' : '#',
                                                \'d' : '//',
                                                \'dart' : '//',
                                                \'go' : '//',
                                                \'hs' : '--',
                                                \'java' : '//',
                                                \'javascript' : '//',
                                                \'kotlin' : '//',
                                                \'lua' : '--',
                                                \'matlab' : '%',
                                                \'perl' : '#',
                                                \'php' : '//',
                                                \'python' : '#',
                                                \'ruby' : '#',
                                                \'rust' : '//',
                                                \'sh' : '#',
                                                \'sql' : '--',
                                                \'swift' : '//',
                                                \'tex' : '%',
                                                \'typescript' : '//',
                                                \'vim' : '"',
                                                \'zsh' : '#',
                                                    \}


" SECTION: Mutineer command {{{1
"================================================================
command! -range Mutineer call mutineer#MutineerMain(<range>,<line1>, <line2>)

" end of the file
let &cpo = s:save_cpo
unlet s:save_cpo
