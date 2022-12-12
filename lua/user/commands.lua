
-- TODO: create a command that will yank the visual selection and the relative file name to a named buffer

--   let @P = expand("%")
--   "Py

local yank_code = function()
  local buf = vim.api.nvim_buf_get_name(0)
  vim.cmd("let @P = '# " .. buf .. "'\n\nj")
end

vim.api.nvim_create_user_command("YankCode", yank_code, {nargs = 0})
