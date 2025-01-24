local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.cmd[[
    syntax on
    filetype on
    filetype indent on
    filetype plugin on
    filetype plugin indent on
]]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix" }
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.signcolumn = "number"
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.errorbells = false
vim.opt.visualbell = true
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.encoding = "utf-8"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.list = false
vim.opt.listchars = { tab = "► ", trail = "·" }
vim.opt.scrolloff = 4
vim.opt.tw = 0
vim.opt.indentexpr = ""
vim.opt.backspace = "indent,eol,start"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.laststatus = 2
vim.opt.autochdir = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wildoptions = "pum"
vim.opt.pumblend = 30
vim.opt.pumheight = 8
vim.opt.completeopt = "menu,menuone,noselect"
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l"

local opt = { noremap = true, silent = true }
local KM = vim.keymap
vim.g.mapleader = " "
KM.set({"i"}, "jk", "<esc>", opt)
KM.set({"n"}, "H", "<s-up>", opt)
KM.set({"n"}, "L", "<s-down>", opt)
KM.set({"n"}, "<leader>v", "<c-v>", opt)
KM.set({"n"}, "<leader>t", ":NvimTreeToggle<return>", opt)
KM.set({"n"}, "n", "nzz", opt)
KM.set({"n"}, "N", "Nzz", opt)
KM.set({"n"}, "S", ":w<Return>", opt)
KM.set({"n"}, "Q", ":q<Return>", opt)
KM.set({"n"}, "ss", ":split<Return><C-w>w", opt)
KM.set({"n"}, "sv", ":vsplit<Return><C-w>w", opt)
KM.set({"n"}, "<Space>", "<C-w>w", opt)
KM.set({"n"}, "sq", "<C-w>q", opt)
KM.set({"n"}, "sh", "<C-w>h", opt)
KM.set({"n"}, "sk", "<C-w>k", opt)
KM.set({"n"}, "sj", "<C-w>j", opt)
KM.set({"n"}, "sl", "<C-w>l", opt)
KM.set({"n"}, "s<left>", "<C-w>5<", opt)
KM.set({"n"}, "s<right>", "<C-w>5>", opt)
KM.set({"n"}, "s<up>", "<C-w>5+", opt)
KM.set({"n"}, "s<down>", "<C-w>-", opt)
KM.set({"x"}, "ga", "<Plug>(EasyAlign)", opt)
KM.set({"n"}, "ga", "<Plug>(EasyAlign)", opt)
KM.set({"n"}, "ff", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opt)
KM.set({"n"}, "<Leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
KM.set({"n"}, "<Leader>j", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opt)
KM.set({"n"}, "<S-Tab>", "<Plug>(cokeline-focus-prev)", { silent = true })
KM.set({"n"}, "<Tab>", "<Plug>(cokeline-focus-next)", { silent = true })
KM.set({"n"}, "<Leader>p", "<Plug>(cokeline-switch-prev)", { silent = true })
KM.set({"n"}, "<Leader>n", "<Plug>(cokeline-switch-next)", { silent = true })
KM.set({"n"}, "<Leader>n", "<Plug>(cokeline-switch-next)", { silent = true })
KM.set({"n"}, "<Leader>d", ":bd<Return>", { silent = true })

require("lazy").setup({
    {
        "williamboman/mason.nvim",
        dependencies = "williamboman/mason-lspconfig.nvim", 
        build = ":MasonUpdate",
        config = function() 
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "pyright" }
            })
        end 
    }, 
    {
        'saghen/blink.cmp',
        dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
        version = '*',
        opts = {
            snippets = {
                expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
                active = function(filter)
                    if filter and filter.direction then
                        return require('luasnip').jumpable(filter.direction)
                    end
                        return require('luasnip').in_snippet()
                end,
                jump = function(direction) require('luasnip').jump(direction) end,
            },
            keymap = { preset = 'super-tab' },
            completion = {
                list = {
                    selection = { 
                        preselect = true, 
                        auto_insert = true,
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
            }, 
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            signature = { enabled = true }, 
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp' },
        opts = {
          servers = {
            clangd = {}, 
            pyright = {
                settings = {
                    python = {
                        analysis = { typeCheckingMode = "off" }
                    },
                },
            },
          }
        },
        config = function(_, opts)
            local lspconfig = require('lspconfig')
            for server, config in pairs(opts.servers) do
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end
        end
    },
    {
        "machakann/vim-sandwich", 
        lazy = true
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { on_attach = on_attach_change },
    },
    {
        "windwp/nvim-autopairs", 
        event = "InsertEnter", 
        config = true, 
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }, 
        config = function() 
            local builtin = require('telescope.builtin')
            vim.keymap.set("n", '<leader>ff', builtin.find_files, {})
            vim.keymap.set("n", '<leader>fg', builtin.live_grep, {})
            vim.keymap.set("n", '<leader>fb', builtin.buffers, {})
            vim.keymap.set("n", '<leader>fh', builtin.help_tags, {})
        end
    },
    { 
        "folke/todo-comments.nvim", 
        dependencies = { "nvim-lua/plenary.nvim" }, 
        config = true 
    },
    { 
        "akinsho/toggleterm.nvim", 
        version = "*", 
        opts = {
            open_mapping = [[<c-\>]], 
            direction = 'float'
        },
    }, 
    { 
        -- automatically highlighting
        "RRethy/vim-illuminate" 
    },
    { "junegunn/vim-easy-align" },
    { 
        "lukas-reineke/indent-blankline.nvim", 
        config = function() 
            require("ibl").setup {} 
        end, 
    },
    { 
        "morhetz/gruvbox", 
        config = function()
            vim.cmd.colorscheme("gruvbox") 
            vim.g.airline_theme = "gruvbox"
            vim.opt.background = "dark"
        end 
    },
    { 
        'nvim-lualine/lualine.nvim', 
        dependencies = { 'nvim-tree/nvim-web-devicons' }, 
        opts = { 
            options = { theme = "gruvbox" } 
        }, 
    }, 
    { 
        "willothy/nvim-cokeline", 
        dependencies = { 
            "nvim-tree/nvim-web-devicons", 
            "nvim-lua/plenary.nvim" 
        }, 
        config = true 
    },
})
