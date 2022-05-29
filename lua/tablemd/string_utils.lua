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

    -- default the spacing to a left justification
    local left_spaces = 0
    local right_spaces = space_count
    
    -- if the alignment is 'right' then put all the space on the left side of the string.
    if alignment == 'right' then
        left_spaces = space_count
        right_spaces = 0
    end

    -- If the alignment is 'center', split the space between the left and right.
    -- For uneven splits, put the extra space on the right side of the string.
    if alignment == 'center' then
        if space_count > 0 then
            left_spaces = math.floor(space_count / 2)
            right_spaces = space_count - left_spaces
        end
    end

    input = string.rep(" ", left_spaces) .. input .. string.rep(" ", right_spaces)

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
