
---@class Epip
Epip = {
    Features = {}, ---@type table<string, Feature> Legacy table.
    _Features = {}, ---@type table<string, Epip.ModTable>
    _FeatureRegistrationOrder = {},

    PREFIXED_GUID = "EpipEncounters_7d32cb52-1cfd-4526-9b84-db4867bf9356",
    VERSION = 1066, -- Also the story version.
    cachedAprilFoolsState = nil,
    _devMode = nil,

    Events = {
        BeforeFeatureInitialization = SubscribableEvent:New("BeforeFeatureInitialization"), ---@type Event<Epip.Events.FeatureInitialization>
        AfterFeatureInitialization = SubscribableEvent:New("AfterFeatureInitialization"), ---@type Event<Epip.Events.FeatureInitialization>
    }
}

---------------------------------------------
-- CLASSES
---------------------------------------------

---Holds data for a mod and its registered Epip content.
---@class Epip.ModTable
---@field Features table<string, Feature>

---------------------------------------------
-- EVENTS/HOOKS
---------------------------------------------

---Fired during feature initialization.
---@class Epip.Events.FeatureInitialization
---@field Feature Feature

---------------------------------------------
-- METHODS
---------------------------------------------

---Registers a feature, initializing its utility metatable and exposing it to other mods via GetFeature(). Should be called outside of any listener, as soon as the table is defined. This will also check for required path overrides and disable the feature if the required mods are not enabled.
---@param modTable string
---@param id string
---@param feature Feature
---@overload fun(id:string, feature:Feature)
function Epip.RegisterFeature(modTable, id, feature)
    -- Overload for Epip's built-in features
    if not feature and type(id) == "table" then
        ---@diagnostic disable-next-line: cast-local-type
        modTable, id, feature = "EpipEncounters", modTable, id
    end

    feature.MOD_TABLE_ID = modTable

    Epip.InitializeFeature(modTable, id, feature)
    feature.MOD_TABLE = modTable

    -- Initialize mod data
    if not Epip._Features[modTable] then
        Epip._Features[modTable] = {Features = {}}
    end
    local modData = Epip._Features[modTable]

    -- Store the feature in the legacy table as well.
    if modTable == "EpipEncounters" then
        Epip.Features[id] = feature
    end

    modData.Features[id] = feature

    -- Throw initialization events
    -- These are delayed by tick to give later scripts a chance to subscribe
    Ext.OnNextTick(function (_)
        Epip.Events.BeforeFeatureInitialization:Throw({Feature = feature})
        ---@diagnostic disable-next-line: invisible
        feature:__Initialize()
        Epip.Events.AfterFeatureInitialization:Throw({Feature = feature})
    end)
end

---Overload for fetching features defined in EpipEncounters.
---@generic T
---@param id `T`
---@return Feature|`T`
---@diagnostic disable-next-line: missing-return, unused-local
function Epip.GetFeature(id) end -- IDE dummy

---@generic T
---@param modTable string
---@param id `T`
---@return Feature|`T`
function Epip.GetFeature(modTable, id)
    -- Overload to get features built-in into Epip.
    if id == nil then
        modTable, id = "EpipEncounters", modTable
    end

    -- Also attempt to fetch the feature using an ID with the "Feature(s)" prefix stripped as in many old Epip features it is only part of the IDE class and not in the feature ID.
    local strippedID = id:gsub("^Feature_", "", 1)
    strippedID = strippedID:gsub("^Features%.", "", 1) -- New naming convention
    local modData = Epip._Features[modTable]
    local feature

    if modData then
        feature = modData.Features[id] or modData.Features[strippedID]
    end

    if not feature then
        error("[EPIP] Attempted to fetch feature that does not exist: " .. id .. " from " .. modTable)
    end

    return feature
end

function Epip.InitializeLibrary(id, lib)
    -- TODO allow setting it to others
    OOP.GetClass("Library").Create("EpipEncounters", id, lib)
end

---@param requirePipPoem boolean? Whether a poem to Pip is required for this call to succeed. Defaults to false (which checks Extender dev mode instead)
---@return boolean
function Epip.IsDeveloperMode(requirePipPoem)
    local devMode = false

    -- Initialize _devMode variable
    if Epip._devMode == nil then
        Epip._devMode = Ext.IO.LoadFile("Epip_DevMode.txt") ~= nil
    end

    if requirePipPoem then
        devMode = Epip._devMode
    else
        devMode = Ext.Debug.IsDeveloperMode()
    end

    return devMode
end

---Silences logging from all features of a mod.
---@param modTable modtable? Defaults to `"EpipEncounters"`
function Epip.ShutUp(modTable)
    modTable = modTable or "EpipEncounters"
    local modData = Epip._Features[modTable] or {}
    for _,feature in pairs(modData.Features) do
        feature:ShutUp()
    end
end

---TODO move to Feature
---@param modTable string
---@param id string
---@param feature Feature
function Epip.InitializeFeature(modTable, id, feature)
    OOP.GetClass("Feature").Create(modTable, id, feature)

    feature._Tests = {}
    feature.MODULE_ID = id

    feature.NAME = id
    feature.FILEPATH_OVERRIDES = feature.FILEPATH_OVERRIDES or {}

    if feature.DEVELOPER_ONLY and not Epip.IsDeveloperMode() then
        feature:SetEnabled("NotDeveloper", false)
    end

    if feature:IsEnabled() then
        -- Add filepath overrides.
        for old,new in pairs(feature.FILEPATH_OVERRIDES) do
            Ext.IO.AddPathOverride(old, new)
        end

        feature._initialized = true
    end

    table.insert(Epip._FeatureRegistrationOrder, feature)
end

---@param obj any
---@param opts any?
---@param fileName string?
function Epip.SaveDump(obj, opts, fileName)
    IO.SaveFile(fileName or "debug_dump.json", Text.Dump(obj, opts or {
        Beautify = true,
        StringifyInternalTypes = true,
        IterateUserdata = true,
        AvoidRecursion = true,
        LimitDepth = 6,
    }), true)
end

---Registers a `FeatureInitialization` listener for a specific feature.
---@param modTable modtable
---@param featureID string
---@param timing "Before"|"After"
---@param listener fun(ev:Epip.Events.FeatureInitialization)
function Epip.RegisterFeatureInitializationListener(modTable, featureID, timing, listener)
    if timing ~= "Before" and timing ~= "After" then
        error("Invalid timing option " .. timing)
    end
    local event = timing == "Before" and Epip.Events.BeforeFeatureInitialization or Epip.Events.AfterFeatureInitialization

    event:Subscribe(function (ev)
        if ev.Feature:GetModTable() == modTable and ev.Feature:GetFeatureID() == featureID then
            listener(ev)
        end
    end)
end

if Ext.IsClient() then
    function Epip.InitializeUI(type, id, ui)
        Epip.InitializeFeature("EpipEncounters", id, ui)
        setmetatable(ui, {__index = Client.UI._BaseUITable})

        ui.UITypeID = type
        ui.TypeID = type

        if ui.INPUT_DEVICE == "Controller" and not Client.IsUsingController() then
            ui:SetEnabled("WrongInputDevice", false)
        elseif ui.INPUT_DEVICE == "KeyboardMouse" and Client.IsUsingController() then
            ui:SetEnabled("WrongInputDevice", false)
        end

        Client.UI[id] = ui
    end

    function Epip.IsAprilFools()
        -- Minor optimisation
        if Epip.cachedAprilFoolsState == nil then
            local date = Client.GetDate()
            Epip.cachedAprilFoolsState = (date.Day == 1 and date.Month == 4)
        end

        return Epip.cachedAprilFoolsState or Settings.GetSettingValue("Epip_Developer", "DEBUG_AprilFools")
    end
end

---@deprecated Legacy call. Use RegisterFeature() instead.
function Epip.AddFeature(id, _, feature)
    Ext.Utils.PrintWarning("[EPIP] Registering Features with AddFeature() is deprecated.", id)
    Epip.RegisterFeature(id, feature)
    Epip.Features[id] = feature
end