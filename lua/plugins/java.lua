return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = vim.fn.expand("$HOME/Library/Java/JavaVirtualMachines/temurin-21.0.4/Contents/Home"),
                default = true,
              },
              {
                name = "JavaSE-17",
                path = "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home",
              },
            },
          },
          import = {
            gradle = {
              enabled = true,
            },
          },
          eclipse = {
            downloadSources = true,
          },
          maven = {
            downloadSources = true,
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      dap.configurations.java = dap.configurations.java or {}

      local has_attach = false
      for _, c in ipairs(dap.configurations.java) do
        if c.name == "Debug (Attach) - Remote" then
          has_attach = true
          break
        end
      end
      if not has_attach then
        table.insert(dap.configurations.java, {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        })
      end

      table.insert(dap.configurations.java, {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Spring Boot bootRun",
        hostName = "127.0.0.1",
        port = 5005,
        projectName = "multi-domain-access-svc",
      })
    end,
  },
}
