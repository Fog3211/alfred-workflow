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
-- local targetGitDir = {os.getenv('HOME')..'../Test'}
local targetGitDir = {
    Code = {wifi = 'HUPU.WORK.5G', dir = os.getenv('HOME') .. '/Code'},
    Mine = {wifi = '*', dir = os.getenv('HOME') .. '/Mine'}
}

local runGitPullShell = function(filePath)
    os.execute('cd ' .. filePath .. '&& git pull --rebase --all')
end

local attrdir = function(rootPath, wifi)
    local currWifi = hs.wifi.currentNetwork()
    -- 对wifi进行判断，内网才请求工作目录
    if (currWifi == wifi) or wifi == '*' then
        for file in lfs.dir(rootPath) do
            if file ~= '.' and file ~= '..' then
                -- 过滤'.'和'..'目录
                local filePath = rootPath .. '/' .. file
                local fileAttr = lfs.attributes(filePath)
                if fileAttr.mode == 'directory' then
                    for subFile in lfs.dir(filePath) do
                        -- 先检查当前项目是否有.git，没有的话跳过
                        if subFile == '.git' then
                            runGitPullShell(filePath)
                        end
                    end
                end
            end
        end
    end
end

local batchGitPull = function()
    for _, item in pairs(targetGitDir) do attrdir(item.dir, item.wifi) end
end

-- 用于和alfred配合做自定义事件监听
local configFileWatcher = hs.pathwatcher.new(
                              os.getenv('HOME') ..
                                  '/.hammerspoon/log/batch-git-pull.log',
                              batchGitPull)
configFileWatcher:start()
