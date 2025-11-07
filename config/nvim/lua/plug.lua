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
  {
      "neovim/nvim-lspconfig",
      version = "v0.1.7",
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- colorschemes
  'folke/tokyonight.nvim',
  'nanotech/jellybeans.vim',

  -- typescript tools instead of typescript language server
  { 'pmizio/typescript-tools.nvim',    dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },

  -- treesitter for better syntax highlighting
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- telscope
  { 'nvim-telescope/telescope.nvim',   dependencies = { 'nvim-lua/plenary.nvim' } },

  -- mason
  {
    'williamboman/mason.nvim',
    version = '^1', -- latest v1.x
  },
  {
    'williamboman/mason-lspconfig.nvim',
    version = '^1', -- latest v1.x
  },

  -- cmp completion engine
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',

  -- ultisnips
  'SirVer/ultisnips',
  'quangnguyen30192/cmp-nvim-ultisnips',

  -- rust
  'rust-lang/rust.vim',

  -- basics
  'tpope/vim-abolish', -- case insensitive search
  'tpope/vim-eunuch',  -- unix commands
  'terryma/vim-multiple-cursors',
  'tommcdo/vim-exchange',
  'AndrewRadev/splitjoin.vim',
  'tpope/vim-commentary',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  { "shirosaki/tabular", branch = "fix_leading_spaces" },

  -- copilot
  'github/copilot.vim',

  -- git
  'f-person/git-blame.nvim',
  'tpope/vim-fugitive',

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

  -- terraform
  {
    'hashivim/vim-terraform',
    ft = { 'terraform' }, -- Load only for Terraform files
    config = function()
      vim.g.terraform_align = 1
      vim.g.terraform_fold_sections = 1
    end
  },
}
require('lazy').setup(plugins, { lockfile = vim.fn.expand('$XDG_DATA_HOME') .. '/nvim/lazy-lock.json' })
