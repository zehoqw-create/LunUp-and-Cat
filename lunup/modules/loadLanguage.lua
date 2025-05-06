-- local file = io.open(system.pathForFile("lunup/languages/".."ru"..".json"), "r")
-- local language = plugins.json.decode(file:read("*a"))
-- io.close(file)
-- return(language)
local language = funsP['получить сохранение']('selectLanguage')
if language == '[]' then
    language = 'Русский'
end
local path = {
    English = 'eng',
    ['Русский'] = 'ru'
}

local file = io.open(system.pathForFile("lunup/languages/"..path[language]..".json"), "r")
local language = plugins.json.decode(file:read("*a"))
io.close(file)
return(language)