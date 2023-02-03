
---@class Feature_QuickInventory : Feature
local QuickInventory = {
    RARITY_PRIORITY = {
        Common = 1,
        Uncommon = 2,
        Rare = 3,
        Epic = 4,
        Legendary = 5,
        Divine = 6,
        Unique = 7,
        Artifact = 8,
    },

    TranslatedStrings = {
        Header = {
           Handle = "hf196badfg6c61g4bd5g91e8g7bfbf9874cbf",
           Text = "Quick Find",
           ContextDescription = "Header for the UI",
        },
        ItemCategory_Name = {
           Handle = "h87e9e867gfd89g458eg850fga1129b558d59",
           Text = "Item Category",
           ContextDescription = "Name for item category filter dropdown (equipment/consumable/skillbook etc.)",
        },
        ShowLearntSkills_Name = {
           Handle = "hd5a53bd8gdcaag4280ga76dg905f40bde45e",
           Text = "Show learned skills",
           ContextDescription = "Checkbox for showing learnt skillbooks",
        },
    },

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Hooks = {
        IsItemVisible = {}, ---@type Event<Feature_QuickInventory_Hook_IsItemVisible>
        SortItems = {}, ---@type Event<Feature_QuickInventory_Hook_SortItems>
    }
}
Epip.RegisterFeature("QuickInventory", QuickInventory)

---------------------------------------------
-- EVENTS
---------------------------------------------

---@class Feature_QuickInventory_Hook_IsItemVisible
---@field Item EclItem
---@field Visible boolean Hookable. Defaults to `true`.

---@class Feature_QuickInventory_Hook_SortItems
---@field ItemA EclItem
---@field ItemB EclItem
---@field Result boolean Hookable. Defaults to sorting by handle.

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns the items from the party's inventory that match the filters set by hooks.
---@return EclItem[]
function QuickInventory.GetItems()
    local char = Client.GetCharacter()
    local allItems = Item.GetItemsInPartyInventory(char)
    local items = {} ---@type EclItem[]

    for _,item in ipairs(allItems) do
        local visible = QuickInventory.Hooks.IsItemVisible:Throw({
            Item = item,
            Visible = true,
        }).Visible

        if visible then
            table.insert(items, item)
        end
    end

    -- Sort items
    table.sort(items, function (itemA, itemB)
        local sortOutcome = QuickInventory.Hooks.SortItems:Throw({
            ItemA = itemA,
            ItemB = itemB,
            Result = Ext.UI.HandleToDouble(itemA.Handle) > Ext.UI.HandleToDouble(itemB.Handle),
        }).Result

        return sortOutcome
    end)

    return items
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Equipment filter.
QuickInventory.Hooks.IsItemVisible:Subscribe(function (ev)
    local item = ev.Item
    local visible = ev.Visible

    if QuickInventory:GetSettingValue(QuickInventory.Settings.ItemCategory) == "Equipment" then
        local itemSlotSetting = QuickInventory:GetSettingValue(QuickInventory.Settings.ItemSlot)

        visible = Item.IsEquipment(item)

        -- Slot restriction
        if itemSlotSetting == "Weapon" then
            local weaponSubTypeSetting = QuickInventory:GetSettingValue(QuickInventory.Settings.WeaponSubType)

            visible = visible and Item.GetItemSlot(item) == itemSlotSetting

            -- Weapon subtype restriction
            if weaponSubTypeSetting ~= "Any" then
                visible = visible and Item.GetEquipmentSubtype(item) == weaponSubTypeSetting
            end
        elseif itemSlotSetting ~= "Any" then
            visible = visible and Item.GetItemSlot(item) == itemSlotSetting
        end
    end

    ev.Visible = visible
end)

-- Sort equipment by rarity.
QuickInventory.Hooks.SortItems:Subscribe(function (ev)
    if QuickInventory:GetSettingValue(QuickInventory.Settings.ItemCategory) == "Equipment" then
        local rarityA, rarityB = ev.ItemA.Stats.Rarity, ev.ItemB.Stats.Rarity
        local scoreA, scoreB

        if Item.IsArtifact(ev.ItemA) then
            rarityA = "Artifact"
        end
        if Item.IsArtifact(ev.ItemB) then
            rarityB = "Artifact"
        end

        scoreA, scoreB = QuickInventory.RARITY_PRIORITY[rarityA] or 0, QuickInventory.RARITY_PRIORITY[rarityB] or 0

        ev.Result = scoreA > scoreB
        ev:StopPropagation()
    end
end)

-- Consumables filter.
QuickInventory.Hooks.IsItemVisible:Subscribe(function (ev)
    local item = ev.Item
    local visible = ev.Visible

    if QuickInventory:GetSettingValue(QuickInventory.Settings.ItemCategory) == "Consumables" then
        visible = visible and Item.HasUseAction(item, "Consume")
    end
    
    ev.Visible = visible
end)

-- Skillbooks filter.
QuickInventory.Hooks.IsItemVisible:Subscribe(function (ev)
    local item = ev.Item
    local visible = ev.Visible

    if QuickInventory:GetSettingValue(QuickInventory.Settings.ItemCategory) == "Skillbooks" then
        local showLearntSkills = QuickInventory:GetSettingValue(QuickInventory.Settings.LearntSkillbooks) == true
        local school = QuickInventory:GetSettingValue(QuickInventory.Settings.SkillbookSchool)

        visible = visible and Item.HasUseAction(item, "SkillBook")
        
        if visible then
            if not showLearntSkills then
                local skillBookActions = Item.GetUseActions(item, "SkillBook") ---@type SkillBookActionData[]
                local knowsAllSkills = true
    
                for _,action in ipairs(skillBookActions) do
                    if not Character.IsSkillLearnt(Client.GetCharacter(), action.SkillID) then
                        knowsAllSkills = false
                        break
                    end
                end
    
                -- Only filter out the item if all skills from the book are learnt.
                visible = visible and not knowsAllSkills
            end
    
            if school ~= "Any" then
                -- Only checks first skill
                local action = Item.GetUseActions(item, "SkillBook")[1] ---@type SkillBookActionData
                local skillStat = Stats.Get("SkillData", action.SkillID)

                visible = visible and skillStat.Ability == school
            end
        end
    end
    
    ev.Visible = visible
end)