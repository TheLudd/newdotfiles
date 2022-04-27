local packer = require('packer')
local util = require('packer.util')

local use = packer.use

packer.init({
  compile_path = util.join_paths(vim.fn.stdpath('data'), 'site', 'plugin', 'packer_compiled.lua'),
})

packer.startup(function()
  -- package manager
  use 'wbthomason/packer.nvim'

  -- lsp utils
  use 'neovim/nvim-lspconfig'
  use 'glepnir/lspsaga.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'

  -- colorscheme
  use 'nanotech/jellybeans.vim'

  -- completion
  use 'hrsh7th/nvim-cmp'
  use 'SirVer/ultisnips'
  use 'quangnguyen30192/cmp-nvim-ultisnips'

  -- unix commands. rename, sudowrite etc.
  use 'tpope/vim-eunuch'

  -- db plugin
  use 'tpope/vim-dadbod'

  -- basics
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-abolish' -- case insensitive search
  use 'terryma/vim-multiple-cursors'
  use 'tommcdo/vim-exchange'
  use 'AndrewRadev/splitjoin.vim'
  use 'tpope/vim-commentary'
  use 'sheerun/vim-polyglot'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
end)
