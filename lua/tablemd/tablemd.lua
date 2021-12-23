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
        local line = vim.api.nvim_buf_get_lines(0, i-1, i, false)[1]
        local formatted_line = M.get_formatted_line(line, col_defs)

        -- replace the line with the formatted line in the buffer
        vim.api.nvim_buf_set_lines(0, i-1, i, false, {formatted_line})
    end
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
        local line = vim.api.nvim_buf_get_lines(0, i-1, i, false)[1]

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

