" gloal settings
" use modern vim features
set nocompatible
" block modeline exploits
set modelines=0

" text wrapping
set wrap
set linebreak
" set conventional backspace
set backspace=2

" turn on hybrid line numbers
set number relativenumber
syntax on

" use more conventional splits
set splitbelow
set splitright

" search down into subfolders
" Provide tab completion for all file-related tasks
set path+=**
" display all matching files when we hit tab
set wildmenu

""" visual appearance
set nocursorline
set ruler
set visualbell
colorscheme slate

" set the prefered colours, pick one line here only.
" dark grey, better you can get if you don't support 256 colours
" hi CursorLine   cterm=NONE ctermbg=8 ctermfg=NONE
" light grey, no 256 colors
" hi CursorLine   cterm=NONE ctermbg=7 ctermfg=NONE
" dark redish
" hi CursorLine   cterm=NONE ctermbg=52 ctermfg=NONE
" dark bluish
"hi CursorLine   cterm=NONE ctermbg=17 ctermfg=NONE
" very light grey
"hi CursorLine   cterm=NONE ctermbg=254 ctermfg=NONE
" yelowish
hi CursorLine   cterm=NONE ctermbg=229 ctermfg=NONE
" almost black
" hi CursorLine   cterm=NONE ctermbg=234 ctermfg=NONE
" bold text on cursoline
" hi CursorLine term=bold cterm=bold

""" Keyboard
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

" Alt key equivalents

" cut with x
map <A-x> "+x
map! <A-x> <Esc>"+xA

" copy with c
map <A-c> "+y
map! <A-v> <Esc>"+yA

" Paste with v
map <A-v> "+gp
map! <A-v> <Esc>"+gpA

" select all with a
map <A-a> ggVG
map!<A-a> <Esc>ggVG

" save with s
map <A-s> :w
map!<A-s> <Esc>:w

" leader key default is \
" let mapleader = "\"
" edit the .vimrc file in a new vertical split
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<CR>
" save with a wordcount, scroll current line to top
nnoremap <leader>wc :w<CR>ztg<C-g>
" insert a Markdown header timestamp, save with wordcount
nnoremap <leader>t GA<CR><Esc>:put =strftime('%H:%M')<CR>i## <Esc>:w<CR>o<Esc>zzg<C-g>
" delete trailing spaces in the current file
nnoremap <leader>dt :%s/\s\+$//e<CR>
" replace double spaces with single spaces 
nnoremap <leader>2s :%s/\ \ /\ /g<CR>`` 

" use standard Win/ Mac Linux keyboard equivalents
" cut with x
nnoremap <leader>x "+x
" copy with c
nnoremap <leader>c "+y
" Paste with v and resume insert
nnoremap <leader>v "+gPA
" select all with a
nnoremap <leader>a ggVG
" save with s
nnoremap <leader>s :w<CR>
"quit with q
nnoremap <leader>q :x<CR>

" quicksave, append at end of line
map! <F5> <Esc>:w<CR>A
" quick save with word count
map! <F6> <Esc>:w<CR>ztg<C-g>
" add timestamp as Markdown H2 at end of file, call quicksave with word count
map! <F7> <Esc>GA<CR><Esc>:put =strftime('%H:%M')<CR>i## <F6>

" change case of selected text (visual mode)
" UPPER, lower, Title Case, repeat
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" configure netrw file browser
let g:netrw_preview = 1
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END

" Show syntax highlights in fenced code blocks
let g:markdown_fenced_languages = ['bash', 'css', 'html', 'javascript', 'js=javascript', 'json=javascript', 'python', 'ruby', 'sass', 'xml', 'vim']
