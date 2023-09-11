return {
  { "rebelot/kanagawa.nvim" },
  {
    "navarasu/onedark.nvim",
    init = function()
      require("onedark").setup({
        style = "darker",
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "kanagawa",
      colorscheme = "onedark",
    },
  },
}
