local term = vim.fn.getenv('TERM')

if term == 'dvtm-256color' then
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "jellybeans",
    callback = function()
      vim.cmd("source " .. vim.fn.stdpath("config") .. "/after/colors/jellybeans.vim")
    end,
  })

  vim.cmd [[colorscheme jellybeans]]

  -- fix diagnostic popup background and border
  -- vim.api.nvim_set_hl(0, "NormalFloat", { ctermfg = 187, ctermbg = 235 })
  -- vim.api.nvim_set_hl(0, "FloatBorder", { ctermfg = 244, ctermbg = 235 })
  -- vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { ctermfg = 203, ctermbg = 235 })
  -- vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn",  { ctermfg = 179, ctermbg = 235 })
  -- vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo",  { ctermfg = 75,  ctermbg = 235 })
  -- vim.api.nvim_set_hl(0, "DiagnosticFloatingHint",  { ctermfg = 107, ctermbg = 235 })

  -- vim.api.nvim_create_autocmd("ColorScheme", {
  --   pattern = "jellybeans",
  --   callback = function()
  --     local set = vim.api.nvim_set_hl
  --     local fg = function(group, color) set(0, group, { ctermfg = color }) end
  --     fg("DiagnosticError", 203)
  --     fg("DiagnosticWarn", 179)
  --     fg("DiagnosticInfo", 75)
  --     fg("DiagnosticHint", 107)
  --     fg("DiagnosticOk", 114)
  --     set(0, "DiagnosticUnderlineError", { cterm = "underline", ctermfg = 203 })
  --     set(0, "DiagnosticUnderlineWarn",  { cterm = "underline", ctermfg = 179 })
  --     set(0, "DiagnosticUnderlineInfo",  { cterm = "underline", ctermfg = 75 })
  --     set(0, "DiagnosticUnderlineHint",  { cterm = "underline", ctermfg = 107 })
  --     set(0, "LspReferenceText",  { ctermbg = 236 })
  --     set(0, "LspReferenceRead",  { ctermbg = 236 })
  --     set(0, "LspReferenceWrite", { ctermbg = 236 })
  --     set(0, "LspInlayHint", { ctermfg = 244 })
  --     set(0, "LspCodeLens", { ctermfg = 240 })
  --     set(0, "LspCodeLensSeparator", { ctermfg = 239 })
  --   end,
  -- })
else
  vim.cmd [[colorscheme cyberpunk]]
end
