" ltlnx vimrc
" Copyright 2022-2025  Wen-Wei Kao (ltlnx), Taichung, Taiwan
" All rights reserved.
"
" Redistribution and use of this config file, with or without modification, is
" permitted provided that the following conditions are met:
"
" 1. Redistributions of this config file must retain the above copyright
"    notice, this list of conditions and the following disclaimer.
"
" THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY EXPRESS OR IMPLIED
" WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
" MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
" EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
" SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
" PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
" OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
" WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
" OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
" ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
  au ColorScheme * hi CursorColumn term=reverse ctermbg=237
               \ | hi clear CursorLine
               \ | hi link CursorLine CursorColumn
               \ | hi clear CursorLineNr
               \ | hi link CursorLineNr CursorColumn
augroup END
" fix slate theme bracket highlight colors
let current_scheme = get(g:, 'colors_name', 'default')
if current_scheme ==? "slate"
    au ColorScheme * hi MatchParen ctermfg=220 ctermbg=16 cterm=NONE
endif

" enable mouse
set mouse=a

" open file at last edited line
autocmd BufReadPost *
     \ if line("'\"") > 1 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" mappings
" basic settings for comfort
noremap j gj
noremap k gk
inoremap <C-l> <Right>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
" map esc in normal mode to nohl 
nnoremap <Esc> :nohl<CR>
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

" Netrw behavior
" credit https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
let g:netrw_keepdir = 0
let g:netrw_winsize = 30
let g:netrw_localcopydircmd = 'cp -r'
nnoremap <F5> :Lexplore<CR>
function! NetrwMapping()
  nmap <buffer> u -^
  nmap <buffer> <Space> <CR>
  nmap <buffer> . gh
  nmap <buffer> P <C-w>z
  nmap <buffer> L <CR>:Lexplore<CR>
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

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
Plug 'tpope/vim-sleuth'	        " accommodate to tabs in file
Plug 'tpope/vim-vinegar'        " enhance netrw, the built-in file manager
Plug 'ap/vim-buftabline'        " make buffers show on the top like tabs
Plug 'preservim/vim-markdown'   " vim markdown goodies
Plug 'yegappan/lsp'             " Language server protocol
call plug#end()

" plugin specific settings
let g:vim_markdown_folding_disabled = 1

" LSP settings
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspCServer = [#{
	\    name: 'clang',
	\    filetype: ['c', 'cpp'],
	\    path: '/usr/bin/clangd',
	\    args: ['--background-index']
	\ }]
let lspRustServer = [#{
	\    name: 'rustlang',
	\    filetype: ['rust'],
	\    path: '/usr/bin/rust-analyzer',
	\    args: [],
	\    syncInit: v:true
	\  }]
autocmd User LspSetup call LspAddServer(lspCServer)
autocmd User LspSetup call LspAddServer(lspRustServer)
