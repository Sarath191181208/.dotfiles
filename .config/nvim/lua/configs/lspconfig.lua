require("nvchad.configs.lspconfig").defaults()
local util = require "lspconfig/util"
local lspconfig = require "lspconfig"

local servers = { "html", "cssls", "clangd", "tailwindcss", "docker_compose_language_service", "tflint", "sqls"}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
lspconfig.ts_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

lspconfig.dockerls.setup {
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = true,
        },
      },
    }
  }
}

lspconfig.jdtls.setup {
  on_attach = nvlsp.on_attach,
  capabilities  = nvlsp.capabilities,
  single_file_support = true,
}


lspconfig.svelte.setup {
  on_attach = nvlsp.on_attach,
  capabilities  = nvlsp.capabilities,
  filetypes = { "svelte" },
  root_dir = util.root_pattern("package.json", ".git"),
}


local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
  ".py",
}

lspconfig.pyright.setup {
  on_attach = nvlsp.on_attach,
  capabilities  = nvlsp.capabilities,
  filetypes = { "python", "py" },
  single_file_support = true,
  root_dir = util.root_pattern(root_files),
}

lspconfig.gopls.setup {
  on_attach = nvlsp.on_attach,
  capabilities  = nvlsp.capabilities,
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

lspconfig.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}


lspconfig.dartls.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  -- on_init = nvlsp.on_init,
}
