
---@meta

---Annotates a Weapon stats entry.
---@class StatsLib_StatsEntry_Weapon
---@field Handedness StatsLib_Enum_Handedness
---@field IsTwoHanded "Yes"|"No"
---@field Damage_Type StatsLib_Enum_DamageType
---@field Damage integer
---@field Damage_Range integer
---@field DamageBoost integer
---@field DamageFromBase integer
---@field CriticalDamage integer
---@field CriticalChance integer
---@field Movement integer
---@field Initiative integer
---@field Requirements StatsLib_StatsEntryField_Requirements
---@field Slot ItemSlot
---@field Durability integer
---@field DurabilityDegradeSpeed StatsLib_Enum_Qualifier
---@field Value integer
---@field WeaponType StatsLib_Enum_WeaponType
---@field AnimType StatsLib_Enum_AnimType
---@field WeaponRange integer
---@field ModifierType StatsLib_Enum_ModifierType
---@field Projectile string
---@field Act 1
---@field Act_part StatsLib_Enum_ActPart
---@field StrengthBoost StatsLib_Enum_PenaltyQualifier
---@field FinesseBoost StatsLib_Enum_PenaltyQualifier
---@field IntelligenceBoost StatsLib_Enum_PenaltyQualifier
---@field ConstitutionBoost StatsLib_Enum_PenaltyQualifier
---@field MemoryBoost StatsLib_Enum_PenaltyQualifier
---@field WitsBoost StatsLib_Enum_PenaltyQualifier
---@field SingleHanded integer
---@field TwoHanded integer
---@field Ranged integer
---@field DualWielding integer
---@field RogueLore integer
---@field WarriorLore integer
---@field RangerLore integer
---@field FireSpecialist integer
---@field WaterSpecialist integer
---@field AirSpecialist integer
---@field EarthSpecialist integer
---@field Sourcery integer
---@field Necromancy integer
---@field Polymorph integer
---@field Summoning integer
---@field Leadership integer
---@field PainReflection integer
---@field Perseverance integer
---@field Telekinesis integer
---@field Sneaking integer
---@field Thievery integer
---@field Loremaster integer
---@field Repair integer
---@field Barter integer
---@field Persuasion integer
---@field Luck integer
---@field Fire integer
---@field Earth integer
---@field Water integer
---@field Air integer
---@field Poison integer
---@field Physical integer
---@field Piercing integer
---@field SightBoost StatsLib_Enum_PenaltyQualifier
---@field HearingBoost StatsLib_Enum_PenaltyQualifier
---@field VitalityBoost integer
---@field MagicPointsBoost StatsLib_Enum_PenaltyQualifier
---@field ChanceToHitBoost integer
---@field APMaximum integer
---@field APStart integer
---@field APRecovery integer
---@field AccuracyBoost integer
---@field DodgeBoost integer
---@field Weight integer
---@field AttackAPCost integer
---@field ComboCategory string
---@field Flags StatsLib_Enum_AttributeFlags
---@field Boosts string
---@field InventoryTab StatsLib_Enum_InventoryTabs
---@field Charges integer
---@field MaxCharges integer
---@field Skills string
---@field Reflection string
---@field ItemGroup string
---@field ObjectCategory string
---@field MinAmount integer
---@field MaxAmount integer
---@field Priority integer
---@field Unique integer
---@field MinLevel integer
---@field MaxLevel integer
---@field ItemColor string
---@field MaxSummons integer
---@field RuneSlots integer
---@field RuneSlots_V1 integer
---@field NeedsIdentification "Yes"|"No"
---@field LifeSteal integer
---@field CleavePercentage integer
---@field CleaveAngle integer
---@field Talents string
---@field IgnoreVisionBlock "Yes"|"No"
---@field Tags string

---Annotates an Armor stats entry.
---@class StatsLib_StatsEntry_Armor
---@field Armor_Defense_Value integer
---@field ArmorBoost integer
---@field Magic_Armor_Value integer
---@field MagicArmorBoost integer
---@field Movement integer
---@field Initiative integer
---@field Requirements StatsLib_StatsEntryField_Requirements
---@field Slot ItemSlot
---@field Durability integer
---@field DurabilityDegradeSpeed StatsLib_Enum_Qualifier
---@field Value integer
---@field ModifierType StatsLib_Enum_ModifierType
---@field Act 1
---@field Act_part StatsLib_Enum_ActPart
---@field Fire integer
---@field Air integer
---@field Water integer
---@field Earth integer
---@field Poison integer
---@field Piercing integer
---@field Physical integer
---@field StrengthBoost StatsLib_Enum_PenaltyQualifier
---@field FinesseBoost StatsLib_Enum_PenaltyQualifier
---@field IntelligenceBoost StatsLib_Enum_PenaltyQualifier
---@field ConstitutionBoost StatsLib_Enum_PenaltyQualifier
---@field MemoryBoost StatsLib_Enum_PenaltyQualifier
---@field WitsBoost StatsLib_Enum_PenaltyQualifier
---@field SingleHanded integer
---@field TwoHanded integer
---@field Ranged integer
---@field DualWielding integer
---@field RogueLore integer
---@field WarriorLore integer
---@field RangerLore integer
---@field FireSpecialist integer
---@field WaterSpecialist integer
---@field AirSpecialist integer
---@field EarthSpecialist integer
---@field Sourcery integer
---@field Necromancy integer
---@field Polymorph integer
---@field Summoning integer
---@field PainReflection integer
---@field Perseverance integer
---@field Leadership integer
---@field Telekinesis integer
---@field Sneaking integer
---@field Thievery integer
---@field Loremaster integer
---@field Repair integer
---@field Barter integer
---@field Persuasion integer
---@field Luck integer
---@field SightBoost StatsLib_Enum_PenaltyQualifier
---@field HearingBoost StatsLib_Enum_PenaltyQualifier
---@field VitalityBoost integer
---@field MagicPointsBoost StatsLib_Enum_PenaltyQualifier
---@field ChanceToHitBoost integer
---@field APMaximum integer
---@field APStart integer
---@field APRecovery integer
---@field AccuracyBoost integer
---@field DodgeBoost integer
---@field CriticalChance integer
---@field ComboCategory string
---@field Weight integer
---@field InventoryTab StatsLib_Enum_InventoryTabs
---@field Flags StatsLib_Enum_AttributeFlags
---@field ArmorType StatsLib_Enum_ArmorType
---@field Boosts string
---@field Skills string
---@field ItemColor string
---@field Reflection string
---@field ItemGroup string
---@field ObjectCategory string
---@field MinAmount integer
---@field MaxAmount integer
---@field Priority integer
---@field Unique integer
---@field MinLevel integer
---@field MaxLevel integer
---@field MaxSummons integer
---@field NeedsIdentification "Yes"|"No"
---@field Charges integer
---@field RuneSlots integer
---@field RuneSlots_V1 integer
---@field MaxCharges integer
---@field Talents string
---@field Tags string

---Annotates a Shield stats entry.
---@class StatsLib_StatsEntry_Shield
---@field Armor_Defense_Value integer
---@field ArmorBoost integer
---@field Magic_Armor_Value integer
---@field MagicArmorBoost integer
---@field Movement integer
---@field Initiative integer
---@field Requirements StatsLib_StatsEntryField_Requirements
---@field Slot ItemSlot
---@field Durability integer
---@field DurabilityDegradeSpeed StatsLib_Enum_Qualifier
---@field Value integer
---@field ModifierType StatsLib_Enum_ModifierType
---@field Act 1
---@field Act_part StatsLib_Enum_ActPart
---@field Fire integer
---@field Air integer
---@field Water integer
---@field Earth integer
---@field Poison integer
---@field Piercing integer
---@field Physical integer
---@field Blocking integer
---@field StrengthBoost StatsLib_Enum_PenaltyQualifier
---@field FinesseBoost StatsLib_Enum_PenaltyQualifier
---@field IntelligenceBoost StatsLib_Enum_PenaltyQualifier
---@field ConstitutionBoost StatsLib_Enum_PenaltyQualifier
---@field MemoryBoost StatsLib_Enum_PenaltyQualifier
---@field WitsBoost StatsLib_Enum_PenaltyQualifier
---@field SingleHanded integer
---@field TwoHanded integer
---@field Ranged integer
---@field DualWielding integer
---@field RogueLore integer
---@field WarriorLore integer
---@field RangerLore integer
---@field FireSpecialist integer
---@field WaterSpecialist integer
---@field AirSpecialist integer
---@field EarthSpecialist integer
---@field Sourcery integer
---@field Necromancy integer
---@field Polymorph integer
---@field Summoning integer
---@field Leadership integer
---@field PainReflection integer
---@field Perseverance integer
---@field Telekinesis integer
---@field Sneaking integer
---@field Thievery integer
---@field Loremaster integer
---@field Repair integer
---@field Barter integer
---@field Persuasion integer
---@field Luck integer
---@field SightBoost StatsLib_Enum_PenaltyQualifier
---@field HearingBoost StatsLib_Enum_PenaltyQualifier
---@field VitalityBoost integer
---@field MagicPointsBoost StatsLib_Enum_PenaltyQualifier
---@field ChanceToHitBoost integer
---@field APMaximum integer
---@field APStart integer
---@field APRecovery integer
---@field AccuracyBoost integer
---@field DodgeBoost integer
---@field CriticalChance StatsLib_Enum_PenaltyQualifier
---@field ComboCategory string
---@field Weight integer
---@field InventoryTab StatsLib_Enum_InventoryTabs
---@field Flags StatsLib_Enum_AttributeFlags
---@field Skills string
---@field Reflection string
---@field ItemGroup string
---@field ObjectCategory string
---@field MinAmount integer
---@field MaxAmount integer
---@field Priority integer
---@field Unique integer
---@field MinLevel integer
---@field MaxLevel integer
---@field ItemColor string
---@field MaxSummons integer
---@field RuneSlots integer
---@field RuneSlots_V1 integer
---@field NeedsIdentification "Yes"|"No"
---@field Talents string
---@field Tags string