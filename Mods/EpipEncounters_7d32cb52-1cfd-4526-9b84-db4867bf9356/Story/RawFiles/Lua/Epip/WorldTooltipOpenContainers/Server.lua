
---@class Feature_WorldTooltipOpenContainers
local OpenContainers = Epip.GetFeature("WorldTooltipOpenContainers")
OpenContainers.EVENTID_TASK_FINISHED = "Features.WorldTooltipOpenContainers.EventID.TaskFinished"

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Listen for requests to open containers.
Net.RegisterListener("EPIPENCOUNTERS_Feature_WorldTooltipOpenContainers_OpenContainer", function (payload)
    local char = Character.Get(payload.CharacterNetID)
    local item = Item.Get(payload.ItemNetID)

    -- Only queue the task if no others are running.
    -- Otherwise we cannot tell precisely whether ours ran immediately or got queued - would require a per-tick check.
    if char.OsirisController.Tasks[1] == nil then
        -- We need to queue moving first, otherwise the character will only walk.
        Osiris.CharacterMoveTo(char, item, 1, OpenContainers.EVENTID_TASK_FINISHED, 0)
        Osiris.CharacterUseItem(char, item, "")
        Osiris.SetTag(char, OpenContainers.TAG_TASK_RUNNING)
    end
end)

-- Listen for the move-to task finishing.
-- There's no need to allow cancelling the item use one.
Osiris.RegisterSymbolListener("StoryEvent", 2, "after", function (charGUID, eventID)
    if eventID == OpenContainers.EVENTID_TASK_FINISHED then
        Osi.ClearTag(charGUID, OpenContainers.TAG_TASK_RUNNING)
    end
end)

-- Listen for requests to cancel the task.
Net.RegisterListener(OpenContainers.NETMSG_REQUEST_CANCEL, function (payload)
    local char = payload:GetCharacter()
    local controller = char.OsirisController
    local task1 = controller.Tasks[1]
    if controller.Tasks[3] == nil and task1 and task1.TaskTypeId == "MoveToObject" then
        ---@cast task1 EsvOsirisMoveToObjectTask
        if task1.ArriveEvent == OpenContainers.EVENTID_TASK_FINISHED then
            Osiris.CharacterPurgeQueue(char)
            OpenContainers:DebugLog("Canceled task for", char.DisplayName)
        end
    end
    Osiris.ClearTag(char, OpenContainers.TAG_TASK_RUNNING) -- Remove the tag in all cases; we must never allow it to persist
end)