-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "jk", "<Esc>", { silent = true })

map("n", "H", "^", { silent = true })
map("n", "L", "$", { silent = true })
map("n", "<leader>v", "<c-v>", { silent = true })
map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })
map("n", "S", ":w<Return>", { silent = true })
map("n", "Q", ":q<Return>", { silent = true })
map("n", "ss", ":split<Return><c-w>w", { silent = true })
map("n", "sv", ":vsplit<Return><c-w>w", { silent = true })
map("n", "<Space>", "<c-w>w", { silent = true })
map("n", "sq", "<c-w>q", { silent = true })
map("n", "sh", "<c-w>h", { silent = true })
map("n", "sk", "<c-w>k", { silent = true })
map("n", "sj", "<c-w>j", { silent = true })
map("n", "sl", "<c-w>l", { silent = true })
map("n", "s<left>", "<c-w>5<", { silent = true })
map("n", "s<right>", "<c-w>5>", { silent = true })
map("n", "s<up>", "<c-w>5+", { silent = true })
map("n", "s<down>", "<c-w>-", { silent = true })
map("n", "<PageUp>", "<c-u>zz", { silent = true })
map("n", "<PageDown>", "<c-d>zz", { silent = true })
