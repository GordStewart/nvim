return {
  "folke/flash.nvim",
  opts = {
    search = {
      -- If mode is set to the default "exact" and you mistype a word, it will
      -- exit flash, (and if then you type "i" for example, you will start
      -- inserting text)
      -- "search" lets you mistype and not ruin your file
      mode = "fuzzy",
    },
  },
}
