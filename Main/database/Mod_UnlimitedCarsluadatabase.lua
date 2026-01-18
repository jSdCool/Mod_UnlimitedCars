--The main initlization fine
local global = _G
local api = global.api
local pairs = global.pairs
local require = global.require
local table = require("Common.tableplus")

local Mod_UnlimitedCarsLuaDatabase = module(...)

Mod_UnlimitedCarsLuaDatabase.AddContentToCall = function(_tContentToCall)    
    if not global.api.acse or global.api.acse.versionNumber < 0.7 then
        return
    end

    table.insert(_tContentToCall, Mod_UnlimitedCarsLuaDatabase)
    table.insert(_tContentToCall, require("Database.UnlimitedCarsDatabaseManager"))
end

Mod_UnlimitedCarsLuaDatabase.Init = function()
    api.debug.Trace("Mod_UnlimitedCarsLuaDatabase.Init()")
end

Mod_UnlimitedCarsLuaDatabase.Activate = function()
    api.debug.Trace("Mod_UnlimitedCarsLuaDatabase.Activate()")
end