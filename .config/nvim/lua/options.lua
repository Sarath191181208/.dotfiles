require "nvchad.options"

vim.wo.relativenumber = true
vim.o.wrap = false
vim.opt.showmode = false

--adding custom snippets
vim.g.snipmate_snippets_path = vim.fn.stdpath "config" .. "/lua/snippets"

-- setting file type for .tmux files
vim.cmd([[
  augroup filetype_tmux
    autocmd!
    autocmd BufRead,BufNewFile .tmux set filetype=sh
  augroup END
]])
