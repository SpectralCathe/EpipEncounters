
local Menu = Epip.GetFeature("Feature_SettingsMenu")

---@param name string
---@return Feature_SettingsMenu_Entry_Label
local function CreateHeader(name)
    return {Type = "Label", Label = Text.Format(name, {Color = "7E72D6", Size = 23})}
end

---@type table<string, Feature_SettingsMenu_Tab>
local tabs = {
    ["EpipEncounters"] = {
        ID = "EpipEncounters",
        ButtonLabel = "General",
        HeaderLabel = "Epip Encounters",
        Entries = {
            {Type = "Label", Label = Text.Format("Most options require a reload for changes to apply.", {Size = 19})},
            "AutoIdentify",
            "ImmersiveMeditation",
            "ExaminePosition",
            "Minimap",
            "TreasureTableDisplay",
            "CinematicCombat",
            "ESCClosesAmerUI",
            "RenderShroud",
            "Feature_WalkOnCorpses",
            "CombatLogImprovements",
            "PreferredTargetDisplay",
            {Type = "Setting", Module = "EpipEncounters_AnimationCancelling", ID = "Enabled"}
        }
    },
    ["Epip_Hotbar"] = {
        ID = "Epip_Hotbar",
        ButtonLabel = "Hotbar",
        HeaderLabel = "Hotbar",
        Entries = {
            CreateHeader("Hotbar"),
            "HotbarCombatLogButton",
            "HotbarHotkeysText",
            "HotbarHotkeysLayout",
            "HotbarCastingGreyOut",
        }
    },
    ["Epip_QuickExamine"] = {
        ID = "Epip_QuickExamine",
        ButtonLabel = "Quick Examine",
        HeaderLabel = "Quick Examine",
        Entries = {
            CreateHeader("Quick Examine"),
            {Module = "EpipEncounters_QuickExamine", ID = "AllowDead"},
            {Module = "EpipEncounters_QuickExamine", ID = "Opacity"},
            {Module = "EpipEncounters_QuickExamine", ID = "Width"},
            {Module = "EpipEncounters_QuickExamine", ID = "Height"},
            {Module = "EpipEncounters_QuickExamine", ID = "Widget_Artifacts"},
            {Module = "EpipEncounters_QuickExamine", ID = "Widget_Statuses"},
            {Module = "EpipEncounters_QuickExamine", ID = "Widget_Skills"},
            {Type = "Button", ID = "QuickExamine_SaveDefaultPosition", Label = "Save Default Position", Tooltip = "Saves the UI's current position and restores it upon reloading. Use to set the default position of the UI."},
        }
    },
    ["Epip_Other"] = {
        ID = "Epip_Other",
        ButtonLabel = "Miscellaneous UI",
        HeaderLabel = "Miscellaneous UI",
        Entries = {
            CreateHeader("Overheads"),
            {Module = "Epip_Overheads", ID = "OverheadsSize"},
            {Module = "Epip_Overheads", ID = "DamageOverheadsSize"},
            {Module = "Epip_Overheads", ID = "StatusOverheadsDurationMultiplier"},
            {Module = "Epip_Notifications", ID = "RegionLabelDuration"},

            CreateHeader("Chat"),
            {Module = "Epip_Chat", ID = "Chat_MessageSound"},
            {Module = "Epip_Chat", ID = "Chat_ExitAfterSendingMessage"},

            CreateHeader("Save/Load UI"),
            {Module = "Epip_SaveLoad", ID = "SaveLoad_Overlay"},
            {Module = "Epip_SaveLoad", ID = "SaveLoad_Sorting"},
        }
    },
    ["Epip_Developer"] = {
        ID = "Epip_Developer",
        ButtonLabel = "Developer",
        HeaderLabel = "Developer",
        DeveloperOnly = true,
        Entries = {
            CreateHeader("Developer"),
            {Type = "Button", Label = "Warp to AMER_Test", ID = "DEBUG_WarpToAMERTest"},
            "Developer_DebugDisplay",
            "DEBUG_ForceStoryPatching",
            "DEBUG_AI",
            "DEBUG_AprilFools",
        }
    },
    ["Epip_PlayerInfo"] = {
        ID = "Epip_PlayerInfo",
        ButtonLabel = "Player Portraits",
        HeaderLabel = "Player Portraits",
        Entries = {
            CreateHeader("Player Portraits UI"),
            "PlayerInfoBH",
            "PlayerInfo_StatusHolderOpacity",
            "PlayerInfo_EnableSortingFiltering",
            "PlayerInfo_SortingFunction",
            "PlayerInfo_Filter_SourceGen",
            "PlayerInfo_Filter_BatteredHarried",
        }
    },
    ["Epip_Inventory"] = {
        ID = "Epip_Inventory",
        ButtonLabel = "Inventory",
        HeaderLabel = "Inventory",
        Entries = {
            CreateHeader("Inventory UI"),
            "Inventory_AutoUnlockInventory",
            "Inventory_InfiniteCarryWeight",
            "Inventory_RewardItemComparison",
            CreateHeader("Crafting UI"),
            {Module = "Epip_Crafting", ID = "Crafting_DefaultFilter"},
        }
    },
    ["Epip_Notifications"] = {
        ID = "Epip_Notifications",
        ButtonLabel = "Notifications",
        HeaderLabel = "Notifications",
        Entries = {
            CreateHeader("Notifications"),
            "CastingNotifications",
            "Notification_ItemReceival",
            "Notification_StatSharing",
        }
    },
    ["Epip_Tooltips"] = {
        ID = "Epip_Tooltips",
        ButtonLabel = "Tooltips",
        HeaderLabel = "Tooltips",
        Entries = {
            CreateHeader("UI Tooltips"),
            "Tooltip_SimpleTooltipDelay_World",
            "Tooltip_SimpleTooltipDelay_UI",

            CreateHeader("World Item Tooltips"),
            "WorldTooltip_OpenContainers",
            "WorldTooltip_HighlightContainers",
            "WorldTooltip_HighlightConsumables",
            "WorldTooltip_HighlightEquipment",
            "WorldTooltip_EmptyContainers",
            "WorldTooltip_ShowSittableAndLadders",
            "WorldTooltip_ShowDoors",
            "WorldTooltip_ShowInactionable",
            "WorldTooltip_MoreTooltips",

            CreateHeader("Tooltip Adjustments"),
            {Module = "EpipEncounters_TooltipAdjustments", ID = "AstrologerFix"},
            {Module = "EpipEncounters_TooltipAdjustments", ID = "DamageTypeDeltamods"},
            {Module = "EpipEncounters_TooltipAdjustments", ID = "RewardGenerationWarning"},
            {Module = "EpipEncounters_TooltipAdjustments", ID = "RuneCraftingHint"},
            {Module = "EpipEncounters_TooltipAdjustments", ID = "SurfaceTooltips"},
            {Module = "EpipEncounters_TooltipAdjustments", ID = "WeaponRangeDeltamods"},
        }
    }
}

local tabOrder = {
    tabs.Epip_Developer,
    tabs.EpipEncounters,
    tabs.Epip_Hotbar,
    tabs.Epip_QuickExamine,
    tabs.Epip_PlayerInfo,
    tabs.Epip_Inventory,
    tabs.Epip_Notifications,
    tabs.Epip_Tooltips,
    tabs.Epip_Other
}

for tabIndex,tab in ipairs(tabOrder) do
    for i,entry in ipairs(tab.Entries) do
        if type(entry) == "string" then
            tab.Entries[i] = {Type = "Setting", Module = tab.ID, ID = entry} -- We make the Module ID be the same as tab ID
        else
            ---@diagnostic disable-next-line: undefined-field
            if entry.Module then
                entry.Type = "Setting"
            end
        end
    end

    Menu.RegisterTab(tab, tabIndex)
end