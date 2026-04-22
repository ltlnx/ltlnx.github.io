" ltlnx vimrc

" visuals
" colorscheme fallbacks
try 
    colorscheme slate
    catch
    try 
        colorscheme industry
        catch
    endtry
endtry
set number
set cursorline
" set cursorline color only when changing colorscheme
augroup cursorline
  au!
  au ColorScheme * hi CursorColumn term=reverse ctermbg=236
               \ | hi clear CursorLine
               \ | hi link CursorLine CursorColumn
               \ | hi clear CursorLineNr
               \ | hi link CursorLineNr CursorColumn
augroup END
" amend slate theme bracket highlight colors
let current_scheme = get(g:, 'colors_name', 'default')
if current_scheme ==? "slate"
    au ColorScheme * hi MatchParen ctermfg=220 ctermbg=16 cterm=NONE
endif

" mappings
" basic settings for comfort
noremap j gj
noremap k gk
inoremap <C-l> <Right>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
" map two escs to nohl 
" (since one esc won't work on some terminals)
nnoremap <Esc><Esc> :nohl<CR>
" map c-u to undo
inoremap <C-U> <C-O>u
" map enter
inoremap <S-CR> <C-O>o

" disable arrow keys in normal, insert and visual mode
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
vnoremap <Up> <nop>
vnoremap <Down> <nop>
vnoremap <Left> <nop>
vnoremap <Right> <nop>

" quit regardless of capitalization
command! W w
command! WQ wq
command! Wq wq
command! Q q

" tab behavior
set tabstop=4	    " set width of tabs
set softtabstop=4   " set percieved width of tabs
set expandtab	    " turns tabs into spaces

" buffer behavior
" best combined with ap/vim-buftabline
set hidden
nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>

" set vim file storage to .vim
" and create .vim if necessary
" credit https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif

" set undo options
" credit https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif
set undodir=~/.vim/undo
set undofile

" set backup options
" credit https://stackoverflow.com/questions/607435/why-does-vim-save-files-with-a-extension
if !isdirectory($HOME."/.vim/tmp")
    call mkdir($HOME."/.vim/tmp", "", 0700)
endif
set backupdir=~/.vim/tmp//,.
set directory=~/.vim/tmp//,.

" restore functionality on systems with worse defaults
syntax enable
filetype plugin indent on
set hlsearch
set incsearch

" install plugin manager if it doesn't exist
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugins
call plug#begin()
Plug 'tpope/vim-sleuth'	    " accommodate to tabs in file
Plug 'ap/vim-buftabline'    " make buffers show on the top like tabs
call plug#end()
