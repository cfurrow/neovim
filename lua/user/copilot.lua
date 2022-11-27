-- For copilot.vim

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

vim.api.nvim_set_keymap("i", "<C-/>", 'copilot#Suggest()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.g.copilot_filetypes = {
  ["*"] = false,
  ["css"] = true,
  ["sass"] = true,
  ["html"] = true,
  ["javascript"] = true,
  ["typescript"] = true,
  ["lua"] = true,
  ["ruby"] = true,
  ["rust"] = true,
  ["c"] = true,
  ["c#"] = true,
  ["c++"] = true,
  ["go"] = true,
  ["python"] = true,
}



-- vim.cmd [[
--   imap <silent><script><expr> <C-A> copilot#Accept("\<CR>")
--   let g:copilot_no_tab_map = v:true
-- ]]

-- local status_ok, copilot = pcall(require, "copilot")
-- if not status_ok then
--   return
-- end
--
-- copilot.setup {
--   cmp = {
--     enabled = true,
--     method = "getPanelCompletions",
--   },
--   panel = { -- no config options yet
--     enabled = true,
--   },
--   ft_disable = { "markdown" },
--   -- plugin_manager_path = vim.fn.stdpath "data" .. "/site/pack/packer",
--   -- server_opts_overrides = {},
-- }
