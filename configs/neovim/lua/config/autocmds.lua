-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ⚠️  Disable auto comment continuation on file open
-- 🧠 Recommended Setup: Keep Auto-Comments in Python, Disable Elsewhere
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- Default: disable comment continuation
    vim.opt.formatoptions:remove({ "o", "r" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- Re-enable auto-comment continuation in Python
    vim.opt.formatoptions:append({ "o", "r" })
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "yaml",
--   callback = function()
--     vim.opt_local.shiftwidth = 2
--     vim.opt_local.tabstop = 2
--     vim.opt_local.softtabstop = 2
--     vim.opt_local.expandtab = true
--   end,
-- })
