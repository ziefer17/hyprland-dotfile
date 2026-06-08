return {
    -- ensure roslyn binary is auto-installed, omnisharp is never installed
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}

        -- add tools you want
        vim.list_extend(opts.ensure_installed, {
            "roslyn",
            "csharpier",
            "netcoredbg",
            "fantomas",
            "fsautocomplete",
        })

        -- filter out omnisharp if something else adds it
        opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "omnisharp"
        end, opts.ensure_installed)
        end,
    },

    -- prevent mason-lspconfig from ever auto-starting omnisharp
    {
        "mason-org/mason-lspconfig.nvim",
        opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        opts.ensure_installed = vim.tbl_filter(function(s)
        return s ~= "omnisharp"
        end, opts.ensure_installed)
        end,
    },

    {
        "seblj/roslyn.nvim",
        ft = "cs",
        opts = {},
    },

    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
        opts.formatters_by_ft = opts.formatters_by_ft or {}
        opts.formatters_by_ft.cs = { "csharpier" }
        opts.formatters_by_ft.fsharp = { "fantomas" }
        end,
    },
}
