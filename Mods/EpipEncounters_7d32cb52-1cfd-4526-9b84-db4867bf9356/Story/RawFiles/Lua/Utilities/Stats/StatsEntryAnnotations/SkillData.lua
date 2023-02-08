
---@meta

---Annotates a SkillData stats entry.
---@class StatsLib_StatsEntry_SkillData
---@field SkillType string
---@field Level integer
---@field Ability StatsLib_Enum_SkillAbility
---@field Element "None"
---@field Requirement StatsLib_Enum_SkillRequirement
---@field Requirements StatsLib_StatsEntryField_Requirements
---@field DisplayName string
---@field DisplayNameRef string
---@field Description string
---@field DescriptionRef string
---@field StatsDescription string
---@field StatsDescriptionRef string
---@field StatsDescriptionParams string
---@field Icon string
---@field FXScale integer
---@field PrepareAnimationInit string
---@field PrepareAnimationLoop string
---@field PrepareEffect string
---@field PrepareEffectBone string
---@field CastAnimation string
---@field CastTextEvent string
---@field CastAnimationCheck StatsLib_Enum_CastCheckType
---@field CastEffect string
---@field CastEffectTextEvent string
---@field TargetCastEffect string
---@field TargetHitEffect string
---@field TargetEffect string
---@field SourceTargetEffect string
---@field TargetTargetEffect string
---@field LandingEffect string
---@field ImpactEffect string
---@field MaleImpactEffects string
---@field FemaleImpactEffects string
---@field OnHitEffect string
---@field SelectedCharacterEffect string
---@field SelectedObjectEffect string
---@field SelectedPositionEffect string
---@field DisappearEffect string
---@field ReappearEffect string
---@field ReappearEffectTextEvent string
---@field RainEffect string
---@field StormEffect string
---@field FlyEffect string
---@field SpatterEffect string
---@field ShieldMaterial string
---@field ShieldEffect string
---@field ContinueEffect string
---@field SkillEffect string
---@field Template string
---@field TemplateCheck StatsLib_Enum_CastCheckType
---@field TemplateOverride string
---@field TemplateAdvanced string
---@field Totem "Yes"|"No"
---@field Template1 string
---@field Template2 string
---@field Template3 string
---@field WeaponBones string
---@field TeleportSelf "Yes"|"No"
---@field CanTargetCharacters "Yes"|"No"
---@field CanTargetItems "Yes"|"No"
---@field CanTargetTerrain "Yes"|"No"
---@field ForceTarget "Yes"|"No"
---@field TargetProjectiles "Yes"|"No"
---@field UseCharacterStats "Yes"|"No"
---@field UseWeaponDamage "Yes"|"No"
---@field UseWeaponProperties "Yes"|"No"
---@field SingleSource "Yes"|"No"
---@field ContinueOnKill "Yes"|"No"
---@field Autocast "Yes"|"No"
---@field AmountOfTargets integer
---@field AutoAim "Yes"|"No"
---@field AddWeaponRange "Yes"|"No"
---@field Memory_Cost integer
---@field Magic_Cost integer
---@field ActionPoints integer
---@field Cooldown integer
---@field CooldownReduction integer
---@field ChargeDuration integer
---@field CastDelay integer
---@field Offset integer
---@field Lifetime integer
---@field Duration StatsLib_Enum_Qualifier
---@field TargetRadius integer
---@field ExplodeRadius integer
---@field AreaRadius integer
---@field HitRadius integer
---@field RadiusMax integer
---@field Range integer
---@field MaxDistance integer
---@field Angle integer
---@field TravelSpeed integer
---@field Acceleration integer
---@field Height integer
---@field Damage StatsLib_Enum_DamageSourceType
---@field Damage_Multiplier integer
---@field Damage_Range integer
---@field DamageType StatsLib_Enum_DamageType
---@field DamageMultiplier StatsLib_Enum_PreciseQualifier
---@field DeathType StatsLib_Enum_DeathType
---@field BonusDamage StatsLib_Enum_Qualifier
---@field Chance_To_Hit_Multiplier integer
---@field HitPointsPercent integer
---@field MinHitsPerTurn integer
---@field MaxHitsPerTurn integer
---@field HitDelay integer
---@field MaxAttacks integer
---@field NextAttackChance integer
---@field NextAttackChanceDivider integer
---@field EndPosRadius integer
---@field JumpDelay integer
---@field TeleportDelay integer
---@field PointsMaxOffset integer
---@field RandomPoints integer
---@field ChanceToPierce integer
---@field MaxPierceCount integer
---@field MaxForkCount integer
---@field ForkLevels integer
---@field ForkChance integer
---@field HealAmount StatsLib_Enum_PreciseQualifier
---@field StatusClearChance integer
---@field SurfaceType StatsLib_Enum_SurfaceType
---@field SurfaceLifetime integer
---@field SurfaceStatusChance integer
---@field SurfaceTileCollision unknown TODO
---@field SurfaceGrowInterval integer
---@field SurfaceGrowStep integer
---@field SurfaceRadius integer
---@field TotalSurfaceCells integer
---@field SurfaceMinSpawnRadius integer
---@field MinSurfaces integer
---@field MaxSurfaces integer
---@field MinSurfaceSize integer
---@field MaxSurfaceSize integer
---@field GrowSpeed integer
---@field GrowOnSurface unknown TODO
---@field GrowTimeout integer
---@field SkillBoost string
---@field SkillAttributeFlags StatsLib_Enum_AttributeFlags
---@field SkillProperties unknown TODO
---@field CleanseStatuses string
---@field AoEConditions unknown TODO
---@field TargetConditions unknown TODO
---@field ForkingConditions unknown TODO
---@field CycleConditions unknown TODO
---@field ShockWaveDuration integer
---@field TeleportTextEvent string
---@field SummonEffect string
---@field ProjectileCount integer
---@field ProjectileDelay integer
---@field StrikeCount integer
---@field StrikeDelay integer
---@field PreviewStrikeHits "Yes"|"No"
---@field SummonLevel integer
---@field Damage_On_Jump "Yes"|"No"
---@field Damage_On_Landing "Yes"|"No"
---@field StartTextEvent string
---@field StopTextEvent string
---@field Healing_Multiplier integer
---@field Atmosphere StatsLib_Enum_AtmosphereType
---@field ConsequencesStartTime integer
---@field ConsequencesDuration integer
---@field HealthBarColor integer
---@field Skillbook string
---@field PreviewImpactEffect string
---@field IgnoreVisionBlock "Yes"|"No"
---@field HealEffectId string
---@field AddRangeFromAbility StatsLib_Enum_Ability
---@field DivideDamage "Yes"|"No"
---@field OverrideMinAP "Yes"|"No"
---@field OverrideSkillLevel "Yes"|"No"
---@field Tier StatsLib_Enum_SkillTier
---@field GrenadeBone string
---@field GrenadeProjectile string
---@field GrenadePath string
---@field MovingObject string
---@field SpawnObject string
---@field SpawnEffect string
---@field SpawnFXOverridesImpactFX "Yes"|"No"
---@field SpawnLifetime integer
---@field ProjectileTerrainOffset "Yes"|"No"
---@field ProjectileType StatsLib_Enum_ProjectileType
---@field HitEffect string
---@field PushDistance integer
---@field ForceMove "Yes"|"No"
---@field Stealth "Yes"|"No"
---@field Distribution StatsLib_Enum_ProjectileDistribution
---@field Shuffle "Yes"|"No"
---@field PushPullEffect string
---@field Stealth_Damage_Multiplier integer
---@field Distance_Damage_Multiplier integer
---@field BackStart integer
---@field FrontOffset integer
---@field TargetGroundEffect string
---@field PositionEffect string
---@field BeamEffect string
---@field PreviewEffect string
---@field CastSelfAnimation string
---@field IgnoreCursed "Yes"|"No"
---@field IsEnemySkill "Yes"|"No"
---@field DomeEffect string
---@field AuraSelf string
---@field AuraAllies string
---@field AuraEnemies string
---@field AuraNeutrals string
---@field AuraItems string
---@field AIFlags AIFlags
---@field Shape string
---@field Base integer
---@field AiCalculationSkillOverride string
---@field TeleportSurface "Yes"|"No"
---@field ProjectileSkills string
---@field SummonCount integer
---@field LinkTeleports "Yes"|"No"
---@field TeleportsUseCount integer
---@field HeightOffset integer
---@field ForGameMaster "Yes"|"No"
---@field IsMelee "Yes"|"No"
---@field MemorizationRequirements table[] TODO
---@field IgnoreSilence "Yes"|"No"