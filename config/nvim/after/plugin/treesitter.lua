local ok, treesitterConfigs = pcall(require, 'nvim-treesitter.configs')

if not ok then
  return
end

treesitterConfigs.setup {
  auto_install = false,
  highlight = { enable = true, disable = {} },
  indent = { enable = true, disable = {} },
  ensure_installed = {
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
  },
  sync_install = false,
}
