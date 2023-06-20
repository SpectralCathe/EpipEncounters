
---------------------------------------------
-- Allows loading additional scripts defined in a json within the Osiris Data directory.
-- Intended usage is to quickly run test/debug scripts without including them in any mod directory.
---------------------------------------------

---@type Feature
local PersonalScripts = {
    DEFINITION_PATH = "Epip/PersonalScripts.json",
}
Epip.RegisterFeature("PersonalScripts", PersonalScripts)

---------------------------------------------
-- CLASSES
---------------------------------------------

---@class Feature_PersonalScripts_ScriptSet
---@field Scripts Feature_PersonalScripts_Script[]

---@class Feature_PersonalScripts_Script
---@field Context ScriptContext
---@field Path path Relative to the root directory.
---@field PathRoot InputOutputLib_UserFileContext
---@field ModTable string Mod table to use as the environment.

---------------------------------------------
-- METHODS
---------------------------------------------

---Loads scripts from a definition file.
---@param path path? Defaults to `DEFINITION_PATH`. File must follow the `Feature_PersonalScripts_ScriptSet` structure.
function PersonalScripts._LoadScripts(path)
    local def = IO.LoadFile(path or PersonalScripts.DEFINITION_PATH) ---@type Feature_PersonalScripts_ScriptSet

    for _,scriptDef in ipairs(def.Scripts) do
        local canLoad = scriptDef.Context == "Shared"
        if not canLoad then
            canLoad = (Ext.IsClient() and scriptDef.Context == "Client") or (Ext.IsServer() and scriptDef.Context == "Server")
        end

        if canLoad then
            local script = IO.LoadFile(scriptDef.Path, scriptDef.PathRoot, true)
            local env = nil
            if scriptDef.ModTable then
                env = Mods[scriptDef.ModTable]
            end
            print("env", env, env.Client)

            local chunk = load(script, scriptDef.Path, "t", env)

            chunk()
        end
    end
end

---------------------------------------------
-- SETUP
---------------------------------------------

-- Load personal scripts.
PersonalScripts._LoadScripts()