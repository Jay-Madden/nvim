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
    ```
    brew install fd
    ```
* For golang debugging ensure that delve is installed 
    ```
    go install github.com/go-delve/delve/cmd/dlv@latest
    ```
    and that go/bin is added to PATH
* Ensure `fzf` is installed for telescope in general
    ```
    brew install fzf
    ```
* Ensure `ripgrep` is installed for telescope livegrep
    ```
    brew install ripgrep
    ```
* Ensure `gcc/clang` and `tree-sitter-cli` is installed for treesitter parser compiling
    ```
    brew install tree-sitter-cli
    ```
