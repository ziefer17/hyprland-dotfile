return {
    -- ensure roslyn binary is auto-installed, omnisharp is never installed
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
        opts.registries = opts.registries or {}
        vim.list_extend(opts.registries, {
            "github:Crashdummyy/mason-registry",  -- needed for roslyn
            "github:mason-org/mason-registry",
        })

        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {
            "roslyn",       -- correct package name, NOT roslyn-language-server
            "csharpier",
            "netcoredbg",
            "fantomas",
            "fsautocomplete",
            "html-lsp",
        })

        opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "omnisharp" and tool ~= "roslyn-language-server"
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
        "seblyng/roslyn.nvim",
        ft = { "cs", "razor", "cshtml" },  -- expand filetypes
        opts = {
            config = {
                filewatching = false, -- reduces load significantly on large projects
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                roslyn_ls = { enabled = false },
                omnisharp = { enabled = false },
                omnisharp_mono = { enabled = false },
            },
        },
    },

    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
        opts.formatters_by_ft = opts.formatters_by_ft or {}
        opts.formatters_by_ft.cs = { "csharpier" }
        opts.formatters_by_ft.fsharp = { "fantomas" }
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
            "c_sharp",
        })
        end,
    },
}
