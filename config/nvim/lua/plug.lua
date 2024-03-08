local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  'neovim/nvim-lspconfig',
  'folke/neodev.nvim',

  -- colorschemes
  'folke/tokyonight.nvim',
  'nanotech/jellybeans.vim',

  -- typescript tools instead of typescript language server
  { 'pmizio/typescript-tools.nvim',    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' }, opts = {} },

  -- treesitter for better syntax highlighting
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- telscope
  { 'nvim-telescope/telescope.nvim',   dependencies = { 'nvim-lua/plenary.nvim' } },

  -- mason
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- cmp completion engine
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',

  -- ultisnips
  'SirVer/ultisnips',
  'quangnguyen30192/cmp-nvim-ultisnips',

  -- basics
  'tpope/vim-abolish', -- case insensitive search
  'tpope/vim-eunuch',  -- unix commands
  'terryma/vim-multiple-cursors',
  'tommcdo/vim-exchange',
  'AndrewRadev/splitjoin.vim',
  'tpope/vim-commentary',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'godlygeek/tabular',

  -- copilot
  'github/copilot.vim',

  -- git
  'f-person/git-blame.nvim',

  -- db plugin
  'tpope/vim-dadbod',

  -- coffee specific
  'kchmck/vim-coffee-script',


  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
  },
}
require('lazy').setup(plugins, { lockfile = vim.fn.expand('$XDG_DATA_HOME') .. '/nvim/lazy-lock.json' })
