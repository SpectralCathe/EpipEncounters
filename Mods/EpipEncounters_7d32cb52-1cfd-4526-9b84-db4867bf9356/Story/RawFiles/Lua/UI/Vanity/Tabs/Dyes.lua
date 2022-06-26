
local Vanity = Client.UI.Vanity

local Dyes = {
    Tab = nil,
    CustomDyes = {},
    lockColorSlider = false,

    currentSliderColor = {
        Color1 = Color.Create(),
        Color2 = Color.Create(),
        Color3 = Color.Create(),
    },

    DYE_CATEGORIES = {},
    DYE_DATA = {},
    DYE_CATEGORY_ORDER = {},
    DYE_PALETTE_BITS = 1,
    COLOR_NAMES = {"Primary", "Secondary", "Tertiary"},
    CACHE = {},

    Events = {
        ---@type VanityDyes_Event_DyeUsed
        DyeUsed = {},
    },
    Hooks = {
        ---@type VanityDyes_Hook_GetCategories
        GetCategories = {},
    },
}
Epip.AddFeature("VanityDyes", "VanityDyes", Dyes)

---@type CharacterSheetCustomTab
local Tab = Vanity.CreateTab({
    Name = "Dyes",
    ID = "PIP_Vanity_Dyes",
    Icon = "hotbar_icon_dye",
})
Dyes.Tab = Tab

---@class VanityDye
---@field Name string? Can be anonymous.
---@field ID string
---@field Type string
---@field Icon string?
---@field Color1 RGBColor
---@field Color2 RGBColor
---@field Color3 RGBColor

---@class VanityDyeCategory
---@field Name string
---@field ID string
---@field Dyes VanityDye[]

---@class VanityDyeCategory
---@field ID string
---@field Name string
---@field Dyes VanityDye[]

---------------------------------------------
-- EVENTS / HOOKS
---------------------------------------------

---@class VanityDyes_Event_DyeUsed : Event
---@field RegisterListener fun(self, listener:fun(dye:VanityDye, item:EclItem, character:EclCharacter))
---@field Fire fun(self, dye:VanityDye, item:EclItem, character:EclCharacter)

---@class VanityDyes_Hook_GetCategories : Hook
---@field RegisterHook fun(self, handler:fun(categories:VanityDyeCategory[]))
---@field Return fun(self, categories:VanityDyeCategory[])

---------------------------------------------
-- METHODS
---------------------------------------------

---@param categoryID string
---@param data VanityDyeCategory
function Dyes.AddDyeCategory(categoryID, data)
    setmetatable(data, {__index = {
        ID = categoryID,
        Name = "MISSING NAME",
        Dyes = {},
    }})

    Dyes.DYE_CATEGORIES[categoryID] = data
    table.insert(Dyes.DYE_CATEGORY_ORDER, categoryID)
end

---Register a dye for the dyes tab.
---@param categoryID string
---@param data VanityDye
function Dyes.AddDye(categoryID, data)
    setmetatable(data, {__index = {
        Name = "MISSING NAME",
        Color = "ffffff",
    }})

    if not data.ID then
        Dyes:LogError("Dyes must have an ID field!")
        return nil
    elseif Dyes.DYE_DATA[data.ID] then
        Dyes:LogError("Dye already registered: " .. data.ID)
        return nil
    elseif Dyes.DYE_CATEGORIES[categoryID] == nil then
        Dyes:LogError("AddDyeCategory() must be called first for " .. categoryID .. " category!")
        return nil
    end

    ---@type VanityDyeCategory
    local category = Dyes.DYE_CATEGORIES[categoryID]

    table.insert(category.Dyes, data)
    Dyes.DYE_DATA[data.ID] = data
end

---Use a dye.
---@param id string
function Dyes.UseDye(id)
    local data = Dyes.DYE_DATA[id] or Dyes.CustomDyes[id]

    Dyes:DebugLog("Using dye: " .. id)

    Dyes.Events.DyeUsed:Fire(data, Vanity.GetCurrentItem(), Client.GetCharacter())
end

---Save a custom dye.
---@param id string
---@param data VanityDye
function Dyes.SaveCustomDye(id, data)
    data.Name = id
    data.ID = id
    data.Type = "Custom"
    Dyes.CustomDyes[id] = data

    Vanity.Refresh()
    Vanity.SaveData()
end

---@param dye VanityDye
---@param item EclItem?
function Dyes.ApplyCustomDye(dye, item)
    item = item or Vanity.GetCurrentItem()
    local color1 = dye.Color1
    local color2 = dye.Color2
    local color3 = dye.Color3
    local itemColorStat = string.format("PIP_GENCOLOR_FF%s%s%s_FF%s%s%s_FF%s%s%s", hex(color1.Red, 2), hex(color1.Green, 2), hex(color1.Blue, 2), hex(color2.Red, 2), hex(color2.Green, 2), hex(color2.Blue, 2), hex(color3.Red, 2), hex(color3.Green, 2), hex(color3.Blue, 2))
    
    Dyes:DebugLog("ItemColor stat: " .. itemColorStat)

    local statData = {
        Name = itemColorStat,
        Color1 = (256 ^ 4) + (color1.Red * 256 ^ 2) + (color1.Green * 256) + (color1.Blue),
        Color2 = (256 ^ 4) + (color2.Red * 256 ^ 2) + (color2.Green * 256) + (color2.Blue),
        Color3 = (256 ^ 4) + (color3.Red * 256 ^ 2) + (color3.Green * 256) + (color3.Blue),
    }

    Ext.Stats.ItemColor.Update(statData)
    Dyes:Dump(Ext.Stats.ItemColor.Get(itemColorStat))

    Dyes.ApplyDye(item, statData)
end

-- TODO use wrapper table for dye instead
function Dyes.ApplyDye(item, dyeStatData)
    Vanity.ignoreNextUnEquip = true
    -- item.ItemColorOverride = dyeStatData.Name

    Dyes.CreateDyeStats(item, dyeStatData)

    Game.Net.PostToServer("EPIPENCOUNTERS_CreateDyeStat_ForPeers", {ItemNetID = item.NetID, Stat = dyeStatData})

    Client.Timer.Start("PIP_ApplyCustomDye", 0.35, function()
        Game.Net.PostToServer("EPIPENCOUNTERS_DyeItem", {NetID = item.NetID, DyeStat = dyeStatData, CharacterNetID = Client.GetCharacter().NetID})
    end)
end

---@param item EclItem|string
---@param dyeStat StatsItemColorDefinition
function Dyes.CreateDyeStats(item, dyeStat)
    local statType = item
    if type(item) ~= "string" then statType = item.Stats.ItemType end

    local deltaModName = string.format("Boost_%s_%s", statType, dyeStat.Name)
    local boostStatName = "_" .. deltaModName
    local stat = Ext.Stats.Create(boostStatName, statType)

    Ext.Stats.ItemColor.Update(dyeStat, true)

    if stat then
        stat.ItemColor = dyeStat.Name
    end

    Ext.Stats.DeltaMod.Update({
        Name = deltaModName,
        MinLevel = 1,
        Frequency = 1,
        BoostType = "ItemCombo",
        ModifierType = statType,
        SlotType = "Sentinel",
        WeaponType = "Sentinel",
        Handedness = "Any",
        Boosts = {
            {
                Boost = boostStatName,
                Count = 1,
            }
        }
    })
end

function Dyes.ApplyGenericDyeFromSliders()
    local item = Vanity.GetCurrentItem()
    local color1 = Dyes.currentSliderColor.Color1
    local color2 = Dyes.currentSliderColor.Color2
    local color3 = Dyes.currentSliderColor.Color3

    ---@type VanityDye
    local dyeData = {
        Color1 = color1,
        Color2 = color2,
        Color3 = color3,
    }

    Dyes.ApplyCustomDye(dyeData)
end

---@param index integer
---@return RGBColor
function Dyes.GetCurrentSliderColor(index)
    local sliderColor = Dyes.currentSliderColor["Color" .. index]
    return Color.Create(sliderColor.Red, sliderColor.Green, sliderColor.Blue)
end

---Gets the custom dye of the item. If item is nil, returns the values from the sliders instead.
---@param item EclItem?
---@param useSliders boolean? Defaults to true.
---@return VanityDye
function Dyes.GetCurrentCustomDye(item, useSliders)
    if useSliders == nil then useSliders = true end
    local colorData

    if item then
        for i,mod in ipairs(item:GetDeltaMods()) do
            local c1,c2,c3 = string.match(mod, "PIP_GENCOLOR_FF(%x%x%x%x%x%x)_FF(%x%x%x%x%x%x)_FF(%x%x%x%x%x%x)")

            if c1 then
                colorData = {
                    Color1 = Color.CreateFromHex(c1),
                    Color2 = Color.CreateFromHex(c2),
                    Color3 = Color.CreateFromHex(c3),
                }
            end
        end
    end
    if not colorData and useSliders then
        colorData = {
            Color1 = Dyes.GetCurrentSliderColor(1),
            Color2 = Dyes.GetCurrentSliderColor(2),
            Color3 = Dyes.GetCurrentSliderColor(3),
        }
    end

    return colorData
end

---------------------------------------------
-- TAB RENDERING
---------------------------------------------

---@param categories VanityDyeCategory[]
function Tab:RenderCategories(categories)
    for i,category in ipairs(categories) do
        local isOpen = Vanity.IsCategoryOpen(category.ID)
        Vanity.RenderEntry(category.ID, category.Name, true, isOpen, false, false)

        if isOpen then
            local dyes = category.Dyes

            for i,dye in ipairs(dyes) do
                Vanity.RenderEntry(dye.ID, dye.Name or dye.ID, false, false, false, false, nil, false, {
                    dye.Color1,
                    dye.Color2,
                    dye.Color3,
                })
            end
        end
    end
end

---@param dye VanityDye
function Tab:SetSliderColors(dye)
    Dyes.currentSliderColor = {
        Color1 = Color.Clone(dye.Color1),
        Color2 = Color.Clone(dye.Color2),
        Color3 = Color.Clone(dye.Color3),
    }
    
    for i=1,3,1 do
        ---@type RGBColor
        local color = "Color" .. i
        color = Dyes.currentSliderColor[color]

        Tab:SetSliderColor(i, color)
    end
end

---@param sliderIndex integer
---@param color RGBColor
function Tab:SetSliderColor(sliderIndex, color)
    local menu = Vanity.GetMenu()

    menu.setSlider("Dye_" .. sliderIndex .. "_Red", color.Red)
    menu.setSlider("Dye_" .. sliderIndex .. "_Green", color.Green)
    menu.setSlider("Dye_" .. sliderIndex .. "_Blue", color.Blue)

    self:UpdateColorSliderLabel(sliderIndex)
end

function Tab:Render()
    local item = Vanity.GetCurrentItem()

    Vanity.RenderItemDropdown()

    local categories = Dyes.Hooks.GetCategories:Return({})

    if item then
        local char = Client.GetCharacter()
        local visuals = {}

        currentSliderColor = {
            Color1 = Color.Create(),
            Color2 = Color.Create(),
            Color3 = Color.Create(),
        }

        local currentCustomDye = Dyes.GetCurrentCustomDye(item)

        if currentCustomDye and not Dyes.lockColorSlider then
            currentSliderColor = currentCustomDye
            Dyes.currentSliderColor = currentSliderColor
        end

        Vanity.RenderText("Color1_Hint", "Custom Color (RGB)")
        -- RGB sliders
        for i=1,3,1 do
            ---@type RGBColor
            local color = "Color" .. i
            color = Dyes.currentSliderColor[color]

            -- TODO render color labels
            Vanity.RenderLabelledColor("Color_Label_" .. i, color:ToDecimal(), "", true)
            self:UpdateColorSliderLabel(i)

            Vanity.RenderSlider("Dye_" .. i .. "_Red", color.Red, 0, 255, Dyes.DYE_PALETTE_BITS, "Red", "Red")
            Vanity.RenderSlider("Dye_" .. i .. "_Green", color.Green, 0, 255, Dyes.DYE_PALETTE_BITS, "Green", "Green")
            Vanity.RenderSlider("Dye_" .. i .. "_Blue", color.Blue, 0, 255, Dyes.DYE_PALETTE_BITS, "Blue", "Blue")
        end

        Vanity.RenderButtonPair("Dye_Apply", "Apply Dye", true, "Dye_Save", "Save Dye", true)

        Vanity.RenderCheckbox("Dye_DefaultToItemColor", Text.Format("Lock Color Sliders", {Color = "000000"}), Dyes.lockColorSlider, true)

        self:RenderCategories(categories)
    else
        Vanity.RenderText("NoItem", "You don't have an item equipped in that slot!")
    end
end

function Tab:UpdateColorSliderLabel(index)
    local color = Dyes.currentSliderColor["Color" .. index]
    Vanity.SetColorLabel("Color_Label_" .. index, color:ToDecimal(), Text.Format(Dyes.COLOR_NAMES[tonumber(index)], {Color = "000000"}), color:ToHex(true))
end

Tab:RegisterListener(Vanity.Events.ButtonPressed, function(id)
    if id == "Dye_Apply" then
        Dyes.ApplyGenericDyeFromSliders()
    elseif id == "Dye_Save" then
        Client.UI.MessageBox.ShowMessageBox({
            ID = "PIP_Vanity_SaveDye",
            Header = "Save Dye",
            Type = "Input",
            Message = "Enter a name for this dye!",
            Buttons = {{Text = "Accept", Type = 1, ID = 0}},
        })
    end
end)

Tab:RegisterListener(Vanity.Events.CheckboxPressed, function(id, state)
    if id == "Dye_DefaultToItemColor" then
        Dyes.lockColorSlider = state
    end
end)

-- Listen for RGB sliders.
Tab:RegisterListener(Vanity.Events.SliderHandleReleased, function (id, value)
    local colorIndex,channel = id:match("^Dye_(%d)_(%a*)$")
    local color = Dyes.currentSliderColor["Color" .. colorIndex]

    color[channel] = value

    Tab:UpdateColorSliderLabel(colorIndex)
end)

-- Listen for copy buttons.
Tab:RegisterListener(Vanity.Events.CopyPressed, function(id, text)
    Client.UI.MessageBox.CopyToClipboard(text)
end)

Tab:RegisterListener(Vanity.Events.PastePressed, function(id)
    local colorIndex = string.gsub(id, "Color_Label_", "")

    Client.UI.MessageBox:GetUI():ExternalInterfaceCall("pastePressed")

    Client.Timer.Start("PIP_VanityPaste", 0.1, function()
        local text = Client.UI.MessageBox:GetRoot().popup_mc.input_mc.input_txt.text
        local color = Color.CreateFromHex(text)

        if color then
            Dyes.currentSliderColor["Color" .. colorIndex] = color

            Tab:SetSliderColor(colorIndex, color)
        end
    end)
end)

-- Listen for color codes being entered.
Tab:RegisterListener(Vanity.Events.InputChanged, function(id, text)
    text = string.gsub(text, "#", "")
    local colorIndex = string.gsub(id, "Color_Label_", "")

    if string.len(text) == 6 then
        local color = Color.CreateFromHex(text)
        
        Dyes.currentSliderColor["Color" .. colorIndex] = color

        -- Tab:UpdateColorSliderLabel(tonumber(colorIndex))
        Tab:SetSliderColor(colorIndex, color)
    end
end)

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

Ext.Events.SessionLoading:Subscribe(function()
    local file = Utilities.LoadJson("pip_useddyes.json")

    Dyes.CACHE = file or {}

    if file then
        -- print("creating dyes from cache")
        for id,dye in pairs(file) do
            Dyes.CreateDyeStats("Armor", dye)
            Dyes.CreateDyeStats("Weapon", dye)
        end
    end
end)

Game.Net.RegisterListener("EPIP_CACHEDYE", function(cmd, payload)
    local dye = payload.Dye

    Dyes.CACHE[dye.Name] = dye

    Utilities.SaveJson("pip_useddyes.json", Dyes.CACHE)
end)

-- _D(Ext.Stats.ItemColor.Get("PIP_GENCOLOR_FF006699_FF669999_FF669999"))
-- _D(Ext.GetItem(_C():GetItemBySlot("Breast")):GetDeltaMods())
-- _D(Ext.Stats.DeltaMod.GetLegacy("Boost_Armor_PIP_GENCOLOR_FF006699_FF669999_FF669999", "Armor"))
-- SESSIONLOADED WORKS!
Game.Net.RegisterListener("EPIPENCOUNTERS_CreateVanityDyes", function(cmd, payload)
-- Ext.Events.SessionLoaded:Subscribe(function()

    -- print("Creating dye stats")
    -- _D(payload)
    for id,dye in pairs(payload.Dyes) do
        Dyes.CreateDyeStats("Armor", dye)
        Dyes.CreateDyeStats("Weapon", dye)
    end
end)

-- Create dye stats on this client when requested by the server.
Game.Net.RegisterListener("EPIPENCOUNTERS_CreateDyeStat", function(cmd, payload)
    Dyes.CreateDyeStats(Ext.GetItem(payload.ItemNetID), payload.Stat)
end)

Vanity.Hooks.GetSaveData:RegisterHook(function (data)
    data.Dyes = Dyes.CustomDyes

    return data
end)

Vanity.Events.SaveDataLoaded:RegisterListener(function (data)
    if data.Version >= 4 then
        Dyes.CustomDyes = data.Dyes or {}

        for id,dye in pairs(Dyes.CustomDyes) do
            Inherit(dye.Color1, RGBColor)
            Inherit(dye.Color2, RGBColor)
            Inherit(dye.Color3, RGBColor)
            dye.Type = "Custom"
        end
    end
end)

Client.UI.MessageBox:RegisterMessageListener("PIP_Vanity_SaveDye", "InputSubmitted", function(input, id, data)
    Dyes.SaveCustomDye(input, Dyes.GetCurrentCustomDye())
end)

Epip.Features.VanityOutfits.Hooks.GetOutfitSaveData:RegisterHook(function(outfit, char)
    outfit.CustomDyes = {}

    for i,slot in ipairs(Data.Game.SLOTS_WITH_VISUALS) do
        local item = char:GetItemBySlot(slot)

        if item then
            item = Ext.GetItem(item)

            local dye = Dyes.GetCurrentCustomDye(item, false)
            outfit.CustomDyes[slot] = dye
        end
    end

    return outfit
end)

Epip.Features.VanityOutfits.Events.OutfitApplied:RegisterListener(function (outfit, char)
    if outfit.CustomDyes then
        for slot,dye in pairs(outfit.CustomDyes) do
            local item = char:GetItemBySlot(slot)

            if item then
                item = Ext.GetItem(item)
    
                Dyes.ApplyCustomDye(dye, item)
            end
        end

        Dyes:DebugLog("Applied saved dyes to outfit " .. outfit.Name)
    end
end)

Dyes.Events.DyeUsed:RegisterListener(function (dye, item, character)
    if dye.Type == "Custom" then
        Dyes.ApplyCustomDye(dye)

        Tab:SetSliderColors(dye)
    end
end)

-- Custom Dyes.
Dyes.Hooks.GetCategories:RegisterHook(function (categories)
    local dyes = {}

    for id,dye in pairs(Dyes.CustomDyes) do
        table.insert(dyes, dye)
    end

    table.insert(categories, {
        ID = "CustomDyes",
        Name = "Custom Dyes",
        Dyes = dyes,
    })

    return categories
end)

-- Registered categories of premade dyes.
Dyes.Hooks.GetCategories:RegisterHook(function (categories)
    for i,categoryID in ipairs(Dyes.DYE_CATEGORY_ORDER) do
        local category = Dyes.DYE_CATEGORIES[categoryID]

        table.insert(categories, category)
    end

    return categories
end)

-- Register all ItemColors into their own category.
function Dyes:__Setup()
    ---@type VanityDyeCategory
    local category = {
        Name = "Built-in Colors",
        ID = "BUILT-IN",
        Dyes = {},
    }

    Dyes.AddDyeCategory(category.ID, category)

    for i,statID in ipairs(Ext.Stats.GetStats("Armor")) do
        local stat = Ext.Stats.Get(statID)

        if stat.ItemColor ~= "" and string.find(statID, "GENCOLOR") == nil then
            local colorStat = Ext.Stats.ItemColor.Get(stat.ItemColor)

            if colorStat then
                local dye = {
                    Name = stat.ItemColor,
                    ID = stat.ItemColor,
                    Color1 = Color.CreateFromDecimal(colorStat.Color1),
                    Color2 = Color.CreateFromDecimal(colorStat.Color2),
                    Color3 = Color.CreateFromDecimal(colorStat.Color3),
                    Type = "Custom",
                }
    
                if not Dyes.DYE_DATA[dye.ID] then
                    Dyes.AddDye(category.ID, dye)
                end
            end
        end
    end

end

Tab:RegisterListener(Vanity.Events.EntryClicked, function(id)
    Dyes.UseDye(id)
end)