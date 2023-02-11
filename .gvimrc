" the formatting for the guifont line varies by platform
" also relative font sizes are different
if has("gui_gtk2") || has("gui_gtk3")
  " Linux GUI
  set guifont=Source\ Code\ Pro\ Semi-Bold\ 12
elseif has("gui_win32")
  " Win32/64 GVim
  set guifont=Source_Code_Pro_Semibold:h12
  colorscheme ron
elseif has("gui_macvim")
  " MacVim
  set guifont=SourceCodeProRoman-Regular:h18 
else
  echo "Unknown GUI system!!!!"
endif
