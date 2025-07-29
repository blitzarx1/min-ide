return {
  name = "go run",
  builder = function()
    return {
      cmd = { "go" },
      args = { "run", "." },
      cwd = vim.fn.getcwd(),
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "go" },
  },
}
