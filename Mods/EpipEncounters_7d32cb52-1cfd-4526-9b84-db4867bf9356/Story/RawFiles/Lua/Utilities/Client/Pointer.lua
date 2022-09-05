
---@class PointerLib : Library
Pointer = {
    CurrentHandles = {
        HoverCharacter = {EventName = "HoverCharacterChanged", EntityEventFieldName = "Character", CurrentHandle = nil},
        HoverCharacter2 = {EventName = "HoverCharacter2Changed", EntityEventFieldName = "Character", CurrentHandle = nil},
        HoverItem = {EventName = "HoverItemChanged", EntityEventFieldName = "Item", CurrentHandle = nil},
        PlaceableEntity = {EventName = "HoverEntityChanged", EntityEventFieldName = "Entity", CurrentHandle = nil},
    },

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS= false,

    Events = {
        HoverCharacterChanged = {}, ---@type SubscribableEvent<PointerLib_Event_HoverCharacterChanged>
        HoverCharacter2Changed = {}, ---@type SubscribableEvent<PointerLib_Event_HoverCharacter2Changed>
        HoverItemChanged = {}, ---@type SubscribableEvent<PointerLib_Event_HoverItemChanged>
        HoverEntityChanged = {}, ---@type SubscribableEvent<PointerLib_Event_HoverEntityChanged>
    },
}
Epip.InitializeLibrary("Pointer", Pointer)

---------------------------------------------
-- CLASSES
---------------------------------------------

---@class PointerLib_PickingState
---@field WorldPosition Vector3D?
---@field WalkablePosition Vector3D
---@field HoverCharacter EntityHandle?
---@field HoverCharacter2 EntityHandle? Used for corpses.
---@field HoverCharacterPosition Vector3D? Corresponds to HoverCharacter's position.
---@field HoverItem EntityHandle?
---@field HoverItemPosition Vector3D?
---@field PlaceableEntity EntityHandle?
---@field PlaceablePosition Vector3D?

---------------------------------------------
-- EVENTS/HOOKS
---------------------------------------------

---@class PointerLib_Event_HoverCharacterChanged
---@field Character EclCharacter?

---Fired when the corpse character over the pointer changes.
---@class PointerLib_Event_HoverCharacter2Changed
---@field Character EclCharacter?

---@class PointerLib_Event_HoverItemChanged
---@field Item EclItem?

---@class PointerLib_Event_HoverEntityChanged
---@field Entity Entity?

---------------------------------------------
-- METHODS
---------------------------------------------

---@param includeDead boolean? Defaults to false.
---@return EclCharacter?
function Pointer.GetCurrentCharacter(includeDead)
    local char = Pointer._GetCurrentEntity("HoverCharacter") ---@type EclCharacter
    
    if not char and includeDead then
        char = Pointer._GetCurrentEntity("HoverCharacter2") ---@type EclCharacter
    end

    return char
end

---@return EclItem?
function Pointer.GetCurrentItem()
    ---@diagnostic disable-next-line: return-type-mismatch
    return Pointer._GetCurrentEntity("HoverItem")
end

---@return Entity?
function Pointer.GetCurrentEntity()
    return Pointer._GetCurrentEntity("HoverEntity")
end

---@return Vector3D
function Pointer.GetWalkablePosition()
    local state = Ext.UI.GetPickingState()
    local position
    
    if state then
        position = Vector.Create(table.unpack(state.WalkablePosition))
    end

    return position
end

---@param fieldName string
---@return Entity
function Pointer._GetCurrentEntity(fieldName)
    local state = Ext.UI.GetPickingState()
    local entity

    if state then
        local handle = state[fieldName]

        if handle then
            entity = Ext.Entity.GetGameObject(handle) ---@type Entity
        end
    end

    return entity
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Listen for pointer entities changing.
GameState.Events.RunningTick:Subscribe(function (_)
    local state = Ext.UI.GetPickingState(1) -- TODO support more players

    for field,data in pairs(Pointer.CurrentHandles) do
        local newHandle = state[field]

        -- Fire events when the pointer entities change
        if newHandle ~= data.CurrentHandle then
            local event = {}

            if newHandle then
                event[data.EntityEventFieldName] = Ext.Entity.GetGameObject(newHandle)
            end

            Pointer.Events[data.EventName]:Throw(event)

            data.CurrentHandle = newHandle
        end
    end
end)

---------------------------------------------
-- TESTS
---------------------------------------------

-- Pointer.Events.HoverCharacter2Changed:Subscribe(function (ev)
--     print("HoverCharacter2Changed:", ev.Character)
-- end)

-- Pointer.Events.HoverCharacterChanged:Subscribe(function (ev)
--     print("HoverCharacterChanged:", ev.Character)
-- end)

-- Pointer.Events.HoverEntityChanged:Subscribe(function (ev)
--     print("HoverEntityChanged:", ev.Entity)
-- end)

-- Pointer.Events.HoverItemChanged:Subscribe(function (ev)
--     print("HoverItemChanged:", ev.Item)
-- end)