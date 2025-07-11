```
                                 ██╗      ██╗   ██╗██╗███╗   ███╗
                                 ██║      ██║   ██║██║████╗ ████║
                                 ██║█████╗╚██╗ ██╔╝██║██╔████╔██║
                            ██╗  ██║╚════╝ ╚████╔╝ ██║██║╚██╔╝██║
                            ╚█████╔╝        ╚██╔╝  ██║██║ ╚═╝ ██║
                             ╚════╝          ╚═╝   ╚═╝╚═╝     ╚═╝
```

### Dependencies
* Ensure `fd` is installed so that telescope ignoring `.gitignore` files will work correctly
* For golang debugging ensure that delve is installed 
    ```
    go install github.com/go-delve/delve/cmd/dlv@latest
    ```
    and that go/bin is added to PATH
* Ensure `fzf` is installed for telescope in general
* Ensure `ripgrep` is installed for telescope livegrep
* Ensure `gcc/clang` is installed for treesitter parser compiling

### debugging
1. If you are running into weird errors remove your session and restart nvim

