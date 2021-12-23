package.loaded['tablemd'] = nil
package.loaded['tablemd.tablemd'] = nil
package.loaded['utils'] = nil
package.loaded['tablemd.utils'] = nil
package.loaded['dev'] = nil

vim.api.nvim_set_keymap('n', ',r', ':luafile dev/init.lua<cr>', {})

TableMD = require('tablemd')

