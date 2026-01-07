-- Custom LSP rename with floating window that starts in normal mode
local M = {}

function M.rename()
  local current_word = vim.fn.expand('<cword>')
  local row = math.floor(vim.o.lines / 2) - 1
  local col = math.floor(vim.o.columns / 2) - 20
  local width = 40

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { current_word })

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = 1,
    style = 'minimal',
    border = 'rounded',
    title = ' Rename ',
    title_pos = 'center',
  })

  -- Set buffer options
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false

  -- Start in normal mode with cursor at end of word
  vim.cmd('stopinsert')
  vim.api.nvim_win_set_cursor(win, { 1, #current_word - 1 })

  -- Keymaps for the rename buffer
  local opts = { buffer = buf, silent = true, nowait = true }

  -- Confirm with Enter (both normal and insert mode)
  vim.keymap.set({ 'n', 'i' }, '<CR>', function()
    local new_name = vim.trim(vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or '')
    vim.api.nvim_win_close(win, true)
    if new_name and #new_name > 0 and new_name ~= current_word then
      vim.lsp.buf.rename(new_name)
    end
  end, opts)

  -- Cancel with Escape (normal mode)
  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
  end, opts)

  -- Cancel with Escape (insert mode) - go to normal mode first
  vim.keymap.set('i', '<Esc>', function()
    vim.cmd('stopinsert')
  end, opts)

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, opts)
end

return M
