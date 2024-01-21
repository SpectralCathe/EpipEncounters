
---@class GenericUI
local Generic = Client.UI.Generic

---@class GenericUI_Element_Text : GenericUI_Element
---@field Events GenericUI_Element_Text_Events
local Text = {
    ---@enum GenericUI_Element_Text_Align
    TYPES = {
        LEFT_ALIGN = "Left",
        CENTER_ALIGN = "Center",
        RIGHT_ALIGN = "Right",
    },
}
local _Text = Text

---------------------------------------------
-- EVENTS
---------------------------------------------

---@class GenericUI_Element_Text_Events : GenericUI_Element_Events
Text.Events = {
    Changed = {}, ---@type Event<GenericUI_Element_Text_Event_Changed>
    Focused = {}, ---@type Event<Empty>
    Unfocused = {}, ---@type Event<Empty>
}
Generic.Inherit(Text, Generic._Element)

---@class GenericUI_Element_Text_Event_Changed
---@field Text string

---------------------------------------------
-- METHODS
---------------------------------------------

---Sets the stroke style and color of the text element.
---@param color uint64|RGBColor
---@param size number
---@param alpha number
---@param strength uint64
---@param unknown uint64
function Text:SetStroke(color, size, alpha, strength, unknown)
    local root = self:GetMovieClip()
    local tableType = GetMetatableType(color)
    if tableType and tableType == "RGBColor" then
        color = color:ToDecimal()
    end

    root.AddStroke(color, size, alpha, strength, unknown)
end

---Returns the size of the text itself.
---@return Vector2
function Text:GetTextSize()
    local mc = self:GetMovieClip()
    local txt = mc.text_txt
    local width = txt.textWidth + 2 -- Flash docs mention a "2-pixel gutter" which is possibly misimplemented in Iggy
    local height = 0 -- txt.textHeight is not accurate; it looks like it considers an additional line, which is difficult to undo if the lines have mixed height.

    for i=1,txt.numLines,1 do
        height = height + self:GetLineHeight(i)
        width = math.max(width, self:GetLineWidth(i)) -- Not 100% if necessary
    end

    return Vector.Create(math.max(0, width), math.ceil(height)) -- Empty text fields have -infinity width.
end

---Returns the text of the element.
---@return string
function Text:GetText()
    local mc = self:GetMovieClip()

    return mc.text_txt.htmlText
end

---Sets whether text should wrap once it reaches the edge of the element's size.
---@param wrap boolean
function Text:SetWordWrap(wrap)
    self:GetMovieClip().text_txt.wordWrap = wrap
end

---Returns whether the mouse is currently hovering over a range of characters.
---Ignores HTML tags.
---@param startIndex integer 1-based.
---@param length integer
---@return boolean
function Text:IsMouseWithinRange(startIndex, length)
    return self:GetMovieClip().IsMouseWithinRange(startIndex - 1, length)
end

_Text.SetText = Generic.ExposeFunction("SetText")
_Text.SetType = Generic.ExposeFunction("SetType")
_Text.SetEditable = Generic.ExposeFunction("SetEditable")
_Text.SetRestrictedCharacters = Generic.ExposeFunction("SetRestrictedCharacters")
_Text.GetLineWidth = Generic.ExposeFunction("GetLineWidth")
_Text.GetLineHeight = Generic.ExposeFunction("GetLineHeight")
_Text.IsMouseWithinKeyword = Generic.ExposeFunction("IsMouseWithinKeyword")

---------------------------------------------
-- SETUP
---------------------------------------------

Generic.RegisterElementType("Text", Text)