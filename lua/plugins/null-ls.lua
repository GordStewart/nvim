return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources, {
        nls.builtins.formatting.black,
        -- nls.builtins.formatting.ruff,
        nls.builtins.diagnostics.mypy,
        -- nls.builtins.diagnostics.ruff,
        nls.builtins.diagnostics.djlint,
        nls.builtins.formatting.djlint,
      })
    end,
  },
}
