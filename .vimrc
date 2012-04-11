" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"set tabstop=4          " <Tab> == <Space> x 4 (display of ^I)
set softtabstop=4      " <Tab> == <Space> x 4 (indent via <Tab>)
set shiftwidth=4       " <Tab> == <Space> x 4 (indent via shift)
set expandtab
set foldmethod=marker foldlevel=32 " foldmarker={,}
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set smartcase           " search in case-insensetive manner unless it matters
set ignorecase          " required for `smartcase` to work
set wildmode=list:longest
set noequalalways
set mouse=n             " Normal mode

" showing special chars
set listchars=tab:»\ ,trail:·
set list

set exrc " Read local .vimrc

" toggle with :set spell / :set nospell
set spelllang=en,ru

function! s:diff(...)
	let opts = ""
	if isdirectory("CVS")
		let cmd = "cvs"
	elseif isdirectory(".svn")
		let cmd = "svn"
	elseif isdirectory(".bzr")
		let cmd = "bzr"
	elseif isdirectory(".git")
		let cmd = "git"
		let opts = "--no-prefix HEAD"
	else
		throw "Unable to find suitable VCS"
	endif

	new
	if a:0 == 0
		exec "0r !" . cmd . " diff " . opts
	else
		exec "0r !" . cmd . " diff " . opts . " " .  a:1
	endif
	set buftype=nofile
	set noswapfile
	set syntax=diff
	goto
endfunction

if isdirectory("kernel") && filereadable("Kbuild") && filereadable("MAINTAINERS")
	set makeprg=xkmake
elseif filereadable("waf")
	set makeprg=./waf
endif

if isdirectory(".git")
	set grepprg=git\ grep\ -n\ $*
elseif isdirectory(".svn")
	" A new option has been introduced in grep-2.5.3, --exclude-dir that applies a pattern only to directory names.
	set grepprg=find\ .\ -name\ .svn\ -prune\ -o\ -type\ f\ -exec\ grep\ -n\ $*\ \\{\\}\ +
endif

if isdirectory("include")
	set path+=include
endif

if isdirectory("src/include")
	set path+=src/include
endif

" TODO: add better path detection
set path+=/usr/include/c++/4.5

command Diff call s:diff()
command FileDiff call s:diff(bufname("%"))
command Save !wigit save %
command Rm call delete(expand("%"))

" TODO: get better templates
" autocmd BufNewFile  *  0r !generate <afile>

function! s:generate_c_head()
    let uuid=matchstr(system("uuidgen | tr -- -a-z _A-Z"), "[^\n\r]*")
    exec "0s!.*!#ifndef UUID_" . uuid . "#define UUID_" . uuid . "#endif // " . uuid
endfunction

autocmd BufNewFile *.h,*.hpp,*.hh call s:generate_c_head()

autocmd BufRead,BufNewFile  *.py,*.puw  let python_highlight_all = 1
autocmd BufRead,BufNewFile  *.py,*.puw  set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd BufRead,BufNewFile  *.php       set path+=/usr/lib/php
autocmd BufRead,BufNewFile  *.c,*.cc,*.cpp,*.h,*.hpp,*.hh set foldmarker={,}
" autocmd BufRead,BufNewFile  *.py,*.puw  set fileencoding=utf-8


" Try to guess...
set fileencodings=utf-8,koi8-r,cp1251,cp866

" map F7 in all modes to make, "!" disables jumping to first error
map <F7>  :wall<CR>:make!<CR>
vmap <F7> <C-C><F7>
imap <F7> <C-O><F7>

map <F3> :cp<CR>
map <F4> :cn<CR>
map <F11> :wincmd _<CR>

" <F8> File encoding for open
" <Shift+F8> Force file encoding for open (encoding = fileencoding)
" <Ctrl+F8> File encoding for save (convert)
source ~/.vim/checn.vim

" That's patched order from /usr/lig/man.conf
let $MANSECT = "2:3:3p:1:1p:8:4:5:6:7:9:0p:tcl:n:l:p:o"
runtime ftplugin/man.vim

set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ 0x%B\ %l,%c%V\ %P
if &term == "screen"
  set laststatus=1
else
  set laststatus=2
endif


" Don't use Ex mode, use Q for for:ting
map Q gq
map  <BS>
map!  <BS>

map  <F2>  :w<CR>
vmap <F2> <C-C><F2>
imap <F2> <C-O><F2>

ab vimset vim:set tabstop=4 softtabstop=4 shiftwidth=4 foldmethod=marker foldlevel=32 foldmarker={,}:
ab tab8 set tabstop=8 softtabstop=8 shiftwidth=8
ab tab4 set tabstop=4 softtabstop=4 shiftwidth=4
ab tab2 set tabstop=2 softtabstop=2 shiftwidth=2
ab #i #include
ab #d #define
ab &at; &#64;
ab sign- Signed-off-by: Leonid Evdokimov <leon@darkk.net.ru>

ab cgit    ((https://git.yandex.ru/csadmins/juggler-client.git/?a=commit;h=... FIXED))
ab cligit  ((https://git.yandex.ru/csadmins/juggler-client.git/?a=commit;h=... FIXED))
ab jcligit ((https://git.yandex.ru/csadmins/juggler-client.git/?a=commit;h=... FIXED))

ab jgit    ((https://git.yandex.ru/csadmins/juggler.git/?a=commit;h=... FIXED))
ab jugit   ((https://git.yandex.ru/csadmins/juggler.git/?a=commit;h=... FIXED))
ab juggit  ((https://git.yandex.ru/csadmins/juggler.git/?a=commit;h=... FIXED))


" Window Title
source ~/.vim/termtitle.vim

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp
"
"
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 16
  set t_Co=16
endif

if &t_Co > 2 || has("gui_running")
  syntax on
  set guifont=Terminus\ 12
  set hlsearch
  if has("gui_running")
    colorscheme my-pablo
  else
    colorscheme desert
  endif

  " Show trailing whitepace, spaces before a tab, tabs that are not at the
  " start of a line
  autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/
  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  autocmd Syntax * syn match ErrorMsg '\%>100v.\+'
endif


" set foldmethod=marker
" set foldlevel=32
set foldmarker={,}

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

if v:progname =~? "view"
  set linebreak
endif


