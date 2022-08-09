
local Generic = Client.UI.Generic

---@class GenericUI_Element_Slider : GenericUI_Element
---@field Events GenericUI_Element_Slider_Events
local Slider = {
    Events = {},
}

---------------------------------------------
-- EVENTS
---------------------------------------------

---@class GenericUI_Element_Slider_Events : GenericUI_Element_Events
Slider.Events = {
    HandleReleased = {}, ---@type SubscribableEvent<GenericUI_Element_Slider_Event_HandleReleased>
}
Generic.Inherit(Slider, Generic._Element)

---@class GenericUI_Element_Slider_Event_HandleReleased
---@field Value number

---------------------------------------------
-- METHODS
---------------------------------------------

---@return number
function Slider:GetValue()
    return self:GetMovieClip().value
end

---@param min number
function Slider:SetMin(min)
    self:GetMovieClip().minimum = min
end

---@param max number
function Slider:SetMax(max)
    self:GetMovieClip().maximum = max
end

---------------------------------------------
-- SETUP
---------------------------------------------

Generic.RegisterElementType("Slider", Slider)