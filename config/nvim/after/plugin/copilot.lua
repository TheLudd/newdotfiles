-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true

-- vim.gcopilot_node_command = '/usr/local/n/versions/node/22.21.1/bin/node'

-- vim.api.nvim_set_keymap('i', '<C-h>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
--
require('copilot').setup({
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = '<C-p>',
      jump_next = '<C-n>',
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right | bottom |
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    trigger_on_accept = false,
    keymap = {
      accept = '<C-h>',
      accept_word = '<C-w>',
      accept_line = '<C-l>',
      next = '<M-n>',
      prev = '<M-p>',
      dismiss = "<C-]>",
    },

  },
  nes = {
    enabled = false,
    auto_trigger = false,
    keymap = {
      accept_and_goto = false,
      accept = false,
      dismiss = false,
    },
  },
  auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
  logger = {
    file = vim.fn.stdpath("log") .. "/copilot-lua.log",
    file_log_level = vim.log.levels.OFF,
    print_log_level = vim.log.levels.WARN,
    trace_lsp = "off", -- "off" | "messages" | "verbose"
    trace_lsp_progress = false,
    log_lsp_messages = false,
  },
  copilot_node_command = '/usr/local/n/versions/node/22.21.1/bin/node',
  workspace_folders = {},
  copilot_model = "",
  disable_limit_reached_message = false, -- Set to `true` to suppress completion limit reached popup
  root_dir = function()
    return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
  end,
  should_attach = function(_, _)
    if not vim.bo.buflisted then
      -- logger.debug("not attaching, buffer is not 'buflisted'")
      return false
    end

    if vim.bo.buftype ~= "" then
      -- logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
      return false
    end

    return true
  end,
  server = {
    type = "nodejs", -- "nodejs" | "binary"
    custom_server_filepath = nil,
  },
  server_opts_overrides = {},
})

vim.keymap.set("i", "<C-P>", function()
  vim.cmd("Copilot panel")
end, { desc = "Open Copilot Panel" })
