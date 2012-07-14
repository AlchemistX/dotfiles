" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" keep a backup file
set history=50		" keep 50 lines of command line history
set showcmd			" display incomplete commands
set incsearch		" do incremental searching

" KSI's Configure...
set tabstop=4
set nu
set shiftwidth=4
"set tenc=utf-8
"set enc=utf-8

" ============ Configure at Book ============= 
" ============ Default variables ============= 
set cindent
set smartindent
set autoindent
"set nowrap
set ff=unix
set bg=dark
set ruler
set path=./,/usr/include,/usr/local/include,/usr/src/include
:filetype on

" ============ key mapping ============
map <F1> v]}zf					" code folding
map <F2> zo						" code unfolding
map <F3> :Tlist<cr><C-W><C-W>	" taglist
map <F4> :BufExplorer<cr>		" BufExplorer
map <PageUp> <C-U><C-U>
map <PageDown> <C-D><C-D>
map <F4> :A<cr>

" ============ indent ============
map ,noi :set noai<CR>:set nocindent<CR>:set nosmartindent<CR>
map ,sei :set ai<CR>:set cindent<CR>:set smartindent<CR>

" ============ explore file buffers ============
map ,1 :b!1<CR>				" move to file buffer no. 1
map ,2 :b!2<CR>				" move to file buffer no. 2
map ,3 :b!3<CR>				" move to file buffer no. 3
map ,4 :b!4<CR>				" move to file buffer no. 4
map ,5 :b!5<CR>				" move to file buffer no. 5
map ,6 :b!6<CR>				" move to file buffer no. 6
map ,7 :b!7<CR>				" move to file buffer no. 7
map ,8 :b!8<CR>				" move to file buffer no. 8
map ,9 :b!9<CR>				" move to file buffer no. 9
map ,0 :b!10<CR>			" move to file buffer no. 10
map ,w :bw<CR>				" clos current file buffer

" ============ ctags ============
set tags+=./tags

if version >= 500
	func! Sts ()
    	let st = expand ("<cword>")
		exe "sts ".st
	endfunc
	nmap ,st :call Sts()<CR>

	func! Tj()
		let st = expand("<cword>")
		exe "tj ".st
	endfunc
	nmap ,tj :call Tj()<CR>
endif

" ============ cscope ============
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb

if filereadable("./cscope.out")
	cs add cscope.out
else
	cs add cscope.out
endif
set csverb

func! Css()
	let css = expand("<cword>")
	new
	exe "cs find s ".css
	if getline(1) == " "
		exe "q!"
	endif
endfunc
nmap ,css :call Css()<CR>

func Csc()
	let csc = expand("<cword>")
	new
	exe "cs find c ".csc
	if getline(1) == " "
		exe "q!"
	endif
endfunc
nmap ,csc :call Csc()<CR>

func Csd()
	let csd = expand("<cword>")
	new
	exe "cs find d ".csd
	if getline(1) == " "
		exe "q!"
	endif
endfunc
nmap ,csd :call Csd()<CR>

func Csg()
	let csg = expand("<cword>")
	new
	exe "cs find g ".csg
	if getline(1) == " "
		exe "q!"
	endif
endfunc
nmap ,csg :call Csg()<CR>

" ============ man page ============
func! Man()
	let sm = expand("<cword>")
	exe "!man -S 2:3:4:5:6:7:8:9:tcl:n:l:p:o ".sm
endfunc
nmap ,ma :call Man()<CR><CR>

" ============ internet english dictionary ============
"func! Engdic()
"	let ske = expand("<cword>")
"	new
"	exec "r !lynx -nolist -verbose -dump http://kr.engdic.yahoo.com/result.html?p=".ske " | sed 's/\\[INLINE\\]//g' | tail +23"
"	set nomod wrap
"	noremap <buffer> q :bd<CR>:echo ' '<CR>
"endfunc
"nmap ,ed :call Engdic()<CR>gg


" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif
endif " has("autocmd")

let g:molokai_original=1
