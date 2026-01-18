local global = _G
local api = global.api
local pairs = pairs
local ipairs = ipairs
local type = type
local table = global.table
local tostring = global.tostring
local GameDatabase = require("Database.GameDatabase")
local UnlimitedCarsDatabaseManager = module(...)
-- Get access to the Game Database interface
local database = global.api.database

local dbgTrace = function(_line)
    api.debug.Trace("[MOD] Unlimited Cars: " .. _line)
    -- end
end

--
-- Initialization functions. These functions are called during the initialization process only
--

-- This method will be called when our manager gets initialized, early in the game launch after
-- all data has been merged for all the Content Packs. This method allows our manager to know
-- the database is getting initialized.
UnlimitedCarsDatabaseManager.Init = function()
    dbgTrace("UnlimitedCarsDatabaseManager:Init()")
    UnlimitedCarsDatabaseManager.Global = {}
end

-- This method will be called after our manager gets initialized, all Database and Player methods have 
-- been added to the main Game Databases.
UnlimitedCarsDatabaseManager.Setup = function()
    dbgTrace("UnlimitedCarsDatabaseManager:Setup()")
    

    
end

UnlimitedCarsDatabaseManager.Activate = function()
    dbgTrace("UnlimitedCarsDatabaseManager.Activate()")

end

UnlimitedCarsDatabaseManager._ExecuteQuery = function(_sDatabase, _sPSCollection, _sInstance, ...)
    local result = nil
    database.SetReadOnly(_sDatabase, false)
    local tArgs = table.pack(...)

    local cPSInstance = database.GetPreparedStatementInstance(_sDatabase, _sInstance)
    if cPSInstance ~= nil then
        if #tArgs > 0 then
            for i, j in ipairs(tArgs) do
                database.BindParameter(cPSInstance, i, j)
            end
        end
        database.BindComplete(cPSInstance)
        database.Step(cPSInstance)

        local tRows = database.GetAllResults(cPSInstance, false)
        result = tRows or nil
    else
        dbgTrace("WARNING: COULD NOT GET INSTANCE: ".. _sInstance .. " IN: ".._sPSCollection)
    end
    database.SetReadOnly(_sDatabase, true)
    return result
end



-- This table contains the list of functions our module wants to add to the Game Database.
UnlimitedCarsDatabaseManager.tDatabaseFunctions = {
    UCSetMaxCars = function(_max)
        dbgTrace("UnlimitedCarsDatabaseManager.UCSetMaxCars()")
        return UnlimitedCarsDatabaseManager._ExecuteQuery("TrackedRides","Mod_UnlimitedCarsPSList","SetAllCarLimit",_max)
    end
}

-- This method will be called when our manager gets initialized to inject custom functions 
-- in the Game Database. These functions will be available for the rest of the game Lua modules.
UnlimitedCarsDatabaseManager.AddDatabaseFunctions = function(_tDatabaseFunctions)
    for sMethod,fnMethod in pairs(UnlimitedCarsDatabaseManager.tDatabaseFunctions) do
        _tDatabaseFunctions[sMethod] = fnMethod
    end
end

--
-- Database active functions. These functions are optional and can be called while our Database Manager is active.
--
-- Nothing included yet.


--
-- De-initialization functions. These functions are called during the shutdown or restart processes only
--

-- This method will be called when the Game Database is shutting down for re-initialization. It is a soft Re-Init
-- of the database. We don't need to close or free resources if we don't want, but remember we have them open when
-- the Game Database calls our :Init() function again.
UnlimitedCarsDatabaseManager.ShutdownForReInit = function()

end

-- This method will be called when the Game Database is shutting down and we need to close any 
-- or free any resource we have open. The module will be unloaded after.
UnlimitedCarsDatabaseManager.Shutdown = function()

end

--Set containing the database and Prepaired statement assocications
local tPreparedStatements = {
    TrackedRides = "Mod_UnlimitedCarsPSList"
}

UnlimitedCarsDatabaseManager._BindPreparedStatements = function()
    dbgTrace("UnlimitedCarsDatabaseManager._BindPreparedStatements()")

    local bSuccess = 0
    for k, ps in pairs(tPreparedStatements) do
        dbgTrace(k)
        dbgTrace(ps)
        database.SetReadOnly(k, false)

        bSuccess = database.BindPreparedStatementCollection(k, ps)
        if bSuccess == 0 then
            dbgTrace("Warning: Prepared Statement " .. ps .. " can not be bound to table " .. k)
            return nil
        end
        database.SetReadOnly(k, true)
    end
end

UnlimitedCarsDatabaseManager.PreBuildPrefabs = function(_fnAdd, _tLuaPrefabNames, _tLuaPrefabs)
    --The databases are actually modified here
    dbgTrace("UnlimitedCarsDatabaseManager:PreBuildPrefabs()")
    UnlimitedCarsDatabaseManager._BindPreparedStatements()

    GameDatabase.UCSetMaxCars(1000)
end