vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

vim.g.copilot_node_command = '/usr/local/n/versions/node/22.21.1/bin/node'

vim.api.nvim_set_keymap('i', '<C-h>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
