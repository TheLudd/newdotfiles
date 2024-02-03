local keymap = vim.api.nvim_set_keymap

local command = vim.api.nvim_create_user_command

local opts = { noremap = true, silent = true }

-- no ex mode
keymap('n', 'Q', '<nop>', opts)

-- move easily between windows
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- move lines up and down
keymap('n', '-', ':normal ddp<CR>', opts)
keymap('n', '_', 'kddpk', opts)

-- sane close and save commands
command('X', 'x', {})
command('Xa', 'xa', {})
command('Q', 'q', {})
command('Qa', 'qa', {})
command('W', 'w', {})
command('Wa', 'wa', {})
