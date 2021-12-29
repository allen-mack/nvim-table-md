local su = require('tablemd/string_utils')

local M = {}

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
        local line = su.trim_string(vim.api.nvim_buf_get_lines(0, i-1, i, false)[1])

        -- Split the line by the pipe symbol
        local t = su.split_string(line, "|")

        -- For each column
        for k, v in ipairs(t) do
            local trimmed_str = su.trim_string(v)
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
function M.get_current_column_index()
    local cursor_location = vim.api.nvim_win_get_cursor(0)
    local line = su.trim_string(vim.api.nvim_buf_get_lines(0, cursor_location[1]-1, cursor_location[1], false)[1])
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
    local t = su.split_string(line, "|")
    local build_str = "| "

    for k, v in ipairs(t) do
        local col_width = col_defs[k]["length"]
        local col_align = col_defs[k]["align"]
        local padded_str = su.pad_string(su.trim_string(v), col_width, col_align)
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

-- Export Module
return M
