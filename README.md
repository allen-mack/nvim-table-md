# nvim-table-md

Neovim plugin to help with markdown tables.

## Key Maps

| Key          | Behavior                              |
| ---          | ---                                   |
| \<Leader\>tc | Add column to the right of the cursor |
| \<Leader\>td | Delete the current column             |
| \<Leader\>tf | Format the table                      |
| \<Leader\>tR | Add row above the current line        |
| \<Leader\>tr | Add row below the current line        |
| \<Leader\>tj | Align column to the left              |
| \<Leader\>tk | Center column                         |
| \<Leader\>tl | Align column to the right             |

Until I can figure out how to assign these keybindings only to markdown files, just add the following to your `after/ftplugin/markdown.lua` file. Of course, you can change these to whatever keybindings you like.

```
vim.api.nvim_set_keymap("n", "<Leader>tf", ':lua require("tablemd").format()<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>tc", ':lua require("tablemd").insertColumn(false)<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>td", ':lua require("tablemd").deleteColumn()<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>tr", ':lua require("tablemd").insertRow(false)<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>tR", ':lua require("tablemd").insertRow(true)<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>tj", ':lua require("tablemd").alignColumn("left")<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>tk", ':lua require("tablemd").alignColumn("center")<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>tl", ':lua require("tablemd").alignColumn("right")<cr>', { noremap = true })
```

## Developing

There is an init file in the dev directory.  If you source it like `:luafile dev/init.lua`, it will add a keymap that will reload the modules so that you can test your changes without having to exit and re-enter Neovim.

### Setting up the project

- Create GitHub project
- Clone the project
- Open Neovim for editing\
*Note:* Make sure to add current directory to runtime path. Otherwise, Novim does not know how to find you plugin.\
`nvim --cmd "set rtp+=."`
- Create Lua module in Lua source directory
- Create init file and sub modules for the module\
`touch lua/greetings/init.lua` & `touch lua/greetings/awesome-module.lua`
