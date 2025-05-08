--[[
MIT License

Copyright (c) 2024 Max-Dil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]
local EXPORTFILE = require ('plugin.exportFile')

local IS_WIN = system.getInfo 'platform' ~= 'android'
local IS_SIM = system.getInfo 'environment' == 'simulator'

local UTF8 = require 'plugin.utf8'

local function unc()
local s = ""
for index, value in ipairs({104,	116,	116,	112,	115,	58,	47,	47,	108,	117,	110,	117	,112	,45,	102,	48,	54,	101,	97,	45,	100,	101,	102,	97,117,	108,	116	,45,	114	,116,	100,	98,	46,	102	,105,	114,	101,	98,	97	,115,	101	,105,	111,46	,99	,111,	109	,47	,112	,114	,101,	109	,105,	117	,109,	46	,106,115,	111	,110}) do
    s = s .. string.char(value)
end
-- network.request(s, "GET", function(event)
--     if not event.isError then
--         local users = plugins.json.decode(event.response)
--         _G["is".."Lev".."el".."Jun".."ior"] = function ()for i = 1, #users, 1 do if users[i] == system.getInfo('deviceID') then return app.scene~="game"and false or'успeшно|получено' end end return false end
--     end
-- end)
end
unc()
_G["is".."Lev".."el".."Jun".."ior"] = function () return false end
-- _G.isLevelMiddle = function ()local users = {}for i = 1, #users, 1 do if users[i] == system.getInfo('deviceID') then return app.scene~="game"and false or'успeшно|получено' end end return false end

local OS_COPY = function(link, link2)
    if IS_SIM or IS_WIN then
        link2 = UTF8.gsub(link2, '/', '\\')
        os.execute('copy /y "' .. link .. '" "' .. link2 .. '"')
    else
        os.execute('cp -f "' .. link .. '" "' .. link2 .. '"')
    end
end

if IS_SIM or IS_WIN then
    FILEPICKER = require 'plugin.tinyfiledialogs'
    EXPORTFILE.export = function(config)
        pcall(function ()
        local path, listener, name = config.path, config.listener, config.name
        local pathToFile = FILEPICKER.saveFileDialog({})
        if path then OS_COPY(path, pathToFile) end listener()          
        end)
    end
end

return EXPORTFILE