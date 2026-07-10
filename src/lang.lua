local config = require("config")
local log = require('logger')('lang')
local utils = require('utils')

local langs = {
    en = require("lang/en"),
    fr = require("lang/fr"),
    zh = require("lang/zh"),
    ne = {}, -- "en" backwards
}

for key, value in pairs(langs["en"]) do
    value = value:gsub("ö", "oe") -- ö in Lönn turns into soup backwards
    value = value:reverse()
    value, _ = value:gsub("}0{", "{0}")
    value, _ = value:gsub("}1{", "{1}")
    value, _ = value:gsub("S%%", "%%S")
    value, _ = value:gsub("s%%", "%%s") -- %s works, s% not that much
    value, _ = value:gsub("Y%%", "%%Y") -- same for date formats
    value, _ = value:gsub("m%%", "%%m")
    value, _ = value:gsub("d%%", "%%d")
    value, _ = value:gsub("H%%", "%%H")
    value, _ = value:gsub("M%%", "%%M")
    value, _ = value:gsub("S%%", "%%S")
    langs["ne"][key] = value
end

local function get(key)
    return langs[config.language][key] or langs["en"][key] or ('[' .. key .. ']')
end

local function updateSharp()
    local sharp = require("sharp")
    local csharp_keys = {}
    for _, lang in pairs(langs) do
        for key, _ in pairs(lang) do
            if key:find("^csharp_") ~= nil then
                csharp_keys[key] = true
            end
        end
    end
    for key, _ in pairs(csharp_keys) do
        csharp_keys[key] = get(key)
    end
    if sharp.setLanguageMap(utils.toJSON(csharp_keys)):result() ~= "ok" then
        log.error("Couldn't update the sharp language map! Things might go badly.")
    end
end

return { get = get, updateSharp = updateSharp }
