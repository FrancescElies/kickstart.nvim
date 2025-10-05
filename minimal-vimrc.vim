" viemu.com graphical cheat sheet - http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html

" https://github.com/wklken/vim-for-server/blob/master/vimrc

" execute as shell command from cursor to EOL
"nnoremap <F4> :execute system(getline('.')[col('.')-1:])<CR>
nnoremap <F4> "ey$:!<c-r>e<cr>
" execute as : command from cursor to EOL
"nnoremap <F5> :execute getline('.')[col('.')-1:]<CR>
nnoremap <F5> "ey$:<c-r>e<cr>

" TPOPE PLUGINS COMMON STEPS:
" mkdir ~/.vim/pack/tpope/start
" cd ~/.vim/pack/tpope/start
" SENSIBLE DEFAULTS:
" git clone https://tpope.io/vim/sensible.git
" SUBSTITUTE WORD VARIANTS:
" git clone https://tpope.io/vim/abolish.git
" vim -u NONE -c "helptags abolish/doc" -c q
" NIX SHELL COMMANDS: :Remove, :Delete, :Move, :Chmod, :Mkdir, :Cfind, :Clocate, :Lfind/, :Wall, :SudoWrite, :SudoEdit
" git clone https://tpope.io/vim/eunuch.git
" vim -u NONE -c "helptags eunuch/doc" -c q
" UNIMPAIRED:
" git clone https://tpope.io/vim/unimpaired.git
" vim -u NONE -c "helptags unimpaired/doc" -c q
" GIT:
" git clone https://tpope.io/vim/fugitive.git
" vim -u NONE -c "helptags fugitive/doc" -c q
" COMMENTARY: gc
" git clone https://tpope.io/vim/commentary.git
" vim -u NONE -c "helptags commentary/doc" -c q
" SURROUND:
" git clone https://tpope.io/vim/surround.git
" vim -u NONE -c "helptags surround/doc" -c q
" SESSIONS:
" git clone https://github.com/tpope/vim-obsession.git
" vim -u NONE -c "helptags vim-obsession/doc" -c q

" Something simple for emergencies or to easily copy on servers.
"
" https://github.com/changemewtf/no_plugins
"
"    Fuzzy search:
"    When moving to another buffer with :b, hit tab to autocomplete, or simply
"    hit Enter to go to the first buffer with a unique match to what you have
"    already typed.
"
"    By adding set path+=** and set wildmenu to the vimrc, we are now able to
"    hit Tab when running a :find command to expand partial matches.
"
"    Another asterisk (*) can be placed in the query to return fuzzy/partial matches.
"    ^x^n to search within the file
"    ^x^f to complete filenames (works with path+=**!)
"    ^x^] to complete only tags
"
"    Snippets:
"    nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>

" FINDING FILES:

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu
set wildignorecase
set wildmode=list:longest,full
set wildignore=*.o,*~,*.pyc,*.class




" https://github.com/mhinz/vim-galore?tab=readme-ov-file#cosmetic-changes-to-colorschemes
autocmd ColorScheme * highlight StatusLine ctermbg=darkgray cterm=NONE guibg=darkgray gui=NONE
colorscheme desert

" save
cmap w!! w !sudo tee > /dev/null %

" Toggle syntax on/off
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>
set synmaxcol=500

" cycle previous entries showing only the ones starting with current input
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>

" y$ -> Y Make Y behave like other capitals
map Y y$

nnoremap gb :ls<cr>:b
nnoremap cgn *Ncgn
" [s]witch to alternat[e] buffer
nnoremap se :e #<cr>
" [s]ource buffer
nnoremap so :so %<cr>



" https://github.com/iggredible/Learn-Vim/blob/master/ch03_searching_files.md
":grep "pizza"
":cfdo %s/pizza/donut/g | update
if executable('rg')
  " Use ripgrep in “vimgrep” (parseable) mode
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
  " Format: file:line:column:message
  "set grepformat=%f:%l:%c:%m
endif

" WHICH KEYS TO MAP: :h map-which-keys

"^/$ (start/end) of line is more common than H/L defaults top/bottom of buffer"
map H ^
map L $

" QUICKLY NAVIGATE QUICKFIX LIST:
nnoremap <c-h> :colder<cr>
nnoremap <c-l> :cnewer<cr>
nnoremap <c-k> :cprev<cr>zz
nnoremap <c-j> :cnext<cr>zz


" KEEP THINGS VERTICALLY CENTERED DURING SEARCHES:
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n     nzzzv
nnoremap N     Nzzzv
nnoremap *     *zzzv
nnoremap #     #zzzv
nnoremap g*    g*zzzv
nnoremap g#    g#zzzv

" QUICK ESCAPE:
inoremap jk <Esc>
nnoremap Q <nop>

" Turkish keyboard
nnoremap ı  i

" !ip!sort will sort the lines of the current paragraph.

let mapleader = " "

nnoremap <leader>y "+y
vnoremap <leader>y "+yg_
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>p "+p
vnoremap <leader>p "+p


nnoremap <leader>ve  :e $MYVIMRC<cr>

" quickly cd to current file dir or it's root dir project
function! FindRootAndCd()
  let l:markers = ['.git', 'Cargo.toml', 'package.json', 'pyproject.toml', '.hg']
  let l:dir = expand('%:p:h')
  while l:dir !=# '/'
    for l:marker in l:markers
      if filereadable(l:dir . '/' . l:marker) || isdirectory(l:dir . '/' . l:marker)
        execute 'cd' fnameescape(l:dir)
        echo "Changed directory to project root: " . l:dir
        return
      endif
    endfor
    let l:dir = fnamemodify(l:dir, ':h')
  endwhile
  echo "No project root marker found."
endfunction

command! Cdd call FindRootAndCd()
nnoremap cdb  :cd %:p:h<cr>
nnoremap cdd  :Cdd<cr>

" QUICKLY EDIT YOUR MACROS: https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
" "q<leader>m  edits macro in register q
nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" SMARTER CURSORLINE: https://github.com/mhinz/vim-galore?tab=readme-ov-file#smarter-cursorline
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" easily add empty lines
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" MATCHIT A BUILTIN PLUGIN: https://github.com/mhinz/vim-galore?tab=readme-ov-file#matchit
if exists("loaded_matchit") == 0
  packadd! matchit
endif
" Since the documentation of matchit is pretty extensive, I suggest also doing the following once:
" :!mkdir -p ~/.vim/doc
" :!cp $VIMRUNTIME/macros/matchit.txt ~/.vim/doc
" :helptags ~/.vim/doc
autocmd FileType python let b:match_words = '\<if\>:\<elif\>:\<else\>'

" QUICKLY JUMP TO HEADER OR SOURCE FILE: https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-jump-to-header-or-source-file
autocmd BufLeave *.{c,cpp} mark C
autocmd BufLeave *.h       mark H

" RELOAD FILE ON SAVING: https://github.com/mhinz/vim-galore?tab=readme-ov-file#reload-a-file-on-saving
" autocmd BufWritePost $MYVIMRC source $MYVIMRC

" QUICKLY CHANGE FONT SIZE:
command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

" CHANGE CURSOR STYLE DEPENDENT ON MODE: https://github.com/mhinz/vim-galore?tab=readme-ov-file#change-cursor-style-dependent-on-mode
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer

" AUTOCOMPLETE:

" The good stuff is documented in |ins-completion|

" HIGHLIGHTS:
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our path trick!)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option

" NOW WE CAN:
" - Use ^n and ^p to go back and forth in the suggestion list
"

" movement
set scrolloff=5

" show
set ruler                       " show the current row and column
set number                      " show line numbers
set relativenumber              " easier vertical jumps, 4j 5k...
set nowrap
set showcmd                     " display incomplete commands
set showmode                    " display current modes
set showmatch                   " jump to matches when entering parentheses
set matchtime=2                 " tenths of a second to show the matching parenthesis


"set history=2000 " how many lines of history VIM has to remember

"---------------------------------------------------------------------------

"
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#minimal-vimrc
"
" https://github.com/mhinz/vim-galore/blob/master/static/minimal-vimrc.vim
"
" A (not so) minimal vimrc.
"

" You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitely to make our position clear!
set nocompatible

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.
set ignorecase             " ignore case when searching
set smartcase              " no ignorecase if Uppercase char present

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
if &shell =~# 'nu$'
    " see https://github.com/nushell/integrations/blob/main/nvim/init.lua
    set shellcmdflag=--stdin\ --no-newline\ -c
    set shellpipe   =\|\ complete\ \|\ update\ stderr\ {\ ansi\ strip\ \}\ \|\ tee\ {\ get\ stderr\ \|\ save\ --force\ --raw\ %s\ }\ \|\ into\ record
    set shellredir  =out+err>\ %s
    set noshelltemp
    set shellquote  =
    set shellxescape=
    set shellxquote =
else
    set shell=/bin/bash
endif

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#temporary-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap//
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
if has('nvim')
    set viminfo     ='100,n$HOME/.local/state/nvim/viminfo
else
    set viminfo     ='100,n$HOME/.vim/files/info/viminfo
endif

