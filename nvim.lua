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
  autocmd filetype python,c,shell,bash,vim,cpp set sw=4
  autocmd filetype python,c,shell,bash,vim,cpp set ts=4
  autocmd filetype python,c,shell,bash,vim,cpp set sts=4
  autocmd filetype tex,lua set sw=2
  autocmd filetype tex,lua set ts=2
  autocmd filetype tex,lua set sts=2
  syntax on
  filetype on
  filetype indent on
  filetype plugin on
  filetype plugin indent on
]]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1
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
vim.opt.list = true
vim.opt.listchars = { tab = "► ", trail = "·" }
vim.opt.scrolloff = 4
vim.opt.tw = 0
vim.opt.indentexpr = ""
vim.opt.backspace = "indent,eol,start"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.laststatus = 2
vim.opt.autochdir = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wildoptions = "pum"
vim.opt.pumblend = 30
vim.opt.pumheight = 8
vim.opt.completeopt = "menu,menuone,noselect"
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l"

local opt = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.keymap.set({"i", "v"}, "jk", "<esc>", opt)
vim.keymap.set({"n"}, "H", "<s-up>", opt)
vim.keymap.set({"n"}, "L", "<s-down>", opt)
vim.keymap.set({"n"}, "<leader>v", "<c-v>", opt)
vim.keymap.set({"n"}, "<leader>t", ":nvimtreetoggle<return>", opt)
vim.keymap.set({"n"}, "n", "nzz", opt)
vim.keymap.set({"n"}, "N", "Nzz", opt)
vim.keymap.set({"n"}, "S", ":w<Return>", opt)
vim.keymap.set({"n"}, "Q", ":q<Return>", opt)
vim.keymap.set({"n"}, "ss", ":split<Return><C-w>w", opts)
vim.keymap.set({"n"}, "sv", ":vsplit<Return><C-w>w", opts)
vim.keymap.set({"n"}, "<Space>", "<C-w>w", opts)
vim.keymap.set({"n"}, "sq", "<C-w>q", opts)
vim.keymap.set({"n"}, "sh", "<C-w>h", opts)
vim.keymap.set({"n"}, "sk", "<C-w>k", opts)
vim.keymap.set({"n"}, "sj", "<C-w>j", opts)
vim.keymap.set({"n"}, "sl", "<C-w>l", opts)
vim.keymap.set({"n"}, "s<left>", "<C-w>5<", opts)
vim.keymap.set({"n"}, "s<right>", "<C-w>5>", opts)
vim.keymap.set({"n"}, "s<up>", "<C-w>5+", opts)
vim.keymap.set({"n"}, "s<down>", "<C-w>-", opts)
vim.keymap.set({"n"}, "<Leader>f", ":Files<Enter>", opts)
vim.keymap.set({"x"}, "ga", "<Plug>(EasyAlign)", opts)
vim.keymap.set({"n"}, "ga", "<Plug>(EasyAlign)", opts)
vim.keymap.set({"n"}, "ff", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
-- vim.keymap.set({"n"}, "<Leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
vim.keymap.set({"n"}, "<S-Tab>", "<Plug>(cokeline-focus-prev)", { silent = true })
vim.keymap.set({"n"}, "<Tab>", "<Plug>(cokeline-focus-next)", { silent = true })
vim.keymap.set({"n"}, "<Leader>p", "<Plug>(cokeline-switch-prev)", { silent = true })
vim.keymap.set({"n"}, "<Leader>n", "<Plug>(cokeline-switch-next)", { silent = true })
vim.keymap.set({"n"}, "<Leader>d", ":bd<Return>", { silent = true })

require("lazy").setup({
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "ray-x/lsp_signature.nvim",
      "onsails/lspkind.nvim",
      "hrsh7th/vim-vsnip",
      "hrsh7th/vim-vsnip-integ",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
    build = ":MasonUpdate",

    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Esc>"] = cmp.mapping.close(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "path" }
        }, {
          { name = "buffer" },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.order,
          }
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
              nvim_lsp = "[LSP]",
              path = "[Path]",
              buffer = "[Buffer]",
              emoji = "[Emoji]",
              omni = "[Omni]",
            }),
          }),
        },
      })
      -- Use buffer source for `/`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      -- Use cmdline & path source for ":"
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })



      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if vim.tbl_contains({ "null-ls" }, client.name) then  -- blacklist lsp
            return
          end
          require("lsp_signature").on_attach({
            hint_prefix = " ",
            max_height = 8,
            max_width = 80,
            handler_opts = { border = "none" },
          }, bufnr)
        end,
      })
      -- LSP server setup 
      require("mason").setup()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local lsp_servers = {
        clangd = { capabilities = capabilities }, 
        pyright = { capabilities = capabilities }, 
        texlab = { 
          capabilities = capabilities, 
          settings = {
            texlab = {
              build = {
                executable = "latexmk",
                args = {"-pdf", "-interaction=nonstopmode", "-synctex=1", "%f"},
                onSave = true
              },
              forwardSearch = {
                executable = "SumatraPDF",
                args = {"-reuse-instance", "%p", "-forward-search", "%f", "%l"}, 
              }, 
            }
          }
        }
      }
      local lsp_names = {}
      for k, _ in pairs(lsp_servers) do 
        table.insert(lsp_names, k)
      end
      require("mason-lspconfig").setup {
        ensure_installed = lsp_names
      }
      -- Setup lspconfig.
      for lsp_server, cfg in pairs(lsp_servers) do
        lspconfig[lsp_server].setup(cfg)
      end
    end
  },
  {"machakann/vim-sandwich", lazy = true},
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true, },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    opts = { on_attach = on_attach_change },
  },
  { "junegunn/fzf", dir = "~/.fzf", build = "./install --all", },
  { "junegunn/fzf.vim", },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "RRethy/vim-illuminate" },
  { "junegunn/vim-easy-align" },
  -- { "karb94/neoscroll.nvim" },
  { "lukas-reineke/indent-blankline.nvim", config = function() require("ibl").setup {} end, },
  { 
    "morhetz/gruvbox", 
    config = function()
      vim.cmd.colorscheme("gruvbox") 
      vim.g.airline_theme = "gruvbox"
    end 
  },
  -- {
  --   "embark-theme/vim",
  --   config = function()
  --     vim.cmd.colorscheme("embark")
  --     vim.g.airline_theme = "embark"
  --
  --   end,
  -- },
  { 
    'nvim-lualine/lualine.nvim', 
    dependencies = { 'nvim-tree/nvim-web-devicons' }, 
    opts = { options = { theme = "gruvbox" } } 
  }, 
  { 
    "willothy/nvim-cokeline", 
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" }, 
    config = true 
  },
})
