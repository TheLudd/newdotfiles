local ok, ts = pcall(require, 'nvim-treesitter')

if not ok then
  return
end

ts.install({
  'bash',
  'c',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'markdown',
  'pug',
  'python',
  'regex',
  'terraform',
  'tsx',
  'typescript',
  'vim',
  'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
