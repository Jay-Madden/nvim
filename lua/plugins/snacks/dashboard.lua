-- Taken from https://gitlab.com/dwt1/shell-color-scripts/-/blob/master/colorscripts/square
local colorscript_square_cmd = [[
esc="\u001b"

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
  opts = {
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
        icon = " ",
        key = "f",
        desc = "Find File",
        action = function()
          Snacks.picker.files({
            hidden = true,
            ignore = true,
          })
        end,
      },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      {
        icon = " ",
        key = "g",
        desc = "Find Text",
        action = function()
          Snacks.picker.grep()
        end,
      },
      {
        icon = " ",
        key = "r",
        desc = "Recent Files",
        action = ":lua Snacks.dashboard.pick('oldfiles')",
      },
      {
        icon = " ",
        key = "c",
        desc = "Config",
        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
      },
      { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      {
        icon = " ",
        key = "L",
        desc = "Lazy",
        action = ":Lazy",
        enabled = package.loaded.lazy ~= nil,
      },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },
  sections = {
    { section = "header" },
    {
      pane = 2,
      section = "terminal",
      cmd = colorscript_square_cmd,
      height = 5,
      padding = 1,
    },
    { section = "keys", gap = 1, padding = 1 },
    {
      pane = 2,
      icon = " ",
      desc = "Browse Repo",
      padding = 1,
      key = "b",
      action = function()
        Snacks.gitbrowse()
      end,
    },
    {
      pane = 2,
      icon = " ",
      title = "Recent Files",
      section = "recent_files",
      indent = 2,
      padding = 1,
    },
    {
      icon = " ",
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
      icon = " ",
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
}
