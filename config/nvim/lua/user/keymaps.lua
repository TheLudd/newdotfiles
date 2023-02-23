function splitFilePath(filePath)
  -- remove leading './' if present
  if filePath:sub(1, 2) == './' then filePath = filePath:sub(3) end

  local folders = {}
  local fileName = ''
  local suffix = ''

  -- split file path into folder and file name/suffix
  for folder, separator, file in filePath:gmatch('(.+)([/\\])(.+)') do
    table.insert(folders, folder)
    fileName = file
  end

  -- if no folder separators found, assume file name is in current directory
  if fileName == '' then fileName = filePath end

  -- split file name into name and suffix
  for name, separator, suf in fileName:gmatch('(.+)(%.)(.+)') do
    fileName = name
    suffix = suf
  end
  folders = table.concat(folders, '/')
  return folders, fileName, suffix
end

function get_test_file()
  local file_path = vim.fn.expand('%')
  local folders, fileName, suffix = splitFilePath(file_path)

  local test_file

  test_file = folders .. '/' .. fileName .. '-test.' .. suffix
  if io.open(test_file) then return test_file end

  local testFolders = folders:gsub('lib', 'test', 1):gsub('src', 'test', 1)

  test_file = testFolders .. '/' .. fileName .. '.' .. suffix
  if io.open(test_file) then return test_file end

  test_file = testFolders .. '/' .. fileName .. '-test.' .. suffix
  if io.open(test_file) then return test_file end

  local testUnitFolders = folders:gsub('lib', 'test/unit', 1):gsub('src', 'test/unit', 1)

  test_file = testUnitFolders .. '/' .. fileName .. '.' .. suffix
  if io.open(test_file) then return test_file end

  test_file = testUnitFolders .. '/' .. fileName .. '-test.coffee'
  if io.open(test_file) then return test_file end

  return nil
end

function open_test_file(mode)
  local test_file = get_test_file()
  if (test_file ~= nil) then vim.cmd(mode .. ' ' .. test_file) end
end

local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- jump to test (spec) file
keymap('n', 'gss', ':lua open_test_file("vsplit")<cr>', opts)
keymap('n', 'gse', ':lua open_test_file("edit")<cr>', opts)
