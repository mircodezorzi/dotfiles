colorscheme base16-default-dark       " set default colorscheme

set autoindent                        " maintain indent of current line
set backspace=indent,start,eol        " allow unrestricted backspacing in insert mode

"if exists('+colorcolumn')
"	let &l:colorcolumn='+' . join(range(80, 254), ',+')
"endif

if has('folding')
	set foldenable                      " enable folding
endif

set cursorline                        " highlight current line

if has('termguicolors')
	set termguicolors                   " use guifg/guibg instead of ctermfg/ctermbg in terminal
endif

if has('syntax')
	set synmaxcol=200                   " don't bother syntax highlighting long lines
endif

set splitright splitbelow             " more intuitive splits

let &showbreak='↳ '
set listchars=tab:\┊\ ,trail:·,nbsp:~
set list

set foldtext=mirco#fold#text()

if !isdirectory($HOME."/.undo")
	call mkdir($HOME."/.undo", "", 0700)
endif
set undodir=$HOME/.undo
set undofile
set swapfile

set number
if exists('+relativenumber')
	set relativenumber                  " show relative numbers in gutter
endif

set tabstop=2
set softtabstop=0
set noexpandtab
set shiftwidth=2
set smarttab

set foldenable
set foldmethod=manual
set foldlevel=999

" these options still have to be sorted
autocmd Filetype c,cpp set comments^=:///
filetype indent plugin on
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
set hidden
set ignorecase incsearch
set mouse=a
set noautochdir
set nowrap
set ruler
set shortmess+=A
set shortmess+=I
set shortmess+=W
set signcolumn=yes
set wildmode=longest,full
syntax on

" live preview in substitution comands
set inccommand=nosplit
