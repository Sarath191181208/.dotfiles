require "nvchad.mappings"

local telescope_config = require("configs.telescope-config")

local M = {}

-- Remove the split terminal keybinds
vim.keymap.del({ "n" }, "<leader>h")
vim.keymap.del({ "n" }, "<leader>v")

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>d"] = { '"_d', "delete without yanking" },
    ["<leader>p"] = { '[["_dP]]', "paste the text without copying " },

    -- some lsp keybinds
    ["<leader>lf"] = { vim.diagnostic.open_float, "Open float diagnostics" },

    -- sending tmux commands
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft <CR>", "Window left" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown <CR>", "Window down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp <CR>", "Window up" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight <CR>", "Window right" },

    -- sending rest api commands
    ["<leader>rr"] = { "<cmd>Rest run<cr>", "Run request under the cursor" },
    -- {
    --   "<leader>rl", "<cmd>Rest run last<cr>", "Re-run latest request",
    -- },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

M.nvimtree = {
  n = {
    ["<C-b>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  },
}

M.telescope = {
  n = {
    ["<C-F>"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>ff"] = { telescope_config.live_multigrep, "Live grep with file filter" }
  },
}

local gitsigns = require "gitsigns"

-- more keybinds!
M.gitsigns = {
  n = {
    ["<leader>hb"] = {
      function()
        gitsigns.blame_line { full = true }
      end,
      "Blame Full line",
    },
    ["<leader>hD"] = {
      function()
        gitsigns.diffthis "~"
      end,
      "show git diff this entire file",
    },
    ["<leader>hd"] = { gitsigns.diffthis, "show git diff this hunk" },
    ["<leader>hp"] = { gitsigns.preview_hunk, "preview hunk" },
    ["<leader>hR"] = { gitsigns.reset_buffer, "reset buffer" },
    ["<leader>hr"] = { gitsigns.reset_hunk, "reset hunk" },
    ["<leader>hS"] = { gitsigns.stage_buffer, "stage buffer" },
    ["<leader>hs"] = { gitsigns.stage_hunk, "stage hunk" },
    ["<leader>hu"] = { gitsigns.undo_stage_hunk, "undo_stage hunk" },
    ["<leader>tb"] = { gitsigns.toggle_current_line_blame, "toggle current line blame" },
    ["<leader>td"] = { gitsigns.toggle_deleted, "toggle deleted" },
  },

  v = {
    ["<leader>hr"] = {
      function()
        gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
      end,
      "reset hunk",
    },
    ["<leader>hs"] = {
      function()
        gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
      end,
      "stage hunk",
    },
  },
}

local neoscroll = require('neoscroll')
local neomaps = {
  ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 80 }) end,
  ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 80 }) end,
  ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 200 }) end,
  ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 200 }) end,
  ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 }) end,
  ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 100 }) end,
  ["zt"]    = function() neoscroll.zt({ half_win_duration = 150 }) end,
  ["zz"]    = function() neoscroll.zz({ half_win_duration = 150 }) end,
  ["zb"]    = function() neoscroll.zb({ half_win_duration = 150 }) end,
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(neomaps) do
  vim.keymap.set(modes, key, func)
end


-- iterate the map  and use vim.keymap.set
for _, map in pairs(M) do
  for mode, mode_maps in pairs(map) do
    for key, value in pairs(mode_maps) do
      -- local keymap = mode .. key
      local desc = value[2]
      local opts = value.opts or {}
      local cmd = value[1]
      vim.keymap.set(mode, key, cmd, { desc = desc, unpack(opts) })
    end
  end
end

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
