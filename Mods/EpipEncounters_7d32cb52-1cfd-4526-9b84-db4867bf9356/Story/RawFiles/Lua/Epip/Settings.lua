
---@class Feature_EpipSettings : Feature
local EpipSettings = {
    TranslatedStrings = {
        -- TODO
    },
}
Epip.RegisterFeature("EpipSettings", EpipSettings)

---@param name string
---@return OptionsSettingsOption
local function CreateHeader(name)
    return {ID = "Header_" .. name, Type = "Header", Label = Text.Format(name, {Color = "7E72D6", Size = 23})}
end

---@type OptionsSettingsOption[]
local Header = {
    {
        ID = "Epip_Hint",
        Type = "Header",
        Label = Text.Format("Most options require a reload for changes to apply.", {Size = 19}),
    },
}

---@type OptionsSettingsOption[]
local Hotbar = {
    CreateHeader("Hotbar"),
    {
        ID = "HotbarCombatLogButton",
        Type = "Checkbox",
        Label = "Show Vanilla Combat Log Button",
        Tooltip = "Shows the combat log button on the right side of the hotbar.<br>If disabled, you can still toggle the combat log through hotbar actions.",
        DefaultValue = true,
    },
    {
        ID = "HotbarHotkeysText",
        Type = "Checkbox",
        Label = "Show Action Hotkeys",
        Tooltip = "Shows the keyboard hotkeys for custom actions.",
        DefaultValue = true,
    },
    {
        ID = "HotbarHotkeysLayout",
        Type = "Dropdown",
        Label = "Hotbar Buttons Area Sizing",
        Tooltip = "Controls the behaviour of the hotbar custom buttons area. 'Automatic' will cause it to switch between the single-row and dual-row layouts based on how many slot rows you have visible. Other settings will make it stick to one layout.",
        DefaultValue = 1,
        Options = {
            "Automatic",
            "Always One Row",
            "Always Two Rows",
        }
    },
    {
        ID = "HotbarCastingGreyOut",
        Type = "Checkbox",
        Label = "Disable Slots while Casting",
        Tooltip = "Disables the hotbar slots while a spell is being cast.",
        DefaultValue = true,
    },
    -- {
    --     ID = "HotbarRowsQuickToggle",
    --     Type = "Slider",
    --     Label = "Hotbar Quick Toggle Rows",
    --     MinAmount = 1,
    --     MaxAmount = 5,
    --     Interval = 1,
    --     HideNumbers = false,
    --     DefaultValue = 1,
    --     Tooltip = "Controls how many rows will be visible at maximum when you press the 'Toggle Additional Bars' hotkey.",
    -- },
}

if Mod.IsLoaded(Mod.GUIDS.WEAPON_EXPANSION) then
    table.insert(Hotbar, {
        ID = "WEAPONEX_OriginalButton",
        Type = "Checkbox",
        Label = "Show Mastery Button",
        Tooltip = "Shows the Mastery button. If disabled, it remains accessible through hotbar actions.",
        DefaultValue = true,
    })
end

---@type OptionsSettingsOption[]
local Overheads = {
    CreateHeader("Overheads"),
    {
        ID = "OverheadsSize",
        Type = "Slider",
        Label = "Overhead Text Size",
        MinAmount = 10,
        MaxAmount = 45,
        DefaultValue = 19,
        Interval = 1,
        HideNumbers = false,
        Tooltip = "Controls the size of regular text above characters talking.<br><br>Default is 19.",
    },
    {
        ID = "DamageOverheadsSize",
        Type = "Slider",
        Label = "Overhead Damage Size",
        MinAmount = 10,
        MaxAmount = 45,
        DefaultValue = 24,
        HideNumbers = false,
        Interval = 1,
        Tooltip = "Controls the size of damage overheads.<br><br>Default is 24.",
    },
    {
        ID = "StatusOverheadsDurationMultiplier",
        Type = "Slider",
        Label = "Overhead Status Duration Multiplier",
        MinAmount = 0.1,
        MaxAmount = 2,
        Interval = 0.1,
        DefaultValue = 1,
        HideNumbers = false,
        Tooltip = "Multiplies the duration of status overheads.<br><br>Default is 1.",
    },
    {
        ID = "RegionLabelDuration",
        Type = "Slider",
        Label = "Area Transition Label Duration",
        MinAmount = 0,
        MaxAmount = 5,
        Interval = 0.1,
        DefaultValue = 5,
        HideNumbers = false,
        Tooltip = "Changes the duration of the label that appears at the top of the screen when you change areas. Set to 0 to disable them entirely.<br><br>Default is 5 seconds.",
    },
}

---@type OptionsSettingsOption[]
local Chat = {
    CreateHeader("Chat"),
    {
        ID = "Chat_MessageSound",
        Type = "Dropdown",
        Label = "Message Sound",
        Tooltip = "Plays a sound effect when a message is received, so as to make it easier to notice.",
        DefaultValue = 1,
        Options = {
            "None",
            "Sound 1 (Click)",
            "Sound 2 (High-pitched click)",
            "Sound 3 (Synth)",
        }
    },
    {
        ID = "Chat_ExitAfterSendingMessage",
        Type = "Checkbox",
        Label = "Unfocus after sending messages",
        Tooltip = "Unfocuses the UI after you send a message, restoring input to the rest of the game.",
        DefaultValue = false,
    },
}

---@type OptionsSettingsOption[]
local Developer = {
    CreateHeader("Developer"),
    {
        ID = "DEBUG_WarpToAMERTest",
        Type = "Button",
        ServerOnly = true,
        Label = "Warp to AMER_Test",
        Tooltip = "Warp the party to AMER_Test.",
        DefaultValue = false,
    },
    {
        ID = "Developer_DebugDisplay",
        Type = "Checkbox",
        Label = "Debug Display",
        Tooltip = "Enables a UI widget that displays framerate, server tickrate, and mod versions.",
        DefaultValue = false,
        Developer = true,
    },
    {
        ID = "DEBUG_SniffUICalls",
        Type = "Dropdown",
        Label = "Sniff UI Calls",
        Tooltip = "Logs ExternalInterface calls to the console, optionally filtered per UI and call. Requires a reload. See Debug/Client/SniffCalls.lua.",
        DefaultValue = 1,
        Options = {
            "Disabled",
            "Log Filtered",
            "Log All"
        }
    },
    {
        ID = "DEBUG_ForceStoryPatching",
        Type = "Checkbox",
        ServerOnly = true,
        Label = "Force Story Patching",
        Tooltip = "Forces story patching on every session load.",
        DefaultValue = false,
    },
    {
        ID = "DEBUG_AI",
        Type = "Checkbox",
        ServerOnly = true,
        Label = "Log AI Scoring",
        Tooltip = "Logs AI scoring to the console.",
        DefaultValue = false,
    },
    {
        ID = "DEBUG_AprilFools",
        Type = "Checkbox",
        ServerOnly = false,
        Label = "Out of season April Fools jokes",
        Tooltip = "Don't you guys have phones?",
        DefaultValue = false,
    },
    {
        ID = "DBUG_TestServerSetting",
        Type = "Checkbox",
        ServerOnly = true,
        SaveOnServer = true,
        Label = "Test.",
        Tooltip = "Test.",
        DefaultValue = false,
    },
    {
        ID = "TestSelector",
        Type = "Selector",
        Label = "",
        Tooltip = "Test",
        DefaultValue = 1,
        Options = {
            {
                Label = "TestOption 1 asdasd",
                SubSettings = {"OverheadsSize", "DEBUG_AprilFools"},
            },
            {
                Label = "TestOption 2",
                SubSettings = {"AutoIdentify", "DBUG_TestServerSetting"},
            },
        },
    },
    {
        ID = "Epip_Developer_Footer",
        Type = "Header",
        Label = "<font color='7e72d6' size='23'>Normie settings</font>",
    },
}

---@type OptionsSettingsOption[]
local Experimental = {
    -- CreateHeader("Experimental"),
}

---@type OptionsSettingsOption[]
local OtherOptions = {
    CreateHeader("Other Settings"),
    {
        ID = "RenderShroud",
        Type = "Checkbox",
        ServerOnly = true,
        Label = "Show Fog of War",
        Tooltip = "Host-only setting. Toggles Fog of War, which hides unexplored areas. This setting applies to all players in the server and is non-destructive; re-enabling it will restore FoW to normal, and all your exploration progress with the setting off will apply.",
        DefaultValue = true,
    },
    {
        ID = "Feature_WalkOnCorpses",
        Type = "Checkbox",
        Label = "Allow walking to corpses in combat",
        Tooltip = "Disables looting corpses in combat, unless shift is held. This allows you to easily move to their position.",
        DefaultValue = true,
    },
    {
        ID = "CombatLogImprovements",
        Type = "Checkbox",
        Label = "Improved Combat Log",
        Tooltip = "Adds improvements to the combat log: custom filters (accessible through right-click), merging messages, and slight rewording to improve consistency.<br>You must reload the save after making changes to this setting.",
        DefaultValue = false,
    },
    {
        ID = "PreferredTargetDisplay",
        Type = "Dropdown",
        Label = "Show Aggro Information",
        Tooltip = "Adds aggro information to the health bar when hovering over enemies: AI preferred/unpreferred/ignored tag, as well as taunt source/target(s).",
        DefaultValue = 1,
        Options = {
            "Disabled",
            "Show when holding shift",
            "Show by default",
        }
    },
    {
        ID = "LoadingScreen",
        Type = "Checkbox",
        Label = "Epic Loading Screen",
        Tooltip = "Changes the loading screen into a family photoshoot!",
    },
}

local PlayerInfo = {
    CreateHeader("Player Portraits"),
    {
        ID = "PlayerInfoBH",
        Type = "Checkbox",
        Label = "Display B/H on player portraits",
        DefaultValue = false,
        Tooltip = "If enabled, Battered and Harried stacks will be shown beside player portraits on the left interface.",
    },
    {
        ID = "PlayerInfo_StatusHolderOpacity",
        Type = "Slider",
        Label = "Status Opacity in Combat",
        MinAmount = 0,
        MaxAmount = 1,
        DefaultValue = 1,
        Interval = 0.05,
        HideNumbers = false,
        Tooltip = "Controls the opacity of your character portraits's status bars in combat. Hovering over the statuses will always display them at full opacity.<br><br>Default is 1.",
    },
    {
        ID = "PlayerInfo_EnableSortingFiltering",
        Type = "Checkbox",
        Developer = true,
        Label = "Enable sorting/filtering",
        DefaultValue = false,
        Tooltip = Text.Format("Enables the sorting and filtering systems, allowing the settings below to take effect.<br>%s", {
            FormatArgs = {
                Text.Format("Changes to this setting will take effect when the UI is refreshed; for example, when a new status is applied, or when the player portraits are dragged.", {Color = Color.MAGIC_ARMOR})
            }
        }),
    },
    {
        ID = "PlayerInfo_SortingFunction",
        Type = "Dropdown",
        Developer = true,
        Label = "Sorting Order",
        Tooltip = "Determines the order of statuses, in order of importance.",
        DefaultValue = 1,
        Options = {
            "Descending (important first)",
            "Ascending (important last)",
        }
    },
    {
        ID = "PlayerInfo_Filter_SourceGen",
        Type = "Checkbox",
        Developer = true,
        Label = "Show Source Generation Status",
        DefaultValue = true,
        Tooltip = "Shows the Source Generation status while sorting/filtering is enabled.",
    },
    {
        ID = "PlayerInfo_Filter_BatteredHarried",
        Type = "Checkbox",
        Developer = true,
        Label = "Show Battered/Harried Statuses",
        DefaultValue = true,
        Tooltip = "Shows the Battered/Harries statuses while sorting/filtering is enabled.<br>If you disable this, it is recommended to enable the B/H display on the portraits.",
    },
}

local SaveLoadOptions = {
    CreateHeader("Save/Load UI"),
    {
        ID = "SaveLoad_Overlay",
        Type = "Checkbox",
        Label = "Save/Load UI Improvements",
        Tooltip = "Enables alternative sorting for the save/load UI, as well as searching.",
        DefaultValue = false,
    },
    {
        ID = "SaveLoad_Sorting",
        Type = "Dropdown",
        Label = "Save/Load Sorting",
        Tooltip = "Determines sorting in the save/load UI, if improvements for it are enabled.",
        DefaultValue = 1,
        Options = {
            "Date",
            "Alphabetic",
        }
    },
}

local CraftingOptions = {
    CreateHeader("Crafting UI"),
    {
        ID = "Crafting_DefaultFilter",
        Type = "Dropdown",
        Label = "Default Tab",
        Tooltip = "Determines the default tab for the crafting UI.",
        DefaultValue = 1,
        Options = {
            "All",
            "Equipment",
            "Consumables",
            "Magical",
            "Ingredients",
            "Miscellaneous",
        }
    },
}

local TopOptions = {
    {
        ID = "AutoIdentify",
        Type = "Dropdown",
        ServerOnly = true,
        Label = "Auto-Identify Items",
        Tooltip = "Automatically and instantly identify items whenever they are generated.<br>'With enough Loremaster' uses the highest Loremaster of all player characters, regardless of party.",
        DefaultValue = 1,
        Options = {
            "Disabled",
            "With enough Loremaster",
            "Always"
        }
    },
    {
        ID = "ImmersiveMeditation",
        Type = "Checkbox",
        Label = "Immersive Meditation",
        Tooltip = "Hides the Hotbar and Minimap while within the Ascension and Greatforge UIs.",
        DefaultValue = false,
    },
    {
        ID = "ExaminePosition",
        Type = "Dropdown",
        Label = "Examine Menu Position",
        Tooltip = "Controls the default position of the Examine menu when it is opened.",
        DefaultValue = 1,
        Options = {
            "Center",
            "Middle Right",
            "Middle Left"
        }
    },
    {
        ID = "Minimap",
        Type = "Checkbox",
        Label = "Show Minimap",
        Tooltip = "Toggles visibility of the minimap UI element.",
        DefaultValue = true,
    },
    {
        ID = "TreasureTableDisplay",
        Type = "Checkbox",
        Label = "Show loot drops in health bar",
        Tooltip = "If enabled, the health bar when you hover over characters and items will show their treasure table (if relevant) as well as the chance of getting an artifact. For characters, this requires holding the Show Sneak Cones key (shift by default)",
        DefaultValue = false,
    },
    {
        ID = "CinematicCombat",
        Type = "Checkbox",
        Label = "Cinematic Combat",
        Tooltip = "Adds visual improvements while it is not your turn to improve immersiveness.",
        DefaultValue = false,
    },
    {
        ID = "ESCClosesAmerUI",
        Type = "Checkbox",
        Label = "Escape Key Closes EE UIs",
        Tooltip = "If enabled, the Escape key will close EE UIs rather than turning back a page.",
        DefaultValue = false,
    },
}

local Inventory = {
    CreateHeader("Inventory"),
    {
        ID = "Inventory_AutoUnlockInventory",
        Type = "Checkbox",
        Label = "Auto-unlock inventory (Multiplayer)",
        Tooltip = "If enabled, your characters's inventories in multiplayer will be automatically unlocked after a reload.",
        DefaultValue = false,
    },
    {
        ID = "Inventory_InfiniteCarryWeight",
        Type = "Checkbox",
        Label = "Infinite Carry Weight",
        Tooltip = "Gives characters practically infinite carry weight.",
        DefaultValue = false,
        ServerOnly = true,
    },
    {
        ID = "Inventory_RewardItemComparison",
        Type = "Checkbox",
        Label = "Show Character Sheet in Reward UI",
        Tooltip = "Allows you to check all your equipped items while in the quest rewards UI.",
        DefaultValue = false,
    },
}

local Notification = {
    CreateHeader("Notifications"),
    {
        ID = "CastingNotifications",
        Type = "Checkbox",
        Label = "Skill-casting Notifications",
        Tooltip = "Controls whether notifications for characters casting skills show up in combat.",
        DefaultValue = true,
    },
    {
        ID = "Notification_ItemReceival",
        Type = "Checkbox",
        Label = "Item Notifications",
        Tooltip = "Controls whether notifications for receiving items show.",
        DefaultValue = true,
    },
    {
        ID = "Notification_StatSharing",
        Type = "Checkbox",
        Label = "Stat-sharing Notifications",
        Tooltip = "Controls whether notifications for sharing stats (Loremaster, Lucky Charm) show.",
        DefaultValue = true,
    },
}

local WorldTooltipsEmphasisColorsDropdown = {
    "None",
    "Blue Label",
    "Green Label",
    "Yellow Label",
    "Orange Label",
}

local WorldTooltipsEmphasisColorsChoices = {
    {ID = 1, Name = "None",},
    {ID = 2, Name = "Blue Label",},
    {ID = 3, Name = "Green Label",},
    {ID = 4, Name = "Yellow Label",},
    {ID = 5, Name = "Orange Label",},
}

local Tooltips = {
    CreateHeader("Tooltips"),
    {
        ID = "Tooltip_SimpleTooltipDelay_World",
        Type = "Slider",
        Label = "Simple Tooltip Delay (World)",
        MinAmount = 0,
        MaxAmount = 4,
        DefaultValue = 0.5,
        Interval = 0.1,
        HideNumbers = false,
        Tooltip = "Controls the delay for simple tooltips to appear while hovering over objects in the world.<br><br>Default is 0.5s.",
    },
    {
        ID = "Tooltip_SimpleTooltipDelay_UI",
        Type = "Slider",
        Label = "Simple Tooltip Delay (UI)",
        MinAmount = 0,
        MaxAmount = 4,
        DefaultValue = 0.1, -- TODO figure out why this doesn't seem to work properly. Causes some tooltips to be "missed" and never show up.
        Interval = 0.1,
        HideNumbers = false,
        Tooltip = "Controls the delay for simple tooltips to appear while hovering over UI elements.<br><br>Default is 0.5s.",
    },
}

local WorldTooltips = {
    CreateHeader("World Item Tooltips"),
    {
        ID = "WorldTooltip_OpenContainers",
        Type = "Checkbox",
        Label = "Open containers",
        Tooltip = "If enabled, clicking world tooltips will open containers rather than picking them up.",
        DefaultValue = false,
    },
    {
        ID = "WorldTooltip_HighlightContainers",
        Type = "Dropdown",
        Label = "Containers Emphasis",
        Tooltip = "Emphasizes container items in world tooltips.",
        DefaultValue = 1,
        Options = WorldTooltipsEmphasisColorsDropdown,
    },
    {
        ID = "WorldTooltip_HighlightConsumables",
        Type = "Dropdown",
        Label = "Consumables Emphasis",
        Tooltip = "Emphasizes consumable items in world tooltips.",
        DefaultValue = 1,
        Options = WorldTooltipsEmphasisColorsDropdown,
    },
    {
        ID = "WorldTooltip_HighlightEquipment",
        Type = "Dropdown",
        Label = "Equipment Emphasis",
        Tooltip = "Emphasizes equipment items in world tooltips.",
        DefaultValue = 1,
        Options = WorldTooltipsEmphasisColorsDropdown,
    },
    {
        ID = "WorldTooltip_EmptyContainers",
        Type = "Checkbox",
        Label = "Show empty containers/bodies",
        Tooltip = "Controls whether tooltips are shown for empty containers and bodies.",
        DefaultValue = true,
    },
    {
        ID = "WorldTooltip_ShowSittableAndLadders",
        Type = "Checkbox",
        Label = "Show chairs and ladders",
        Tooltip = "If enabled, chairs and ladders will show world tooltips. Requires \"Show more items\" to be enabled, as these do not have tooltips by default.",
        DefaultValue = true,
    },
    {
        ID = "WorldTooltip_ShowDoors",
        Type = "Checkbox",
        Label = "Show doors",
        Tooltip = "If enabled, doors will show world tooltips. Requires \"Show more items\" to be enabled, as these do not have tooltips by default.",
        DefaultValue = true,
    },
    {
        ID = "WorldTooltip_ShowInactionable",
        Type = "Checkbox",
        Label = "Show items with no use actions",
        Tooltip = "If enabled, items with no use actions will show world tooltips.",
        DefaultValue = true,
    },
    {
        ID = "WorldTooltip_MoreTooltips",
        Type = "Checkbox",
        Label = "Enable tooltips for all items",
        Tooltip = "If enabled, world tooltips will be shown for all items. This includes clutter like doors.<br>" .. Text.Format("Requires a reload.", {Color = Color.LARIAN.YELLOW}),
        DefaultValue = false,
    },
}

local Order = {
    Header,
    TopOptions,
    Hotbar,
    PlayerInfo,
    Inventory,
    Notification,
    Chat,
    Tooltips,
    WorldTooltips,
    Overheads,
    SaveLoadOptions,
    CraftingOptions,
    OtherOptions,
    Experimental,
}

if Epip.IsDeveloperMode() then
    table.insert(Order, 2, Developer)
end

for _,category in ipairs(Order) do
    for _,setting in ipairs(category) do
        Epip.SETTINGS[setting.ID] = setting
    end
end

Epip.SETTINGS_CATEGORIES = Order

-- New settings declarations
---@type SettingsLib_Setting[]
local newSettings = {
    -- Main Epip settings
    {
        ID = "AutoIdentify",
        Type = "Choice",
        Context = "Host",
        Name = "Auto-Identify Items",
        Description = "Automatically and instantly identify items whenever they are generated.<br>'With enough Loremaster' uses the highest Loremaster of all player characters, regardless of party.",
        DefaultValue = 1,
        ---@type SettingsLib_Setting_Choice_Entry[]
        Choices = {
            {ID = 1, Name = "Disabled"},
            {ID = 2, Name = "With enough Loremaster"},
            {ID = 3, Name = "Always"},
        }
    },
    {
        ID = "ImmersiveMeditation",
        Type = "Boolean",
        Name = "Immersive Meditation",
        Description = "Hides the Hotbar and Minimap while within the Ascension and Greatforge UIs.",
        DefaultValue = false,
    },
    {
        ID = "ExaminePosition",
        Type = "Choice",
        Name = "Examine Menu Position",
        Description = "Controls the default position of the Examine menu when it is opened.",
        DefaultValue = 1,
        ---@type SettingsLib_Setting_Choice_Entry[]
        Choices = {
            {ID = 1, Name = "Center"},
            {ID = 2, Name = "Middle Right"},
            {ID = 3, Name = "Middle Left"},
        }
    },
    {
        ID = "Minimap",
        Type = "Boolean",
        Name = "Show Minimap",
        Description = "Toggles visibility of the minimap UI element.",
        DefaultValue = true,
    },
    {
        ID = "TreasureTableDisplay",
        Type = "Boolean",
        Name = "Show loot drops in health bar",
        Description = "If enabled, the health bar when you hover over characters and items will show their treasure table (if relevant) as well as the chance of getting an artifact. For characters, this requires holding the Show Sneak Cones key (shift by default)",
        DefaultValue = false,
    },
    {
        ID = "CinematicCombat",
        Type = "Boolean",
        Name = "Cinematic Combat",
        Description = "Adds visual improvements while it is not your turn to improve immersiveness.",
        DefaultValue = false,
    },
    {
        ID = "ESCClosesAmerUI",
        Type = "Boolean",
        Name = "Escape Key Closes EE UIs",
        Description = "If enabled, the Escape key will close EE UIs rather than turning back a page.",
        DefaultValue = false,
    },
    {
        ID = "RenderShroud",
        Type = "Boolean",
        Context = "Host",
        Name = "Show Fog of War",
        Description = "Host-only setting. Toggles Fog of War, which hides unexplored areas. This setting applies to all players in the server and is non-destructive; re-enabling it will restore FoW to normal, and all your exploration progress with the setting off will apply.",
        DefaultValue = true,
    },
    {
        ID = "Feature_WalkOnCorpses",
        Type = "Boolean",
        Name = "Allow walking to corpses in combat",
        Description = "Disables looting corpses in combat, unless shift is held. This allows you to easily move to their position.",
        DefaultValue = true,
    },
    {
        ID = "CombatLogImprovements",
        Type = "Boolean",
        Name = "Improved Combat Log",
        Description = "Adds improvements to the combat log: custom filters (accessible through right-click), merging messages, and slight rewording to improve consistency.<br>You must reload the save after making changes to this setting.",
        DefaultValue = false,
    },
    {
        ID = "PreferredTargetDisplay",
        Type = "Choice",
        Name = "Show Aggro Information",
        Description = "Adds aggro information to the health bar when hovering over enemies: AI preferred/unpreferred/ignored tag, as well as taunt source/target(s).",
        DefaultValue = 1,
        ---@type SettingsLib_Setting_Choice_Entry[]
        Choices = {
            {ID = 1, Name = "Disabled"},
            {ID = 2, Name = "Show when holding shift"},
            {ID = 3, Name = "Show by default"},
        }
    },
    {
        ID = "LoadingScreen",
        Type = "Boolean",
        Name = "Epic Loading Screen",
        Description = "Changes the loading screen into a family photoshoot!",
    },

    -- Hotbar settings
    {
        ID = "HotbarCombatLogButton",
        ModTable = "Epip_Hotbar",
        Type = "Boolean",
        Name = "Show Vanilla Combat Log Button",
        Description = "Shows the combat log button on the right side of the hotbar.<br>If disabled, you can still toggle the combat log through hotbar actions.",
        DefaultValue = true,
    },
    {
        ID = "HotbarHotkeysText",
        ModTable = "Epip_Hotbar",
        Type = "Boolean",
        Name = "Show Action Hotkeys",
        Description = "Shows the keyboard hotkeys for custom actions.",
        DefaultValue = true,
    },
    {
        ID = "HotbarHotkeysLayout",
        ModTable = "Epip_Hotbar",
        Type = "Choice",
        Name = "Hotbar Buttons Area Sizing",
        Description = "Controls the behaviour of the hotbar custom buttons area. 'Automatic' will cause it to switch between the single-row and dual-row layouts based on how many slot rows you have visible. Other settings will make it stick to one layout.",
        DefaultValue = 1,
        ---@type SettingsLib_Setting_Choice_Entry[]
        Choices = {
            {ID = 1, Name = "Automatic"},
            {ID = 2, Name = "Always One Row"},
            {ID = 3, Name = "Always Two Rows"},
        }
    },
    {
        ID = "HotbarCastingGreyOut",
        ModTable = "Epip_Hotbar",
        Type = "Boolean",
        Name = "Disable Slots while Casting",
        Description = "Disables the hotbar slots while a spell is being cast.",
        DefaultValue = true,
    },
    {
        ID = "WEAPONEX_OriginalButton",
        Type = "Boolean",
        Name = "Show Mastery Button",
        Description = "Shows the Mastery button. If disabled, it remains accessible through hotbar actions.",
        DefaultValue = true,
    },

    -- Overhead options
    {
        ID = "OverheadsSize",
        ModTable = "Epip_Overheads",
        Type = "ClampedNumber",
        Name = "Overhead Text Size",
        Description = "Controls the size of regular text above characters talking.<br><br>Default is 19.",
        Min = 10,
        Max = 45,
        Step = 1,
        HideNumbers = false,
        DefaultValue = 19,
    },
    {
        ID = "DamageOverheadsSize",
        ModTable = "Epip_Overheads",
        Type = "ClampedNumber",
        Name = "Overhead Damage Size",
        Description = "Controls the size of damage overheads.<br><br>Default is 24.",
        Min = 10,
        Max = 45,
        Step = 1,
        HideNumbers = false,
        DefaultValue = 24,
    },
    {
        ID = "StatusOverheadsDurationMultiplier",
        ModTable = "Epip_Overheads",
        Type = "ClampedNumber",
        Name = "Overhead Status Duration Multiplier",
        Description = "Multiplies the duration of status overheads.<br><br>Default is 1.",
        Min = 0.1,
        Max = 2,
        Step = 0.1,
        HideNumbers = false,
        DefaultValue = 1,
    },

    -- Chat settings
    {
        ID = "Chat_MessageSound",
        Type = "Choice",
        ModTable = "Epip_Chat",
        Name = "Message Sound",
        Description = "Plays a sound effect when a message is received, so as to make it easier to notice.",
        DefaultValue = 1,
        ---@type SettingsLib_Setting_Choice_Entry[]
        Choices = {
            {ID = 1, Name = "None"},
            {ID = 2, Name = "Sound 1 (Click)"},
            {ID = 3, Name = "Sound 2 (High-pitched click)"},
            {ID = 3, Name = "Sound 3 (Synth)"},
        },
    },
    {
        ID = "Chat_ExitAfterSendingMessage",
        Type = "Boolean",
        ModTable = "Epip_Chat",
        Name = "Unfocus after sending messages",
        Description = "Unfocuses the UI after you send a message, restoring input to the rest of the game.",
        DefaultValue = false,
    },

    -- Debug settings
    {
        ID = "Developer_DebugDisplay",
        Type = "Boolean",
        ModTable = "Epip_Developer",
        Name = "Debug Display",
        Description = "Enables a UI widget that displays framerate, server tickrate, and mod versions.",
        DefaultValue = false,
        Developer = true,
    },
    -- TODO remove
    -- {
    --     ID = "DEBUG_SniffUICalls",
    --     Type = "Dropdown",
    --     Label = "Sniff UI Calls",
    --     Tooltip = "Logs ExternalInterface calls to the console, optionally filtered per UI and call. Requires a reload. See Debug/Client/SniffCalls.lua.",
    --     DefaultValue = 1,
    --     Options = {
    --         "Disabled",
    --         "Log Filtered",
    --         "Log All"
    --     }
    -- },
    {
        ID = "DEBUG_ForceStoryPatching",
        Type = "Boolean",
        ModTable = "Epip_Developer",
        Context = "Host",
        Name = "Force Story Patching",
        Description = "Forces story patching on every session load.",
        DefaultValue = false,
    },
    {
        ID = "DEBUG_AI",
        Type = "Boolean",
        ModTable = "Epip_Developer",
        Context = "Host",
        Name = "Log AI Scoring",
        Description = "Logs AI scoring to the console.",
        DefaultValue = false,
    },
    {
        ID = "DEBUG_AprilFools",
        Type = "Boolean",
        ModTable = "Epip_Developer",
        Name = "Out of season April Fools jokes",
        Description = "Don't you guys have phones?",
        DefaultValue = false,
    },

    -- PlayerInfo settings
    {
        ID = "PlayerInfoBH",
        Type = "Boolean",
        ModTable = "Epip_PlayerInfo",
        Name = "Display B/H on player portraits",
        Description = "If enabled, Battered and Harried stacks will be shown beside player portraits on the left interface.",
        DefaultValue = false,
    },
    {
        ID = "PlayerInfo_StatusHolderOpacity",
        Type = "ClampedNumber",
        ModTable = "Epip_PlayerInfo",
        Name = "Status Opacity in Combat",
        Description = "Controls the opacity of your character portraits's status bars in combat. Hovering over the statuses will always display them at full opacity.<br><br>Default is 1.",
        Min = 0,
        Max = 1,
        Step = 0.05,
        HideNumbers = false,
        DefaultValue = 1,
    },
    {
        ID = "PlayerInfo_EnableSortingFiltering",
        Type = "Boolean",
        ModTable = "Epip_PlayerInfo",
        Developer = true,
        Name = "Enable sorting/filtering",
        DefaultValue = false,
        Description = Text.Format("Enables the sorting and filtering systems, allowing the settings below to take effect.<br>%s", {
            FormatArgs = {
                Text.Format("Changes to this setting will take effect when the UI is refreshed; for example, when a new status is applied, or when the player portraits are dragged.", {Color = Color.MAGIC_ARMOR})
            }
        }),
    },
    {
        ID = "PlayerInfo_SortingFunction",
        Type = "Choice",
        ModTable = "Epip_PlayerInfo",
        Developer = true,
        Name = "Sorting Order",
        Description = "Determines the order of statuses, in order of importance.",
        DefaultValue = 1,
        ---@type SettingsLib_Setting_Choice_Entry[]
        Choices = {
            {ID = 1, Name = "Descending (important first)"},
            {ID = 2, Name = "Ascending (important last)"},
        },
    },
    {
        ID = "PlayerInfo_Filter_SourceGen",
        Type = "Boolean",
        ModTable = "Epip_PlayerInfo",
        Name = "Show Source Generation Status",
        Description = "Shows the Source Generation status while sorting/filtering is enabled.",
        DefaultValue = true,
        Developer = true,
    },
    {
        ID = "PlayerInfo_Filter_BatteredHarried",
        Type = "Boolean",
        ModTable = "Epip_PlayerInfo",
        Name = "Show Battered/Harried Statuses",
        Description = "Shows the Battered/Harries statuses while sorting/filtering is enabled.<br>If you disable this, it is recommended to enable the B/H display on the portraits.",
        DefaultValue = true,
        Developer = true,
    },

    -- Save/Load settings
    {
        ID = "SaveLoad_Overlay",
        Type = "Boolean",
        ModTable = "Epip_SaveLoad",
        Name = "Save/Load UI Improvements",
        Description = "Enables alternative sorting for the save/load UI, as well as searching.",
        DefaultValue = false,
    },
    {
        ID = "SaveLoad_Sorting",
        Type = "Choice",
        ModTable = "Epip_SaveLoad",
        Name = "Save/Load Sorting",
        Description = "Determines sorting in the save/load UI, if improvements for it are enabled.",
        DefaultValue = 1,
        ---@type SettingsLib_Setting_Choice_Entry[]
        Choices = {
            {ID = 1, Name = "Date"},
            {ID = 2, Name = "Alphabetic"},
        },
    },

    -- Crafting settings
    {
        ID = "Crafting_DefaultFilter",
        Type = "Choice",
        ModTable = "Epip_Crafting",
        Name = "Default Tab",
        Description = "Determines the default tab for the crafting UI.",
        DefaultValue = 1,
        ---@type SettingsLib_Setting_Choice_Entry[]
        Choices = {
            {ID = 1, Name = "All"},
            {ID = 2, Name = "Equipment"},
            {ID = 3, Name = "Consumables"},
            {ID = 4, Name = "Magical"},
            {ID = 5, Name = "Ingredients"},
            {ID = 6, Name = "Miscellaneous"},
        },
    },

    -- Inventory settings
    {
        ID = "Inventory_AutoUnlockInventory",
        Type = "Boolean",
        ModTable = "Epip_Inventory",
        Name = "Auto-unlock inventory (Multiplayer)",
        Description = "If enabled, your characters's inventories in multiplayer will be automatically unlocked after a reload.",
        DefaultValue = false,
    },
    {
        ID = "Inventory_InfiniteCarryWeight",
        Type = "Boolean",
        ModTable = "Epip_Inventory",
        Context = "Host",
        Name = "Infinite Carry Weight",
        Description = "Gives characters practically infinite carry weight.",
        DefaultValue = false,
    },
    {
        ID = "Inventory_RewardItemComparison",
        Type = "Boolean",
        ModTable = "Epip_Inventory",
        Name = "Show Character Sheet in Reward UI",
        Description = "Allows you to check all your equipped items while in the quest rewards UI.",
        DefaultValue = false,
    },

    -- Notification settings
    {
        ID = "CastingNotifications",
        Type = "Boolean",
        ModTable = "Epip_Notifications",
        Name = "Skill-casting Notifications",
        Description = "Controls whether notifications for characters casting skills show up in combat.",
        DefaultValue = true,
    },
    {
        ID = "Notification_ItemReceival",
        Type = "Boolean",
        ModTable = "Epip_Notifications",
        Name = "Item Notifications",
        Description = "Controls whether notifications for receiving items show.",
        DefaultValue = true,
    },
    {
        ID = "Notification_StatSharing",
        Type = "Boolean",
        ModTable = "Epip_Notifications",
        Name = "Stat-sharing Notifications",
        Description = "Controls whether notifications for sharing stats (Loremaster, Lucky Charm) show.",
        DefaultValue = true,
    },
    {
        ID = "RegionLabelDuration",
        ModTable = "Epip_Notifications",
        Type = "ClampedNumber",
        Name = "Area Transition Label Duration",
        Description = "Changes the duration of the label that appears at the top of the screen when you change areas. Set to 0 to disable them entirely.<br><br>Default is 5 seconds.",
        Min = 0,
        Max = 5,
        Step = 0.1,
        HideNumbers = false,
        DefaultValue = 5,
    },

    -- Tooltip settings
    {
        ID = "Tooltip_SimpleTooltipDelay_World",
        Type = "ClampedNumber",
        ModTable = "Epip_Tooltips",
        Name = "Simple Tooltip Delay (World)",
        Description = "Controls the delay for simple tooltips to appear while hovering over objects in the world.<br><br>Default is 0.5s.",
        Min = 0,
        Max = 4,
        DefaultValue = 0.5,
        Step = 0.1,
        HideNumbers = false,
    },
    {
        ID = "Tooltip_SimpleTooltipDelay_UI",
        Type = "ClampedNumber",
        ModTable = "Epip_Tooltips",
        Name = "Simple Tooltip Delay (UI)",
        Description = "Controls the delay for simple tooltips to appear while hovering over UI elements.<br><br>Default is 0.5s.",
        Min = 0,
        Max = 4,
        DefaultValue = 0.1, -- TODO figure out why this doesn't seem to work properly. Causes some tooltips to be "missed" and never show up.
        Step = 0.1,
        HideNumbers = false,
    },

    -- World tooltip settings
    {
        ID = "WorldTooltip_OpenContainers",
        Type = "Boolean",
        ModTable = "Epip_Tooltips",
        Name = "Open containers",
        Description = "If enabled, clicking world tooltips will open containers rather than picking them up.",
        DefaultValue = false,
    },
    {
        ID = "WorldTooltip_HighlightContainers",
        Type = "Choice",
        ModTable = "Epip_Tooltips",
        Name = "Containers Emphasis",
        Description = "Emphasizes container items in world tooltips.",
        DefaultValue = 1,
        Choices = WorldTooltipsEmphasisColorsChoices,
    },
    {
        ID = "WorldTooltip_HighlightConsumables",
        Type = "Choice",
        ModTable = "Epip_Tooltips",
        Name = "Consumables Emphasis",
        Description = "Emphasizes consumable items in world tooltips.",
        DefaultValue = 1,
        Choices = WorldTooltipsEmphasisColorsChoices,
    },
    {
        ID = "WorldTooltip_HighlightEquipment",
        Type = "Choice",
        ModTable = "Epip_Tooltips",
        Name = "Equipment Emphasis",
        Description = "Emphasizes equipment items in world tooltips.",
        DefaultValue = 1,
        Choices = WorldTooltipsEmphasisColorsChoices,
    },
    {
        ID = "WorldTooltip_EmptyContainers",
        Type = "Boolean",
        ModTable = "Epip_Tooltips",
        Name = "Show empty containers/bodies",
        Description = "Controls whether tooltips are shown for empty containers and bodies.",
        DefaultValue = true,
    },
    {
        ID = "WorldTooltip_ShowSittableAndLadders",
        Type = "Boolean",
        ModTable = "Epip_Tooltips",
        Name = "Show chairs and ladders",
        Description = "If enabled, chairs and ladders will show world tooltips. Requires \"Show more items\" to be enabled, as these do not have tooltips by default.",
        DefaultValue = true,
    },
    {
        ID = "WorldTooltip_ShowDoors",
        Type = "Boolean",
        ModTable = "Epip_Tooltips",
        Name = "Show doors",
        Description = "If enabled, doors will show world tooltips. Requires \"Show more items\" to be enabled, as these do not have tooltips by default.",
        DefaultValue = true,
    },
    {
        ID = "WorldTooltip_ShowInactionable",
        Type = "Boolean",
        ModTable = "Epip_Tooltips",
        Name = "Show items with no use actions",
        Description = "If enabled, items with no use actions will show world tooltips.",
        DefaultValue = true,
    },
    {
        ID = "WorldTooltip_MoreTooltips",
        Type = "Boolean",
        ModTable = "Epip_Tooltips",
        Name = "Enable tooltips for all items",
        Description = "If enabled, world tooltips will be shown for all items. This includes clutter like doors.<br>" .. Text.Format("Requires a reload.", {Color = Color.LARIAN.YELLOW}),
        DefaultValue = false,
    },
}
for _,setting in ipairs(newSettings) do
    setting.Context = setting.Context or "Client"
    setting.ModTable = setting.ModTable or "EpipEncounters"

    Settings.RegisterSetting(setting)
end