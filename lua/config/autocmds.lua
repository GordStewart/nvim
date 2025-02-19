-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local line_numbers_group = vim.api.nvim_create_augroup("gs/toggle_line_numbers", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  group = line_numbers_group,
  desc = "Toggle relative line numbers on",
  callback = function()
    if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, "i") then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  group = line_numbers_group,
  desc = "Toggle relative line numbers off",
  callback = function(args)
    if vim.wo.nu then
      vim.wo.relativenumber = false
    end

    -- Redraw here to avoid having to first write something for the line numbers to update.
    if args.event == "CmdlineEnter" then
      if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
        vim.cmd.redraw()
      end
    end
  end,
})

-- Folding
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("gs/treesitter_folding", { clear = true }),
  desc = "Enable Treesitter folding",
  callback = function(args)
    local bufnr = args.buf

    -- Enable Treesitter folding when not in huge files and when Treesitter
    -- is working.
    if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.cmd.normal("zx")
      end)
    else
      -- Else just fallback to using indentation.
      vim.wo[0][0].foldmethod = "indent"
    end
  end,
})

-- Lualine colour scheme switching
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("gs/lualine_toggling", { clear = true }),
  desc = "Toggles Lualine between light/dark.",
  callback = function()
    if vim.o.background == "light" then
      require("lualine").setup({ options = { theme = "tokyonight-day" } })
    elseif vim.o.background == "dark" and package.loaded["snacks"] then
      require("lualine").setup({ options = { theme = "tokyonight-moon" } })
    end
  end,
})

-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
