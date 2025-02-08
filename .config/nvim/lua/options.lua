require "nvchad.options"

vim.wo.relativenumber = true
vim.o.wrap = false
vim.opt.showmode = false

--adding custom snippets
vim.g.snipmate_snippets_path = vim.fn.stdpath "config" .. "/lua/snippets"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- setting file type for .tmux files
vim.cmd([[
  augroup filetype_tmux
    autocmd!
    autocmd BufRead,BufNewFile .tmux set filetype=sh
  augroup END
]])
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
