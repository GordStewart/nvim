return {
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown",
    init = function()
      require("mtoc").setup({
        toc_list = {
          -- Keep all the heading markers as '-', not +,*, etc
          markers = "-",
          -- swap spaces with '%20' instead of '-' for obsidian;
          item_formatter = function(item, fmtstr)
            local default_formatter = require("mtoc.config").defaults.toc_list.item_formatter
            item.link = item.name:gsub(" ", "%%20")
            return default_formatter(item, fmtstr)
          end,
        },
      })
    end,
  },
}
