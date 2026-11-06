-- Helpers for reviewing a branch the way a PR does: compare against the point
-- where the branch forked off the base, not against the base's current tip.
local M = {}

-- Resolve the repo's default branch. Prefers origin/HEAD (set by `git clone`, or
-- `git remote set-head origin -a`), then falls back to the usual suspects.
local function default_branch()
  local head = vim.fn.systemlist("git symbolic-ref --quiet --short refs/remotes/origin/HEAD")[1]
  if vim.v.shell_error == 0 and head and head ~= "" then
    return head
  end

  for _, candidate in ipairs({ "origin/main", "origin/master", "main", "master", "develop" }) do
    vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", candidate })
    if vim.v.shell_error == 0 then
      return candidate
    end
  end
end

---@param opts? { prompt?: boolean, log?: boolean }
function M.review(opts)
  opts = opts or {}

  local base = default_branch()
  if not base and not opts.prompt then
    vim.notify("Could not determine the base branch; pick one with <leader>gC", vim.log.levels.WARN)
    return
  end

  local function open(b)
    if not b or b == "" then
      return
    end
    if opts.log then
      vim.cmd("DiffviewFileHistory --range=" .. b .. "...HEAD --right-only")
    else
      vim.cmd("DiffviewOpen " .. b .. "...HEAD")
    end
  end

  if opts.prompt then
    vim.ui.input({ prompt = "Base branch: ", default = base or "origin/main" }, open)
  else
    open(base)
  end
end

return M
