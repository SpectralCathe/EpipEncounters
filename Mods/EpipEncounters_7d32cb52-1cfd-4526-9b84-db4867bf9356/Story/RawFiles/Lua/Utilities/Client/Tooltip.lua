
local TextDisplay = Client.UI.TextDisplay

---@class TooltipLib : Feature
local Tooltip = {
    nextTooltipData = nil, ---@type TooltipLib_TooltipSourceData

    SURFACE_DAMAGE_ELEMENT_TYPES = {
        Fire = true,
        Water = true,
        Earth = true,
        Air = true,
        Poison = true,
        Physical = true,
        Sulphur = true,
    },

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Hooks = {
        RenderFormattedTooltip = {Preventable = true}, ---@type PreventableEvent<TooltipLib_Hook_RenderFormattedTooltip>
        RenderSkillTooltip = {Preventable = true,}, ---@type PreventableEvent<TooltipLib_Hook_RenderFormattedTooltip>
        RenderSurfaceTooltip = {Preventable = true,}, ---@type PreventableEvent<TooltipLib_Hook_RenderFormattedTooltip>
        RenderMouseTextTooltip = {Preventable = true}, ---@type PreventableEvent<TooltipLib_Hook_RenderMouseTextTooltip>
    },
}
Client.Tooltip = Tooltip
Epip.InitializeLibrary("TooltipLib", Tooltip)

---@alias TooltipLib_FormattedTooltipType "Surface"|"Skill"
---@alias TooltipLib_Element table See `Game.Tooltip`. TODO
---@alias TooltipLib_FormattedTooltipElementType string TODO

---@class TooltipLib_TooltipSourceData
---@field UIType integer
---@field Type TooltipLib_FormattedTooltipType

---@class TooltipLib_FormattedTooltip
---@field Elements TooltipLib_Element[]
local _FormattedTooltip = {}

---@param element TooltipLib_Element
---@param index integer? Defaults to next index.
function _FormattedTooltip:InsertElement(element, index)
    table.insert(self.Elements, index or #self.Elements + 1, element)
end

---@param elementType TooltipLib_FormattedTooltipElementType?
---@return TooltipLib_Element[] If elementType is nil, the list will be passed by reference.
function _FormattedTooltip:GetElements(elementType)
    local elements = {}

    if elementType ~= nil then
        for _,element in ipairs(self.Elements) do
            if element.Type == elementType then
                table.insert(elements, element)
            end
        end
    else
        elements = self.Elements
    end

    return elements
end

---@param elementType TooltipLib_FormattedTooltipElementType?
function _FormattedTooltip:GetFirstElement(elementType)
    return self:GetElements(elementType)[1]
end

---If the target element is not found, the new element will be inserted at the end.
---@param target TooltipLib_Element|TooltipLib_FormattedTooltipElementType The element before which to insert the new one.
---@param element TooltipLib_Element The element to insert.
function _FormattedTooltip:InsertAfter(target, element)
    local inserted = false

    for i=#self.Elements,1,-1 do
        local existingElement = self.Elements[i]

        if existingElement.Type == target or existingElement == target then
            self:InsertElement(element, i + 1)
            inserted = true
            break
        end
    end

    if not inserted then
        _FormattedTooltip:InsertElement(element)
    end
end

---If the target element is not found, the new element will be inserted at the end.
---@param target TooltipLib_Element|TooltipLib_FormattedTooltipElementType The element before which to insert the new one.
---@param element TooltipLib_Element The element to insert.
function _FormattedTooltip:InsertBefore(target, element)
    local inserted = false

    for i,existingElement in ipairs(self.Elements) do
        if existingElement.Type == target or existingElement == target then
            self:InsertElement(element, i)
            inserted = true
            break
        end
    end

    if not inserted then
        _FormattedTooltip:InsertElement(element)
    end
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

---@class TooltipLib_Hook_RenderFormattedTooltip : PreventableEventParams
---@field Type TooltipLib_FormattedTooltipType
---@field Tooltip TooltipLib_FormattedTooltip Hookable.
---@field UI UIObject

---@class TooltipLib_Hook_RenderMouseTextTooltip : PreventableEventParams
---@field Text string Hookable.

---------------------------------------------
-- METHODS
---------------------------------------------

---@param ui UIObject
---@param tooltipType TooltipLib_FormattedTooltipType
---@param tooltip TooltipLib_FormattedTooltip
function Tooltip.ShowFormattedTooltip(ui, tooltipType, tooltip)
    local root = ui:GetRoot()

    if tooltipType == "Surface" then
        local originalTbl = Game.Tooltip.ParseTooltipArray(Game.Tooltip.TableFromFlash(ui, "tooltipArray"))
        local newTable = Game.Tooltip.EncodeTooltipArray(tooltip.Elements)

        Game.Tooltip.ReplaceTooltipArray(ui, "tooltipArray", newTable, originalTbl)

        root.displaySurfaceText(Client.GetMousePosition())
    end
end

---@param text string
function Tooltip.ShowMouseTextTooltip(text)
    local root = TextDisplay:GetRoot()

    root.addText(text, Client.GetMousePosition())
end

---@param ui UIObject
---@param tooltipType TooltipLib_FormattedTooltipType
---@param data TooltipLib_Element[]
---@return TooltipLib_Hook_RenderFormattedTooltip
function Tooltip._SendFormattedTooltipHook(ui, tooltipType, data)
    local obj = {Elements = data} ---@type TooltipLib_FormattedTooltip
    Inherit(obj, _FormattedTooltip)

    ---@type TooltipLib_Hook_RenderFormattedTooltip
    local hook = {
        Type = tooltipType,
        Tooltip = obj,
        UI = ui,
    }

    -- Specific listeners go first.
    local specificEvent = Tooltip.Hooks["Render" .. tooltipType .. "Tooltip"]
    if specificEvent then
        specificEvent:Throw(hook)
    else
        Tooltip:LogWarning("No specific hook defined for tooltip type " .. tooltipType)
    end

    Tooltip.Hooks.RenderFormattedTooltip:Throw(hook)

    return hook
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

---@param ui UIObject
---@param fieldName string
---@return table
local function ParseArray(ui, fieldName)
    return Game.Tooltip.ParseTooltipArray(Game.Tooltip.TableFromFlash(ui, fieldName))
end

local function HandleFormattedTooltip(ev, arrayFieldName, x, y, unknown)
    local sourceData = Tooltip.nextTooltipData

    if sourceData then
        local tbl = ParseArray(ev.UI, arrayFieldName)
        local hook = Tooltip._SendFormattedTooltipHook(Ext.UI.GetByType(sourceData.UIType), sourceData.Type, tbl)

        if not hook.Prevented then
            local newTable = Game.Tooltip.EncodeTooltipArray(hook.Tooltip.Elements)

            Game.Tooltip.ReplaceTooltipArray(ev.UI, arrayFieldName, newTable, tbl)
        else
            ev:PreventAction()
        end
    end

    Tooltip.nextTooltipData = nil
end

Ext.Events.UICall:Subscribe(function(ev)
    if ev.Function == "showSkillTooltip" then
        Tooltip.nextTooltipData = {UIType = ev.UI:GetTypeId(), Type = "Skill"}
    end
end)

Client.UI.Tooltip:RegisterInvokeListener("addFormattedTooltip", function(ev, x, y, unknown)
    HandleFormattedTooltip(ev, "tooltip_array", x, y, unknown)
end)

-- Listen for surface tooltips from TextDisplay.
-- TODO place dummy values.
TextDisplay:RegisterInvokeListener("displaySurfaceText", function(ev, _, _)
    local ui = ev.UI
    local arrayFieldName = "tooltipArray"

    local tbl = Game.Tooltip.ParseTooltipArray(Game.Tooltip.TableFromFlash(ui, arrayFieldName))

    local hook = Tooltip._SendFormattedTooltipHook(ui, "Surface", tbl)

    if not hook.Prevented then
        local newTable = Game.Tooltip.EncodeTooltipArray(hook.Tooltip.Elements)

        Game.Tooltip.ReplaceTooltipArray(ui, arrayFieldName, newTable, tbl)
    else
        ev:PreventAction()
    end
end)

TextDisplay:RegisterInvokeListener("addText", function(ev, text, x, y)
    local hook = {Text = text} ---@type TooltipLib_Hook_RenderMouseTextTooltip

    Tooltip.Hooks.RenderMouseTextTooltip:Throw(hook)

    if not hook.Prevented then
        ev.Args[1] = hook.Text
        ev.UI:GetRoot().addText(hook.Text, x, y)
        ev:PreventAction()
    else
        ev:PreventAction()
    end
end)