-- Config for https://github.com/epwalsh/obsidian.nvim
local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
	return
end

local util = require "obsidian.util"
local work = {
  dir = "/usr/local/Obsidian/BetterUp/",
  notes_subdir = "areas/inbox",
  daily_notes = {
    folder = "resources/logs",
  },
}
local personal = {
  dir = "~/Vaults/Personal",
  notes_subdir = "areas/inbox",
  daily_notes = {
    folder = "resources/logs",
  },
}

local setup_obsidian = function(opts)
  local options = {
    completion = {
      nvim_cmp = true
    },
    -- This mimics the default function used by the plugin
    note_frontmatter_func = function(note)
      local out = {
        id = note.id,
        aliases = note.aliases,
        tags = note.tags
      }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and util.table_length(note.metadata) > 0 then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
  }

  -- print(vim.inspect(opts))
  local mode = opts.args
  if mode == "work" then
    options = vim.tbl_deep_extend("force", work, options)
  else
    options = vim.tbl_deep_extend("force", personal, options)
  end
  --print(vim.inspect(options))

  obsidian.setup(options)
end

vim.api.nvim_create_user_command("ObsidianSetup", setup_obsidian, {nargs = 1})

setup_obsidian("personal")
