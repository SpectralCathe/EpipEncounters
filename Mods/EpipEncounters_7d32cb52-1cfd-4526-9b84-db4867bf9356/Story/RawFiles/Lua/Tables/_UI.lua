
---------------------------------------------
-- Base table for Client.UI libraries. Inherits from Feature.
---------------------------------------------

---@alias LuaFlashCompatibleType string|number|integer

---@class UI : Feature
---@field UITypeID integer? Use only for built-in UIs.
---@field PATH string? Path to the SWF. Use only for custom UIs.
---@field INPUT_DEVICE UI_InputDevice
---@field UI_FLAGS table<string, UIObjectFlags> Flags for UIObject.
local BaseUI = {
    UI = nil, -- Deprecated
    Root = nil, -- Deprecated

    UITypeID = nil,
    PATH = nil,
    INPUT_DEVICE = "Any",
    UI_FLAGS = {
        LOAD = "OF_Load",
        LOADED = "OF_Loaded",
        REQUEST_DELETE = "OF_RequestDelete",
        VISIBLE = "OF_Visible",
        ACTIVATED = "OF_Activated",
        PLAYER_INPUT_1 = "OF_PlayerInput1",
        PLAYER_INPUT_2 = "OF_PlayerInput2",
        PLAYER_INPUT_3 = "OF_PlayerInput3",
        PLAYER_INPUT_4 = "OF_PlayerInput4",
        PLAYER_MODAL_1 = "OF_PlayerModal1",
        PLAYER_MODAL_2 = "OF_PlayerModal2",
        PLAYER_MODAL_3 = "OF_PlayerModal3",
        PLAYER_MODAL_4 = "OF_PlayerModal4",
        KEEP_IN_SCREEN = "OF_KeepInScreen",
        KEEP_CUSTOM_IN_SCREEN = "OF_KeepCustomInScreen",
        DELETE_ON_CHILD_DESTROY = "OF_DeleteOnChildDestroy",
        PAUSE_REQUEST = "OF_PauseRequest",
        SORT_ON_ADD = "OF_SortOnAdd",
        FULL_SCREEN = "OF_FullScreen",
        PLAYER_TEXT_INPUT_1 = "OF_PlayerTextInput1",
        PLAYER_TEXT_INPUT_2 = "OF_PlayerTextInput2",
        PLAYER_TEXT_INPUT_3 = "OF_PlayerTextInput3",
        PLAYER_TEXT_INPUT_4 = "OF_PlayerTextInput4",
        DONT_HIDE_ON_DELETE = "OF_DontHideOnDelete",
        PRECACHE_UI_DATA = "OF_PrecacheUIData",
        PREVENT_CAMERA_MOVE = "OF_PreventCameraMove",
    },
} 
Client.UI._BaseUITable = BaseUI
OOP.RegisterClass("UI", BaseUI, {"Feature"})

---Returns the UIObject for this UI.
---Note that some UIs are destroyed after use (ex. OptionsSettings)
---and therefore do not always exist.
---@return UIObject?
function BaseUI:GetUI()
    if self.PATH then
        return Ext.UI.GetByPath(self.PATH)
    elseif self.UITypeID then
        return Ext.UI.GetByType(self.UITypeID)
    elseif self.ID then
        self:LogWarning("Getting UIs by name is deprecated! " .. self.ID)
        return Ext.UI.GetByName(self.ID)
    end
end

---Register a listener for a UI Invoke raw event.
---@param method string Method name.
---@param handler fun(ev:EclLuaUICallEvent, ...)
---@param when? "Before"|"After"
---@param typeID integer? Defaults to the UI's type ID. Used for UIs that are reused with different type IDs (ex. OptionsSettings)
function BaseUI:RegisterInvokeListener(method, handler, when, typeID)
    local path = typeID or self.PATH or self.UITypeID
    when = when or "Before"

    Utilities.Hooks.RegisterListener("GenericUIEventManager", "UI_" .. path .. "_UIInvoke_" .. method .. "_" .. when, handler)
end

---Register a listener for a UI Call raw event.
---@param method string ExternalInterface call name.
---@param handler fun(ev:EclLuaUICallEvent, ...)
---@param when ("Before"|"After")?
---@param typeID integer? Defaults to the UI's type ID. Used for UIs that are reused with different type IDs (ex. OptionsSettings)
function BaseUI:RegisterCallListener(method, handler, when, typeID)
    local path = typeID or self.PATH or self.UITypeID
    when = when or "Before"

    Utilities.Hooks.RegisterListener("GenericUIEventManager", "UI_" .. path .. "_UICall_" .. method .. "_" .. when, handler)
end

---Get the MainTimeline of a UI, if it currently exists.
---@return FlashMainTimeline?
function BaseUI:GetRoot()
    local ui = self:GetUI()

    if ui then
        return ui:GetRoot()
    else
        return nil
    end
end

---Returns true if the UI currently exists.
---Some UIs, like CharacterCreation, are destroyed when not in use.
---@return boolean
function BaseUI:Exists()
    return self:GetUI() ~= nil
end

---Shorthand for UIObject:Show()
function BaseUI:Show()
    local ui = self:GetUI()

    if ui then
        ui:Show()
    else
        self:LogError("Show(): UI does not currently exist!")
    end
end

---Sets the position of the UIObject relative to viewport.
---Equivalent to the `setPosition` UI call.
---@param anchor "center"|"topleft"|"topright"|"bottomleft"|"bottomright"
---@param position "center"|"topleft"|"topright"|"bottomleft"|"bottomright"
---@param target ("screen"|"splitscreen")? Defaults to `"screen"`
---@param delay number? Defaults to 0 seconds. Useful while initializing the UI, as the call does not work during the first few ticks of its existence.
function BaseUI:SetPositionRelativeToViewport(anchor, position, target, delay)
    target = target or "screen"
    
    if delay then
        Timer.Start(delay, function (_)
            self:ExternalInterfaceCall("setPosition", anchor, target, position)
        end)
    else
        self:ExternalInterfaceCall("setPosition", anchor, target, position)
    end
end

---Sets the position of the UIObject.
---Equivalent to `UIObject:SetPosition()`
---@param pos Vector2
function BaseUI:SetPosition(pos)
    self:GetUI():SetPosition(pos:unpack())
end

---Shorthand for UIObject:Hide()
function BaseUI:Hide()
    local ui = self:GetUI()

    if ui then
        ui:Hide()
    else
        self:LogError("Hide(): UI does not currently exist!")
    end
end

---Plays a sound through the PlaySound ExternalInterface call.
---@param id string
function BaseUI:PlaySound(id)
    self:GetUI():ExternalInterfaceCall("PlaySound", id)
end

---Shorthand for UIObject:ExternalInterfaceCall()
---@param event string
---@vararg any Event parameters.
function BaseUI:ExternalInterfaceCall(event, ...)
    self:GetUI():ExternalInterfaceCall(event, ...)
end

---Hides the UI's current tooltip.
function BaseUI:HideTooltip()
    self:ExternalInterfaceCall("hideTooltip")
end

---Toggles input on the UI for a given player.
---UIs without input do not capture mouse or keyboard events; mouse clicks go through them, into UIs below (or the world)
---@param enabled? boolean Defaults to toggling.
---@param player? integer Defaults to 1.
---@return boolean --The new state.
function BaseUI:TogglePlayerInput(enabled, player)
    player = player or 1
    local flag = "OF_PlayerInput" .. tostring(player)

    if enabled == nil then
        enabled = not self:IsFlagged(flag)
    end

    return self:SetFlag(flag, enabled)
end

---Returns whether the UI is flagged as visible.
---@return boolean
function BaseUI:IsVisible()
    return self:IsFlagged(self.UI_FLAGS.VISIBLE)
end

---Returns whether an UI flag is raised.
---@param flag UIObjectFlags
---@return boolean
function BaseUI:IsFlagged(flag)
    local flagged = false

    for _,f in ipairs(self:GetUI().Flags) do
        if f == flag then
            flagged = true
            break
        end
    end

    return flagged
end

---Changes the state of a flag.
---@param flag UIObjectFlags
---@param enabled? boolean Defaults to toggling to complimentary state.
---@return boolean --The new state.
function BaseUI:SetFlag(flag, enabled)
    if enabled == nil then
        enabled = not self:IsFlagged(flag)
    end

    local ui = self:GetUI()
    local hadFlag = false
    local oldFlags = ui.Flags
    local newFlags = {}

    for _,f in ipairs(oldFlags) do
        if f == flag then
            hadFlag = true
            if enabled then
                table.insert(newFlags, f)
            end
        else
            table.insert(newFlags, f)
        end
    end

    if enabled and not hadFlag then
        table.insert(newFlags, flag)
    end

    ui.Flags = newFlags

    return enabled
end

---Returns the position of the UI object on the screen.
---@return integer, integer --X, Y
function BaseUI:GetPosition()
    local ui = self:GetUI()
    local x, y

    if ui then
        local pos = ui:GetPosition()

        x, y = pos[1], pos[2]
    end

    return x, y
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Forward events
Ext.Events.UICall:Subscribe(function(ev)
    local ui = ev.UI
    local identifier = ui:GetTypeId()

    -- TODO improve
    local relativePath = string.match(ev.UI.Path, "(Public/EpipEncounters_7d32cb52%-1cfd%-4526%-9b84%-db4867bf9356/GUI/.*%.swf)$")
    if relativePath and not string.match(ev.UI.Path, "(Public/EpipEncounters_7d32cb52%-1cfd%-4526%-9b84%-db4867bf9356/GUI/generic%.swf)$") then
        identifier = relativePath
    end

    Utilities.Hooks.FireEvent("GenericUIEventManager", "UI_" .. identifier .. "_UICall_" .. ev.Function .. "_" .. ev.When, ev, table.unpack(ev.Args))
end)

Ext.Events.UIInvoke:Subscribe(function(ev)
    local ui = ev.UI
    local identifier = ui:GetTypeId()

    -- TODO improve
    local relativePath = string.match(ev.UI.Path, "Public/EpipEncounters_7d32cb52%-1cfd%-4526%-9b84%-db4867bf9356/GUI/(.*)%.swf$")
    if relativePath and not string.match(ev.UI.Path, "(Public/EpipEncounters_7d32cb52%-1cfd%-4526%-9b84%-db4867bf9356/GUI/generic%.swf)$") then
        identifier = relativePath
    end

    Utilities.Hooks.FireEvent("GenericUIEventManager", "UI_" .. identifier .. "_UIInvoke_" .. ev.Function .. "_" .. ev.When, ev, table.unpack(ev.Args))
end)