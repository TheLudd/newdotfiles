local keymap = vim.api.nvim_set_keymap

local command = vim.api.nvim_create_user_command

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
command('X', 'x', {})
command('Xa', 'xa', {})
command('Q', 'q', {})
command('Qa', 'qa', {})
command('W', 'w', {})
command('Wa', 'wa', {})

keymap('n', ',e', ':e <C-R>=expand("%:h") . "/" <CR>', opts)
keymap('n', ',t', ':tabe <C-R>=expand("%:h") . "/" <CR>', opts)
keymap('n', ',s', ':split <C-R>=expand("%:h") . "/" <CR>', opts)
keymap('n', ',v', ':vsplit <C-R>=expand("%:h") . "/" <CR>', opts)
