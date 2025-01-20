local ok, gitblame = pcall(require, 'gitblame')

if not ok then
  return
end

gitblame.setup {
  use_blame_commit_file_urls = true,
  message_when_not_committed = '',
  message_template = '<date> • <author> • <summary>',
  date_format = '%d/%m-%y',
  enabled = true,
}
