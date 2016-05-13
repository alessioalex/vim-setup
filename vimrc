" Basics
  set nocompatible

" Setup bundle support
  execute pathogen#infect()

" General
  " utf-8 for the win
  set encoding=utf-8
  " Automatically detect file types
  filetype plugin indent on
  " Turn on syntax highlighting
  syntax on
  " Splits window below current window
  set splitbelow
  " Open new split on the right
  set splitright
  " Automatically use the current file's directory as the working directory
  set autochdir
  " Allow for cursor beyond last character
  set virtualedit=onemore
  " Store last 50 commands in history (defaults to 20)
  set history=50
  " Lower the timeout after typing the leader key
  set timeoutlen=500
  " Switch between buffers without saving
  set hidden
  " No beeping
  set visualbell
  " Source the vimrc file after saving it (slow?)
  " autocmd bufwritepost .vimrc source $MYVIMRC

" Directory setup
  " No backups, swap is enough in case of a crash
  set nobackup
  " and again
  set nowritebackup
  " Disable netrw history/bookmarks generation
  let g:netrw_dirhistmax=0
  " Swap files location
  set directory=$HOME/.vim/tmp//,.
  " View files location
  set viewdir=$HOME/.vim/sessions

" Vim UI
  " theme
  colorscheme mustang
  " Only show 15 tabs
  set tabpagemax=15
  " Display the current mode
  set showmode
  " CursorLine color group for the current line
  set cursorline
  " 80 column lines concern
  set textwidth=80
  set colorcolumn=+1
  " Intuitive backspace
  " (allow bs over autoindent, line breaks, start of insert)
  set backspace=indent,eol,start
  " Show line numbers
  set number
  " Show matching brackets/parenthesis
  set showmatch
  " Find as you type search
  set incsearch
  " Highlight search terms
  set hlsearch
  " Case-insensitive searching
  set ignorecase
  " But case-sensitive if expression contains a capital letter
  set smartcase
  " Show list instead of just completing (command line completion)
  set wildmenu
  " Command line <Tab> completion, list matches,
  " then longest common part then all
  set wildmode=list:longest,full
  " Make Vim move to previous/next line after
  " reaching first/last char in the line
  set whichwrap=b,s,h,l,<,>,[,]
  " Minimum 5 lines of text above and below the cursor
  set scrolloff=5
  " The /g (global) flag on :s substitutions by default
  set gdefault
  " Disable folding
  set nofoldenable
  " View tabs, where line ends etc
  set list
  " Highlight problematic white space, tab displays as >.. & space as . etc
  set listchars=tab:>.,trail:.,extends:#,nbsp:.
  " Use the same symbols as TextMate for tabstops and EOLs
  " set listchars=tab:▸\ ,eol:¬,trail:˺,nbsp:█

if has('cmdline_info')
  " Show the ruler
  set ruler
  " A ruler on steroids
  set rulerformat=%30(%=%y%m%r%w\ %l,%c%V\ %P%)
  " Show partial commands in status line and selected chars/lines is visual mode
  set showcmd
endif

if has('statusline')
  " Always show the status line
  set laststatus=2
  " Broken down into easily includeable segments
  set statusline=%<%f\  " Filename
  set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}/%{&ff}/%Y] " File encoding/format/type
  set statusline+=%=%-14.(line:%l,col:%c%V%)\ %p%% " Right aligned file nav info
endif

" Formatting
  " Don't wrap long lines
  set nowrap
  " Do smart autoindenting when starting a new line (works for C-like programs)
  set smartindent
  " Indent at the same level of the previous line
  set autoindent
  " Use indents of 2 spaces
  set shiftwidth=2
  " Tabs are spaces, not tabs
  set expandtab
  " A <Tab> has 2 spaces
  set tabstop=2
  " Let backspace delete indent
  set softtabstop=2
  " Sane indentation on pastes
  set pastetoggle=<F12>
  " Remove whitespace on file save - via https://github.com/spf13/spf13-vim
  autocmd FileType c,cpp,java,php,javascript,css,html,python,twig,xml,yml,typescript autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

" Key remappings
  " Make sure default leader is '\'
  let mapleader="\\"
  " Yank from the cursor to the end of the line, to be consistent with C and D
  nnoremap Y y$
  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv
  " Map escape to ',e' (insert mode)
  imap ,e <esc>
  " Shortcut ',ev' for editing .vimrc (normal mode)
  nmap ,ev :tabedit $MYVIMRC<cr>
  " Clear highlighting with ./
  nmap <silent>./ :let@/=""<CR>

  " http://stackoverflow.com/questions/3878692/aliasing-a-command-in-vim
  fun! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
          \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
          \ .'? ("'.a:to.'") : ("'.a:from.'"))'
  endfun

  " Fix common typos (when saving file and quitting)
  call SetupCommandAlias("W","w")
  call SetupCommandAlias("Q","q")
  call SetupCommandAlias("Qa","qa")
  call SetupCommandAlias("WQ","wq")
  call SetupCommandAlias("WQA","wqa")


" Plugins
  " NERDTree
    " Make sure the working directory is set correctly
    let NERDTreeChDirMode=2
    " Toggle NERDTree with ',nt'
    nnoremap ,nt :call NERDTreeToggleInCurDir()<cr>
    " Show hidden files
    let NERDTreeShowHidden=1
    " Open a NERDTree automatically when vim starts up
    " autocmd VimEnter * NERDTreeFind
    " autocmd VimEnter * if !argc() | NERDTree | endif

    " http://vi.stackexchange.com/questions/2969/how-to-set-up-nerdtree-to-cd-to-current-folder-when-opening-it-for-the-first-tim
    function! NERDTreeToggleInCurDir()
      " If NERDTree is open in the current buffer
      if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exe ":NERDTreeClose"
      else
        if (expand("%:t") != '')
          exe ":NERDTreeFind"
        else
          exe ":NERDTreeToggle"
        endif
      endif
    endfunction

    " enable proper NT toggling
    command! -nargs=0 NERDTreeToggleInCurDir call NERDTreeToggleInCurDir()

  " NERDTree + sessions
    " on saving session, for each tab: close NT
    command! CommitSession :execute "tabdo NERDTreeClose" <bar> :execute "set sessionoptions-=options" <bar> :execute "mksession! $HOME/.vim/sessions/session.vim" <bar> :execute "qa!"
    " on loading session, for each tab: open NT with the file's current folder
    command! CheckoutSession :execute "source $HOME/.vim/sessions/session.vim" <bar> :execute "tabdo NERDTreeToggleInCurDir" <bar> :execute "tabdo wincmd p" <bar> :execute "tabn 1"

  " BufOnly
    nnoremap ,da :execute "BufOnly" <bar> :execute "tabdo NERDTreeClose" <cr>

  " TComment
    map <leader>c <c-_><c-_>

  " emmet (former zencoding)
    " Tutorial -> https://github.com/mattn/emmet-vim/blob/master/TUTORIAL
    let g:user_emmet_leader_key='<C-E>'

  " vim-js-pretty-template
    " Apply pretty HTML code inside typescript (Angular2 usage)
    autocmd FileType typescript JsPreTmpl html
    " For leafgarland/typescript-vim users only
    autocmd FileType typescript syn clear foldBraces

" GUI Settings
  if has('gui_running')
    set guioptions-=m " Remove the menu
    set guioptions-=T " Remove the toolbar
    " Prefer a slightly higher line height
    set linespace=3
  endif
