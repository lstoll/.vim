" Pathogen (autoload bundles)
call pathogen#runtime_append_all_bundles()


"" DEFAULT .vim contents:	

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

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

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

""""""""""""""""""""""
" End default contents
""""""""""""""""""""""

" Line Numbers
set number

" Try the vividchalk colorscheme
colorscheme vividchalk

" Tab Stuff
set shiftwidth=2
set expandtab
set smarttab
set tabstop=2

" Autotag
source ~/.vim/bundle/autotag/autotag.vim

" Copy rather than rename for backups. This means stuff like transmit upload
" triggers will work.
set backupcopy=yes

" Rspec Integration

" From https://wincent.com/blog/running-rspec-specs-from-inside-vim
function! RunSpec(command)
  if a:command == ''
    let dir = 'spec'
  else
    let dir = a:command
  endif
  cexpr system("spec -r ~/.vim/rspec_vim_formatter.rb -f Spec::Runner::Formatter::VimFormatter " . dir)"a:command)
  cw
endfunction

command! -nargs=? -complete=file Spec call RunSpec(<q-args>)

" From http://cassiomarques.wordpress.com/2009/01/09/running-rspec-files-from-vim-showing-the-results-in-firefox/

function! RunSpecHTML()
ruby << EOF
  buffer = VIM::Buffer.current
  spec_file = VIM::Buffer.current.name
  command = "ruby ~/.vim/bin/run_rspec.rb #{spec_file}"
  print "Running Rspec for #{spec_file}. Results will be displayed in Firefox."
  system(command)
EOF
endfunction

" Disable SVK - we won't use it, and it has bugs.
" see http://code.google.com/p/vcscommand/issues/detail?id=41
let VCSCommandSVKExec='disabled no such executable'

" Backup and swap files to ~/.vim_backup
set backupdir=~/.vim_backups//,.,/tmp//
set directory=~/.vim_backups//,.,/tmp//

" Always show status bar
:set laststatus=2 
:set cursorline

" Auto syntax checking
let g:syntastic_enable_signs=1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" For the MakeGreen plugin and Ruby RSpec. Uncomment to use.
autocmd BufNewFile,BufRead *_spec.rb compiler rspec

