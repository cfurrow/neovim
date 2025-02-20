local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local icons = require "user.icons"

local kind_icons = icons.kind

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})
-- vim.api.nvim_set_hl(0, "CmpItemKindTabnine", {fg ="#CA42F0"})
vim.api.nvim_set_hl(0, "CmpItemKindEmoji", {fg ="#FDE030"})

-- TODO: make this a function in neovim that I can call to disable cmp in current buffer
-- :lua require('cmp').setup.buffer { enabled = false }
--vim.fn["DisableCmp"] = function()
--  require("cmp").setup.buffer {enabled = false}
--end
local function setAutoCmp(mode)
  if mode then
    cmp.setup({
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
      }
    })
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
  end
end
setAutoCmp(false)

-- enable automatic completion popup on typing
vim.cmd('command AutoCmpOn lua setAutoCmp(true)')

-- disable automatic competion popup on typing
vim.cmd('command AutoCmpOff lua setAutoCmp(false)')



cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  mapping = cmp.mapping.preset.insert {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    -- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      --[[ local copilot_keys = vim.fn['copilot#Accept']() ]]
      --[[ print("copilot keys: " .. copilot_keys) ]]

      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      --[[ elseif copilot_keys ~= '' and type(copilot_keys) == 'string' then ]]
      --[[   -- https://www.reddit.com/r/neovim/comments/sk70rk/comment/hxephoi/?utm_source=reddit&utm_medium=web2x&context=3 ]]
      --[[   vim.api.nvim_feedkeys(copilot_keys, 'i', true) ]]
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = kind_icons[vim_item.kind]

      --[[ if entry.source.name == "cmp_tabnine" then ]]
      --[[   vim_item.kind = icons.misc.Robot ]]
      --[[   vim_item.kind_hl_group = "CmpItemKindTabnine" ]]
      --[[ end ]]

      if entry.source.name == "copilot" then
        vim_item.kind = icons.git.Octoface
        vim_item.kind_hl_group = "CmpItemKindCopilot"
      end

      if entry.source.name == "emoji" then
        vim_item.kind = icons.misc.Smiley
        vim_item.kind_hl_group = "CmpItemKindEmoji"
      end

      -- NOTE: order matters
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        nvim_lua = "",
        luasnip = "",
        buffer = "[Buffer]",
        path = "[Path]",
        emoji = "[Emoji]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "buffer" },
    --{ name = "cmp_tabnine" },
    { name = "path" },
    --{ name = "emoji" },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = {
      border = "rounded",
      winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
    },
    completion = {
      border = "rounded",
      winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  experimental = {
    ghost_text = true,
  },
}
