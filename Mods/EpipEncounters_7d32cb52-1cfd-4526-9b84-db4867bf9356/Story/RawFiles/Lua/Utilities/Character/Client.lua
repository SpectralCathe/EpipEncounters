
---@class CharacterLib
local Character = Character

---------------------------------------------
-- EVENTS
---------------------------------------------

Character.Hooks.CreateEquipmentVisuals = Character:AddSubscribableHook("CreateEquipmentVisuals") ---@type Event<CharacterLib_Hook_CreateEquipmentVisuals>

---Wrapper for Ext.Events.CreateEquipmentVisualsRequest.
---@class CharacterLib_Hook_CreateEquipmentVisuals
---@field Character EclCharacter
---@field Item EclItem
---@field Request EclEquipmentVisualSystemSetParam Hookable.
---@field RawEvent EclLuaCreateEquipmentVisualsRequestEvent

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns a list of party members of char's party. Char must be a player.
---Depends on PlayerInfo.
---@param char EclCharacter
---@return EclCharacter[] Includes the char passed per param.
function Character.GetPartyMembers(char)
    local members = {}

    if char.IsPlayer then
        members = Client.UI.PlayerInfo.GetCharacters()

        local hasChar = false
        for _,member in ipairs(members) do
            if member.Handle == char.Handle then
                hasChar = true
            end
        end

        -- If char is not in the client's party, we cannot fetch its members.
        if not hasChar then
            Character:LogWarning(char.DisplayName .. " is not in the client's party; cannot fetch their party members on the client.")

            members = {}
        end
    end

    return members
end

---@param char EclCharacter
---@param handle EntityHandle
---@return EclStatus
function Character.GetStatusByHandle(char, handle)
    return Ext.GetStatus(char, handle)
end

---Returns a list of statuses the character has from its equipped items.
---@param char Character
---@return CharacterLib_StatusFromItem[]
function Character.GetStatusesFromItems(char)
    local items = Character.GetEquippedItems(char)
    local statuses = {}

    for _,item in ipairs(items) do
        local props = item.Stats.PropertyLists
        local extraProps = props.ExtraProperties

        -- Check SelfOnEquip properties
        if extraProps and table.contains(extraProps.AllPropertyContexts, "SelfOnEquip") then
            local name = extraProps.Name
            name = string.sub(name, 1, string.len(name)//2)
            name = name:gsub("_ExtraProperties$", "") -- Boost name

            -- Examine boost stat to find the status name
            local stat = Stats.Get("Boost", name)
            if stat then
                local statProps = stat.ExtraProperties

                for _,statProp in ipairs(statProps) do
                    if statProp.Type == "Status" then
                        local status = char:GetStatus(statProp.Action)
    
                        if status then
                            table.insert(statuses, {Status = status, ItemSource = item})
                        end
                    end
                end
            end
        end
    end

    return statuses
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Forward equipment visual events.
Ext.Events.CreateEquipmentVisualsRequest:Subscribe(function (ev)
    ev = ev ---@type EclLuaCreateEquipmentVisualsRequestEvent
    local char = ev.Character or Client.GetCharacter() -- If character is nil, then we are rendering the sheet paperdoll
    local item = char:GetItemBySlot(ev.Params.Slot)
    ---@diagnostic disable-next-line: cast-local-type
    item = item and Item.Get(item)

    Character.Hooks.CreateEquipmentVisuals:Throw({
        Character = char,
        Request = ev.Params,
        RawEvent = ev,
        Item = item,
    })
end)