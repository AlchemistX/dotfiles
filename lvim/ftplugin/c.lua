local manager = require "lvim.lsp.manager"

if os.getenv("QUERY_DRIVER") then
  manager.setup("clangd", {
    cmd = {
      "clangd",
      "--query-driver=" .. os.getenv("QUERY_DRIVER"),
    },
  })
else
  manager.setup("clangd", { cmd = { "clangd", }, })
end
