require "nvchad.mappings"

local M = {}

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
    ["<leader>rr"] = {"<cmd>Rest run<cr>", "Run request under the cursor"}
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

-- require("gitsigns")

-- more keybinds!
M.gitsigns = {
  n = {
    ["<leader>gsh"] = { "<cmd> Gitsigns stage_hunk <CR>", "Stage hunk" },
    ["<leader>gus"] = { "<cmd> Gitsigns undo_stage_hunk <CR>", "Undo stage hunk" },
    ["<leader>gub"] = { "<cmd> Gitsigns reset_buffer <CR>", "Undo stage buffer" },
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
      vim.keymap.set(mode, key, cmd, { desc = desc, unpack(opts)})
    end
  end
end
