
local Bedazzled = Epip.GetFeature("Feature_Bedazzled")
local Generic = Client.UI.Generic
local Input = Client.Input
local V = Vector.Create

local UI = Generic.Create("Feature_Bedazzled")
UI:Hide()

UI._Initialized = false
UI.Board = nil ---@type Feature_Bedazzled_Board
UI.Gems = {} ---@type table<GUID, GenericUI_Prefab_Bedazzled_Gem>
UI.GemSelection = nil ---@type Feature_Bedazzled_UI_GemSelection

UI.CELL_BACKGROUND = "Item_Epic"
UI.CELL_SIZE = V(64, 64)
UI.BACKGROUND_SIZE = V(700, 800)
UI.MOUSE_SWIPE_DISTANCE_THRESHOLD = 30

---------------------------------------------
-- CLASSES
---------------------------------------------

---@class Feature_Bedazzled_UI_GemSelection
---@field Position Vector2
---@field InitialMousePosition Vector2
---@field CanSwipe boolean

---------------------------------------------
-- GEM PREFAB
---------------------------------------------

---@class GenericUI_Prefab_Bedazzled_Gem : GenericUI_Prefab, GenericUI_Element
---@field Gem Feature_Bedazzled_Board_Gem
---@field Root GenericUI_Element_Empty
---@field Icon GenericUI_Element_IggyIcon
local GemPrefab = {

}
Generic.RegisterPrefab("GenericUI_Prefab_Bedazzled_Gem", GemPrefab)

---@param ui GenericUI_Instance
---@param id string
---@param parent (GenericUI_Element|string)?
---@param gem Feature_Bedazzled_Board_Gem
---@return GenericUI_Prefab_Bedazzled_Gem
function GemPrefab.Create(ui, id, parent, gem)
    ---@diagnostic disable-next-line: invisible
    local element = GemPrefab:_Create(ui, id) ---@type GenericUI_Prefab_Bedazzled_Gem

    element.Gem = gem

    local root = element:CreateElement("Container", "GenericUI_Element_Empty", parent)
    element.Root = root
    local icon = element:CreateElement("Icon", "GenericUI_Element_IggyIcon", root)
    element.Icon = icon

    icon:SetPosition(-UI.CELL_SIZE[1] / 2, -UI.CELL_SIZE[2]/2)

    root:SetMouseEnabled(false)
    root:SetMouseChildren(false)

    element:UpdateIcon()

    return element
end

---@param tween GenericUI_ElementTween
function GemPrefab:Tween(tween)
    self.Root:Tween(tween)
end

function GemPrefab:Update()
    local gem = self.Gem
    local root = self.Root
    local x, y = UI.GamePositionToUIPosition(self.Gem.X, gem:GetPosition())
    local gemState = gem.State.ClassName

    if gemState == "Feature_Bedazzled_Board_Gem_State_InvalidSwap" or gemState == "Feature_Bedazzled_Board_Gem_State_Swapping" then
        -- Handled by tween
    else
        root:SetPosition(x, y)
    end

    self:UpdateIcon()
end

function GemPrefab:UpdateIcon()
    local iconElement = self.Icon
    local gem = self.Gem
    local icon
    
    icon = gem:GetIcon()

    iconElement:SetIcon(icon, UI.CELL_SIZE:unpack())
end

---Returns the gem's position on the UI grid, in pixels.
function GemPrefab:GetGridPosition()
    local gem = self.Gem
    local x, y = gem.X, gem.Y

    return UI.GamePositionToUIPosition(x, y)
end

---------------------------------------------
-- METHODS
---------------------------------------------

function UI.Setup()
    local board = Bedazzled.CreateBoard()
    UI.Board = board

    UI._Initialize(board)

    -- Update UI when the board updates.
    board.Events.Updated:Subscribe(function (ev)
        UI.Update(ev.DeltaTime)
    end)

    board.Events.GemAdded:Subscribe(function (ev)
        local gem = ev.Gem
        local guid = Text.GenerateGUID()
        local element = GemPrefab.Create(UI, guid, UI.Background, gem)

        -- Forward state change events.
        gem.Events.StateChanged:Subscribe(function (stateChangeEv)
            UI.OnGemStateChanged(gem, stateChangeEv.NewState, stateChangeEv.OldState)
        end)

        UI.Gems[guid] = element
    end)

    UI:Show()
end

---@param gem Feature_Bedazzled_Board_Gem
---@param newState Feature_Bedazzled_Board_Gem_StateClassName
---@param oldState Feature_Bedazzled_Board_Gem_State
function UI.OnGemStateChanged(gem, newState, oldState)
    local element = UI.GetGemElement(gem)
    local state

    if oldState.ClassName == "Feature_Bedazzled_Board_Gem_State_Swapping" then
        element:UpdateIcon()
    end

    if newState == "Feature_Bedazzled_Board_Gem_State_Swapping" then
        state = gem.State ---@type Feature_Bedazzled_Board_Gem_State_Swapping
        local otherGem = state.OtherGem
        local otherElement = UI.GetGemElement(otherGem)

        element.Gem, otherElement.Gem = otherElement.Gem, element.Gem

        local element1x, element1y = UI.GamePositionToUIPosition(element.Gem:GetBoardPosition())
        local element2x, element2y = UI.GamePositionToUIPosition(otherElement.Gem:GetBoardPosition())

        -- Tween both gems to make it look like they're swapping places
        -- In the game logic, this actually happens instantly.
        -- Match-checks are delayed until the Swapping state ends.
        otherElement:Tween({
            EventID = "Bedazzled_Swap1",
            FinalValues = {
                x = element2x,
                y = element2y,
            },
            StartingValues = {
                x = element1x,
                y = element1y,
            },
            Function = "Cubic",
            Ease = "EaseOut",
            Duration = state.Duration,
        })
        element:Tween({
            EventID = "Bedazzled_Swap1",
            FinalValues = {
                x = element1x,
                y = element1y,
            },
            StartingValues = {
                x = element2x,
                y = element2y,
            },
            Function = "Cubic",
            Ease = "EaseOut",
            Duration = state.Duration,
        })
    elseif newState == "Feature_Bedazzled_Board_Gem_State_Consuming" then
        state = gem.State ---@type Feature_Bedazzled_Board_Gem_State_Consuming

        element:Tween({
            EventID = "Bedazzled_Consume",
            FinalValues = {
                scaleX = 0, -- TODO dispose of elements afterwards
                scaleY = 0,
            },
            StartingValues = {
                scaleX = 1.2,
                scaleY = 1.2,
            },
            Function = "Quadratic",
            Ease = "EaseInOut",
            Duration = state.Duration,
        })
    elseif newState == "Feature_Bedazzled_Board_Gem_State_InvalidSwap" then -- Play invalid swap animation
        state = gem.State ---@type Feature_Bedazzled_Board_Gem_State_InvalidSwap

        local otherGem = state.OtherGem
        local otherElement = UI.GetGemElement(otherGem)

        local element1x, element1y = UI.GamePositionToUIPosition(element.Gem:GetBoardPosition())
        local element2x, element2y = UI.GamePositionToUIPosition(otherElement.Gem:GetBoardPosition())

        element:Tween({
            EventID = "Bedazzled_InvalidSwap",
            FinalValues = {
                x = element2x,
                y = element2y,
            },
            StartingValues = {
                x = element1x,
                y = element1y,
            },
            Function = "Quadratic",
            Ease = "EaseInOut",
            Duration = state.Duration / 2,
            OnComplete = function (_) -- Animate back to initial position
                element:Tween({
                    EventID = "Bedazzled_InvalidSwap_Return",
                    FinalValues = {
                        x = element1x,
                        y = element1y,
                    },
                    StartingValues = {
                        x = element2x,
                        y = element2y,
                    },
                    Function = "Quadratic",
                    Ease = "EaseInOut",
                    Duration = state.Duration / 2,
                })
            end
        })
    end
end

---@return boolean
function UI.HasGemSelection()
    return UI.GemSelection ~= nil
end

---@return Vector2?
function UI.GetSelectedPosition()
    return UI.GemSelection and UI.GemSelection.Position or nil
end

---@return boolean
function UI.CanMouseSwipe()
    return UI.GemSelection and UI.GemSelection.CanSwipe or false
end

function UI.ClearSelection()
    local selector = UI.Selector

    UI.GemSelection = nil
    selector:SetVisible(false)
end

---@param gem Feature_Bedazzled_Board_Gem
function UI.SelectGem(gem)
    local element = UI.GetGemElement(gem)
    local selector = UI.Selector
    local visualPositionX, visualPositionY = element:GetGridPosition()

    visualPositionX = visualPositionX - UI.CELL_SIZE[1]/2
    visualPositionY = visualPositionY - UI.CELL_SIZE[2]/2

    selector:SetPosition(visualPositionX, visualPositionY)
    selector:SetVisible(true)

    UI.GemSelection = {
        Position = V(UI.Board:GetGemGridCoordinates(gem)),
        InitialMousePosition = V(Client.GetMousePosition()),
        CanSwipe = true,
    }
end

---@param pos1 Vector2
---@param pos2 Vector2
function UI.RequestSwap(pos1, pos2)
    UI.Board:Swap(pos1, pos2)

    UI.ClearSelection()
end

---@param gem Feature_Bedazzled_Board_Gem
---@return GenericUI_Prefab_Bedazzled_Gem
function UI.GetGemElement(gem)
    local element

    for _,gemElement in pairs(UI.Gems) do
        if gemElement.Gem == gem then
            element = gemElement
        end
    end

    return element
end

---@return number, number --Width, height, in pixels.
function UI.GetBoardDimensions()
    return UI.Board.Size[2] * UI.CELL_SIZE[1], UI.Board.Size[1] * UI.CELL_SIZE[2]
end

---@param board Feature_Bedazzled_Board
function UI._Initialize(board)
    if not UI._Initialized then
        local bg = UI:CreateElement("Background", "GenericUI_Element_TiledBackground")
        UI.Background = bg
        bg:SetBackground("Black", UI.BACKGROUND_SIZE:unpack())
        bg:SetAlpha(0.1)

        local grid = bg:AddChild("BackgroundGrid", "GenericUI_Element_Grid")
        grid:SetGridSize(board.Size:unpack())
        grid:SetElementSpacing(0, 0)
        UI.Grid = grid

        for i=1,board.Size[1]*board.Size[2],1 do
            local icon = grid:AddChild("BackgroundGrid_Icon_" .. i, "GenericUI_Element_IggyIcon")
            icon:SetIcon(UI.CELL_BACKGROUND, UI.CELL_SIZE:unpack())
        end

        -- Create clickboxes for selecting gems
        local clickboxGrid = bg:AddChild("ClickboxGrid", "GenericUI_Element_Grid")
        clickboxGrid:SetGridSize(board.Size:unpack())
        -- clickboxGrid:GetMovieClip().gridList.ROW_SPACING = 0
        clickboxGrid:SetElementSpacing(0, 0)
        for i=1,board.Size[1],1 do
            for j=1,board.Size[2],1 do
                local clickbox = clickboxGrid:AddChild("Clickbox_" .. i .. "_" .. j, "GenericUI_Element_Color")
                clickbox:SetColor(Color.Create(255, 128, 128))
                clickbox:SetSize(UI.CELL_SIZE:unpack())
    
                clickbox.Events.MouseDown:Subscribe(function (_)
                    UI.OnGemClickboxClicked(j, board.Size[1] - i + 1)
                end)
            end
        end

        local selector = bg:AddChild("Selector", "GenericUI_Element_IggyIcon")
        selector:SetIcon("Item_Divine", UI.CELL_SIZE:unpack())
        selector:SetVisible(false)
        selector:SetMouseEnabled(false)
        UI.Selector = selector
    end

    UI._Initialized = true
end

---@param x number
---@param y number
---@return number, number
function UI.GamePositionToUIPosition(x, y)
    local board = UI.Board

    local UIboardHeight = UI.CELL_SIZE[2] * board.Size[1]
    local UIBoardWidth = UI.CELL_SIZE[1] * board.Size[2]
    local gameBoardHeight = Bedazzled.GEM_SIZE * board.Size[1]
    local gameBoardWidth = board.Size[2]

    local translatedPositionY = y / gameBoardHeight * UIboardHeight
    translatedPositionY = UIboardHeight - translatedPositionY - UI.CELL_SIZE[2]

    local translatedPositionX = (x - 1) / gameBoardWidth * UIBoardWidth

    translatedPositionX = translatedPositionX + UI.CELL_SIZE[1] / 2
    translatedPositionY = translatedPositionY + UI.CELL_SIZE[2] / 2

    return translatedPositionX, translatedPositionY
end

---@param dt number In seconds.
---@diagnostic disable-next-line: unused-local
function UI.Update(dt)
    for _,element in pairs(UI.Gems) do
        element:Update()
    end
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

---Handle clickboxes being clicked.
---@param x integer
---@param y integer
function UI.OnGemClickboxClicked(x, y)
    local newSelection = V(x, y)
    local gem = UI.Board:GetGemAt(x, y)
    local element = UI.GetGemElement(gem)

    if gem and element and not gem:IsBusy() and not gem:IsFalling() then
        if UI.HasGemSelection() and newSelection == UI.GetSelectedPosition() then -- Deselect position
            UI.ClearSelection()
        elseif UI.HasGemSelection() then -- Swap gems TODO change to idle only
            UI.RequestSwap(UI.GetSelectedPosition(), V(x, y))
        else -- Select gem
            UI.SelectGem(gem)
        end
    end
end

-- Listen for mouse swipe gestures.
Input.Events.MouseMoved:Subscribe(function (_)
    if UI.CanMouseSwipe() then
        local currentPos = V(Client.GetMousePosition())
        local difference = currentPos - UI.GemSelection.InitialMousePosition

        if Vector.GetLength(difference) >= UI.MOUSE_SWIPE_DISTANCE_THRESHOLD then
            -- Get the dominant axis
            local swipeDirection = V(1, 0)
            if difference[1] < 0 then
                swipeDirection = V(-1, 0)
            end

            if difference[2] > 0 and difference[2] > math.abs(difference[1]) then
                swipeDirection = V(0, -1)
            elseif difference[2] < 0 and math.abs(difference[2]) > math.abs(difference[1]) then
                swipeDirection = V(0, 1)
            end

            UI.RequestSwap(UI.GetSelectedPosition(), UI.GetSelectedPosition() + swipeDirection)
        end
    end
end)

-- Stop listening for swipes if left click is released.
Input.Events.KeyStateChanged:Subscribe(function (ev)
    if ev.InputID == "left2" and ev.State == "Released" then
        if UI.HasGemSelection() then
            UI.GemSelection.CanSwipe = false
        end
    end
end)

-- Add Bedazzled option to gem context menus.
local function IsRuneCraftingMaterial(item) -- TODO move
    local RUNE_MATERIAL_STATS = {
        LOOT_Bloodstone_A = "Bloodstone",
        TOOL_Pouch_Dust_Bone_A = "Bone",
        LOOT_Clay_A = "Clay",
        LOOT_Emerald_A = "Emerald",
        LOOT_Granite_A = "Granite",
        LOOT_OreBar_A_Iron_A = "Iron",
        LOOT_Jade_A = "Jade",
        LOOT_Lapis_A = "Lapis",
        LOOT_Malachite_A = "Malachite",
        LOOT_Obsidian_A = "Obsidian",
        LOOT_Onyx_A = "Onyx",
        LOOT_Ruby_A = "Ruby",
        LOOT_Sapphire_A = "Sapphire",
        LOOT_OreBar_A_Silver_A = "Silver",
        LOOT_OreBar_A_Steel_A = "Steel",
        LOOT_Tigerseye_A = "TigersEye",
        LOOT_Topaz_A = "Topaz",
    }

    return RUNE_MATERIAL_STATS[item.StatsId] ~= nil
end
Client.UI.ContextMenu.RegisterVanillaMenuHandler("Item", function(item)
    print(IsRuneCraftingMaterial(item))
    if IsRuneCraftingMaterial(item) then
        Client.UI.ContextMenu.AddElement({
            {id = "epip_Feature_Bedazzled", type = "button", text = "Bedazzle"},
        })
    end
end)

-- Start the game when the context menu option is selected.
Client.UI.ContextMenu.RegisterElementListener("epip_Feature_Bedazzled", "buttonPressed", function(_, _)
    UI.Setup()
end)