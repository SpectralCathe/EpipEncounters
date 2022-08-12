

Stats.ModifierLists = {
    ----@type table<string, StatEntry_PropertyType> Type commented out as it breaks auto-complete.
    SkillData = {
        Name = "String",
        Level = "Integer",
        Using = "String",
        SkillType = "String",
        Ability = "SkillAbility",
        Element = "SkillElement",
        SkillRequirements = "SkillRequirements",
        Requirements = "StatRequirements",
        DisplayName = "String",
        DisplayNameRef = "String",
        Description = "String",
        DescriptionRef = "String",
        StatsDescription = "String",
        StatsDescriptionRef = "String",
        StatsDescriptionParams = "String",
        Icon = "String",
        FXScale = "Integer",
        PrepareAnimationInit = "String",
        PrepareAnimationLoop = "String",
        PrepareEffect = "String",
        PrepareEffectBone = "String",
        CastAnimation = "String",
        CastTextEvent = "String",
        CastAnimationCheck = "CastCheckType",
        CastEffect = "String",
        CastEffectTextEvent = "String",
        TargetCastEffect = "String",
        TargetHitEffect = "String",
        TargetEffect = "String",
        SourceTargetEffect = "String",
        TargetTargetEffect = "String",
        LandingEffect = "String",
        ImpactEffect = "String",
        MaleImpactEffects = "String",
        FemaleImpactEffects = "String",
        OnHitEffect = "String",
    },
}

---@alias StatEntry_FieldType "String"|"Integer"|"SkillAbility"|"SkillElement"|"SkillRequirements"|"StatRequirements"|"CastCheckType"