local status1, nvim_lsp = pcall(require, "lspconfig")
if not status1 then
  return
end

local status2, nvim_cmp_lsp = pcall(require, "cmp_nvim_lsp")
if not status2 then
  return
end

local protocol = require("vim.lsp.protocol")

-- Set up completion using nvim_cmp with LSP source
local capabilities = nvim_cmp_lsp.update_capabilities(protocol.make_client_capabilities())

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  update_in_insert = true,
  float = {
    source = "always", -- Or "if_many"
  },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  update_in_insert = false,
  --virtual_text = { spacing = 4, prefix = "●" },
  virtual_text = false,
  severity_sort = true,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]] ,
      false
    )
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  -- buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  -- buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  -- buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', '<leader>f', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  -- buf_set_keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  buf_set_keymap("n", "gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', opts)
  -- buf_set_keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  -- buf_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
  lsp_highlight_document(client)
end

-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
nvim_lsp.sumneko_lua.setup({
  on_attach = on_attach,
  settings = require("bill.lsp.sumneko_lua"),
  capabilities = capabilities,
})

nvim_lsp.jsonls.setup({
  on_attach = on_attach,
  settings = require("bill.lsp.jsonls").settings,
  setup = require("bill.lsp.jsonls").setup,
  capabilities = capabilities,
})

nvim_lsp.pyright.setup({
  on_attach = on_attach,
  settings = require("bill.lsp.pyright"),
  capabilities = capabilities,
})

nvim_lsp.clangd.setup({
  on_attach = on_attach,
  settings = require("bill.lsp.clangd"),
  cmd = {
    'clangd',
    '-log=verbose',
    '--query-driver=' .. os.getenv("QUERY_DRIVER"),
  },
  capabilities = capabilities,
})
