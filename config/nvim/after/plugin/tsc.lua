require('tsc').setup({
  auto_open_qflist = true,
  auto_close_qflist = false,
  auto_focus_qflist = false,
  auto_start_watch_mode = false,
  use_trouble_qflist = false,
  use_diagnostics = false,
  run_as_monorepo = false,
  max_tsconfig_files = 20,
  enable_progress_notifications = true,
  enable_error_notifications = true,
  flags = {
    noEmit = true,
    watch = true,
  },
  hide_progress_notifications_from_history = true,
  spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  pretty_errors = true,
})
