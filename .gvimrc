" the formatting for the guifont line varies by platform
" also relative font sizes are different
if has("gui_gtk2") || has("gui_gtk3")
  " Linux GUI
  set guifont=Source\ Code\ Pro\ Semi-Bold\ 12
elseif has("gui_win32")
  " Win32/64 GVim
elseif has("gui_macvim")
  " MacVim
  set guifont=Source\ Code\ Pro:h18 
else
  echo "Unknown GUI system!!!!"
endif
