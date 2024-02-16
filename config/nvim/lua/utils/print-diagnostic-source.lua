function PrintDiagnosticsSourceForCurrentLine()
    local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
    local buf_nr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(buf_nr, {lnum = line_num})

    for _, diag in ipairs(diagnostics) do
        print("Source: " .. diag.source .. ", Message: " .. diag.message)
    end
end
