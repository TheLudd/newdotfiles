local keymap = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }

-- set map leader
vim.g.mapleader = 'ä'

-- no ex mode
keymap('n', 'Q', '<nop>', opts)

-- yank rest of line
keymap('n', 'Y', 'y$', opts)

-- move easily between windows
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- move lines up and down
keymap('n', '-', ':normal ddp<CR>', opts)
keymap('n', '_', 'kddpk', opts)

-- move characters left and right
keymap('n', '<Right>', 'xp', opts)
keymap('n', '<Left>', 'hxph', opts)

-- sane close and save commands
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Wa wa')
vim.cmd('cnoreabbrev X x')
vim.cmd('cnoreabbrev Xa xa')
vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev Qa qa')

-- open new file in same directory
vim.cmd('map ,e :e <C-R>=expand("%:h") . "/" <CR>')
vim.cmd('map ,t :tabe <C-R>=expand("%:h") . "/" <CR>')
vim.cmd('map ,s :split <C-R>=expand("%:h") . "/" <CR>')
vim.cmd('map ,v :vsplit <C-R>=expand("%:h") . "/" <CR>')

-- go to test and source files
keymap('n', 'gss', ':lua TestFinder.openTestFile("vsplit", "")<cr>', opts)
keymap('n', 'gsS', ':lua TestFinder.openTestFile("vsplit", "f")<cr>', opts)
keymap('n', 'gse', ':lua TestFinder.openTestFile("edit", "")<cr>', opts)
keymap('n', 'gsE', ':lua TestFinder.openTestFile("edit", "f")<cr>', opts)
keymap('n', 'gcs', ':lua TestFinder.openSourceFile("rightbelow vsplit", "")<cr>', opts)
keymap('n', 'gcS', ':lua TestFinder.openSourceFile("rightbelow vsplit", "f")<cr>', opts)
keymap('n', 'gce', ':lua TestFinder.openSourceFile("edit", "")<cr>', opts)
keymap('n', 'gcE', ':lua TestFinder.openSourceFile("edit", "f")<cr>', opts)

-- Telescope
keymap('n', '<leader>f', ':Telescope find_files<CR>', opts)
keymap('n', '<leader>g', ':Telescope live_grep<CR>', opts)
keymap('n', '<leader>r', ':Telescope lsp_references<CR>', opts)
vim.cmd('cnoreabbrev ls :Telescope buffers<CR>')

-- search file with ctrl s
vim.cmd('nnoremap <C-s> :%s/')

-- copy visual selection to clipboard
keymap('v', '<C-c>', '"+y', opts)

-- Clear search with space
keymap('n', '<Space>', ':nohlsearch<CR>', opts)

-- git
keymap('n', 'ghc', ':GitBlameCopySHA<CR>', opts)
keymap('n', 'ghu', ':GitBlameOpenFileURL<CR>', opts)

-- disable :Delete to avoid confusion with :DB
vim.cmd('cnoreabbrev Delete echo "Use :Remove"')
