package.loaded['nvim-table-md'] = nil
package.loaded['nvim-table-md.table-md'] = nil
package.loaded['dev'] = nil

vim.api.nvim_set_keymap('n', ',r', ':luafile dev/init.lua<cr>', {})
