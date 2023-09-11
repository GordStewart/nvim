-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- don't move cursor to top of yanked visual range
map("v", "y", "ygv<Esc>")

-- u to undo, U to redo
map("n", "U", "<C-r>", { desc = "Redo" })

map("i", "<C-E>", "<ESC>BDi<><ESC>hpyypa/<ESC>O", { desc = "html tag" })
-- map("i", "<C-E>", "<ESC>BDi<><ESC>hpyypa/<ESC>O<Space><Space>", { desc = "html tag" })

-- escape in insert mode
map("i", "jj", "<Esc><Esc>")
map("i", "jk", "<Esc><Esc>")
map("i", "kj", "<Esc><Esc>")

-- insert empty lines before / after
map("n", "[<Space>", "O<Esc>j", { desc = "Add blank line before" })
map("n", "]<Space>", "o<Esc>k", { desc = "Add blank line after" })

-- select recently pasted text in visual mode - like "gv" to select last visual selection
map("n", "gp", "`[v`]", { desc = "Select last pasted text in Visual" })

-- Easier pasting
map("n", "[p", ":pu!<cr>", { desc = "Paste into previous line" })
map("n", "]p", ":pu<cr>", { desc = "Paste into next line" })
