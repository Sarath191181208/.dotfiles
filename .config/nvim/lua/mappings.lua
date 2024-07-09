require "nvchad.mappings"

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
    },
    ["<leader>hD"] = {
      function()
        gitsigns.diffthis "~"
      end,
    },
    ["<leader>hd"] = { gitsigns.diffthis },
    ["<leader>hp"] = { gitsigns.preview_hunk },
    ["<leader>hR"] = { gitsigns.reset_buffer },
    ["<leader>hr"] = { gitsigns.reset_hunk },
    ["<leader>hS"] = { gitsigns.stage_buffer },
    ["<leader>hs"] = { gitsigns.stage_hunk },
    ["<leader>hu"] = { gitsigns.undo_stage_hunk },
    ["<leader>tb"] = { gitsigns.toggle_current_line_blame },
    ["<leader>td"] = { gitsigns.toggle_deleted },
  },

  v = {
    ["<leader>hr"] = {
      function()
        gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
      end,
    },
    ["<leader>hs"] = {
      function()
        gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
      end,
    },
  },
}

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
