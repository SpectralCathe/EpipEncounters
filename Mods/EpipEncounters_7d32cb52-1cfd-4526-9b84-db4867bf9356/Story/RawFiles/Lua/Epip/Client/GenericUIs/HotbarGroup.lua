
local Generic = Client.UI.Generic
local HotbarSlot = Generic.GetPrefab("GenericUI_Prefab_HotbarSlot")
local Spinner = Generic.GetPrefab("GenericUI_Prefab_Spinner")
local ContextMenu = Client.UI.ContextMenu

---@class Feature_HotbarGroupManager : Feature
local GroupManager = {
    UI = nil, ---@type GenericUI_Instance
    Groups = {}, ---@type table<GUID, HotbarGroup>
    SharedGroups = {}, ---@type table<GUID, true>

    _Content_WIDTH = 450,
    UI_WIDTH = 500,
    UI_HEIGHT = 400,

    SAVE_FILENAME = "EpipEncounters_HotbarGroups.json",
    SAVE_VERSION = 0,

    STATE = {CREATE=0, RESIZE=1},
    CURRENT_STATE = 0,
    CURRENT_GROUP_GUID = nil, ---@type string
}
Epip.RegisterFeature("HotbarGroupManager", GroupManager)

---------------------------------------------
-- HOTBAR GROUP
---------------------------------------------

---@class HotbarGroupState
---@field Rows integer
---@field Columns integer
---@field SharedContents GenericUI_Prefab_HotbarSlot_Object[][]
---@field RelativePosition number[]

---@class HotbarGroup
local HotbarGroup = {
    UI = nil, ---@type GenericUI_Instance
    GUID = nil, ---@type GUID
    SLOT_SIZE = 50,
    SLOT_SPACING = 0,

    _ElementRows = {},
    _Rows = 0,
    _Columns = 0,

    _Content = nil, ---@type GenericUI_Element_TiledBackground
    _Container = nil, ---@type GenericUI_Element_Grid
    _DragArea = nil, ---@type GenericUI_Element_Divider
}

---@param row integer
---@param col integer
---@return GenericUI_Prefab_HotbarSlot
function HotbarGroup:_AddSlot(row, col)
    local slot = HotbarSlot.Create(self.UI, "Row_" .. row .. "_Slot_" .. col, self._Container)
    slot:SetCanDragDrop(true)
    slot.SlotElement:SetSizeOverride(self.SLOT_SIZE + 6, self.SLOT_SIZE + 6)
    self._ElementRows[row][col] = slot
    return slot
end

---@param row integer
---@param col integer
function HotbarGroup:_DeleteSlot(row, col)
    local slot = self._ElementRows[row][col]
    if slot then HotbarSlot.Destroy(slot) end
    self._ElementRows[row][col] = nil
end

---@return number, number -- Width, height
function HotbarGroup:GetSlotAreaSize()
    local width = self._Columns * self.SLOT_SIZE + (self._Columns - 1) * self.SLOT_SPACING
    local height = self._Rows * self.SLOT_SIZE + (self._Rows - 1) * self.SLOT_SPACING

    return width, height
end

---@return GenericUI_Prefab_HotbarSlot
function HotbarGroup:GetSlot(row, column)
    local slot = self._ElementRows[row][column]

    return slot
end

---@param newRows integer
---@param newColumns integer
function HotbarGroup:Resize(newRows, newColumns)
    --Delete excess rows first
    if self._Rows > 0 then
        for i=self._Rows,newRows+1,-1 do
            for j=1,math.max(self._Columns,newColumns),1 do
                if (i > newRows or j > newColumns) then
                    self:_DeleteSlot(i, j)
                end
            end
            self._ElementRows[i] = nil
        end
    end

    for i=newRows,1,-1 do
        if i > self._Rows then
            self._ElementRows[i] = {}
        end
        for j=1,math.max(self._Columns,newColumns),1 do
            if i > self._Rows or j > self._Columns then
                self:_AddSlot(i, j)
            else
                self:_DeleteSlot(i, j)
            end
        end
    end

    self._Rows = newRows
    self._Columns = newColumns

    local width, height = self:GetSlotAreaSize()

    self._Content:SetBackground("Black", width, height)
    self._Content:SetPosition(25, 25)

    self._Container:SetGridSize(newColumns, newRows)
    self._Container:SetPosition(3, 3)
    self._Container:RepositionElements()
    self._Container:SetSizeOverride(self:GetSlotAreaSize())

    -- Dragging area/handle
    local mcWidth, mcHeight = self._Container:GetMovieClip().width, self._Container:GetMovieClip().height
    local EXTRA_WIDTH = 15 * 2
    -- Show the handle on the longest side of the slot group
    if width < height then
        self._DragArea:SetRotation(90)
        self._DragArea:SetSize(mcHeight + EXTRA_WIDTH)
        self._DragArea:SetPosition(0, -EXTRA_WIDTH/2)
    else
        self._DragArea:SetRotation(0)
        self._DragArea:SetSize(mcWidth + EXTRA_WIDTH)
        self._DragArea:SetPosition(-EXTRA_WIDTH/2, -25)
    end
end

function HotbarGroup:_Init(id, rows, columns)
    self.GUID = id
    self.UI = Generic.Create("HotbarGroup_" .. self.GUID)

    local content = self.UI:CreateElement("ContentContainer", "GenericUI_Element_TiledBackground")
    content:SetAlpha(0)
    self._Content = content

    local container = content:AddChild("container", "GenericUI_Element_Grid")
    container:SetElementSpacing(HotbarGroup.SLOT_SPACING - 4, HotbarGroup.SLOT_SPACING)
    container:SetPosition(3, 3)
    container:SetRepositionAfterAdding(false)
    container:SetGridSize(self._Columns, self._Rows)
    self._Container = container

    local dragArea = content:AddChild("DragArea", "GenericUI_Element_Divider")
    dragArea:SetAsDraggableArea()
    dragArea:SetType("Border")
    dragArea.Tooltip = "Click and hold to drag."
    self._DragArea = dragArea

    self:Resize(rows, columns)

    self.UI:Show()
end

---------------------------------------------
-- METHODS
---------------------------------------------

function GroupManager.Setup()
    GroupManager.CURRENT_STATE = GroupManager.STATE.CREATE
    local ui = GroupManager.UI

    ui:ExternalInterfaceCall("setPosition", "center", "screen", "center")
    ui:Show()
end

---@param guid string
function GroupManager.ShowResizeUI(guid)
    GroupManager.CURRENT_STATE = GroupManager.STATE.RESIZE
    GroupManager.CURRENT_GROUP_GUID = guid
    local ui = GroupManager.UI

    ui:ExternalInterfaceCall("setPosition", "center", "screen", "center")
    ui:Show()
end

---@param id string
---@return HotbarGroup
function GroupManager.Create(id, rows, columns)
    ---@type HotbarGroup
    local group = {
    }
    Inherit(group, HotbarGroup)

    id = id or Text.GenerateGUID()

    group:_Init(id, rows, columns)

    local width, height = group:GetSlotAreaSize()
    local uiObject = group.UI:GetUI()
    
    uiObject.SysPanelSize = {width, height}
    uiObject.Left = width

    uiObject:ExternalInterfaceCall("setPosition", "center", "screen", "center")

    local container = group.UI:GetElementByID("ContentContainer")
    container.Events.RightClick:Subscribe(function (e)
        local x, y = Client.GetMousePosition()
        ContextMenu.RequestMenu(x, y, "HotbarGroup", nil, group.GUID)
    end)

    GroupManager.Groups[group.GUID] = group
    GroupManager.SharedGroups[group.GUID] = true

    return group
end

function GroupManager.ResizeGroup(guid, newRows, newColumns)
    ---@type HotbarGroup
    local group = nil
    if type(guid) == "string" then group = GroupManager.Groups[guid] end

    if group then
        group:Resize(newRows, newColumns)
    else
        GroupManager:LogError("Tried to resize group that doesn't exist")
    end
end

---@param group HotbarGroup|GUID
function GroupManager.DeleteGroup(group)
    if type(group) == "string" then group = GroupManager.Groups[group] end

    if group then
        -- TODO truly delete
        -- Ext.UI.Destroy(group.UI.Name)
        group.UI:Hide()

        GroupManager.Groups[group.GUID] = nil
    else
        GroupManager:LogError("Tried to delete group that doesn't exist")
    end
end

---@param group HotbarGroup
---@return HotbarGroupState
function GroupManager.GetGroupState(group)
    ---@type HotbarGroupState
    local state = {
        Rows = group._Rows,
        Columns = group._Columns,
    }

    -- Store position relative to viewport edges
    local uiObject = group.UI:GetUI()
    local viewport = Ext.UI.GetViewportSize()
    state.RelativePosition = uiObject:GetPosition()
    state.RelativePosition[1] = state.RelativePosition[1] / viewport[1]
    state.RelativePosition[2] = state.RelativePosition[2] / viewport[2]

    if GroupManager.SharedGroups[group.GUID] == true then
        state.SharedContents = {}

        for i=1,state.Rows,1 do
            local row = {}

            state.SharedContents[i] = row

            for z=1,state.Columns,1 do
                local slot = table.deepCopy(group:GetSlot(i, z).Object) ---@type GenericUI_Prefab_HotbarSlot_Object
                if slot.ItemHandle then slot.ItemHandle = nil end

                table.insert(row, slot)
            end
        end
    end

    return state
end

---@param path string?
function GroupManager.SaveData(path)
    path = path or GroupManager.SAVE_FILENAME
    local save = {
        Version = GroupManager.SAVE_VERSION,
        Groups = {},
    }

    for guid,group in pairs(GroupManager.Groups) do
        save.Groups[guid] = GroupManager.GetGroupState(group)
    end

    IO.SaveFile(path, save)
end

---@param path string?
function GroupManager.LoadData(path)
    path = path or GroupManager.SAVE_FILENAME
    local save = IO.LoadFile(path)

    if save and save.Version == 0 then
        local groups = save.Groups

        for guid,data in pairs(groups) do
            local group = GroupManager.Create(guid, data.Rows, data.Columns)

            -- Load shared contents
            if data.SharedContents then
                for i=1,data.Rows,1 do
                    for z=1,data.Columns,1 do
                        local slotData = data.SharedContents[i][z]
                        local slot = group:GetSlot(i, z)

                        slot:SetObject(slotData)
                    end
                end
            end

            -- Set position
            local position = data.RelativePosition
            local viewport = Ext.UI.GetViewportSize()

            if GameState.GetState() == "Running" then
                Timer.Start(0.1, function ()
                    group.UI:GetUI():SetPosition(Ext.Round(position[1] * viewport[1]), Ext.Round(position[2] * viewport[2]))
                end)
            else
                GameState.Events.GameReady:Subscribe(function (e)
                    group.UI:GetUI():SetPosition(Ext.Round(position[1] * viewport[1]), Ext.Round(position[2] * viewport[2]))
                end, {Once = true})
            end
            
        end
    end
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

Client.UI.ContextMenu.RegisterElementListener("hotBarRow_CreateGroup", "buttonPressed", function(_)
    GroupManager.Setup()
end)

Client.UI.Hotbar:RegisterListener("SaveDataSaved", function()
    GroupManager.SaveData()
end)

---------------------------------------------
-- Listeners for context menus on HotbarGroup

ContextMenu.RegisterMenuHandler("HotbarGroup", function(char, guid)
    local contextMenu = {
        {id = "HotbarGroup_Delete", type = "button", text = "Delete", params = {GUID = guid}},
        {id = "HotbarGroup_Resize", type = "button", text = "Resize", params = {GUID = guid}}
    }

    Client.UI.ContextMenu.Setup({
        menu = {
            id = "main",
            entries = contextMenu,
        }
    })

    Client.UI.ContextMenu.Open()
end)

ContextMenu.RegisterElementListener("HotbarGroup_Delete", "buttonPressed", function(_, params)
    GroupManager.DeleteGroup(params.GUID)
end)

ContextMenu.RegisterElementListener("HotbarGroup_Resize", "buttonPressed", function(_, params)
    GroupManager.ShowResizeUI(params.GUID)
end)

---------------------------------------------
-- SETUP
---------------------------------------------

function GroupManager:__Setup()
    local ui = Generic.Create("PIP_HotbarGroup") ---@type GenericUI_Instance
    GroupManager.UI = ui

    local bg = ui:CreateElement("BG", "GenericUI_Element_TiledBackground")
    bg:SetBackground("RedPrompt", GroupManager.UI_WIDTH, GroupManager.UI_HEIGHT)
    local uiObject = ui:GetUI()
    uiObject.SysPanelSize = {GroupManager.UI_WIDTH, GroupManager.UI_HEIGHT}

    -- Content
    local content = bg:AddChild("Content", "GenericUI_Element_VerticalList")
    content:SetSize(GroupManager._Content_WIDTH, GroupManager.UI_HEIGHT)
    content:SetPosition(27, 60)

    local text = content:AddChild("Header", "GenericUI_Element_Text")
    text:SetText(Text.Format("Create Hotbar Group", {Color = Color.WHITE, Size = 23}))
    text:SetStroke(Color.Create(0, 0, 0), 1, 1, 1, 5)
    text:SetSize(GroupManager._Content_WIDTH, 50)

    local rowSpinner = Spinner.Create(ui, "RowSpinner", content, "Rows", 1, 20, 1)
    local columnSpinner = Spinner.Create(ui, "ColumnSpinner", content, "Columns", 1, 20, 1)

    rowSpinner:GetMainElement():SetCenterInLists(true)
    columnSpinner:GetMainElement():SetCenterInLists(true)

    content:AddChild("Filler", "GenericUI_Element_Empty"):GetMovieClip().heightOverride = 175

    local createButton = content:AddChild("Confirm", "GenericUI_Element_Button")
    createButton.Events.Pressed:Subscribe(function(_)
        if (GroupManager.CURRENT_STATE == GroupManager.STATE.CREATE) then
            GroupManager.Create(nil, rowSpinner:GetValue(), columnSpinner:GetValue())
        else --if (GroupManager.CURRENT_STATE == GroupManager.STATE.RESIZE) then
            GroupManager.ResizeGroup(GroupManager.CURRENT_GROUP_GUID, rowSpinner:GetValue(), columnSpinner:GetValue())
        end
        GroupManager.UI:Hide()
    end)
    createButton:SetCenterInLists(true)
    createButton:SetType("Red")
    createButton:SetText("Create", 4)

    content:SetElementSpacing(0)

    content:RepositionElements()

    ui:Hide()

    GroupManager.LoadData()
end

---------------------------------------------
-- TESTS
---------------------------------------------

-- Ext.Events.SessionLoaded:Subscribe(function (e)
--     if Epip.IsDeveloperMode(true) then
--         local group = GroupManager.Create("test")
--     end
-- end)