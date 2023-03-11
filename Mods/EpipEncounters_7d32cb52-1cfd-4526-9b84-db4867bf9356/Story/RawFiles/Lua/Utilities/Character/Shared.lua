
---@class CharacterLib : Library
Character = {
    AI_PREFERRED_TAG = "AI_PREFERRED_TARGET",
    AI_UNPREFERRED_TAG = "AI_UNPREFERRED_TARGET",
    AI_IGNORED_TAG = "AI_IGNORED_TARGET",

    ---@enum ItemSlot
    EQUIPMENT_SLOTS = {
        HELMET = "Helmet",
        BREAST = "Breast",
        LEGGINGS = "Leggings",
        WEAPON = "Weapon",
        SHIELD = "Shield",
        RING = "Ring",
        BELT = "Belt",
        BOOTS = "Boots",
        GLOVES = "Gloves",
        AMULET = "Amulet",
        RING2 = "Ring2",
        WINGS = "Wings",
        HORNS = "Horns",
        OVERHEAD = "Overhead",
    },

    EQUIPMENT_VISUAL_CLASS = {
        HUMAN_MALE = 1,
        HUMAN_FEMALE = 2,
        DWARF_MALE = 3,
        DWARF_FEMALE = 4,
        ELF_MALE = 5,
        ELF_FEMALE = 6,
        LIZARD_MALE = 7,
        LIZARD_FEMALE = 8,

        NONE = 9,
        
        UNDEAD_HUMAN_MALE = 10,
        UNDEAD_HUMAN_FEMALE = 11,
        UNDEAD_DWARF_MALE = 12,
        UNDEAD_DWARF_FEMALE = 13,
        UNDEAD_ELF_MALE = 14,
        UNDEAD_ELF_FEMALE = 15,
        UNDEAD_LIZARD_MALE = 16,
        UNDEAD_LIZARD_FEMALE = 17,

    },

    ---@enum CharacterLib_EquipmentVisualMask
    EQUIPMENT_VISUAL_MASKS = {
        NONE = 0,
        HELMET = 1,
        BREAST = 2,
        LEGGINGS = 4,
        WEAPON = 8,
        SHIELD = 16,
        RING = 32,
        BELT = 64,
        BOOTS = 128,
        GLOVES = 256,
        AMULET = 512,
        RING_2 = 1024,
        WINGS = 2048,
        HORNS = 4096,
        OVERHEAD = 8192,
        SENTINEL = 16384,
        -- Unknown if more exist
    },

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Events = {
        StatusApplied = {}, ---@type Event<CharacterLib_Event_StatusApplied>
        ItemEquipped = {}, ---@type Event<CharacterLib_Event_ItemEquipped>
    },
    Hooks = {
        CreateEquipmentVisuals = {}, ---@type Event<CharacterLib_Hook_CreateEquipmentVisuals> Client-only.
    },
}
Game.Character = Character -- Legacy alias.
Epip.InitializeLibrary("Character", Character)

---------------------------------------------
-- EVENTS
---------------------------------------------

---TODO move somewhere else, since victim could be an item
---@class CharacterLib_Event_StatusApplied
---@field SourceHandle EntityHandle
---@field Victim Character|Item
---@field Status EclStatus|EsvStatus

---@class CharacterLib_Event_ItemEquipped
---@field Character Character
---@field Item Item
---@field Slot ItemSlot

---------------------------------------------
-- NET MESSAGES
---------------------------------------------

---@class EPIP_CharacterLib_StatusApplied : NetLib_Message
---@field OwnerNetID NetId
---@field StatusNetID NetId

---@class EPIP_CharacterLib_ItemEquipped : NetLib_Message_Character, NetLib_Message_Item

---------------------------------------------
-- CLASSES
---------------------------------------------

---@class CharacterLib_StatusFromItem
---@field Status Status
---@field ItemSource Item

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns whether char has a skill memorized. Returns true for innate skills.
---@param char Character
---@param skillID string
---@return boolean
function Character.IsSkillMemorized(char, skillID)
    local state = char.SkillManager.Skills[skillID]

    return state and state.IsLearned or Character.IsSkillInnate(char, skillID)
end

---Returns whether char has a skill learnt. Returns true for innate skills.
---@param char Character
---@param skillID string
---@return boolean
function Character.IsSkillLearnt(char, skillID)
    local state = char.SkillManager.Skills[skillID]

    return state and state.IsActivated or Character.IsSkillInnate(char, skillID)
end

---Returns the combat ID and team ID of char, if any.
---@param char Character
---@return integer?, integer? -- The combat ID and team ID. Nil if the character is not in combat. This is different from the osi query, which returns a reserved value.
function Character.GetCombatID(char)
    local status = char:GetStatusByType("COMBAT") ---@type EclStatusCombat
    local id, teamID

    if status then
        id, teamID = status.CombatTeamId.CombatId, status.CombatTeamId.CombinedId
    end

    return id, teamID
end

---Returns whether char has their weapon(s) unsheathed.
---@param char Character
---@return boolean
function Character.IsUnsheathed(char)
    return char:GetStatusByType("UNSHEATHED") ~= nil
end

---Returns whether char is currently the active character of any player.
---@return boolean
function Character.IsActive(char)
    return Osiris.CharacterIsControlled(char) == 1
end

---Returns whether char has an owner.
---@param char Character
---@return boolean
function Character.HasOwner(char)
    return char.HasOwner
end

---Returns the character's owner, if it is a summon or party follower(?).
---@param char Character
---@return Character?
function Character.GetOwner(char)
    local ownerHandle

    -- Unfortunate inconsistency.
    if char.HasOwner then
        if Ext.IsClient() then
            ownerHandle = char.OwnerCharacterHandle
        else
            ownerHandle = char.OwnerHandle
        end
    end

    return ownerHandle and Character.Get(ownerHandle)
end

---Returns whether a skill is innate to a character.
---Returns false if the character doesn't have the skill in any way.
---@param char Character
---@param skillID string
---@return boolean
function Character.IsSkillInnate(char, skillID)
    local playerData = char.SkillManager.Skills[skillID]
    local stat = Stats.Get("SkillData", skillID)
    local innate = false

    if stat and playerData then
        innate = stat["Memory Cost"] == 0 or playerData.ZeroMemory
    end

    return innate
end

---Returns wether char has a certain immunity.
---@param char Character
---@param immunityName StatsLib_ImmunityID
---@return boolean
function Character.HasImmunity(char, immunityName)
    return char.Stats[immunityName .. "Immunity"]
end

---Returns the equipped items of char, per slot.
---@param char Character
---@return table<ItemSlot, EclItem>
function Character.GetEquippedItems(char)
    local items = {}

    for _,slot in pairs(Character.EQUIPMENT_SLOTS) do
        local item

        if Ext.IsClient() then
            item = char:GetItemBySlot(slot)
            if item then
                item = Item.Get(item)
            end
        else
            item = Osiris.CharacterGetEquippedItem(char, slot)
            if item then
                item = Item.Get(item)
            end
        end

        if item then
            items[slot] = item
        end
    end

    return items
end

---@param char Character
---@param statName string
function Character.GetDynamicStat(char, statName)
    local total = 0
    local dynStats = char.Stats.DynamicStats

    for i=1,#dynStats,1 do
        local dynStat = dynStats[i]

        total = total + dynStat[statName]
    end

    return total
end

---Returns the maximum carry weight of char.
---@param char Character
---@return integer --In "grams"
function Character.GetMaxCarryWeight(char)
    local base = Stats.ExtraData.CarryWeightBase:GetValue()
    local strScaling = Stats.ExtraData.CarryWeightPerStr:GetValue()
    local strength = char.Stats.Strength

    return base + (strength * strScaling)
end

---@param char Character
---@return integer, integer --Current, maximum
function Character.GetActionPoints(char)
    return char.Stats.CurrentAP, char.Stats.APMaximum
end

---Returns the initiative of char.
---@param char Character
---@return integer
function Character.GetInitiative(char)
    return char.Stats.Initiative
end

---Returns the computed resistance value of char.
---@param char Character
---@param damageType StatsDamageType
---@param baseValuesOnly boolean? If `true`, base value will be returned. Defaults to `false`.
---@return integer
function Character.GetResistance(char, damageType, baseValuesOnly)
    return Ext.Stats.Math.GetResistance(char.Stats, damageType, baseValuesOnly)
end

---@param identifier GUID|PrefixedGUID|NetId|EntityHandle
---@param isFlashHandle boolean? If true, the identifier will be passed through DoubleToHandle() first.
---@return Character
function Character.Get(identifier, isFlashHandle)
    if isFlashHandle then
        identifier = Ext.UI.DoubleToHandle(identifier)
    end

    return Ext.Entity.GetCharacter(identifier)
end

---@param char Character
---@return boolean
function Character.IsPreferredByAI(char)
    return char:HasTag(Character.AI_PREFERRED_TAG)
end

---Returns whether char is unpreferred by AI.
---@param char Character
---@return boolean
function Character.IsUnpreferredByAI(char)
    return char:HasTag(Character.AI_UNPREFERRED_TAG)
end

---Returns whether char is ignored by AI.
---@param char Character
---@return boolean
function Character.IsIgnoredByAI(char)
    return char:HasTag(Character.AI_IGNORED_TAG)
end

---Returns true if char is a summon.
---@param char Character
---@return boolean
function Character.IsSummon(char)
    return char:HasTag("SUMMON") -- Summon flag does not do what's expected.
end

---Returns true if the character is dead.
---@param char Character
---@return boolean
function Character.IsDead(char)
    return char:GetStatus("DYING") ~= nil
end

---Returns a status by handle.
---@param char Character
---@param handle EntityHandle
---@return EclStatus|EsvStatus
function Character.GetStatusByHandle(char, handle)
    return Ext.Entity.GetStatus(char.Handle, handle)
end

---Returns the gender of char.
---@param char Character
---@return Gender
function Character.GetGender(char)
    local gender = "Male"

    if not Character.IsMale(char) then
        gender = "Female"
    end

    return gender
end

---Returns true if char is male.
---@param char Character
---@return boolean
function Character.IsMale(char)
    return char:HasTag("MALE")
end

---Returns true if char is undead.
---@param char Character
---@return boolean
function Character.IsUndead(char)
    return char:HasTag("UNDEAD")
end

---Returns the current race of char.
---@param char Character
---@return Race
function Character.GetRace(char)
    local racialTags = {
        HUMAN = "Human",
        ELF = "Elf",
        DWARF = "Dwarf",
        LIZARD = "Lizard",
    }

    local characterRace = nil

    for tag,race in pairs(racialTags) do
        if char:HasTag(tag) then
            characterRace = race
            break
        end
    end

    return characterRace
end

---Returns the original race of a player char, before any transforms.
---@param char Character Must be tagged with "REALLY_{Race}"
---@return Race
function Character.GetRealRace(char)
    local pattern = "^REALLY_(.+)$"
    local race = nil

    for _,tag in ipairs(char:GetTags()) do
        local match = tag:match(pattern)

        if match then
            race = match
            break
        end
    end

    if race then
        race = race:lower()
        race = race:sub(1, 1):upper() .. race:sub(2)
    end

    return race
end

---Returns whether the character is in a combat.
---@param char EclCharacter
---@return boolean
function Character.IsInCombat(char)
    return char:GetStatus("COMBAT") ~= nil
end

---Returns the calculated movement stat of a character.
---@param char Character
---@return number -- In centimeters.
function Character.GetMovement(char)
    local movement = 0
    local movementBoost = 100
    local dynStats = char.Stats.DynamicStats

    -- Character
    for i=1,#dynStats,1 do
        -- TODO general function for tallying dynstats
        local dynStat = dynStats[i]
        movement = movement + dynStat.Movement
        movementBoost = movementBoost + dynStat.MovementSpeedBoost
    end

    -- Items
    for slot in Item.ITEM_SLOTS:Iterator() do
        local statItem = char.Stats:GetItemBySlot(slot)

        if statItem then
            dynStats = statItem.DynamicStats
            for i=1,#dynStats,1 do
                local dynStat = dynStats[i]
                movement = movement + dynStat.Movement
                movementBoost = movementBoost + dynStat.MovementSpeedBoost
            end
        end
    end

    -- Add scoundrel bonus
    movement = movement + char.Stats.RogueLore * Stats.ExtraData.SkillAbilityMovementSpeedPerPoint:GetValue()

    return movement * (movementBoost / 100)
end

---Returns whether char can enter preparation state for a skill.
---@param char Character
---@param skillID string
---@param itemSource Item?
---@return boolean
function Character.CanUseSkill(char, skillID, itemSource)
    return Game.Stats.MeetsRequirements(char, skillID, false, itemSource)
end

---Returns whether char has a melee weapon equipped in either slot.
---@param char Character
---@return boolean
function Character.HasMeleeWeapon(char)
    local weapon = char:GetItemBySlot("Weapon")
    if weapon then weapon = Item.Get(weapon) end
    
    local offhand = char:GetItemBySlot("Shield")
    if offhand then offhand = Item.Get(offhand) end
    
    return Item.IsMeleeWeapon(weapon) or Item.IsMeleeWeapon(offhand)
end

---Returns whether char has a bow or crossbow equipped.
---@param char Character
---@return boolean
function Character.HasRangedWeapon(char)
    local weapon = char:GetItemBySlot("Weapon")
    if weapon then weapon = Item.Get(weapon) end

    return Item.IsRangedWeapon(weapon)
end

---Returns the current and maximum source points of char.
---@param char Character
---@return integer, integer --Current and maximum points.
function Character.GetSourcePoints(char)
    local current, max = char.Stats.MPStart, char.Stats.MaxMp
    if char.Stats.MaxMpOverride ~= -1 then max = char.Stats.MaxMpOverride end

    return current, max
end

---Returns whether char has a shield equipped.
---@param char Character
---@return boolean
function Character.HasShield(char)
    local offhand = char:GetItemBySlot("Shield")
    if offhand then offhand = Item.Get(offhand) end

    return Item.IsShield(offhand)
end

---Returns whether char has a dagger equipped in either slot.
---@param char Character
---@return boolean
function Character.HasDagger(char)
    local weapon = char:GetItemBySlot("Weapon")
    if weapon then weapon = Item.Get(weapon) end
    
    local offhand = char:GetItemBySlot("Shield")
    if offhand then offhand = Item.Get(offhand) end

    return Item.IsDagger(weapon) or Item.IsDagger(offhand)
end

---Returns whether char is muted.
---@param char Character
---@return boolean
function Character.IsMuted(char)
    return char:GetStatusByType("MUTED") ~= nil
end

---Returns whether char is disarmed.
---@param char Character
---@return boolean
function Character.IsDisarmed(char)
    return char:GetStatusByType("DISARMED") ~= nil
end

---Gets the highest stat score of all characters in char's party.
---@param char Character
---@param ability string Needs to be a property indexable in char.Stats
---@return integer
function Character.GetHighestPartyAbility(char, ability)
    local highest = 0

    for _,member in ipairs(Character.GetPartyMembers(char)) do
        local score = member.Stats[ability]

        if score > highest then
            highest = score
        end
    end

    return highest
end

---Returns the level of char.
---@param char Character
---@return integer
function Character.GetLevel(char)
    return char.Stats.Level
end

---Returns the current experience points of char.
---@param char Character
---@return integer
function Character.GetExperience(char)
    return char.Stats.Experience
end

---Returns the **cumulative** experience required to reach a level.
---@param targetLevel integer
---@return integer --Experience points.
function Character.GetExperienceRequiredForLevel(targetLevel)
    local levelCap = Stats.Get("Data", "LevelCap") or 1
    local totalXp = 0

    for level=1,targetLevel - 1,1 do
        local levelXp 

        if level <= 0 or level >= levelCap then
            levelXp = 0
        else
            local v8
            local v9 = 1
            local over8Scaler = math.min(level, 8)
            local levelsOver8 = level - over8Scaler

            v8 = over8Scaler * (over8Scaler + 1)

            if level - over8Scaler > 0 then
                v9 = 1.39 ^ levelsOver8 -- This part has had a compiler pow() optimization removed.
            end

            v8 = Ext.Round(v8 * v9)

            levelXp = 25 * ((1000 * v8 + 24) // 25)
        end

        totalXp = totalXp + levelXp
    end

    return totalXp
end

---Returns the contents of a character's skillbar row.
---@param char Character Must be a player.
---@param row integer
---@param slotsPerRow integer? Defaults to 29.
---@return EocSkillBarItem[]
function Character.GetSkillBarRowContents(char, row, slotsPerRow)
    slotsPerRow = slotsPerRow or 29
    local skillBar = char.PlayerData.SkillBarItems
    local items = {}

    local startingIndex = (row - 1) * slotsPerRow
    for i=1,slotsPerRow,1 do
        local slotIndex = startingIndex + i
        local slot = skillBar[slotIndex]

        table.insert(items, slot)
    end

    return items
end

---Returns a status on char by its net ID.
---@param char Character
---@param netID NetId
---@return EclStatus|EsvStatus
function Character.GetStatusByNetID(char, netID)
    local statuses = char:GetStatusObjects() ---@type (EclStatus|EsvStatus)[]
    local status

    for _,obj in ipairs(statuses) do
        if obj.NetID == netID then
            status = obj
            break
        end
    end

    return status
end

---Throws the ItemEquipped event.
---@param character Character
---@param item Item
function Character._ThrowItemEquippedEvent(character, item)
    local equippedSlot

    if Ext.IsServer() then
        equippedSlot = item.Slot
    else
        equippedSlot = item.CurrentSlot
    end
    
    Character.Events.ItemEquipped:Throw({
        Character = character,
        Item = item,
        Slot = Ext.Enums.ItemSlot[equippedSlot],
    })
end