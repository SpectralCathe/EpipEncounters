
---------------------------------------------
-- Pre-made effects for Epic Enemies that achieve generic functionality like applying specific statuses, Special Logic, etc.
---------------------------------------------

local Templates = {
    ---@type table<Keyword, boolean>
    KEYWORD_ACTIVATOR_REQUIREMENT_EXCLUSIONS = {
        Presence = true,
        IncarnateChampion = true,
        Disintegrate = true,
        VolatileArmor = true,
        Voracity = true,
    },
}
Epip.AddFeature("EpicEnemiesEffectTemplates", "EpicEnemiesEffectTemplates", Templates)
Epip.Features.EpicEnemiesEffectTemplates = Templates

local EpicEnemies = Epip.Features.EpicEnemies

---------------------------------------------
-- CLASSES
---------------------------------------------

---@class EpicEnemiesExtendedEffect : EpicEnemiesEffect
---@field SpecialLogic? string Special logic to grant when the effect is rolled.
---@field Artifact? string Artifact power to grant when the effect is rolled.
---@field Keyword? EpicEnemiesKeywordData Used for activation conditions; certain keyword mutators will not be granted if the target has no activators of the keyword.
---@field Summon? GUID Template to summon.
---@field Status? EpicEnemiesStatus[]
---@field ExtendedStats? EpicEnemiesExtendedStat[]

---@class EpicEnemiesStatus
---@field StatusID string
---@field Duration integer

---@class EpicEnemiesExtendedStat
---@field StatID string The ID of the ExtendedStat.
---@field Amount number
---@field Property1 string
---@field Property2 string
---@field Property3 string

---------------------------------------------
-- EFFECTS
---------------------------------------------

EpicEnemies.Events.EffectActivated:RegisterListener(function(char, effect)
    ---@type EpicEnemiesExtendedEffect
    effect = effect

    -- Special logic effects.
    if effect.SpecialLogic then
        Osi.PROC_AMER_UI_Ascension_SpecialLogic_Add(char.MyGuid, effect.SpecialLogic, 1)
    end

    -- Artifact.
    if effect.Artifact then
        Osi.PROC_AMER_Artifacts_EquipEffects(char.MyGuid, effect.Artifact, "Rune")
    end

    -- Statuses.
    if effect.Status then
        local statusData = effect.Status

        Osi.ApplyStatus(char.MyGuid, statusData.StatusID, statusData.Duration, 1)
    end

    -- Summons.
    if effect.Summon then
        local pos = char.WorldPos

        local guid = Osi.CharacterCreateAtPosition(pos[1], pos[2], pos[3], effect.Summon, 1)
        Osi.CharacterLevelUpTo(guid, char.Stats.Level)
        Osi.CharacterChangeToSummon(guid, char.MyGuid)
        Osi.EnterCombat(guid, char.MyGuid)
    end

    -- Extended Stats.
    if effect.ExtendedStats then
        for i,extendedStat in ipairs(effect.ExtendedStats) do
            Osi.PROC_AMER_ExtendedStat_CharacterAddStat(char.MyGuid, extendedStat.StatID, extendedStat.Property1, extendedStat.Property2, extendedStat.Property3, extendedStat.Amount)
        end
    end
end)

EpicEnemies.Events.EffectRemoved:RegisterListener(function (char, effect)
    -- SpecialLogic.
    if effect.SpecialLogic then
        Osi.PROC_AMER_UI_Ascension_SpecialLogic_Add(char.MyGuid, effect.SpecialLogic, -1)
    end

    -- Artifacts.
    if effect.Artifact then
        Osi.PROC_AMER_Artifacts_UnequipEffects(char.MyGuid, effect.Artifact, "Rune")
    end

    -- Statuses.
    if effect.Status then
        local statusData = effect.Status
        
        Osi.RemoveStatus(char.MyGuid, statusData.StatusID)
    end

    -- Extended Stats.
    if effect.ExtendedStats then
        for i,extendedStat in ipairs(effect.ExtendedStats) do
            Osi.PROC_AMER_ExtendedStat_CharacterAddStat(char.MyGuid, extendedStat.StatID, extendedStat.Property1, extendedStat.Property2, extendedStat.Property3, -extendedStat.Amount)
        end
    end
end)

-- Make mutator effects only available if character already has an activator
EpicEnemies.Hooks.IsEffectApplicable:RegisterHook(function (applicable, effect, char, activeEffects)
    if effect.Keyword then
        local excluded = Templates.KEYWORD_ACTIVATOR_REQUIREMENT_EXCLUSIONS[effect.Keyword]
        
        if effect.Keyword.BoonType == "Mutator" and not excluded then
            local hasActivator = false
            local keywordID = effect.Keyword.Keyword

            -- Search for an activator for this keyword
            for i,appliedEffect in ipairs(activeEffects) do
                if appliedEffect.Keyword and appliedEffect.Keyword.Keyword == keywordID then
                    hasActivator = true
                    break
                end
            end

            if not hasActivator then
                applicable = false
            end
        end
    end

    return applicable
end)