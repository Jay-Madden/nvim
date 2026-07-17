local function root_readme_path()
  local root = Snacks.git.get_root() or (vim.uv or vim.loop).cwd()
  if not root then
    return
  end

  for _, name in ipairs({ "README.md", "README" }) do
    local path = vim.fs.joinpath(root, name)
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

local function header_padding(dashboard)
  local top_padding = 0
  local path = root_readme_path()

  if path then
    local key_count = 0
    for _, key in ipairs(dashboard.opts.preset.keys) do
      key_count = key_count + (dashboard:enabled(key) and 1 or 0)
    end

    local available_height = math.max(vim.api.nvim_win_get_height(0) - 10, 1)
    local readme_height = math.min(#vim.fn.readfile(path) + 5, available_height)
    local header_height = #vim.split(dashboard.opts.preset.header, "\n", { plain = true }) + 2
    local keys_height = key_count * 2 + 1
    local startup_height = 1
    top_padding =
      math.max(math.floor((readme_height - header_height - keys_height - startup_height) / 2), 0)
  end

  if top_padding == 0 then
    return
  end

  return {
    pane = 1,
    text = ("\n"):rep(top_padding - 1),
  }
end

local function root_readme()
  local path = root_readme_path()
  if not path then
    return
  end

  local lines = vim.fn.readfile(path)
  local available_height = math.max(vim.api.nvim_win_get_height(0) - 10, 1)
  local height = math.min(#lines + 4, available_height)
  if vim.fn.executable("glow") == 1 then
    return {
      pane = 2,
      section = "terminal",
      cmd = { "glow", "--style", "dark", "--width", "72", path },
      height = height,
      ttl = 24 * 60 * 60,
      padding = 1,
    }
  end

  lines = vim.list_slice(lines, 1, height)
  return {
    pane = 2,
    text = table.concat(lines, "\n"),
    padding = 1,
  }
end

return {
  opts = {
    dashboard = {
      enabled = true,
      width = 72,
      preset = {
        header = [[
         ██╗      ██╗   ██╗██╗███╗   ███╗
         ██║      ██║   ██║██║████╗ ████║
         ██║█████╗╚██╗ ██╔╝██║██╔████╔██║
    ██╗  ██║╚════╝ ╚████╔╝ ██║██║╚██╔╝██║
    ╚█████╔╝        ╚██╔╝  ██║██║ ╚═╝ ██║
     ╚════╝          ╚═╝   ╚═╝╚═╝     ╚═╝]],
        keys = {
          {
            icon = " ",
            key = "f",
            desc = "Find File",
            action = function()
              Snacks.picker.files({
                hidden = true,
                ignore = true,
              })
            end,
          },
          {
            icon = " ",
            key = "g",
            desc = "Find Text",
            action = function()
              Snacks.picker.grep()
            end,
          },
          {
            icon = "󰒲 ",
            key = "L",
            desc = "Plugins",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          {
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        header_padding,
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        root_readme,
        { section = "startup" },
      },
    },
  },
}
