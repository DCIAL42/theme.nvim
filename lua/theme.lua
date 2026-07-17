local theme_group = vim.api.nvim_create_augroup("Theme", { clear = true })
local theme_file_path = vim.fs.joinpath(vim.fn.stdpath("cache"), "theme")

vim.api.nvim_create_autocmd("ColorScheme", {
    group = theme_group,
    callback = function(e)
        local theme_file = io.open(theme_file_path, "w")
        if theme_file then
            theme_file:write(e.match)
            theme_file:close()
        else
            vim.health.error("Could not open theme file for writing")
        end
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = theme_group,
    callback = function()
        local theme_file = io.open(theme_file_path, "r")
        if theme_file then
            local theme = theme_file:read("*l")
            vim.cmd("colorscheme " .. theme)
            theme_file:close()
        else
            vim.health.error("Could not open theme file for reading")
        end
    end,
})

vim.api.nvim_create_user_command("Theme", "Telescope colorscheme", {})
