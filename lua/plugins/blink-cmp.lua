-- NOTE: Specify the trigger character(s) used for luasnip
local trigger_text = ";"

return {
  "saghen/blink.cmp",
  enabled = true,
  opts = {
    sources = {
      providers = {
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          kind = "LSP",
          min_keyword_length = 2,
          score_offset = 90,
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 25,
          -- show snippets and text only if there are no path suggestions
          fallbacks = { "snippets", "buffer" },
          min_keyword_length = 2,
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            -- get_cwd = function(context)
            --   return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            -- end,
            show_hidden_files_by_default = true,
          },
        },
      },
    },
  },
}
