-- Two *different* JVMs matter for a Java setup, and mixing them up is what
-- silently breaks "find references":
--
--   1. The JVM hosting the language server. Recent jdtls builds require
--      JavaSE-25, so we point --java-executable at JDK 25.
--   2. The JVM Buildship uses to run the Gradle import
--      (java.import.gradle.java.home). Gradle 8.x cannot run on JDK 25, so when
--      this is left unset jdtls picks an arbitrary registered JDK. On this
--      machine it picked Corretto 18, which made Gradle resolve
--      `compileClasspath` against a Java 18 target and fail on every dependency
--      published for Java 21 -> no classpath -> no compiled index -> `gr`
--      returns nothing even though the callers exist.
--
-- Projects still *compile* against the runtimes configured below; these two
-- settings only control which JVM runs the tooling.
local function java_home(version)
  local out = vim.fn.system({ "/usr/libexec/java_home", "-v", version })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

local jdk25 = java_home("25+")
local jdk21 = java_home("21")
local jdk17 = java_home("17")

local function runtimes()
  local list = {}
  if jdk21 then
    table.insert(list, { name = "JavaSE-21", path = jdk21, default = true })
  end
  if jdk17 then
    table.insert(list, { name = "JavaSE-17", path = jdk17 })
  end
  return list
end

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      if jdk25 then
        table.insert(opts.cmd, string.format("--java-executable=%s/bin/java", jdk25))
      else
        vim.notify("jdtls needs JDK 25: run `brew install --cask temurin@25`", vim.log.levels.WARN)
      end

      if not jdk21 then
        vim.notify(
          "JDK 21 not found: jdtls will guess a JVM for the Gradle import and the classpath may be incomplete",
          vim.log.levels.WARN
        )
      end

      return vim.tbl_deep_extend("force", opts, {
        settings = {
          java = {
            configuration = {
              -- Default is "interactive", which in Neovim means the classpath is
              -- never refreshed after build.gradle changes.
              updateBuildConfiguration = "automatic",
              runtimes = runtimes(),
            },
            import = {
              gradle = {
                enabled = true,
                wrapper = { enabled = true },
                -- The fix: pin the Gradle import JVM instead of letting jdtls guess.
                java = { home = jdk21 },
              },
            },
            eclipse = {
              downloadSources = true,
            },
            maven = {
              downloadSources = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
          },
        },
      })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      dap.configurations.java = dap.configurations.java or {}

      local function add(config)
        for _, existing in ipairs(dap.configurations.java) do
          if existing.name == config.name then
            return
          end
        end
        table.insert(dap.configurations.java, config)
      end

      add({
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
      })

      -- No hardcoded projectName: jdtls resolves it from the current root dir,
      -- so this works for every svc-apis service rather than just one.
      add({
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Spring Boot bootRun",
        hostName = "127.0.0.1",
        port = 5005,
      })
    end,
  },
}
