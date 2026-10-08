local M = {}

-- Format with biome when it is attached, otherwise with any formatting client.
M.format = function()
  local has_biome = #vim.lsp.get_clients({ bufnr = 0, name = 'biome' }) > 0
  vim.lsp.buf.format({
    async = false,
    filter = function(client) return not has_biome or client.name == 'biome' end,
  })
end

return M
