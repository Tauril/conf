set nocompatible
filetype off                  " required

execute pathogen#infect()
syntax on " Enable syntax highlighting
filetype plugin indent on

set encoding=utf-8
set backspace=indent,eol,start " Sane backspace behaviour

" BASICS
set number
set colorcolumn=80

" MOUSE
set mouse=a

" TABULATIONS
set expandtab " Insert spaces instead of tabs
set softtabstop=2 " 2 spaces instead of 8
set shiftwidth=2
autocmd FileType make setlocal noexpandtab

" BACKSPACES
set backspace=eol,indent,start
set list
set listchars=tab:>─,trail:\ ,nbsp:¤

" SEARCH
set ignorecase
set smartcase
set hlsearch
set incsearch
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" SPLITSCREEN
map <C-H> <C-W>h<C-W>
map <C-Left> <C-W>h<C-W>
map <C-J> <C-W>j<C-W>
map <C-Down> <C-W>j<C-W>
map <C-K> <C-W>k<C-W>
map <C-Up> <C-W>k<C-W>
map <C-L> <C-W>l<C-W>
map <C-Right> <C-W>l<C-W>

" MOVING
nnoremap Y y$
nnoremap k gk
nnoremap j gj
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>

" TYPING
noremap <leader>ta :Tab / [^ ]*;<cr>
map <C-S> :wq

" FILES
cmap cwd lcd %:p:h
set autoread


" HIGHLIGHT
highlight link CodingStyle Error
match CodingStyle /\s\+$\|if(\|for(\|while(\|do{\|switch(/
" \|[^- ><*+=]=\|=[^ =]\|+[^] +=);]\|-[^] ->=);]\|[^ +]+[^]+);]\|[^ -]-[^->);]/ [^ ]\

" COLORSCHEME
set t_Co=256
syntax enable
set background=dark

let g:solarized_termcolors= 16
let g:solarized_termtrans = 0
let g:solarized_degrade = 0
let g:solarized_bold = 1
let g:solarized_underline = 1
let g:solarized_italic = 1
let g:solarized_contrast = "normal"
let g:solarized_visibility= "normal"

colorscheme solarized

" Transparency
" hi Normal guibg=NONE ctermbg=NONE
" hi ColorColumn guibg=NONE ctermbg=DarkCyan

map <c-y> 0df:dwi* <Esc>A: here.<Esc><CR>0

set cursorline

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_solarized_bg = 'dark'
let g:airline_theme = 'solarized'

" tagbar
nmap <F2> :TagbarToggle<CR>

" undo persistent
if version >= 703
  set undofile
  set undodir=~/.vimtmp/undo
  silent !mkdir -p ~/.vimtmp/undo
endif

" Search in Visual mode
vnoremap // y/<C-R>"<CR>

set exrc

" Increase vim buffer size
set viminfo='20,<100000,s100000

" Increase tab page limit
set tabpagemax=1000

highlight LineNr term=bold cterm=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
