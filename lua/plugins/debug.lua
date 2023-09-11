return {
  "mxsdev/nvim-dap-vscode-js",
  dependencies = {

    -- {
    --   "microsoft/vscode-js-debug",
    --   build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
    -- },
    {
      "microsoft/vscode-node-debug2",
      build = "npm install && NODE_OPTIONS=--no-experimental-fetch npm run build",
    },
  },
  init = function()
    require("dap-vscode-js").setup({
      debugger_path = os.getenv("HOME") .. "/.local/share/nvim/lazy/vscode-js-debug",
      adapters = {
        "pwa-node",
        "pwa-chrome",
        "pwa-msedge",
        "node-terminal",
        "pwa-extensionHost",
      },
    })

    -- mfussenegger/nvim-dap
    local dap = require("dap")
    dap.adapters.node2 = {
      type = "executable",
      command = "node-debug2-adapter",
      args = {
        -- os.getenv("HOME") .. "/.local/share/nvim/lazy/vscode-node-debug2/out/src/nodeDebug.js",
      },
    }
  end,
}
