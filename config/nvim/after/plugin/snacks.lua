local ok, snacks = pcall(require, 'snacks')

if not ok then
  return
end

snacks.setup({
  input = {
    enabled = true,
    icon = ' ',
    icon_pos = 'left',
    prompt_pos = 'title',
    win = {
      style = 'input',
      relative = 'editor',
      border = 'rounded',
      title_pos = 'center',
      row = math.floor(vim.o.lines / 2) - 1,
      col = math.floor(vim.o.columns / 2) - 20,
      width = 40,
      keys = {
        i_esc = { '<esc>', { 'cmp_close', 'cancel' }, mode = 'i' },
        n_esc = { '<esc>', 'cancel', mode = 'n' },
      },
      on_win = function()
        vim.cmd('stopinsert')
      end,
    },
  },
})

-- Use telescope or native for ui.select instead of broken snacks picker
-- vim.ui.select stays as default (or use telescope-ui-select if installed)
