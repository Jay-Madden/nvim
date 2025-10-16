-- Taken from https://gitlab.com/dwt1/shell-color-scripts/-/blob/master/colorscripts/square
local colorscript_square = [[
esc=""

blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
cyanf="${esc}[36m";    whitef="${esc}[37m"

blackfbright="${esc}[90m";   redfbright="${esc}[91m";    greenfbright="${esc}[92m"
yellowfbright="${esc}[93m"   bluefbright="${esc}[94m";   purplefbright="${esc}[95m"
cyanfbright="${esc}[96m";    whitefbright="${esc}[97m"

blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
cyanb="${esc}[46m";    whiteb="${esc}[47m"

boldon="${esc}[1m";    boldoff="${esc}[22m"
italicson="${esc}[3m"; italicsoff="${esc}[23m"
ulon="${esc}[4m";      uloff="${esc}[24m"
invon="${esc}[7m";     invoff="${esc}[27m"

reset="${esc}[0m"

cat << EOF

 ${redf}▀ █${reset} ${boldon}${redfbright}█ ▀${reset}   ${greenf}▀ █${reset} ${boldon}${greenfbright}█ ▀${reset}   ${yellowf}▀ █${reset} ${boldon}${yellowfbright}█ ▀${reset}   ${bluef}▀ █${reset} ${boldon}${bluefbright}█ ▀${reset}   ${purplef}▀ █${reset} ${boldon}${purplefbright}█ ▀${reset}   ${cyanf}▀ █${reset} ${boldon}${cyanfbright}█ ▀${reset} 
 ${redf}██${reset}  ${boldon}${redfbright} ██${reset}   ${greenf}██${reset}   ${boldon}${greenfbright}██${reset}   ${yellowf}██${reset}   ${boldon}${yellowfbright}██${reset}   ${bluef}██${reset}   ${boldon}${bluefbright}██${reset}   ${purplef}██${reset}   ${boldon}${purplefbright}██${reset}   ${cyanf}██${reset}   ${boldon}${cyanfbright}██${reset}  
 ${redf}▄ █${reset}${boldon}${redfbright} █ ▄ ${reset}  ${greenf}▄ █ ${reset}${boldon}${greenfbright}█ ▄${reset}   ${yellowf}▄ █ ${reset}${boldon}${yellowfbright}█ ▄${reset}   ${bluef}▄ █ ${reset}${boldon}${bluefbright}█ ▄${reset}   ${purplef}▄ █ ${reset}${boldon}${purplefbright}█ ▄${reset}   ${cyanf}▄ █ ${reset}${boldon}${cyanfbright}█ ▄${reset}  

EOF

]]

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---
  keys = {
    {
      "<leader>lg",
      function()
        Snacks.lazygit.open()
      end,
      desc = "LazyGit",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.files({
          hidden = true,
          ignore = true,
        })
      end,
      desc = "Test out snacks picker",
    },
  },
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    indent = { enabled = false },
    input = { enabled = false },
    lazygit = {
      enabled = true,
    },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 5, total = 50 },
        easing = "linear",
      },
    },
    -- picker = {
    --   layout = {
    --     reverse = true,
    --     layout = {
    --       box = "horizontal",
    --       width = 0.8,
    --       min_width = 120,
    --       height = 0.85,
    --       {
    --         box = "vertical",
    --         border = "rounded",
    --         title = "{title} {live} {flags}",
    --         { win = "list", border = "none" },
    --         { win = "input", height = 1, border = "top" },
    --       },
    --       { win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
    --     },
    --   },
    -- },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    dashboard = {
      enabled = true,
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
              require("plugins.telescope").find_files()
            end,
          },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          {
            icon = " ",
            key = "g",
            desc = "Find Text",
            action = function()
              require("plugins.telescope").live_grep()
              Snacks.picker.git_files()
            end,
          },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = ":lua Snacks.dashboard.pick('oldfiles')",
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          {
            icon = "󰒲 ",
            key = "L",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        {
          pane = 2,
          section = "terminal",
          cmd = colorscript_square,
          height = 5,
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        {
          pane = 2,
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
        },
        {
          icon = " ",
          pane = 2,
          title = "Git Tree",
          section = "terminal",
          indent = 2,
          ttl = 0,
          padding = 1,
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git --no-pager log --oneline --decorate --graph --all -n 5",
        },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git -c color.status=always status --branch --short | sed q && git --no-pager diff --stat --break-rewrites --find-renames --find-copies",
          padding = 1,
          height = 3,
          ttl = 0,
          indent = 3,
        },
        { section = "startup" },
      },
    },
  },
}
