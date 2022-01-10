local su = require('tablemd/string_utils')
local tu = require('tablemd/table_utils')

local M = {}

--[[
Formats the markdown table so cells in a column are a uniform width.
]]
function M.formatTable()
    local start_line = nil
    local end_line = nil
    local cur_line = nil
    local cursor_location = vim.fn.line('v')

    -- Get the range of lines to format
    start_line, end_line = tu.get_table_range(cursor_location)

    -- Get column definitions
    local col_defs = tu.get_column_defs(start_line, end_line)

    -- Format each line
    for i = start_line, end_line do  -- The range includes both ends.
        local line = su.trim_string(vim.api.nvim_buf_get_lines(0, i-1, i, false)[1])
        local formatted_line = tu.get_formatted_line(line, col_defs)

        -- replace the line with the formatted line in the buffer
        vim.api.nvim_buf_set_lines(0, i-1, i, false, {formatted_line})
    end
end

--[[--
Deletes the current column from the table.
]]
function M.deleteColumn()
    local start_line = nil
    local end_line = nil
    local cursor_location = vim.api.nvim_win_get_cursor(0)

    -- Get the range of lines to format
    start_line, end_line = tu.get_table_range(cursor_location[1])

    -- Get column definitions
    local col_defs = tu.get_column_defs(start_line, end_line)

    -- Get the current column index
    local current_col = tu.get_current_column_index()

    -- Format each line
    for i = start_line, end_line do 
        local line = su.trim_string(vim.api.nvim_buf_get_lines(0, i-1, i, false)[1])
        local t = su.split_string(line, "|")

        local new_line = "|"
        local table_len = 0
        for _ in pairs(t) do table_len = table_len + 1 end

        for j = 1, table_len do
            if j ~= current_col then
                new_line = new_line .. su.trim_string(t[j]) .. " | "
            end
        end

        -- replave the line with the formatted line in the buffer
        vim.api.nvim_buf_set_lines(0, i-1, i, false, {new_line})
    end

    M.formatTable()
end

--[[--
Formats each line in the table with a new column.
@tparam bool before If true, the column will be inserted on the left side of the current column
]]
function M.insertColumn(before)
    local start_line = nil
    local end_line = nil
    local cursor_location = vim.api.nvim_win_get_cursor(0)

    -- Get the range of lines to format
    start_line, end_line = tu.get_table_range(cursor_location[1])

    -- Get column definitions
    local col_defs = tu.get_column_defs(start_line, end_line)

    -- Get the current column index
    local current_col = tu.get_current_column_index()

    -- Format each line
    for i = start_line, end_line do  -- The range includes both ends.
        local line = su.trim_string(vim.api.nvim_buf_get_lines(0, i-1, i, false)[1])

        local t = su.split_string(line, "|")

        local new_line = "|"
        local table_len = 0
        for _ in pairs(t) do table_len = table_len + 1 end

        for j = 1, table_len do
            new_line = new_line .. su.trim_string(t[j]) .. " | "
            if j == current_col then
                if i == start_line + 1 then
                    new_line = new_line .. "--- | "
                else
                    new_line = new_line .. "    | "
                end
            end
        end

        -- replace the line with the formatted line in the buffer
        vim.api.nvim_buf_set_lines(0, i-1, i, false, {new_line})
    end

    M.formatTable()
end

--[[--
Inserts a new row into the table
@tparam bool before If true, the row will be inserted above the current row
]]
function M.insertRow(before)
    -- Get the current location of the cursor
    local cursor_location = vim.api.nvim_win_get_cursor(0)
    print(vim.inspect(cursor_location))
    local line_num = cursor_location[1]

    local col_defs = tu.get_column_defs(line_num, line_num)
    local new_line = "|"

    for k, v in ipairs(col_defs) do
        new_line = new_line .. "   |"
    end

    -- If 'before' is true, then insert the row above the current row.
    if before then
        line_num = line_num - 1
    end

    -- To insert a line, pass in the same line number for both start and end.
    vim.api.nvim_buf_set_lines(0, line_num, line_num, false, {new_line})

    -- Move the cursor to the newly created line
    vim.api.nvim_win_set_cursor(0, {line_num + 1, cursor_location[2]})

    M.formatTable()
end

function M.setKeyMap()
    vim.api.nvim_set_keymap("n", "<Leader>tf", ':lua require("tablemd").format()<cr>', { noremap = true })
    vim.api.nvim_set_keymap("n", "<Leader>tc", ':lua require("tablemd").insertColumn(false)<cr>', { noremap = true })
    vim.api.nvim_set_keymap("n", "<Leader>td", ':lua require("tablemd").deleteColumn()<cr>', { noremap = true })
    vim.api.nvim_set_keymap("n", "<Leader>tr", ':lua require("tablemd").insertRow(false)<cr>', { noremap = true })
    vim.api.nvim_set_keymap("n", "<Leader>tR", ':lua require("tablemd").insertRow(true)<cr>', { noremap = true })
end

function M.help()
    print('THIS IS A HELP MESSAGE')
end

-- Export module
return M

