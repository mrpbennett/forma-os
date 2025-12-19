-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jj", "<Esc>", { noremap = false })
vim.keymap.set("i", "jk", "<Esc>", { noremap = false })

vim.keymap.set("n", "aa", "A", { noremap = false }) -- Pressing 'aa' in normal mode will take you to the end of the line in insert mode

-- autoindent in insert mode
vim.keymap.set("i", "<CR", "<C-o>0<CR>", { noremap = true })

-- Move current line or selected block down/up in normal and visual modes
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down (insert mode)" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up (insert mode)" })

-- k9s
if vim.fn.executable("k9s") == 1 then
  vim.keymap.set("n", "<leader>k8", function()
    Snacks.terminal("k9s")
  end, { desc = "K9s (kubernetes)" })
end
