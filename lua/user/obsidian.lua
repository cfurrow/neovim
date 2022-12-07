-- Config for https://github.com/epwalsh/obsidian.nvim
local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
	return
end

local util = require "obsidian.util"


obsidian.setup({
  dir = "~/Vaults/Personal",
  completion = {
    nvim_cmp = true
  },
  notes_subdir = "areas/inbox",
  daily_notes = {
    folder = "resources/logs",
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
})
