local paq = require('paq')

paq({
  -- package manager
  'savq/paq-nvim',

  -- lsp utils
  'neovim/nvim-lspconfig',
  'glepnir/lspsaga.nvim',
  'nvim-treesitter/nvim-treesitter',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/nvim-cmp',

  -- colorscheme
  'nanotech/jellybeans.vim',

  -- completion
  'hrsh7th/nvim-cmp',
  'SirVer/ultisnips',
  'quangnguyen30192/cmp-nvim-ultisnips',

  -- unix commands. rename, sudowrite etc.
  'tpope/vim-eunuch',

  -- db plugin
  'tpope/vim-dadbod',

  -- basics
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-abolish', -- case insensitive search
  'terryma/vim-multiple-cursors',
  'tommcdo/vim-exchange',
  'AndrewRadev/splitjoin.vim',
  'tpope/vim-commentary',

  'sheerun/vim-polyglot',

  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
})
