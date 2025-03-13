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
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- add any opts here
      -- for example
      provider = "openai",
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o",       -- your desired model (or use gpt-4o, etc.)
        timeout = 30000,        -- timeout in milliseconds
        temperature = 0,        -- adjust if needed
        max_tokens = 4096
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick",       -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",            -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
require('lazy').setup(plugins, { lockfile = vim.fn.expand('$XDG_DATA_HOME') .. '/nvim/lazy-lock.json' })
