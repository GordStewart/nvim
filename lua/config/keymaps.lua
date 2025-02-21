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

-- Navigator
map({ "n", "t" }, "<C-h>", "<CMD>lua require('tmux').move_left()<cr>")
map({ "n", "t" }, "<C-l>", "<CMD>lua require('tmux').move_right()<cr>")
map({ "n", "t" }, "<C-k>", "<CMD>lua require('tmux').move_top()<cr>")
map({ "n", "t" }, "<C-j>", "<CMD>lua require('tmux').move_bottom()<cr>")

map("n", "<Space>ab", "<CMD>lua require('config/utils').add_bold()<CR>")
map("v", "<Space>ab", "<CMD>lua require('config/utils').add_bold()<CR>")
map("n", "<Space>ai", "<CMD>lua require('config/utils').add_italic()<CR>")
map("v", "<Space>ai", "<CMD>lua require('config/utils').add_italic()<CR>")
map("n", "<Space>mw", "<CMD>lua require('config/utils').add_markdown_wikilink()<CR>")
map("v", "<Space>mw", "<CMD>lua require('config/utils').add_markdown_wikilink()<CR>")
map("n", "<Space>ml", "<CMD>lua require('config/utils').toggle_markdown_bp()<CR>")
map("v", "<Space>mg", "<CMD>lua require('config/utils').book_to_get()<CR>")
map("n", "<Space>mt", "<CMD>Mtoc<CR>", { desc = "Insert/Update ToC" })

-- AutoIndent to appropriate position
map("n", "i", function()
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")
  local is_empty = #line == 0
  local is_leading_whitespace = col <= #line:match("^%s*")

  if is_empty then
    return '"_cc'
  elseif is_leading_whitespace then
    return "A"
  else
    return "i"
  end
end, { desc = "Automatically indent to the appropriate position", silent = true, expr = true })
-- 1. if its an empty line, it autoindents to the shiftwidth using black hole \cc``
-- 2. if its a filled line but the cursor is in a leading whitespace, your cursor enters insert mode at EOL
-- 3. if its a filled line but the cursor is in between text, it returns a normal i

-- Toggles between virtual lines and virtual lines diagnostics
-- When lines are on, text is off. Text on, lines off. Minimize clutter.
vim.keymap.set("", "<leader>bl", function()
  vim.diagnostic.config({
    virtual_lines = not vim.diagnostic.config().virtual_lines,
    virtual_text = not vim.diagnostic.config().virtual_text,
  })
end, { desc = "Toggle diagnostic [l]ines" })

-- better <esc>.
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
