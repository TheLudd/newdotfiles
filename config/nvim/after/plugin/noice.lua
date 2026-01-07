local ok, noice = pcall(require, 'noice')

if not ok then
  return
end

noice.setup({
  cmdline = {
    view = 'cmdline_popup',
    format = {
      cmdline = { icon = '>' },
      search_down = { icon = '/' },
      search_up = { icon = '?' },
      filter = { icon = '$' },
      lua = { icon = '' },
      help = { icon = '?' },
    },
  },
  views = {
    cmdline_popup = {
      position = {
        row = '50%',
        col = '50%',
      },
      size = {
        width = 60,
        height = 'auto',
      },
      border = {
        style = 'rounded',
      },
    },
    popupmenu = {
      position = {
        row = '53%',
        col = '50%',
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = 'rounded',
      },
    },
  },
  messages = {
    view = 'mini',
  },
  popupmenu = {
    backend = 'cmp',
  },
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  presets = {
    bottom_search = false,
    command_palette = false,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
})
