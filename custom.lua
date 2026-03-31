return {
  {
    "sylvanfranklin/omni-preview.nvim",
    opts = {},
    dependencies = {
        -- for markdown
        { "toppair/peek.nvim", lazy = true, build = "deno task --quiet build:fast" },
              -- Typst
        { 'chomosuke/typst-preview.nvim', lazy = true },
      -- CSV
        { 'hat0uma/csvview.nvim',         lazy = true },
    },
    keys = {
      { "<leader>po", "<cmd>OmniPreview start<CR>", desc = "OmniPreview Start" },
      { "<leader>pc", "<cmd>OmniPreview stop<CR>",  desc = "OmniPreview Stop" },
    },
    config = function()
        require("omni-preview").setup()
        require("peek").setup({ app = "firefox" })
    end
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
          cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
          root_dir = require("lspconfig").util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "project.json"),
          enable_roslyn_analyzers = true,
          enable_import_completion = true,
          organize_imports_on_format = true,
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "omnisharp" })
    end,
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("easy-dotnet").setup({
        -- Optional: Customize as needed
        debugger = {
          auto_register_dap = true,  -- Automatically sets up nvim-dap for .NET
        },
        test_runner = {
          viewmode = "float",  -- Or "split" for test output
        },
        -- Add keymaps (adjust <leader> if your NvChad leader is different)
        mappings = {
          run_project = { lhs = "<leader>dr", desc = "Run .NET Project" },
          build_project = { lhs = "<leader>db", desc = "Build .NET Project" },
          test_project = { lhs = "<leader>dt", desc = "Test .NET Project" },
          -- Add more from plugin docs if needed
        },
      })
    end,
  },
  -- Debugging c
  {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dap = require("dap")
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap" },
    }

    dap.configurations.c = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
        return vim.fn.input("Executable (default ./a.out): ", "./a.out", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
      },
    }

    require("dapui").setup()
  end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "coreclr" },  -- Installs netcoredbg via Mason if not using system package
        automatic_setup = true,
      })
    end,
  },
  -- Bridge Mason to Neovim LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd" },
      })

      local lspconfig = require("lspconfig")
      lspconfig.clangd.setup({
        cmd = { "clangd", "--background-index" },
      })
    end,
  },
  -- Autocomplete LSP
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
        },
        mapping = cmp.mapping.preset.insert(),
      })
    end,
  },

}
