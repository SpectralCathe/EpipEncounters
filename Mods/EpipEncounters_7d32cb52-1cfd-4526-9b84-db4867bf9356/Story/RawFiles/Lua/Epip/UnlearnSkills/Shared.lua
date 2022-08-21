
---@class Feature_UnlearnSkills : Feature
local Unlearn = {
    BLOCKED_SKILLS = {
        Summon_Cat = true,
        Shout_NexusMeditate = true,
        Shout_SourceInfusion = true,
    }
}
Epip.RegisterFeature("UnlearnSkills", Unlearn)

---------------------------------------------
-- METHODS
---------------------------------------------

---@param char Character
---@param skillID string
---@return boolean, string -- Whether the character can unlearn the skill, and a string explaining the reason as to why (in the case of being unable to)
function Unlearn.CanUnlearn(char, skillID)
    local playerData = char.SkillManager.Skills[skillID]
    local stat = Stats.Get("SkillData", skillID)
    local canUnlearn = false
    local reason

    if not stat then
        reason = "I cannot unlearn skills that do not exist."
    elseif playerData.CauseListSize > 0 then
        reason = "I cannot unlearn skills granted by external sources."
    elseif playerData.ZeroMemory then
        reason = "I cannot unlearn skills that take up no memory."
    elseif Character.IsInCombat(char) then
        reason = "I cannot unlearn skills while in combat."
    elseif Unlearn.IsSkillBlocked(skillID) then
        reason = "I cannot unlearn this skill."

        -- Easter egg messages.
        if skillID == "Shout_NexusMeditate" then
            reason = "I would lose my special spark if I were to give that up."
        elseif skillID == "Shout_SourceInfusion" then
            reason = "Sourcery is an innate part of who I am; I cannot get rid of it."
        end
    elseif stat["Memory Cost"] == 0 then
        local skillName = Ext.L10N.GetTranslatedStringFromKey(stat.DisplayName)

        reason = Text.Format("%s is an innate skill; it might be unwise to rid myself of it.", {FormatArgs = {skillName}})
    else
        canUnlearn = true
    end

    return canUnlearn, reason
end

---@param skillID string
---@return boolean
function Unlearn.IsSkillBlocked(skillID)
    return Unlearn.BLOCKED_SKILLS[skillID] == true
end