
local Input = Client.Input

---@class Feature_BHOverheads
local BHOverheads = Epip.GetFeature("Feature_BHOverheads")
BHOverheads._CurrentUIs = {} ---@type table<ComponentHandle, GenericUI_Instance>

BHOverheads.INPUT_ACTION = "EpipEncounters_Feature_BHOverheads"
BHOverheads.SEARCH_RADIUS = 20 -- Search radius for characters, centered on client character.

---------------------------------------------
-- METHODS
---------------------------------------------

---Shows overheads for characters near the client character.
function BHOverheads.Show()
    local factory = BHOverheads._GetUIFactory()
    local chars = BHOverheads._GetCharacters()

    BHOverheads:DebugLog("Showing overheads")

    -- Remove previous instances
    BHOverheads.Hide()

    for _,char in ipairs(chars) do
        local ui = factory.Create(char)

        BHOverheads._CurrentUIs[char.Handle] = ui

        ui:Show()
    end

    BHOverheads:DebugLog(string.format("%s characters eligible", table.getKeyCount(BHOverheads._CurrentUIs)))
end

---Destroys all related UIs.
function BHOverheads.Hide()
    local factory = BHOverheads._GetUIFactory()

    for _,ui in pairs(BHOverheads._CurrentUIs) do
        factory.Destroy(ui)
    end
    BHOverheads._CurrentUIs = {}
end

---Returns the characters eligible for BH overheads.
---@return EclCharacter[]
function BHOverheads._GetCharacters()
    local clientChar = Client.GetCharacter()
    local originPos = Vector.Create(clientChar.WorldPos)
    local level = Entity.GetLevel()
    local levelID = Entity.GetLevelID(level)
    local chars = {}

    for _,char in pairs(level.EntityManager.CharacterConversionHelpers.ActivatedCharacters[levelID]) do
        local hook = BHOverheads.Hooks.IsEligible:Throw({
            Character = char,
            IsEligible = true,
        })

        if hook.IsEligible then
            local pos = Vector.Create(char.WorldPos)
            local dist = pos - originPos
    
            if Vector.GetLength(dist) <= BHOverheads.SEARCH_RADIUS then
                table.insert(chars, char)
            end
        end
    end

    return chars
end

---Returns the UI factory class.
---@return Feature_BHOverheads_UIFactory
function BHOverheads._GetUIFactory()
    return BHOverheads:GetClass("Feature_BHOverheads_UIFactory")
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Show or hide the overheads when the input action is toggled.
Input.Events.ActionExecuted:Subscribe(function (ev)
    if ev.Action:GetID() == BHOverheads.INPUT_ACTION and BHOverheads:IsEnabled() then
        BHOverheads.Show()
    end
end)
Input.Events.ActionReleased:Subscribe(function (ev)
    if ev.Action:GetID() == BHOverheads.INPUT_ACTION then
        BHOverheads.Hide()
    end
end)

-- Default implementation of IsEligible.
BHOverheads.Hooks.IsEligible:Subscribe(function (ev)
    local char = ev.Character
    local eligible = ev.IsEligible

    eligible = eligible and not Character.IsDead(char)
    eligible = eligible and Character.IsInCombat(char)

    ev.IsEligible = eligible
end, {StringID = "DefaultImplementation"})