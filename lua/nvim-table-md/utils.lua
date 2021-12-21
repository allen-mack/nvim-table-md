local M = {}

--[[--
Pad string
@tparam string input The string to pad.
@tparam int len The expected length of the return value.
@treturn string String padded with spaces.
]]
function M.pad_string(input, len)
    local space_count = len - string.len(input);

    input = input .. string.rep(" ", space_count)

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
