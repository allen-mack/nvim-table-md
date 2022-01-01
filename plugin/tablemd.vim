fun! Tablemd()
    lua for k in pairs(package.loaded) do if k:match("^nvim%-table%-md") then package.loaded[k] = nil end end
    lua require("tablemd")
endfun

augroup Tablemd
    autocmd!
augroup END
