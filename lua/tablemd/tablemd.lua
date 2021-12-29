local utils = require('tablemd/utils')
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
    start_line, end_line = M.get_table_range(cursor_location)

    -- Get column definitions
    local col_defs = M.get_column_defs(start_line, end_line)

    -- Format each line
    for i = start_line, end_line do  -- The range includes both ends.
        local line = utils.trim_string(vim.api.nvim_buf_get_lines(0, i-1, i, false)[1])
        local formatted_line = M.get_formatted_line(line, col_defs)

        -- replace the line with the formatted line in the buffer
        vim.api.nvim_buf_set_lines(0, i-1, i, false, {formatted_line})
    end
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
    start_line, end_line = M.get_table_range(cursor_location[1])

    -- Get column definitions
    local col_defs = M.get_column_defs(start_line, end_line)

    -- Get the current column index
    local current_col = get_current_column_index()

    -- Format each line
    for i = start_line, end_line do  -- The range includes both ends.
        local line = utils.trim_string(vim.api.nvim_buf_get_lines(0, i-1, i, false)[1])
        
        local t = utils.split_string(line, "|")

        local new_line = "|"
        local table_len = 0
        for _ in pairs(t) do table_len = table_len + 1 end

        for j = 1, table_len do
            new_line = new_line .. utils.trim_string(t[j]) .. " | "
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

    local col_defs = M.get_column_defs(line_num, line_num)
    local new_line = "|"

    for k, v in ipairs(col_defs) do
        new_line = new_line .. "   |"
    end

    -- To insert a line, pass in the same line number for both start and end.
    vim.api.nvim_buf_set_lines(0, line_num, line_num, false, {new_line})

    -- Move the cursor to the newly created line
    vim.api.nvim_win_set_cursor(0, {line_num + 1, cursor_location[2]})

    M.formatTable()
end

function get_column_boundaries(line, col_index)

    local count = 0
    while count <= col_index+1 do
    end
    for i in line:gmatch("|") do
        count = count + 1
    end
    
    return count
end

--[[--
Returns a table with the max column widths and alignment information.
@tparam int s The first line of the table
@tparam int e The last line of the table
@treturn table Table with information for each column
]]
function M.get_column_defs(s, e)
    -- look for alignment clues on the second line
    local second_line = s + 1
    local defs = {}

    for i = s, e do
        -- Read the line from the buffer
        -- local line = vim.api.nvim_buf_get_lines(0, i-1, i, false)[1]
        local line = utils.trim_string(vim.api.nvim_buf_get_lines(0, i-1, i, false)[1])

        -- Split the line by the pipe symbol
        local t = utils.split_string(line, "|")

        -- For each column
        for k, v in ipairs(t) do
            local trimmed_str = utils.trim_string(v)
            local str_len = string.len(trimmed_str)
            local alignment = nil

            -- look for alignment indicators
            if string.match(trimmed_str, "^-+:$") then
                alignment = 'right'
            elseif string.match(trimmed_str, "^:[-]+:$") then
                alignment = 'center'
            elseif string.match(trimmed_str, "^:-+$") or string.match(trimmed_str, "^-+$") then
                alignment = 'left'
            else
                alignment = nil 
            end

            -- if the sub table doesn't already exist, then add it
            if defs[k] == nil then
                table.insert(defs, k, {length = str_len, align = alignment})
            else
                -- update the object if the length is greater
                if str_len > defs[k]["length"] then
                    defs[k]["length"] = str_len
                end
                -- if we haven't already set the alignment
                if defs[k]["align"] == nil then
                    defs[k]["align"] = alignment
                end
            end
        end
    end

    return defs
end

--[[--
Determines which column the cursor is currently in.
@treturn int The column index. This is Lua, so it is 1 based.
]]
function get_current_column_index() 
    local cursor_location = vim.api.nvim_win_get_cursor(0)
    local line = utils.trim_string(vim.api.nvim_buf_get_lines(0, cursor_location[1]-1, cursor_location[1], false)[1])
    line = string.sub(line, 1, cursor_location[2]-1)

    local count = 0
    for i in line:gmatch("|") do
        count = count + 1
    end
    
    return count
end

--[[--
Returns the formatted line
@tparam string line The line to be formatted
@tparam table col_defs Table with metadata about each column
@treturn string The formatted replacement line
]]
function M.get_formatted_line(line, col_defs)
    local t = utils.split_string(line, "|")
    local build_str = "| "

    for k, v in ipairs(t) do
        local col_width = col_defs[k]["length"]
        local col_align = col_defs[k]["align"]
        local padded_str = utils.pad_string(utils.trim_string(v), col_width, col_align)
        build_str = build_str .. padded_str .. " | "
    end

    -- Trim off beginning or trailing spaces.
    build_str = string.gsub(build_str, '^%s*(.-)%s*$', '%1')

    return build_str
end

--[[--
Find the first line and last line of the table.
@tparam int current_line_number The line number that the cursor is currently on.
@treturn int, int The start line and end line for the table.
]]
function M.get_table_range(current_line_number)
    local start_line
    local end_line
    local current_line = nil
    local buf_line_count = vim.api.nvim_buf_line_count(0)

    -- Go Up
    start_line = current_line_number -- - 1

    repeat
        current_line = vim.api.nvim_buf_get_lines(0, start_line-1, start_line, false)[1]
        start_line = start_line - 1
    until current_line == "" or start_line == 0

    start_line = start_line + 2

    -- Go down
    end_line = current_line_number --+ 1
    current_line = vim.api.nvim_buf_get_lines(0, end_line-1, end_line, false)[1]

    while current_line ~= "" and current_line ~= nil and end_line <= buf_line_count do
        end_line = end_line + 1
        current_line = vim.api.nvim_buf_get_lines(0, end_line-1, end_line, false)[1]
    end

    end_line = end_line - 1

    -- Return start and end line numbers
    return start_line, end_line
end

-- Export module
return M

