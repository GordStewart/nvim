return {
  { "rebelot/kanagawa.nvim" },
  {
    "navarasu/onedark.nvim",
    init = function()
      require("onedark").setup({
        style = "darker",
        code_style = {
          comments = "italic",
          keywords = "italic",
          functions = "none",
          strings = "none",
          variables = "none",
        },
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "kanagawa",
      -- colorscheme = "onedark",
      colorscheme = "tokyonight-moon",
    },
  },
}
