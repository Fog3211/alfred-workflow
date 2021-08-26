-- Date: 2021-08-25 22:29:34
-- LastEditTime: 2021-08-25 22:29:35
-- Description: 遍历目录执行批量 git pull 操作
--
-- Tips:需要提前安装lfs
-- brew install luarocks
-- luarocks install luafilesystem
--
local lfs = require 'lfs'

-- 只对'Code'和'Mine'目录操作
local targetGitDir = {'../Test'}
-- local targetGitDir = {'~/Code', '~/Mine'}

local runGitPullShell = function(filePath)
    local error1= os.execute('cd ' .. filePath .. '&& git pull --rebase')
    print(error1)
end

local attrdir = function(rootPath)
    for subFile in lfs.dir(rootPath) do
        if subFile ~= '.' and subFile ~= '..' then
            -- 过滤'.'和'..'目录
            local subFilePath = rootPath .. '/' .. subFile
            local subFileAttr = lfs.attributes(subFilePath)
            if subFileAttr.mode == 'directory' then
                runGitPullShell(subFilePath)
            end
        end
    end
end

local batchGitPull = function()
    for index, dir in pairs(targetGitDir) do attrdir(dir) end
end

batchGitPull()
