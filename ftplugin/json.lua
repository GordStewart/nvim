-- ftplugin/json.lua
-- This adds a comma any time a new line is added with o.
-- Triggered only if there is no existing comma.
-- Ignores lines ending with a { and a few other cases.
-- https://medium.com/scoro-engineering/5-smart-mini-snippets-for-making-text-editing-more-fun-in-neovim-b55ffb96325a
vim.keymap.set("n", "o", function()
  local line = vim.api.nvim_get_current_line()

  local should_add_comma = string.find(line, "[^,{[]$")
  if should_add_comma then
    return "A,<cr>"
  else
    return "o"
  end
end, { buffer = true, expr = true })
