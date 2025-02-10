vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.number = true -- set relative numbered lines
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hidden = true -- Allow switching to buffers before save
vim.opt.inccommand = 'split' -- Visualize preview of search/replace
vim.opt.undofile = true -- enable persistent undo
vim.opt.scrolloff = 0 -- always show n lines before/after the current one
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.tabstop = 2 -- number of spaces that a <Tab> in the file counts for
vim.opt.smartindent = true -- autoindent new lines
vim.opt.shiftwidth = 2 -- number of spaces to use for autoindent

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.feature-template",
  command = "set filetype=cucumber",
})

vim.diagnostic.config({
  float = {
    format = function(diagnostic)
      return string.format("%s\nSource: %s", diagnostic.message, diagnostic.source)
    end,
  },
})
