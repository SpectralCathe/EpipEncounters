
local Set = DataStructures.Get("DataStructures_Set")

---@class Feature_Bedazzled : Feature
local Bedazzled = {
    _Gems = {}, ---@type table<string, Feature_Bedazzled_Gem>
    _GemModifierDescriptors = {}, ---@type table<string, Feature_Bedazzled_GemModifier>
    _GemStateClasses = {}, ---@type table<string, Feature_Bedazzled_Board_Gem_State>>
    _GameModes = Set.Create({}), ---@type DataStructures_Set<string> TODO

    TranslatedStrings = {
        GameTitle = {
            Handle = "h833e3d98g6e6bg4cfag9c23g1bcd1c8e9de1",
            Text = "Bedazzled",
        },
        Score = {
            Handle = "h4bc543cag5f19g4e91gbb76gc3a18177874b",
            Text = "Score             %s\nHigh-Score %s",
            ContextDescription = "Template string for displaying current score",
        },
        GameOver = {
            Handle = "h3166017ag50b9g4943g8ae9g5335c23c58e4",
            Text = "Game Over",
        },
        GameOver_Reason_NoMoreMoves = {
            Handle = "h1b460fc0ge72dg4879g9886g1dc640a782cb",
            Text = "No more valid moves on the board!",
            ContextDescription = "Subtitle for game over text",
        },
        HighScore = {
           Handle = "ha1afe7c2g4d97g43b6g823eg03bf25788dbd",
           Text = "High-Score",
           ContextDescription = "High score label in UI",
        },
        NewHighScore = {
           Handle = "hf254ab01gbb16g4c83ga1e5gc415eaef1acf",
           Text = "New high-score! %s points",
           ContextDescription = "Toast for setting a new highscore",
        },
        NewGamePrompt = {
           Handle = "h9f5438ffg5024g4264gaaa2gef122c54e518",
           Text = "Are you sure you want to start a new game?",
           ContextDescription = "Message box for new game button",
        },
    },
    Settings = {
        HighScores = {
            Type = "Map",
            NameHandle = "ha1afe7c2g4d97g43b6g823eg03bf25788dbd",
            Description = "",
            Context = "Client",
        },
    },

    HIGHSCORES_PROTOCOL = 1,
    MAX_HIGHSCORES_PER_GAMEMODE = 5,
    SPAWNED_GEM_INITIAL_VELOCITY = -4.5,
    GRAVITY = 5.5, -- Units per second squared
    MINIMUM_MATCH_GEMS = 3,
    GEM_SIZE = 1,
    BASE_SCORING = {
        MATCH = 100,
        MEDIUM_RUNE_DETONATION = 250,
        LARGE_RUNE_DETONATION = 500,
        GIANT_RUNE_DETONATION = 1337,
        PROTEAN_PER_GEM = 200, -- Rather high, but I think encouraging people to use hypercubes is good
    },

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Events = {
        NewHighScore = {}, ---@type Event<Feature_Bedazzled_Board_Event_GameOver>
    }
}
Epip.RegisterFeature("Bedazzled", Bedazzled)

---------------------------------------------
-- CLASSES
---------------------------------------------

---@alias Feature_Bedazzled_GemModifier_ID "Rune"|"LargeRune"|"GiantRune"
---@alias Feature_Bedazzled_GemDescriptor_ID "Bloodstone"|"Jade"|"Sapphire"|"Topaz"|"Onyx"|"Emerald"|"Lapis"|"TigersEye"|"Protean"

---@alias Feature_Bedazzled_GameMode_ID "Classic"

---@alias Features.Bedazzled.ModifierSet table<classname, Features.Bedazzled.Board.Modifier.Configuration>

---@class Feature_Bedazzled_HighScore
---@field Score integer
---@field Date string

---@class Features.Bedazzled.GameModeHighScores
---@field ModifierConfigs Features.Bedazzled.ModifierSet
---@field HighScores Feature_Bedazzled_HighScore[]

---@class Features.Bedazzled.Settings.HighScores
---@field Protocol integer
---@field Scores table<Feature_Bedazzled_GameMode_ID, Features.Bedazzled.GameModeHighScores[]>

---------------------------------------------
-- METHODS
---------------------------------------------

---Registers a gamemode.
---@param id string
function Bedazzled.RegisterGameMode(id)
    Bedazzled._GameModes:Add(id)
end

---@param data Feature_Bedazzled_Gem
function Bedazzled.RegisterGem(data)
    local GemClass = Bedazzled:GetClass("Feature_Bedazzled_Gem")

    data = GemClass.Create(data)

    Bedazzled._Gems[data.Type] = data
end

---@param type string
---@return Feature_Bedazzled_Gem?
function Bedazzled.GetGemDescriptor(type)
    return Bedazzled._Gems[type]
end

---Returns all registered gem descriptors.
---@return table<string, Feature_Bedazzled_Gem>
function Bedazzled.GetGemDescriptors()
    return Bedazzled._Gems
end

---Creates a new game.
---@param gameMode Feature_Bedazzled_GameMode_ID
---@param modifiers Features.Bedazzled.Board.Modifier[]? Defaults to empty list.
---@return Feature_Bedazzled_Board
function Bedazzled.CreateGame(gameMode, modifiers)
    modifiers = modifiers or {}
    local BoardClass = Bedazzled:GetClass("Feature_Bedazzled_Board")
    local board = BoardClass.Create(Vector.Create(8, 8), gameMode)

    -- Apply modifiers
    for _,mod in ipairs(modifiers) do
        board:ApplyModifier(mod)
    end

    -- Update high score at the end, forward event
    board.Events.GameOver:Subscribe(function (ev)
        local currentBestScore = Bedazzled.GetHighScore(board.GameMode, board:GetModifierConfigs())
        local isHighScore = false
        if currentBestScore == nil or ev.Score > currentBestScore.Score then
            isHighScore = true
        end

        Bedazzled.AddHighScore(board.GameMode, board:GetModifierConfigs(), {
            Score = ev.Score,
            Date = Client.GetDateString(),
            GameMode = board.GameMode,
        })

        -- Throw event for new high scores
        if isHighScore then
            Bedazzled.Events.NewHighScore:Throw({
                Score = ev.Score,
            })
        end

    end, {StringID = "GameOverHighScoreUpdate"})

    return board
end

---@return Feature_Bedazzled_Gem
function Bedazzled.GetRandomGemDescriptor()
    local totalWeight = 0
    local gems = {} ---@type Feature_Bedazzled_Gem[]
    local chosenGem

    for _,g in pairs(Bedazzled._Gems) do
        totalWeight = totalWeight + g.Weight
        table.insert(gems, g)
    end

    if #gems == 0 then
        Bedazzled:Error("GetRandomGemDescriptor", "No gems are registered.")
    end

    local seed = math.random(0, totalWeight)
    for _,g in ipairs(gems) do
        seed = seed - g.Weight

        if seed <= 0 and g.Weight > 0 then -- Never choose gems with 0 weight
            chosenGem = g
            break
        end
    end

    return chosenGem
end

---@generic T
---@param className `T`|Feature_Bedazzled_Board_Gem_StateClassName
---@return `T`|Feature_Bedazzled_Board_Gem_State
function Bedazzled.GetGemStateClass(className)
    local class = Bedazzled._GemStateClasses[className]
    if not class then
        Bedazzled:Error("GetGemStateClass", "Class is not registered:", className)
    end
    return class
end

---@param className string
---@param class Feature_Bedazzled_Board_Gem_State
function Bedazzled.RegisterGemStateClass(className, class)
    class.ClassName = className
    Bedazzled._GemStateClasses[className] = class
end

---Registers a gem modifier.
---@param id string
---@param mod Feature_Bedazzled_GemModifier
function Bedazzled.RegisterGemModifier(id, mod)
    local class = Bedazzled:GetClass("Feature_Bedazzled_GemModifier")

    Bedazzled._GemModifierDescriptors[id] = class.Create(id, mod)
end

---Gets the descriptor of a gem modifier.
---@param id string
---@return Feature_Bedazzled_GemModifier
function Bedazzled.GetGemModifier(id)
    return Bedazzled._GemModifierDescriptors[id]
end

---Returns the high scores of the user for a gamemode and modifier set.
---@param gameMode Feature_Bedazzled_GameMode_ID
---@param modifiers Features.Bedazzled.ModifierSet
---@return Feature_Bedazzled_HighScore[]
function Bedazzled.GetHighScores(gameMode, modifiers)
    local entry = Bedazzled._GetHighScoreEntries(gameMode, modifiers)
    return entry.HighScores
end

---Returns the highest score of the user.
---@param gameMode Feature_Bedazzled_GameMode_ID
---@param modifiers Features.Bedazzled.ModifierSet
---@return Feature_Bedazzled_HighScore? --`nil` if the user has not set any score.
function Bedazzled.GetHighScore(gameMode, modifiers)
    local scores = Bedazzled._GetHighScoreEntries(gameMode, modifiers)
    return scores.HighScores[1]
end

---Registers a highscore, automatically replacing any existing ones.
---@param gameMode Feature_Bedazzled_GameMode_ID
---@param modifiers Features.Bedazzled.ModifierSet
---@param score Feature_Bedazzled_HighScore
function Bedazzled.AddHighScore(gameMode, modifiers, score)
    local setting = Bedazzled:GetSettingValue(Bedazzled.Settings.HighScores) ---@type Features.Bedazzled.Settings.HighScores
    -- setting = table.deepCopy(setting)
    local scores = setting.Scores[gameMode] or {}
    local entry = Bedazzled._GetHighScoreEntries(gameMode, modifiers)

    table.insert(entry.HighScores, score)
    table.sortByProperty(entry.HighScores, "Score", true)

    -- Remove scores past the limit
    for i=Bedazzled.MAX_HIGHSCORES_PER_GAMEMODE+1,#scores,1 do
        entry.HighScores[i] = nil
    end

    for i,oldEntry in ipairs(scores) do
        if Bedazzled._ModifierConfigsAreEqual(oldEntry.ModifierConfigs, modifiers) then
            scores[i] = entry
            goto EntryUpdated
        end
    end
    table.insert(scores, entry)
    ::EntryUpdated::

    Bedazzled:SetSettingValue(Bedazzled.Settings.HighScores, setting)
end

---Returns all high scores.
---@return table<Feature_Bedazzled_GameMode_ID, Features.Bedazzled.GameModeHighScores[]>
function Bedazzled._GetHighScores()
    local setting = Bedazzled:GetSettingValue(Bedazzled.Settings.HighScores) ---@type Features.Bedazzled.Settings.HighScores

    -- Update save data from before the 3rd Anniversary expansion
    if not setting.Protocol then
        local scores = {} ---@type table<Feature_Bedazzled_GameMode_ID, Features.Bedazzled.GameModeHighScores[]>
        for mode,oldScores in pairs(setting) do
            if not scores[mode] then
                -- Modifiers did not exist before this point;
                -- scores are converted to no-mod ones.
                scores[mode] = {{
                    ModifierConfigs = {},
                    HighScores = {},
                }}
            end
            for _,oldScore in ipairs(oldScores) do
                ---@type Feature_Bedazzled_HighScore
                local newScore = {
                    Score = oldScore.Score,
                    Date = oldScore.Date,
                }
                table.insert(scores[mode][1].HighScores, newScore)
            end
        end

        ---@type Features.Bedazzled.Settings.HighScores
        local newData = {
            Protocol = Bedazzled.HIGHSCORES_PROTOCOL,
            Scores = scores,
        }
        setting = newData
        Bedazzled:SetSettingValue(Bedazzled.Settings.HighScores, newData)
    end

    return setting
end

---Returns whether 2 modifier config sets are equal.
---@param modList1 Features.Bedazzled.ModifierSet
---@param modList2 Features.Bedazzled.ModifierSet
function Bedazzled._ModifierConfigsAreEqual(modList1, modList2)
    if table.getKeyCount(modList1) ~= table.getKeyCount(modList2) then
        return false
    end
    local leftToFind = {}
    for k,_ in pairs(modList1) do
        leftToFind[k] = true
    end

    for className,config in pairs(modList2) do
        local class = Bedazzled:GetClass(className) ---@type Features.Bedazzled.Board.Modifier
        leftToFind[className] = nil
        local modConfig1 = modList1[className]
        if not modConfig1 or not class.ConfigurationEquals(modConfig1, config) then
            return false
        end
    end

    if next(leftToFind) then
        return false
    end

    return true
end

---Returns the highscore entries for a gamemode and modifier set.
---@param gameMode Feature_Bedazzled_GameMode_ID
---@param modifiers Features.Bedazzled.ModifierSet
---@return Features.Bedazzled.GameModeHighScores
function Bedazzled._GetHighScoreEntries(gameMode, modifiers)
    local setting = Bedazzled:GetSettingValue(Bedazzled.Settings.HighScores) ---@type Features.Bedazzled.Settings.HighScores
    local scores = setting.Scores[gameMode] or {}

    -- Find the first entry that matches the modifiers used, if any
    local entry = nil ---@type Features.Bedazzled.GameModeHighScores?
    for _,oldEntry in ipairs(scores) do
        if Bedazzled._ModifierConfigsAreEqual(oldEntry.ModifierConfigs, modifiers) then
            entry = oldEntry
            break
        end
    end
    if not entry then
        entry = {
            ModifierConfigs = modifiers,
            HighScores = {},
        }
    end

    return entry
end

---------------------------------------------
-- SETUP
---------------------------------------------

-- Register built-in gem types and modifiers.
GameState.Events.ClientReady:Subscribe(function (_)
    ---@type Feature_Bedazzled_Gem[]
    local gems = {
        {
            Type = "Bloodstone",
            Icon = "Item_LOOT_Gem_Bloodstone",
        },
        {
            Type = "Jade",
            Icon = "Item_LOOT_Gem_Jade",
        },
        {
            Type = "Sapphire",
            Icon = "Item_LOOT_Gem_Sapphire",
        },
        {
            Type = "Topaz",
            Icon = "Item_LOOT_Gem_Topaz",
        },
        {
            Type = "Onyx",
            Icon = "Item_LOOT_Gem_Onyx",
        },
        {
            Type = "Emerald",
            Icon = "Item_LOOT_Gem_Emerald",
        },
        {
            Type = "Lapis",
            Icon = "Item_LOOT_Gem_Lapis",
        },
        {
            Type = "TigersEye",
            Icon = "Item_LOOT_Gem_TigersEye",
        },
        {
            Type = "Protean",
            Icon = "AMER_LOOT_CallistoAnomaly",
            Weight = 0,
        },
    }
    for _,gem in ipairs(gems) do
        Bedazzled.RegisterGem(gem)
    end

    ---@type table<string, Feature_Bedazzled_GemModifier>
    local mods = {
        Rune = {}, -- Flame gem
        LargeRune = {}, -- Lightning gem
        GiantRune = {}, -- Supernova
        Protean = {}, -- Hypercube
    }

    for id,data in pairs(mods) do
        Bedazzled.RegisterGemModifier(id, data)
    end
end)

Bedazzled.RegisterGameMode("Classic")