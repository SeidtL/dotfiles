vim.cmd('source ' .. vim.fn.stdpath('config') .. '/vimrc')

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
KM.set({"n"}, "<Leader>t", ":NvimTreeToggle<Return>", { silent = true })

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
        dependencies = { 
            {
                'L3MON4D3/LuaSnip', 
                version = 'v2.*'
            },
            'xzbdmw/colorful-menu.nvim',
        },
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
                menu = {
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                width = { fill = true, max = 60 },
                                text = function(ctx)
                                    local highlights_info = require("colorful-menu").blink_highlights(ctx)
                                    if highlights_info ~= nil then
                                        return highlights_info.label
                                    else
                                        return ctx.label
                                    end
                                end,
                                highlight = function(ctx)
                                    local highlights = {}
                                    local highlights_info = require("colorful-menu").blink_highlights(ctx)
                                    if highlights_info ~= nil then
                                        highlights = highlights_info.highlights
                                    end
                                    for _, idx in ipairs(ctx.label_matched_indices) do
                                        table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                                    end
                                    return highlights
                                end,
                            },
                        },
                    },
                },
                -- ghost_text = { enabled = true },
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
            for server, config in pairs(opts.servers) do
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                vim.lsp.config(server, config)
            end
        end
    },
    {
        "machakann/vim-sandwich", 
        lazy = true
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
    -- { 
    --     "morhetz/gruvbox", 
    --     config = function()
    --         vim.cmd.colorscheme("gruvbox") 
    --         vim.g.airline_theme = "gruvbox"
    --         vim.opt.background = "dark"
    --         vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
    --     end 
    -- },
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
