
local OptionsInput = Client.UI.OptionsInput
local Vanity = Client.UI.Vanity

---@class Feature_Housing : Feature
local Housing = Epip.Features.Housing

Housing.selectedFurniture = nil ---@type Feature_Housing_SelectedFurniture
Housing.furnitureYAxisStep = 0.5
Housing.FURNITURE_ROTATION_STEP = 0.1

---@class Feature_Housing_SelectedFurniture
---@field Handle EntityHandle
---@field EntityType "Item"|"Scenery"
---@field PositionOffset Vector3D
---@field OriginalPosition Vector3D
local _SelectedFurniture = {}

---@return EclItem|EclScenery
function _SelectedFurniture:GetEntity()
    return Ext.Entity.GetGameObject(self.Handle)
end

---@param pos Vector3D
---@param addOffset boolean? Defaults to true.
function _SelectedFurniture:SetPosition(pos, addOffset)
    pos = table.deepCopy(pos)
    local obj = self:GetEntity()
    
    if addOffset then
        for i,v in ipairs(pos) do
            pos[i] = v + self.PositionOffset[i]
        end
    end

    if self.EntityType == "Item" then
        obj.Translate = pos
    else
        -- Objects do not automatically snap to walkable grid, since many of them are walkable themselves and cause the object to infinitely rise.
        local y = self.OriginalPosition[2]

        pos[2] = y
        if addOffset then
            pos[2] = pos[2] + self.PositionOffset[2]
        end

        obj.Translate = pos
    end
end

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns the furniture currently being moved.
---@return Feature_Housing_SelectedFurniture
function Housing.GetSelectedFurniture()
    local obj

    if Housing.selectedFurniture then
        obj = Housing.selectedFurniture
    end

    return obj
end

---@return boolean
function Housing.IsMovingFurniture()
    return Housing.selectedFurniture ~= nil
end

---Begins moving a furniture.
---@param obj EclItem|EclScenery
---@param handle? EntityHandle Necessary for scenery due to technical limitations.
function Housing.SelectFurniture(obj, handle)
    Housing:DebugLog("Moving furniture: ", obj)

    ---@type Feature_Housing_SelectedFurniture
    local selectedObj = {
        Handle = handle or obj.Handle,
        EntityType = "Scenery",
        PositionOffset = {0, 0, 0},
        OriginalPosition = obj.Translate,
    }
    Inherit(selectedObj, _SelectedFurniture)

    if GetExtType(obj) == "ecl::Item" then
        selectedObj.EntityType = "Item"
    end

    Housing.selectedFurniture = selectedObj

    GameState.Events.RunningTick:Subscribe(function (_)
        local pos = Ext.UI.GetPickingState(1).WalkablePosition
        -- local pos = Ext.UI.GetPickingState(1).PlaceablePosition

        if pos then
            Housing.selectedFurniture:SetPosition(pos, true)
        end
    end, {StringID = "Housing_MoveFurniture"})

    -- Cannot prevent mouse events unfortunately.
    -- Client.UI.Input.ToggleEventCapture(Client.Input.FLASH_EVENTS.EDIT_CHARACTER, true, "Housing")
    -- Client.UI.Input.ToggleEventCapture(Client.Input.FLASH_EVENTS.CONTEXT_MENU, true, "Housing")

    Client.UI.Input.SetMouseWheelBlocked(true)
end

function Housing.PlaceMovingFurniture()
    local obj = Housing.GetSelectedFurniture():GetEntity()

    -- Sync item positions to server
    if Housing.GetSelectedFurniture().EntityType == "Item" then
        Net.PostToServer("EPIPENCOUNTERS_Housing_PlaceMovingFurniture", {
            ObjNetID = obj.NetID,
            Position = obj.Translate,
        })
    end

    Housing.selectedFurniture = nil
    GameState.Events.RunningTick:Unsubscribe("Housing_MoveFurniture")

    -- Client.UI.Input.ToggleEventCapture(Client.Input.FLASH_EVENTS.EDIT_CHARACTER, false, "Housing")
    -- Client.UI.Input.ToggleEventCapture(Client.Input.FLASH_EVENTS.CONTEXT_MENU, false, "Housing")
    Client.UI.Input.SetMouseWheelBlocked(false)
end

---@param furniture GUID|Feature_Housing_Furniture
---@param position Vector3D
function Housing.SpawnFurniture(furniture, position)
    if type(furniture) == "string" then furniture = Housing.GetFurniture(furniture) end

    Net.PostToServer("EPIPENCOUNTERS_Housing_SpawnFurniture", {
        Position = position,
        FurnitureGUID = furniture.TemplateGUID,
    })
end

---------------------------------------------
-- VANITY TAB
---------------------------------------------

local Tab = Vanity.CreateTab({
    Name = "Furniture",
    ID = "PIP_Furniture",
    Icon = Client.UI.Hotbar.ACTION_ICONS.BAG,
})

function Tab:Render()
    Vanity.RenderText("Header", "Spawn furniture out of thin air!")

    local furniture = Housing.GetFurnitureTable()
    local categories = {}
    for objType,furnitures in pairs(furniture) do
        local newTable = {
            Type = Housing.GetfurnitureTypeName(objType),
            Furnitures = {},
        }
        table.insert(categories, newTable)

        for _,data in pairs(furnitures) do
            table.insert(newTable.Furnitures, data)
        end

        table.sort(newTable.Furnitures, function (a, b)
            return a.Name < b.Name
        end)
    end
    table.sort(categories, function (a, b)
        return a.Type < b.Type
    end)

    for _,category in ipairs(categories) do
        local isOpen = Vanity.IsCategoryOpen(category.Type)
        Vanity.RenderEntry(category.Type, category.Type, true, isOpen, false, false)

        if isOpen then
            for _,data in ipairs(category.Furnitures) do
                Vanity.RenderEntry(data.TemplateGUID, data.Name, false, false, false, false)
            end
        end
    end
end

Tab:RegisterListener(Vanity.Events.EntryClicked, function(id)
    Housing.SpawnFurniture(id, Client.GetCharacter().Translate)
end)

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Interacting with furniture.
OptionsInput.Events.ActionExecuted:RegisterListener(function (action, binding)
    if action == "EpipEncounters_Housing_MoveFurniture" then
        local pointer = Ext.UI.GetPickingState(1)
        local handle = pointer.HoverItem or pointer.PlaceableEntity
        -- local handle = pointer.HoverItem
        
        if Housing.IsMovingFurniture() then
            Housing.PlaceMovingFurniture()
        elseif handle then
            local obj = Ext.Entity.GetGameObject(handle)

            if obj then
                Housing.SelectFurniture(obj, handle)
            end
        end
    elseif Housing.IsMovingFurniture() then
        local obj = Housing.GetSelectedFurniture()
        local entity = obj:GetEntity()

        if action == "EpipEncounters_Housing_RaiseFurniture" or action == "EpipEncounters_Housing_LowerFurniture" then -- Raise/lower furniture.
            local offset = Housing.furnitureYAxisStep
            if action == "EpipEncounters_Housing_LowerFurniture" then
                offset = -offset
            end

            obj.PositionOffset = {obj.PositionOffset[1], obj.PositionOffset[2] + offset, obj.PositionOffset[3]}
        elseif action == "EpipEncounters_Housing_RotateFurniture_Plus" or action == "EpipEncounters_Housing_RotateFurniture_Minus" then
            -- TODO
            local rotation = entity.Rotation
            local offset = Housing.FURNITURE_ROTATION_STEP
            if action == "EpipEncounters_Housing_RotateFurniture_Minus" then
                offset = -offset
            end

            local angles = Ext.Math.ExtractEulerAngles(rotation)
            local rotationMatrix = Ext.Math.BuildRotation3({1, 0, 0}, 10)
            rotation = Ext.Math.BuildFromEulerAngles3(angles)
            
            entity.Rotation = Ext.Math.Rotate(rotation, 90, {1, 0, 0})

            -- _D(rotation)
        end
    end
end)

-- Place down moving furniture.
Client.Input.Events.MouseButtonPressed:Subscribe(function (e)
    if Housing.IsMovingFurniture() and (e.InputID == "left2" or e.InputID == "right2") then
        Housing.PlaceMovingFurniture()
    end
end)