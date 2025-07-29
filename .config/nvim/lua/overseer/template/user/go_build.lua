return {
  name = "go build",
  builder = function()
    return {
      cmd = { "go" },
      args = { "build", "." },
      cwd = vim.fn.getcwd(),
      components = { "default" },
    }
  end,
  condition = {
    filetype = { "go" },
  },
}
