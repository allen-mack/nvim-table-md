local table_md = require('tablemd.tablemd')

--[[ MAP KEYS ]]--
-- vim.api.nvim_set_keymap("n", "<Leader>tf", ':lua require("tablemd").format()<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tv", ':lua require("tablemd").insertColumn(false)<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tc", ':lua require("tablemd").insertColumn(true)<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>td", ':lua require("tablemd").deleteColumn()<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tr", ':lua require("tablemd").insertRow(false)<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tR", ':lua require("tablemd").insertRow(true)<cr>', { noremap = true })

return {
    format = table_md.formatTable,
    help = table_md.help,
    alignColumn = table_md.alignColumn,
    deleteColumn = table_md.deleteColumn,
    insertColumn = table_md.insertColumn,
    insertRow = table_md.insertRow
}
