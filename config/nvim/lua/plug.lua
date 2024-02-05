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
  'folke/tokyonight.nvim',

  -- treesitter for better syntax highlighting
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- mason
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- cmp completion engine
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',

  -- luasnip, required for cmp
  {
    'L3MON4D3/LuaSnip',
    -- follow latest release.
    version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',
  },
  'saadparwaiz1/cmp_luasnip',

  -- basics
  'tpope/vim-abolish', -- case insensitive search
  'terryma/vim-multiple-cursors',
  'tommcdo/vim-exchange',
  'AndrewRadev/splitjoin.vim',
  'tpope/vim-commentary',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'godlygeek/tabular',

  -- copilot
  'github/copilot.vim',
}
require('lazy').setup(plugins, { lockfile = vim.fn.expand('$XDG_DATA_HOME') .. '/nvim/lazy-lock.json' })
