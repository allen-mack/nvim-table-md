local table_md = require('nvim-table-md.table-md')

--[[ MAP KEYS ]]--
vim.api.nvim_set_keymap("n", "<Leader>tf", ":lua nvim-table-md.format()<cr>", { noremap = true })

return {
    format = table_md.formatTable
}
