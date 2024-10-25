local lspconfig = require "lspconfig"

-- Function to check if .fvm exists in the root folder
local function isFvmRoot()
  local fvm_check = io.open(vim.fn.getcwd() .. '/.fvm')
  if fvm_check ~= nil then
    io.close(fvm_check)
    return true
  else
    return false
  end
end

-- Custom command to run dart_language_server using FVM
local custom_dartls_cmd = {
  'fvm',
  'dart',
  'language-server',
  '--protocol=lsp'
}

-- Check if .fvm exists in the root folder, if yes, update the command
if isFvmRoot() then
  custom_dartls_cmd = {
    'fvm',
    'dart',
    'language-server',
    '--protocol=lsp'
  }
end


local nvlsp = require "nvchad.configs.lspconfig"

lspconfig.dartls.setup {
  cmd = custom_dartls_cmd,
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  on_init = nvlsp.on_init,
}
