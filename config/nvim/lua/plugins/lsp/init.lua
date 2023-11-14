local lsp = {{
    "neovim/nvim-lspconfig",
    dependencies = {{
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            build = ":MasonUpdate"
        },
        config = function()
            local servers = {"bashls", "lua_ls", "gopls", "sqlls", "jsonls", "yamlls", "tsserver", "intelephense"}
            require("mason").setup()
            require("mason-lspconfig").setup {
                ensure_installed = servers
            }
        end
    }, {
        "hrsh7th/nvim-cmp",
        dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", {
            "hrsh7th/cmp-vsnip",
            dependencies = {"hrsh7th/vim-vsnip", "rafamadriz/friendly-snippets"}
        }, {
            "windwp/nvim-autopairs",
            config = function()
                require("plugins.lsp.nvim-autopairs")
            end
        }},
        config = function()
            require("plugins.lsp.nvim-cmp")
        end
    }},
    -- event = {"BufReadPre"},
    event = {"BufReadPre", "BufNewFile"},
    config = function()
        require("plugins.lsp.nvim-lspconfig")
    end
}, {
    "ray-x/go.nvim",
    dependencies = {"ray-x/guihua.lua"},
    config = function()
        require("plugins.lsp.go")
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}}

return lsp
