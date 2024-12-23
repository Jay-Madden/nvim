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
    { "<leader>lg", function() Snacks.lazygit.open() end, desc = "LazyGit" },
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
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        {
          pane = 2,
          icon = " ",
          title = "Git Diff",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git --no-pager diff --stat -B -M -C",
          height = 10,
        },
        { section = "startup" },
      },
    },
  },
}
