
---------------------------------------------
-- Modernized, UI-independent settings library.
-- Successor to the previous system bound to OptionsSettings.
---------------------------------------------

---@class SettingsLib : Library
Settings = {
    Modules = {}, ---@type table<string, SettingsLib_Module>
    SettingTypes = {}, ---@type table<SettingsLib_SettingType, SettingsLib_Setting>

    unregisteredSettingValues = {},

    NET_SYNC_CHANNEL = "EPIP_SETTINGS_SYNC",

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Events = {
        SettingValueChanged = {}, ---@type Event<SettingsLib_Event_SettingValueChanged>
    }
}
Epip.InitializeLibrary("Settings", Settings)
Settings:Debug()

---------------------------------------------
-- CLASSES
---------------------------------------------

---@alias SettingsLib_SettingType "Boolean"|"Number"|"ClampedNumber"|"Choice"

---@class EPIP_SETTINGS_SYNC
---@field Module string
---@field ID string
---@field Value any

---A module defines the settings registered for a particular mod.
---@class SettingsLib_Module
---@field ModTable string
---@field Settings table<string, SettingsLib_Setting>

---Represents a setting and holds its value.
---For serialization, you are expected to implement value getter/setters as functions that return only one value. Additional ones will be discarded.
---@class SettingsLib_Setting
---@field ID string
---@field Type SettingsLib_SettingType
---@field Name string? Defaults to ID.
---@field NameHandle TranslatedStringHandle? Preferred over Name.
---@field Description string? Defaults to empty string.
---@field DescriptionHandle TranslatedStringHandle? Preferred over Description.
---@field Context "Client"|"Server"|"Host"
---@field ModTable string
---@field Value any
---@field DefaultValue any
local _Setting = {}
Settings._SettingClass = _Setting

---Creates a new setting.
---@param data SettingsLib_Setting
function _Setting:Create(data)
    Inherit(data, self)
    data.Value = data.DefaultValue

    data:_Init()
    data:SetValue(data.DefaultValue)

    return data
end

---@return string
function _Setting:GetName()
    return Ext.L10N.GetTranslatedString(self.NameHandle or "", self.Name or self.ID)
end

---@return string
function _Setting:GetDescription()
    return Ext.L10N.GetTranslatedString(self.DescriptionHandle or "", self.Description or "")
end

---Returns whether this setting's intended context matches the current environment.
---@return boolean
function _Setting:IsInValidContext()
    local isValid

    if Ext.IsClient() then
        isValid = self.Context == "Client" or (self.Context == "Host" and Client.IsHost())
    else
        isValid = self.Context == "Server"
    end

    return isValid
end

function _Setting:GetValue() return self.Value end
function _Setting:SetValue(value) self.Value = value end
function _Setting:_Init() end

---------------------------------------------
-- EVENTS/HOOKS
---------------------------------------------

---@class SettingsLib_Event_SettingValueChanged
---@field Setting SettingsLib_Setting
---@field Value any

---------------------------------------------
-- METHODS
---------------------------------------------

---Sets a setting's value and fires corresponding events.
---@param moduleID string
---@param settingID string
---@param ... any
function Settings.SetValue(moduleID, settingID, ...)
    local setting = Settings.GetSetting(moduleID, settingID)

    if not setting then
        if GameState.IsInSession() then
            Settings:LogWarning("Tried to set value of an unregistered setting: " .. moduleID .. " " .. settingID .. ". The value will be stored until the setting is registered.")
        end
        if not Settings.unregisteredSettingValues[moduleID] then
            Settings.unregisteredSettingValues[moduleID] = {}
        end

        local values = {...}
        Settings.unregisteredSettingValues[moduleID][settingID] = values[1]
    else
        local newValue = {...}
        if #newValue == 1 then newValue = newValue[1] elseif #newValue == 0 then newValue = nil end -- TODO why is this being truncated? and only in the event??

        setting:SetValue(...)

        Settings.Events.SettingValueChanged:Throw({
            Setting = setting,
            Value = newValue,
        })
    end
end

---Returns a table of setting IDs and their current values.
---@param modTable string
---@param includeInvalidContexts boolean? If true, settings with a mismatched context will be included, if any are registered. Defaults to false.
---@return table<string, any> -- Maps setting ID to value.
function Settings.GetModuleSettingValues(modTable, includeInvalidContexts)
    local module = Settings.GetModule(modTable)
    local output = {}

    for id,setting in pairs(module.Settings) do
        if includeInvalidContexts or setting:IsInValidContext() then
            output[id] = setting:GetValue()
        end
    end

    return output
end

---@param modTable string
---@return SettingsLib_Module
function Settings.GetModule(modTable)
    local mod = Settings.Modules[modTable]

    -- Initialize module
    if not mod then
        mod = {
            ModTable = modTable,
            Settings = {},
        }

        Settings.Modules[modTable] = mod
    end

    return mod
end

---@param modTable string
---@param id string
---@return SettingsLib_Setting
function Settings.GetSetting(modTable, id)
    local mod = Settings.GetModule(modTable)
    local setting

    if mod then
        setting = mod.Settings[id]
    else
        Settings:LogError("GetSetting(): setting doesn't exist: " .. id)
    end

    return setting
end

---@overload fun(setting:SettingsLib_Setting):any
---@param modTable string
---@param id string
---@return any
function Settings.GetSettingValue(modTable, id)
    local value = nil
    local setting = modTable -- Setting overload.
    if type(modTable) ~= "table" then
        setting = Settings.GetSetting(modTable, id)
    end

    if setting then
        value = setting:GetValue()
    elseif Settings.unregisteredSettingValues[modTable] then
        value = Settings.unregisteredSettingValues[modTable][id]
    end

    return value
end

function Settings.RegisterSettingType(settingType, baseTable)
    Settings.SettingTypes[settingType] = baseTable
end

---Registers a setting.
---Any additional data on the table is preserved.
---@param data SettingsLib_Setting
function Settings.RegisterSetting(data)
    local settingTable = Settings.SettingTypes[data.Type] ---@type SettingsLib_Setting
    local setting = settingTable:Create(data)

    if not Settings.Modules[data.ModTable] then
        Settings.Load(data.ModTable)
    end

    local mod = Settings.GetModule(data.ModTable)

    mod.Settings[data.ID] = setting

    -- Initialize saved value
    local unregisteredSettingValues = Settings.unregisteredSettingValues[data.ModTable]
    if unregisteredSettingValues and unregisteredSettingValues[data.ID] ~= nil then
        Settings.SetValue(data.ModTable, data.ID, unregisteredSettingValues[data.ID])
    end
end

---Returns a table of all the registered modules.
---@return table<string, SettingsLib_Module>
function Settings.GetModules()
    local modules = {}

    for id,module in pairs(Settings.Modules) do
        modules[id] = module
    end

    return modules
end