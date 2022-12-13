local status_ok, persisted = pcall(require, "persisted")
if not status_ok then
  return
end

require("persisted").setup({
  use_git_branch = false, -- create session files based on the branch of the git enabled repository
  autosave = true, -- automatically save session files when exiting Neovim
})

require("telescope").load_extension("persisted") -- To load the telescope extension
