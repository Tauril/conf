set nocompatible
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'scrooloose/nerdcommenter'
Plugin 'airblade/vim-gitgutter'
Plugin 'rust-lang/rust.vim'
call vundle#end()
filetype plugin indent on

set encoding=utf-8
set backspace=indent,eol,start " Sane backspace behaviour

" BASICS
syntax on " Enable syntax highlighting
set number
set colorcolumn=80

" MOUSE
set mouse=a

" TABULATIONS
set expandtab " Insert spaces instead of tabs
set softtabstop=2 " 2 spaces instead of 8
set shiftwidth=2
filetype plugin indent on
autocmd FileType make setlocal noexpandtab

" BACKSPACES
set backspace=eol,indent,start
set list
set listchars=tab:>─,trail:\ ,nbsp:¤

" SEARCH
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
set background=dark
colorscheme hybrid
" colorscheme jellybeans
" let g:solarized_termcolors=256

" Transparency
hi Normal guibg=NONE ctermbg=NONE
hi ColorColumn guibg=NONE ctermbg=DarkYellow

" Main
command Main call Main()
function Main()
  if &filetype == 'cpp'
    exe "normal iint main()\n{\n\t\n}"
  else
    exe "normal iint main(void)\n{\n\t\n}"

  endif
  exe "normal 3G"
  exe "a"
endfunction

" HEADERS
command Header call Headers()
function Headers()
  let basename=substitute(@%, "[^/]*/", "", "g")
  let underscored=tr(basename, ".", "_")
  let const=substitute(underscored,".*", "\\U\\0", "")."_"
  exe "normal i#ifndef ".const."\n\e"
  exe "normal i# define ".const."\n\n\n\n\e"
  exe "normal i#endif /"."* !".const." */\e"
  exe "normal 4G"
endfunction

" VCSN
command GnuIndent call GnuIndent()
function! GnuIndent()
  setlocal cinoptions=>4,f0,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+0,(0,u0,w1,m1
  setlocal shiftwidth=2
endfunction

map <c-y> 0df:dwi* <Esc>A: here.<Esc><CR>0

set cursorline

" airline
set laststatus=2
set encoding=utf-8
set statusline=%{fugitive#statusline()}%f\ %l\|%c\ %m%=%p%%\ (%Y%R)
let g:airline_powerline_fonts = 1
let g:airline_theme='murmur'

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

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

" m4
:let g:m4_default_quote="[,]"


set exrc

" Increase vim buffer size
set viminfo='20,<1000,s1000

highlight LineNr term=bold cterm=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
