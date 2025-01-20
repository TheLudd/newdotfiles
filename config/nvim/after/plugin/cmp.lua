local ok, cmp = pcall(require, 'cmp')

if not ok then
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to false to only confirm explicit selections
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer',   option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end } },
    { name = 'path' },
    { name = 'ultisnips' },
  }),
})

cmp.setup.cmdline('/', { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = 'path', option = { trailing_slash = true } }, { name = 'cmdline' } }),
})
