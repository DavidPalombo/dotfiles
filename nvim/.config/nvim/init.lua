-- === Editor Settings ===
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- === Bootstrap lazy.nvim ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

-- === Plugins ===
require("lazy").setup(
    {
        {"neovim/nvim-lspconfig"},
        {"williamboman/mason.nvim"},
        {"williamboman/mason-lspconfig.nvim"},
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip"
            }
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter").setup(
                    {
                        ensure_installed = {
                            "python",
                            "lua",
                            "toml",
                            "yaml",
                            "json",
                            "java",
                            "javascript",
                            "typescript",
                            "tsx",
                            "c_sharp",
                            "c",
                            "cpp"
                        },
                        highlight = {enable = true}
                    }
                )
            end
        },
        {
            "nvim-neo-tree/neo-tree.nvim",
            dependencies = {"nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons"},
            opts = {
                window = {
                    position = "right"
                }
            }
        },
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {"nvim-lua/plenary.nvim"}
        },
        {"lewis6991/gitsigns.nvim"},
        {"nvim-lualine/lualine.nvim"},
        {"akinsho/toggleterm.nvim"},
        {"Mofiqul/vscode.nvim"}
    }
)

-- === Plugin Configuration ===
require("vscode").setup({
    italic_comments = true,
})
vim.cmd.colorscheme("vscode")

require("mason").setup()
require("mason-lspconfig").setup(
    {
        ensure_installed = {
            "pyright", -- Python
            "jdtls", -- Java
            "ts_ls", -- JavaScript/TypeScript
            "omnisharp", -- C#
            "clangd" -- C/C++
        }
    }
)

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {"pyright", "jdtls", "ts_ls", "omnisharp", "clangd"}

for _, server in ipairs(servers) do
    vim.lsp.config[server] = {
        capabilities = capabilities
    }
end

vim.lsp.enable(servers)

-- Autocompletion
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup(
    {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        mapping = cmp.mapping.preset.insert(
            {
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({select = true}),
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item()
            }
        ),
        sources = cmp.config.sources(
            {
                {name = "nvim_lsp"},
                {name = "luasnip"},
                {name = "buffer"},
                {name = "path"}
            }
        )
    }
)

require("gitsigns").setup()
require("lualine").setup({
options = { theme = "vscode" }
})
require("toggleterm").setup({
    open_mapping = [[<leader>t]],
    direction = "horizontal"
})

-- === Keybindings ===
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
