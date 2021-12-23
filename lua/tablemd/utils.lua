local M = {}

--[[--
Pad string
@tparam string input The string to pad.
@tparam int len The expected length of the return value.
@treturn string String padded with spaces.
]]
function M.pad_string(input, len, alignment)
    -- Treat alignment as an optional paramenter with a default value
    alignment = alignment or 'left'

    local space_count = len - string.len(input);

    if alignment == 'left' then
        input = input .. string.rep(" ", space_count)
    elseif alignment == 'right' then
        input = string.rep(" ", space_count) .. input
    elseif alignment == 'center' then
        if space_count > 0 then
            local left_spaces = math.ceil(space_count / 2)
            local right_spaces = space_count - left_spaces
            input = string.rep(" ", left_spaces) .. input .. string.rep(" ", right_spaces)
        end
    else
        -- If we don't know the alignment, then treat it as left justified.
        input = input .. string.rep(" ", space_count)
    end

    return input
end

--[[--
Split string
@tparam string input The string to split.
@tparam string sep The separator string.
@return table Table containing the split pieces
]]
function M.split_string(input, sep) 
    if sep == nil then
        sep = "%s"
    end

    local t = {}
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

--[[--
Trim spaces from beginning and end of string
@tparam string s The string to trim.
@treturn string The trimmed string
]]
function M.trim_string(s) 
    return s:match( "^%s*(.-)%s*$" )
end

-- Export module
return M
