
local Generic = Client.UI.Generic
local TextPrefab = Generic.GetPrefab("GenericUI_Prefab_Text")
local Tooltip = Client.Tooltip

---Base class for prefabs styled as a form element.
---@class GenericUI_Prefab_FormElement : GenericUI_Prefab
---@field Background GenericUI_Element_TiledBackground
---@field Label GenericUI_Prefab_Text
local Prefab = {
    DEFAULT_SIZE = Vector.Create(600, 50),
}
Generic.RegisterPrefab("GenericUI_Prefab_FormElement", Prefab)

---------------------------------------------
-- METHODS
---------------------------------------------

---@param ui GenericUI_Instance
---@param id string
---@param parent (GenericUI_Element|string)?
---@param size Vector2
---@return GenericUI_Prefab_FormElement
function Prefab.Create(ui, id, parent, size)
    local instance = Prefab:_Create(ui, id) ---@type GenericUI_Prefab_FormElement

    instance:__SetupBackground(parent, size)

    return instance
end

---Creates the background and label elements.
---@protected
---@param parent (GenericUI_Element|string)?
---@param size Vector2
function Prefab:__SetupBackground(parent, size)
    local bg = self:CreateElement("Background", "GenericUI_Element_TiledBackground", parent)
    local text = TextPrefab.Create(self.UI, self:PrefixID("Label"), bg, "", "Left", Vector.Create(size[1], 30))

    self.Background = bg
    self.Label = text

    self:SetBackgroundSize(size)
    text:SetPositionRelativeToParent("Left")
end

---@return GenericUI_Element_TiledBackground
function Prefab:GetRootElement()
    return self.Background
end

---Sets the size of the background.
---@param size Vector2
function Prefab:SetBackgroundSize(size)
    local root = self:GetRootElement()

    root:SetBackground("Black", size:unpack())
    root:SetAlpha(0.2)
end

---Sets the label.
---@param label string
function Prefab:SetLabel(label)
    self.Label:SetText(label)
end

---Sets whether the element should be centered in lists.
---@param center boolean
function Prefab:SetCenterInLists(center)
    self:GetRootElement():SetCenterInLists(center)
end

---Sets the tooltip of the element.
---@param type TooltipLib_TooltipType
---@param tooltip any
function Prefab:SetTooltip(type, tooltip)
    local targetElement = self:GetRootElement()

    targetElement.Events.MouseOver:Unsubscribe("_Tooltip")
    targetElement.Events.MouseOut:Unsubscribe("_Tooltip")

    if type == "Simple" then
        targetElement.Events.MouseOver:Subscribe(function (_)
            Tooltip.ShowSimpleTooltip(tooltip)
        end)
        targetElement.Events.MouseOut:Subscribe(function (_)
            Tooltip.HideTooltip()
        end)
    else
        Generic:LogError("FormElement:SetTooltip: unsupported tooltip type " .. type)
    end
end