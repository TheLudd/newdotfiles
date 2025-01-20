local ok, typescriptTools = pcall(require, 'typescript-tools')

if not ok then
  return
end

typescriptTools.setup { settings = { tsserver_file_preferences = { quotePreference = 'single' } } }

