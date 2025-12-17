local function swapExtension(path)
  if path:match('.js$') then
    return path:gsub('.js$', '.ts')
  else
    return path:gsub('.ts$', '.js')
  end
end

local function replaceLibWithTest(path) return path:gsub('/lib/', '/test/'):gsub('^lib/', 'test/') end
local function appendTestSuffix(path) return path:gsub('(%..+)$', '-test%1') end
local function appendDotTestSuffix(path) return path:gsub('(%..+)$', '.test%1') end
local function changeExtensionToCoffee(path) return path:gsub('(%..+)$', '.coffee') end
local function removeTestSuffixAndChangeFolder(path) return path:gsub('-test', ''):gsub('.test', ''):gsub('/test/', '/lib/'):gsub('^test/', 'lib/') end

local function generateSourceFileCandidates(file)
  local paths = {}
  local basePath = removeTestSuffixAndChangeFolder(file)
  paths[1] = basePath
  paths[2] = swapExtension(basePath)

  if file:match('%.coffee$') then
    paths[3] = basePath:gsub('%.coffee$', '.js')
    paths[4] = basePath:gsub('%.coffee$', '.ts')
  end

  return paths
end

TestFinder = {}

local function generateTestFileCandidates(file)
  local paths = {}
  paths[1] = appendTestSuffix(file)
  paths[2] = appendDotTestSuffix(file)
  paths[3] = swapExtension(paths[1])
  paths[4] = replaceLibWithTest(file)
  paths[5] = swapExtension(paths[3])
  paths[6] = appendTestSuffix(paths[3])
  paths[7] = swapExtension(paths[5])
  paths[8] = changeExtensionToCoffee(paths[5])

  return paths
end

local function tryOpenFiles(filePaths)
  for _, filePath in ipairs(filePaths) do
    local file = io.open(filePath, 'r')
    if file then
      file:close() -- Close the file immediately if found and opened
      return filePath
    end
  end
end

local function openFile(mode, flags, findCandidates)
  local currentFile = vim.fn.expand('%')
  local candidates = findCandidates(currentFile)
  local sourceFile = tryOpenFiles(candidates)

  if sourceFile == nil and flags and flags:find('f') then
    sourceFile = candidates[1] -- Open the first candidate if 'f' is present
  end

  if sourceFile then
    vim.cmd(mode .. ' ' .. sourceFile)
  end
end

function TestFinder.openTestFile(mode, flags)
  openFile(mode, flags, generateTestFileCandidates)
end

function TestFinder.openSourceFile(mode, flags)
  openFile(mode, flags, generateSourceFileCandidates)
end
