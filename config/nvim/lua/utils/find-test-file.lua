local function swapExtension(path)
  if path:match('.js$') then
    return path:gsub('.js$', '.ts')
  else
    return path:gsub('.ts$', '.js')
  end
end

local function replaceLibWithTest(path) return path:gsub('/lib/', '/test/'):gsub('^lib/', 'test/') end
local function appendTestSuffix(path) return path:gsub('(%..+)$', '-test%1') end
local function changeExtensionToCoffee(path) return path:gsub('(%..+)$', '.coffee') end

TestFinder = {}

local function generateTestFileCandidated(file)
  local paths = {}
  paths[1] = appendTestSuffix(file)
  paths[2] = swapExtension(paths[1])
  paths[3] = replaceLibWithTest(file)
  paths[4] = swapExtension(paths[3])
  paths[5] = appendTestSuffix(paths[3])
  paths[6] = swapExtension(paths[5])
  paths[7] = changeExtensionToCoffee(paths[5])

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

function TestFinder.openTestFile(mode)
  local currentFile = vim.fn.expand('%')
  local candidates = generateTestFileCandidated(currentFile)
  local testFile = tryOpenFiles(candidates)
  if (testFile ~= nil) then vim.cmd(mode .. ' ' .. testFile) end
end
