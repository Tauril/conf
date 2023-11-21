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
set cursorline
set mouse=a

" TABULATIONS
set expandtab " Insert spaces instead of tabs
set softtabstop=4 " 2 spaces instead of 8
set shiftwidth=4
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

" COLORSCHEME
syntax enable
set background=dark

let g:solarized_termcolors = 256
let g:solarized_termtrans = 0
let g:solarized_degrade = 0
let g:solarized_bold = 1
let g:solarized_underline = 1
let g:solarized_italic = 1
let g:solarized_contrast = "normal"
let g:solarized_visibility= "normal"
let g:solarized_hitrail = 1

colorscheme solarized

" Transparency
" hi Normal guibg=NONE ctermbg=NONE
" hi ColorColumn guibg=NONE ctermbg=DarkCyan

map <c-y> 0df:dwi* <Esc>A: here.<Esc><CR>0

" airline
set laststatus=2
let g:airline_solarized_bg = 'dark'
let g:airline_theme = 'solarized'
let g:airline_section_z = "%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v/%{strwidth(getline('.'))}"

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

au BufRead,BufNewFile *.metal setfiletype metal
