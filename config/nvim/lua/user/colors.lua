local term = vim.fn.getenv('TERM')

if term == 'dvtm-256color' then
  vim.cmd [[colorscheme jellybeans]]
else
  vim.cmd [[colorscheme tokyonight-night]]
end
