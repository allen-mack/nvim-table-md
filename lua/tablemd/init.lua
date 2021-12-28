local table_md = require('tablemd.tablemd')

--[[ MAP KEYS ]]--
vim.api.nvim_set_keymap("n", "<Leader>tf", ':lua require("tablemd").format()<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>tc", ':lua require("tablemd").insertColumn(false)<cr>', { noremap = true })

return {
    format = table_md.formatTable,
    insertColumn = table_md.insertColumn
}
