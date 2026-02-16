-- File: lua/plugins/dap-js.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mxsdev/nvim-dap-vscode-js",
        dependencies = { "microsoft/vscode-js-debug" },
        build = "npm install --legacy-peer-deps && npm run compile",
      },
    },
  },
}
