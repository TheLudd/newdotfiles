local term = vim.fn.getenv('TERM')

if term ~= 'dvtm-256color' then require('tokyonight').setup() end

