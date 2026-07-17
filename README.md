# Theme

## Installation

### lazy.nvim
```lua
{
    "DCIAL42/theme.nvim",
    -- set options
    -- opts = {...}

    -- or
    -- config = function()
    --     require("theme").setup({...})
    -- end
},
```

### Default opts
```lua
opts = {
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
```
