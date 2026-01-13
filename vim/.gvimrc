" the formatting for the guifont line varies by platform
" also relative font sizes are different
if has("gui_gtk2") || has("gui_gtk3")
  " Linux GUI - adjust font size based on machine
  if hostname() =~ 'baby-dell'
    set guifont=Source\ Code\ Pro\ Semi-Bold\ 11
  else
    set guifont=Source\ Code\ Pro\ Semi-Bold\ 14
  endif
elseif has("gui_win32")
  " Win32/64 GVim
  set guifont=Source_Code_Pro_Semibold:h12
  colorscheme ron
elseif has("gui_macvim")
  " MacVim
  set guifont=SourceCodePro-Regular:h16
else
  echo "Unknown GUI system!!!!"
endif
