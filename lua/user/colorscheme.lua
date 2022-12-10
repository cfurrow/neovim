vim.cmd [[
try
  "colorscheme tokyonight
  colorscheme oxocarbon
  set background=dark
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
