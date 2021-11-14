# Mutineer
Simplifies commenting and uncommenting lines of code for every filetype
![Simplifies commenting and uncommenting lines of code](https://github.com/jrihon/mutineer.vim/blob/main/doc/mutineer_banner/mutineer.gif)

# Installation
```vim
Plug 'jrihon/mutineer.vim'
```
Add to your .vimrc (vim) or init.vim (neovim) with [vim-plug](https://github.com/junegunn/vim-plug).

# Configuration
The command `:Mutineer` handles both single line and multiline commenting/uncommenting.

The command `:MutineerBlock` handles block commenting/uncommenting.

Remap the `:Mutineer` and `:MutineerBlock` command to something easier. The whole reason I created this plugin, is to make commenting/uncommenting smoother.

I did the following in my init.vim (`m` stands for mute) : 

```vim
nnoremap <leader>m :Mutineer<CR>
vnoremap <leader>m :Mutineer<CR>
vnoremap <leader>M :MutineerBlock<CR>
```

### :Mutineer
It suffices to have the cursor on a line and to then activate the command. It is not necessary to highlight for a single line comment action.

For multiline commenting, it is necessary to highlight the desired lines (visual mode, visual-block or visual-line is fine) and then to activate the command on the range of highlighted lines.

With the keystrokes, it is possible to uncomment the same lines.

As of now, it only uncomments lines where the comment symbol is present in the first column(s).
It could be that I alter it to the first non-whitespace character, but then again, Mutineer only adds it at the beginning and there are little reasons why someone would do it manually.

Comment symbols elsewhere would entail user inputted comments, and comments not at the first columns do not get removed. Perhaps something I'll look into, perhaps not.

### :MutineerBlock
Works similar to `:Mutineer` visual-selection. When a block-comment has been set, the entire range of the block-comment has to be selected or else it will not block-uncomment.

## File recognition
You can check if vim recognises your filetype by `:echo &filetype` in the buffer that has the file you want recognised opened.
If this command returns ` `, the filetype is not recognised.

`path/to/vim/plugged/mutineer/AllKnownVimFileTypes.txt` contains a list of all the natively recognised filetypes.

If the file you are working on is not natively recognised by Vim, put the following command in your .vimrc / init.vim :

Where $FileExtension is the suffix of your file and $FileType is the name, all in lowercase letters! An example has been added for clarification.

```vim
autocmd BufNewFile,BufRead *.$FileExtension set filetype=$FileType
autocmd BufNewFile,BufRead *.py set filetype='python'
```

## Adding your comment symbol to Mutineer
As of now, there is only a single global variable that is accessible for the user. To add your filetype to `mutineer.vim`, add the following line to your .vimrc / init.vim :
```vim
let g:MutineerCommentSymbolDictionaryPerLanguage['&filetype'] = '$commentSymbol'
```
with `$commentSymbol` the character that denotes a commented line in your preferred language.

NB : This line must come after the custom autocommand, if you also need to specify your filetype. 
As this is a string character, make sure to put it in between quotations.

# Supported languages
- Assembly -------- '.asm'
- C --------------- '.c' 
- C# -------------- '.cs'
- C++ ------------- '.cpp'
- C-shell --------- '.csh'
- Dart ------------ '.dart'
- Dlang ----------- '.d' 
- GoLang ---------- '.go'
- Haskell --------- '.hs' 
- Java ------------ '.java" 
- JavaScript ------ '.js' 
- Kotlin ---------- '.kt'
- LaTeX ----------- '.tex'
- Lua ------------- '.lua'
- Matlab ---------- '.m'
- PHP ------------- '.php'
- Perl ------------ '.pl' 
- Python ---------- '.py' 
- Ruby ------------ '.rb' 
- Rust ------------ '.rs'
- SQL ------------- '.sql'
- Shell(bash) ----- '.sh' 
- Swift ----------- '.swift'
- TypeScript ------ '.ts'
- Vim(script) ----- '.vim'
- YAML ------------ '.yml'
- Z-shell --------- '.zsh'


# Acknowledgements
My roommate for being excited whenever I sent him shows of progress while coding Mutineer.vim. Thanks S v. R <3 
