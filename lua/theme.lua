local M = {}

local set_autocmds = function()
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
                vim.notify("Could not open theme file for writing", vim.log.levels.ERROR, { title = "Theme" })
            end
        end,
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        group = theme_group,
        callback = function()
            local theme_file = io.open(theme_file_path, "r")
            if theme_file then
                local theme = theme_file:read("*l")
                if #vim.fn.getcompletion(theme, "color") == 0 then
                    vim.notify("Most recent theme was removed, failed to load", vim.log.levels.WARN, { title = "Theme" })
                    return
                end
                vim.cmd("colorscheme " .. theme)
                theme_file:close()
            else
                vim.notify("Could not open theme file for reading", vim.log.levels.ERROR, { title = "Theme" })
            end
        end,
    })
end

---Set plugin command
---@param opts theme.CommandOptions
local set_command = function(opts)
    opts = opts or {}
    local color_picker = require "telescope.builtin"
    vim.api.nvim_create_user_command("Theme",
        function()
            color_picker.colorscheme({ enable_preview = opts.preview, ignore_builtins = opts.ignore_builtins })
        end,
        {})
end

---Set keymaps
---@param lhs string
local set_map = function(lhs)
    vim.keymap.set("n", lhs, "<cmd>Theme<CR>", { silent = true })
end

---@class theme.Options
---@field command theme.CommandOptions
---@field map theme.MapOptions

---@class theme.MapOptions
---@field set boolean
---@field lhs string

---@class theme.CommandOptions
---@field set boolean
---@field preview boolean
---@field ignore_builtins boolean

---@type theme.Options
local defaults = {
    command = {
        set = true,
        preview = true,
        ignore_builtins = true,
    },
    map = {
        set = true,
        lhs = "<leader>t",
    },
}

---@type theme.Options
local options

---Setup the plugin
---@param opts theme.Options
M.setup = function(opts)
    options = vim.tbl_deep_extend("force", defaults, opts or {})
    set_autocmds()
    if options.command then
        set_command(options.command)
    end
    if options.map.set then
        set_map(options.map.lhs)
    end
    vim.g.theme_dc_loaded = 1
end

return M
