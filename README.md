# Mutineer
Simplifies commenting and uncommenting lines of code
![]()

# Installation
```vim
Plug 'jrihon/mutineer.vim'
```
Add  to your .vimrc (vim) or init.vim (neovim) with [vim-plug](https://github.com/junegunn/vim-plug).

# Configuration
The command `:Mutineer` handles both single line and multiline commenting. For now, block commenting has not been implemented, but I'll be looking into it in the future.

Remap the `:Mutineer` command to something easier. The whole reason I created this plugin, is to make commenting/uncommenting smoother.

I did the following in my init.vim (I chose the m key because it stands for mute) : 

```vim
nnoremap <leader>m :Mutineer<CR>
vnoremap <leader>m :Mutineer<CR>
```

It suffices to have the cursor on a line and activating the command.
For multiline commenting, it is necessary to highlight the desired lines (visual mode, visual-block or visual-line is fine) and then activating the command on the range of highlighted lines.

With the same command, it is possible to uncomment the line.

As of now, it only uncomments lines where the comment symbol is present in the first column(s).
It could be that I alter it to the first non-whitespace character, but then again, Mutineer only adds it at the beginning. Comment symbols elsewhere would entail user inputted comments.
So perhaps not needed?

## File recognition

You can check if vim recognises your filetype by `:echo &filetype` in the buffer that has the file you want recognised opened.
If this command returns nothing, the filetype is not recognised.

`path/to/vim/plugged/mutineer/AllKnownVimFileTypes.txt` contains a list of all the natively recognised filetypes.

If the file you are working on is not natively recognised by Vim, put the following command in your .vimrc / init.vim :

An example has been added for explanatory purposes
```vim
autocmd BufNewFile,BufRead *.$FileExtension set filetype=$FileType
autocmd BufNewFile,BufRead *.py set filetype='python'
```

## Adding your comment symbol to Mutineer
As of now, there is only a single global variable that is accessible by the user. To add your filetype in (this line must come after the custom autocmd),
add the following line to your .vimrc / init.vim :
```vim
let g:MutineerCommentSymbolDictionaryPerLanguage['&filetype'] = '$commentSymbol'
```
with $commentSymbol the character that denotes a commented line in your preferred language.
As this is a string character, make sure to put it in between quotations.

# Supported languages
- C : '.c' 
- C# : '.cs'
- C++ : '.cpp'
- C-shell : '.csh'
- Dlang : '.d' 
- Haskell : '.hs' 
- Java : '.java" 
- JavaScript : '.js' 
- Kotlin : '.kt'
- LaTeX : '.tex'
- Lua : '.lua'
- Matlab : '.m' :
- Perl : '.pl' 
- Python : '.py' 
- Ruby : '.rb' 
- Shell (bash) : '.sh' 
- Vim(script) : '.vim'
- Z-shell : '.zsh'


# Acknowledgements
My roommate for being excited whenever I sent him shows of progress while coding Mutineer.vim. Thanks S v. R <3 
