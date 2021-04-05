" gloal settings
" use modern vim features
set nocompatible
" block modeline exploits
set modelines=0
" text wrapping
set wrap
set linebreak

set number
set relativenumber
syntax on

" break the arrow key habit
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" visuals
set cursorline
set ruler
set visualbell
colorscheme slate
" set the prefered colours, pick one line here only.
" dark grey, better you can get if you don't support 256 colours
"hi CursorLine   cterm=NONE ctermbg=8 ctermfg=NONE
" light grey, no 256 colors
"hi CursorLine   cterm=NONE ctermbg=7 ctermfg=NONE
" dark redish
hi CursorLine   cterm=NONE ctermbg=52 ctermfg=NONE
" dark bluish
"hi CursorLine   cterm=NONE ctermbg=17 ctermfg=NONE
" very light grey
"hi CursorLine   cterm=NONE ctermbg=254 ctermfg=NONE
" yelowish
"hi CursorLine   cterm=NONE ctermbg=229 ctermfg=NONE
" almost black
"hi CursorLine   cterm=NONE ctermbg=234 ctermfg=NONE
hi CursorLine term=bold cterm=bold

" leader key
let mapleader = ","
" edit the .vimrc file in a new vertical split
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<CR>
" save with a wordcount, scroll current line to top
nnoremap <leader>c :w<CR>ztg<C-g>
" insert a Markdown header timestamp, save with wordcount
nnoremap <leader>t GA<CR><Esc>:put =strftime('%H:%M')<CR>i## <Esc>:w<CR>o<Esc>g<C-g>

" quicksave, append at end of line
map! <F5> <Esc>:w<CR>A
" quick save with word count
map! <F6> <Esc>:w<CR>ztg<C-g>
" add timestamp as Markdown H2 at end of file, call quicksave with word count
map! <F7> <Esc>GA<CR><Esc>:put =strftime('%H:%M')<CR>i## <F6>
