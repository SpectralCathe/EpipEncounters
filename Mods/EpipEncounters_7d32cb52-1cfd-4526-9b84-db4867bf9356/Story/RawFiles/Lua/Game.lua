
---@class Game
---@field Items GameItems
---@field Net GameNet
---@field EDITOR_VERSION string The current version of the game editor.

---@class ArtifactDefinition
---@field ID string
---@field Slot StatsItemSlot
---@field ItemTemplate GUID
---@field RuneTemplate GUID
---@field KeywordActivators Keyword[]
---@field KeywordMutators Keyword[]

Game.Items = {
    ---@type table<string, ArtifactDefinition>
    ARTIFACTS = {
        Artifact_Absence = {
            ID = "Artifact_Absence",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Absence_Leather_f2d18e71-1385-4c05-a274-d18026fa2b29",
            RuneTemplate = "AMER_UNI_Absence_Rune_afc31b2e-7949-4835-b688-d26f2046100e",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Abyss = {
            ID = "Artifact_Abyss",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_Abyss_Platemail_51ba6c46-8e3d-4365-9272-bdd1f43c988a",
            RuneTemplate = "AMER_UNI_Abyss_Rune_686a3e17-d592-4bde-86c9-a43a76a9cf35",
            KeywordActivators = {"Paucity"},
            KeywordMutators = {"ViolentStrike"},
        },
        Artifact_Adamant = {
            ID = "Artifact_Adamant",
            Slot = "Shield",
            ItemTemplate = "AMER_UNI_Adamant_Shield_9949e5e6-ec79-40a3-8a7b-008155822346",
            RuneTemplate = "AMER_UNI_Adamant_Rune_1c5aba55-57d7-4f51-b792-475f9b5397c9",
            KeywordActivators = {},
            KeywordMutators = {"Ward"},
        },
        Artifact_AmaranthineBulwark = {
            ID = "Artifact_AmaranthineBulwark",
            Slot = "Shield",
            ItemTemplate = "AMER_UNI_AmaranthineBulwark_Shield_8544e38f-b611-4632-96ea-4b2e6ca68064",
            RuneTemplate = "AMER_UNI_AmaranthineBulwark_Rune_e956400b-0adf-4379-8f2b-ac2e7332a62a",
            KeywordActivators = {},
            KeywordMutators = {"Ward"},
        },
        Artifact_AngelsEgg = {
            ID = "Artifact_AngelsEgg",
            Slot = "Amulet",
            ItemTemplate = "AMER_UNI_AngelsEgg_b7511c4a-2e74-4fe7-a6d8-6af4aa366a23",
            RuneTemplate = "AMER_UNI_AngelsEgg_Rune_e7b2f2bf-a295-44c6-a6f7-ed5bafe4a477",
            KeywordActivators = {},
            KeywordMutators = {"Purity"},
        },
        Artifact_AntediluvianCarapace = {
            ID = "Artifact_AntediluvianCarapace",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_AntediluvianCarapace_Platemail_42559c79-82af-48b1-8b0c-16ccf6f5fc90",
            RuneTemplate = "AMER_UNI_AntediluvianCarapace_Rune_46e28b0f-b5ad-445a-8340-ebd78f5765d3",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_ApothecarysGuile = {
            ID = "Artifact_ApothecarysGuile",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_ApothecarysGuile_Leather_70ce1774-ba67-4e76-a1cc-5f67c803f1bd",
            RuneTemplate = "AMER_UNI_ApothecarysGuile_Rune_b6a5af70-a439-4af6-a3d6-e99df73b97d4",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Arcturus = {
            ID = "Artifact_Arcturus",
            Slot = "Amulet",
            ItemTemplate = "AMER_UNI_Arcturus_129a3b30-c934-49fb-ba9f-76d8d9bf815e",
            RuneTemplate = "AMER_UNI_Arcturus_Rune_0fdf74c2-d66a-4940-b58c-ca740f30af0c",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Austerity = {
            ID = "Artifact_Austerity",
            Slot = "Ring",
            ItemTemplate = "AMER_UNI_Austerity_9fceb5ad-e02d-4eb4-8098-cdf795d51adf",
            RuneTemplate = "AMER_UNI_Austerity_Rune_3b401786-032d-4e66-9352-100322c8e6fd",
            KeywordActivators = {"Ward"},
            KeywordMutators = {"Centurion", "Ward"},
        },
        Artifact_BlackglassBrand = {
            ID = "Artifact_BlackglassBrand",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_BlackglassBrand_Sword_1H_6b8aefdb-13f5-4cf3-8ea2-d9e0760b3eea",
            RuneTemplate = "AMER_UNI_BlackglassBrand_Rune_3355fb9f-2bd6-4d89-9e05-d4aa64a81b84",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Bloodforge = {
            ID = "Artifact_Bloodforge",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_Bloodforge_Platemail_48f6c263-6234-41a3-a3de-170f82df0abf",
            RuneTemplate = "AMER_UNI_Bloodforge_Rune_2bb5039f-9ad3-432a-8449-32ab5a5dd759",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_BountyHunter = {
            ID = "Artifact_BountyHunter",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_BountyHunter_Leather_d4dafdc1-3ec0-44ed-ba20-b5e33aac1c01",
            RuneTemplate = "AMER_UNI_BountyHunter_Rune_172bacef-0d72-4a5d-941a-c2bcf2069b97",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_ButchersDisciple = {
            ID = "Artifact_ButchersDisciple",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_TheButchersDisciple_Axe_1H_daf7209a-0915-42d4-9925-5f18e0a4407a",
            RuneTemplate = "AMER_UNI_TheButchersDisciple_Rune_e292b87c-25f0-42f8-ba48-3e2cc9f751de",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_ButchersWill = {
            ID = "Artifact_ButchersWill",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_TheButchersWill_Leather_717fa35a-ae08-47a1-bd80-3fa3a784ad4b",
            RuneTemplate = "AMER_UNI_TheButchersWill_Rune_d8b48a12-8669-42e1-858e-24ce073a3801",
            KeywordActivators = {},
            KeywordMutators = {"ViolentStrike"},
        },
        Artifact_Cannibal = {
            ID = "Artifact_Cannibal",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_TheCannibal_Staff_98fce942-7931-4041-81bb-7bd848a45eb8",
            RuneTemplate = "AMER_UNI_TheCannibal_Rune_d4bc3ff0-9b19-48e2-bbd1-91a90345c653",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Carnality = {
            ID = "Artifact_Carnality",
            Slot = "Ring",
            ItemTemplate = "AMER_UNI_Carnality_35eef736-fc2c-40d7-be95-80bda21a00a6",
            RuneTemplate = "AMER_UNI_Carnality_Rune_32b919ae-eb51-4c9e-b95d-caf5bd0afbe7",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Cataclysm = {
            ID = "Artifact_Cataclysm",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Cataclysm_Dagger_ddf6fe71-ebbf-4876-9b20-bba2e3c53d81",
            RuneTemplate = "AMER_UNI_Cataclysm_Rune_08e6b9df-93a6-4415-a53b-31cc4bfe0755",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Charity = {
            ID = "Artifact_Charity",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_Charity_Robes_308ca2bc-a602-475f-8e2f-ecbbfcbc39db",
            RuneTemplate = "AMER_UNI_Charity_Rune_b85e93cd-0e4e-4924-91e9-18a294df89cb",
            KeywordActivators = {},
            KeywordMutators = {"Benevolence"},
        },
        Artifact_Chthonian = {
            ID = "Artifact_Chthonian",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_TheChthonian_Axe_2H_ab669c08-fcf6-4751-9a86-64af7dd2863b",
            RuneTemplate = "AMER_UNI_TheChthonian_Rune_86d70ff3-94ef-4cc0-b49e-f6a29e1da756",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Consecration = {
            ID = "Artifact_Consecration",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Consecration_Platemail_b14f13be-bdbc-4268-bf8a-ea4eb5dd4b58",
            RuneTemplate = "AMER_UNI_Consecration_Rune_fdbc6ad0-62f5-404e-afac-c20cd7944eb9",
            KeywordActivators = {},
            KeywordMutators = {"Celestial"},
        },
        Artifact_Convergence = {
            ID = "Artifact_Convergence",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Convergence_Crossbow_89cc3edd-af46-4432-ab21-b25034b08e3c",
            RuneTemplate = "AMER_UNI_Convergence_Rune_33ed7f25-c707-4dec-b8fc-1fac3ca8c79d",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_CorruscatingSilks = {
            ID = "Artifact_CorruscatingSilks",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_CoruscatingSilks_Robes_1e7c7a0f-541f-4b01-9beb-2313e133a159",
            RuneTemplate = "AMER_UNI_CoruscatingSilks_Rune_4491045f-e8b3-42b8-8209-1c91177922e5",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Crucible = {
            ID = "Artifact_Crucible",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_TheCrucible_Mace_2H_a5b39108-850b-426f-bc85-40cfc4cd95f2",
            RuneTemplate = "AMER_UNI_TheCrucible_Rune_c03c3c84-5f29-49a9-82b3-0547a08a733d",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Deck = {
            ID = "Artifact_Deck",
            Slot = "Amulet",
            ItemTemplate = "AMER_UNI_Deck_94902e34-3693-460c-a7a4-81f27cfc5ec7",
            RuneTemplate = "AMER_UNI_Deck_Rune_eb9f9170-bf4d-40e6-a2f1-1ff499e4f8c5",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Desperation = {
            ID = "Artifact_Desperation",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Desperation_Leather_8e94d381-c195-4bad-942e-7f52df58d6c8",
            RuneTemplate = "AMER_UNI_Desperation_Rune_74a03339-ef71-46cb-9ae5-91763bef326c",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Dread = {
            ID = "Artifact_Dread",
            Slot = "Ring",
            ItemTemplate = "AMER_UNI_Dread_52e6d2a2-9699-4c36-8bc7-9059a22f1624",
            RuneTemplate = "AMER_UNI_Dread_Rune_23ec2353-2a75-4e05-8de6-2abe839225c1",
            KeywordActivators = {},
            KeywordMutators = {"VitalityVoid"},
        },
        Artifact_DrogsLuck = {
            ID = "Artifact_DrogsLuck",
            Slot = "Amulet",
            ItemTemplate = "AMER_UNI_DrogsLuck_c1e3e38a-de97-466e-bdc2-f916e7622e57",
            RuneTemplate = "AMER_UNI_DrogsLuck_Rune_a942773d-a9b2-4883-8d83-9325676ad294",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Dominion = {
            ID = "Artifact_Dominion",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_Dominion_Platemail_dc75d6e0-c900-443d-ab42-8b0904f1d626",
            RuneTemplate = "AMER_UNI_Dominion_Rune_1640501a-2067-4e39-b3ed-a7c6e23a4ea3",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Eclipse = {
            ID = "Artifact_Eclipse",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Eclipse_Staff_13660086-f745-48d1-9d3a-c1560372f426",
            RuneTemplate = "AMER_UNI_Eclipse_Rune_a40d49d4-b0cb-4a01-aac8-0deda6267f09",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_EmpyreanVestments = {
            ID = "Artifact_EmpyreanVestments",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_EmpyreanVestments_Robes_6826cfad-fc09-40ec-827e-3b26dabdc804",
            RuneTemplate = "AMER_UNI_EmpyreanVestments_Rune_8ff8098d-43d0-4a46-9997-a046e8d92d5e",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_EtherTide = {
            ID = "Artifact_EtherTide",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_EtherTide_Robes_a27989b8-9d1f-4bf1-b2b6-877820cbf595",
            RuneTemplate = "AMER_UNI_EtherTide_Rune_139a3219-f127-489b-9d17-f3ae40cfbd87",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Exaltation = {
            ID = "Artifact_Exaltation",
            Slot = "Ring",
            ItemTemplate = "AMER_UNI_Exaltation_8ce4fe8a-41cb-479a-b1ab-c2305bd3f840",
            RuneTemplate = "AMER_UNI_Exaltation_Rune_cefc217c-7f79-44a4-ad57-bd10587f8297",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Expedition = {
            ID = "Artifact_Expedition",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Expedition_Bow_0e3e575b-2a18-45ac-a6e6-670248e80650",
            RuneTemplate = "AMER_UNI_Expedition_Rune_dffb73c3-8a00-4ce6-a73a-c549ac075f07",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_EyeOfTheStorm = {
            ID = "Artifact_EyeOfTheStorm",
            Slot = "Ring",
            ItemTemplate = "AMER_UNI_EyeOfTheStorm_05822cb2-cd54-46fb-9218-4a2c1fcd09db",
            RuneTemplate = "AMER_UNI_EyeOfTheStorm_Rune_4d7e68eb-472f-4cee-bbfe-99c2f0bf9b88",
            KeywordActivators = {},
            KeywordMutators = {"Predator"},
        },
        Artifact_FaceOfTheFallen = {
            ID = "Artifact_FaceOfTheFallen",
            Slot = "Shield",
            ItemTemplate = "AMER_UNI_FaceOfTheFallen_Shield_c3201b00-ed7e-4321-93a1-386e1ec1508b",
            RuneTemplate = "AMER_UNI_FaceOfTheFallen_Rune_6e6743f6-52b1-4c9b-bc39-8733e8850e2b",
            KeywordActivators = {},
            KeywordMutators = {"Voracity"},
        },
        Artifact_Famine = {
            ID = "Artifact_Famine",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Famine_Axe_2H_0cbdd629-416e-4305-b22e-e3288963f4b6",
            RuneTemplate = "AMER_UNI_Famine_Rune_e8f8d868-f208-4c72-9b73-aad0d4f7e09f",
            KeywordActivators = {},
            KeywordMutators = {"Paucity"},
        },
        Artifact_Fecundity = {
            ID = "Artifact_Fecundity",
            Slot = "Ring",
            ItemTemplate = "AMER_UNI_Fecundity_9a31f366-784d-416d-9f7d-d5f052135e1c",
            RuneTemplate = "AMER_UNI_Fecundity_Rune_1376a748-664a-4520-ab09-7299d7b15390",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_FistOfDecay = {
            ID = "Artifact_FistOfDecay",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_FistOfDecay_Robes_c0391cd2-9012-452b-8b59-2104be881804",
            RuneTemplate = "AMER_UNI_FistOfDecay_Rune_88d3fab0-ed36-4c20-b050-b82956200dc8",
            KeywordActivators = {"VitalityVoid"},
            KeywordMutators = {},
        },
        Artifact_Ghostflame = {
            ID = "Artifact_Ghostflame",
            Slot = "Amulet",
            ItemTemplate = "AMER_UNI_Ghostflame_6ad56825-75af-4248-af1c-43200ec25caf",
            RuneTemplate = "AMER_UNI_Ghostflame_Rune_4ccf4271-0eb0-406e-b917-82b84dd87cc2",
            KeywordActivators = {},
            KeywordMutators = {"Occultist"},
        },
        Artifact_GiantsSkull = {
            ID = "Artifact_GiantsSkull",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_GiantsSkull_Platemail_1db0b5be-fa13-4c93-ae53-0552f67e1075",
            RuneTemplate = "AMER_UNI_GiantsSkull_Rune_013e49de-43d4-4d4b-bce3-88864a2dc53d",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Glacier = {
            ID = "Artifact_Glacier",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Glacier_Mace_2H_39f36e1b-e3c6-41a7-bb36-6ac9091121e6",
            RuneTemplate = "AMER_UNI_Glacier_Rune_aef6fcde-08bb-482f-8ff5-a5d13b7db22f",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Gluttony = {
            ID = "Artifact_Gluttony",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Gluttony_Spear_684ae15d-cd97-4d94-bb5a-3136a57bcc82",
            RuneTemplate = "AMER_UNI_Gluttony_Rune_9daf82cc-db67-4918-8142-12051ec78993",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Godspeed = {
            ID = "Artifact_Godspeed",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Godspeed_Leather_57faf828-ca32-44db-a450-88bdfd3a2e19",
            RuneTemplate = "AMER_UNI_Godspeed_Rune_371bce5d-2d54-400a-974d-e4f30e092b9b",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Goldforge = {
            ID = "Artifact_Goldforge",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Goldforge_Mace_2H_40cce3a4-dd7f-4992-a0d9-3b0a27246a4d",
            RuneTemplate = "AMER_UNI_Goldforge_Rune_8bc09d16-75c7-4e5a-830d-fab9acfa1a11",
            KeywordActivators = {},
            KeywordMutators = {"Prosperity"},
        },
        Artifact_Golem = {
            ID = "Artifact_Golem",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Golem_Axe_2H_fa4b9d59-e1d8-46e8-9883-ae08cb618983",
            RuneTemplate = "AMER_UNI_Golem_Rune_6677124c-4604-43cb-952d-23efc50e56a2",
            KeywordActivators = {},
            KeywordMutators = {"Prosperity"},
        },
        Artifact_GramSwordOfGrief = {
            ID = "Artifact_GramSwordOfGrief",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_GramSwordOfGrief_Sword_2H_5e44d043-b9d1-466b-a7a2-997b928dcc5e",
            RuneTemplate = "AMER_UNI_GramSwordOfGrief_Rune_b943d928-be9d-4e9c-94f0-a624924dd110",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Hibernaculum = {
            ID = "Artifact_Hibernaculum",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Hibernaculum_Bow_affbe035-7553-4151-a013-0fb12142c54b",
            RuneTemplate = "AMER_UNI_Hibernaculum_Rune_0b6d1bf4-c3b5-4291-b790-c39a351b6be0",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Impetus = {
            ID = "Artifact_Impetus",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Impetus_Spear_fff1dafe-0988-446a-947f-04d0fa179207",
            RuneTemplate = "AMER_UNI_Impetus_Rune_8505698b-d328-40d0-8ebe-9112ae585e36",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_InfernalContract = {
            ID = "Artifact_InfernalContract",
            Slot = "Shield",
            ItemTemplate = "AMER_UNI_InfernalContract_Shield_96afb247-fe97-4b48-b1c9-d6cfb1671570",
            RuneTemplate = "AMER_UNI_InfernalContract_Rune_0a48df34-0e22-4e81-9196-96f6b06b93ab",
            KeywordActivators = {"Wither"},
            KeywordMutators = {},
        },
        Artifact_IronMaiden = {
            ID = "Artifact_IronMaiden",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_IronMaiden_Platemail_bf18ca16-f822-48e7-8c65-022dd125b928",
            RuneTemplate = "AMER_UNI_IronMaiden_Rune_ee3702f2-b3e2-4a2f-ac61-e8c227c5c1d1",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Jaguar = {
            ID = "Artifact_Jaguar",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_TheJaguar_Leather_5bd63bb6-707f-45dd-b6a6-d587a8babd3c",
            RuneTemplate = "AMER_UNI_TheJaguar_Rune_106b7b9b-ab97-490c-bbbb-74d292d042fc",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Judgement = {
            ID = "Artifact_Judgement",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Judgement_Sword_2H_43b7cfe8-3a5a-48a5-9b39-7f27229ba36b",
            RuneTemplate = "AMER_UNI_Judgement_Rune_a6974e3c-7341-4368-8d37-2fee8e20dd3f",
            KeywordActivators = {},
            KeywordMutators = {"ViolentStrike"},
        },
        Artifact_Kudzu = {
            ID = "Artifact_Kudzu",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Kudzu_Robes_cc36a70b-4260-489f-9196-4572ce20ae47",
            RuneTemplate = "AMER_UNI_Kudzu_Rune_99f328fc-409a-42af-82e5-3913d6910045",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_LambentBlade = {
            ID = "Artifact_LambentBlade",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_LambentBlade_Sword_1H_0a182fe3-639f-4bfc-99f3-b8e863139f50",
            RuneTemplate = "AMER_UNI_LambentBlade_Rune_5aa5bcdd-6fb4-461a-93ad-2e988df31f8f",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Leper = {
            ID = "Artifact_Leper",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Leper_Dagger_62bd59bc-b662-4d13-9b97-9f121edd01ca",
            RuneTemplate = "AMER_UNI_Leper_Rune_d3913dfe-85ff-436f-8880-61e739c02412",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Leviathan = {
            ID = "Artifact_Leviathan",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Leviathan_Mace_2H_2b0eb17a-b644-47fb-b65a-85ca8e727cfb",
            RuneTemplate = "AMER_UNI_Leviathan_Rune_c22f2e5b-881a-459a-b552-bcf09f249539",
            KeywordActivators = {},
            KeywordMutators = {"ViolentStrike"},
        },
        Artifact_Lightspire = {
            ID = "Artifact_Lightspire",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Lightspire_Spear_ed3b3d6f-25c2-48e3-b053-7d14034348ea",
            RuneTemplate = "AMER_UNI_Lightspire_Rune_6fbef305-b6a5-47f4-8ffb-a84b490b4ca4",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_LocustCrown = {
            ID = "Artifact_LocustCrown",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_TheLocustCrown_Robes_f75b90f0-b2f9-4a19-aca2-1fe9458fbe9d",
            RuneTemplate = "AMER_UNI_TheLocustCrown_Rune_45fff2b1-4a44-4d30-af4f-78ba63f6f2a8",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Malice = {
            ID = "Artifact_Malice",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_Malice_Robes_8425ffd0-5236-4dee-bd98-ceb9fd4d12d0",
            RuneTemplate = "AMER_UNI_Malice_Rune_7b6a9205-4495-416a-96a0-2fde849d4f34",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_MalleusMaleficarum = {
            ID = "Artifact_MalleusMaleficarum",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_MalleusMaleficarum_Mace_1H_61684e0f-7d5b-4c86-8df8-c9d0afc4e7ae",
            RuneTemplate = "AMER_UNI_MalleusMaleficarum_Rune_e85b626d-513c-4ed5-b36a-284c67add9d7",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Mirage = {
            ID = "Artifact_Mirage",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Mirage_Dagger_0d2dbc57-d91f-4e10-bc2c-932686b92dc0",
            RuneTemplate = "AMER_UNI_Mirage_Rune_b282cb8f-ded5-4509-894b-753f8081cdb9",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Misery = {
            ID = "Artifact_Misery",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_Misery_Robes_4ff8d1bf-fa0b-4f44-9854-43147ed4cae4",
            RuneTemplate = "AMER_UNI_Misery_Rune_42ae2948-9b58-4ac3-a1b5-1b8b0cba12d0",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Momentum = {
            ID = "Artifact_Momentum",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Momentum_Crossbow_834fff08-cd43-4e24-8610-1a6d6a7f4705",
            RuneTemplate = "AMER_UNI_Momentum_Rune_d163d762-d41d-4d7a-808d-da4f4e255348",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Mountain = {
            ID = "Artifact_Mountain",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_Mountain_Platemail_76820f36-7915-4bac-8b2b-9fc654f452f9",
            RuneTemplate = "AMER_UNI_Mountain_Rune_ece3ca0e-0e69-41ad-8219-d1bcff2ab5bd",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_NecromancersRaiment = {
            ID = "Artifact_NecromancersRaiment",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_NecromancersRaiment_Robes_e96386e8-db7f-4267-aa92-6caff9ae2f7b",
            RuneTemplate = "AMER_UNI_NecromancersRaiment_Rune_705f612a-9109-41ca-88c4-60c24be802b0",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Nemesis = {
            ID = "Artifact_Nemesis",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_Nemesis_Leather_0339fe72-2c9c-404f-9499-7083985dfaac",
            RuneTemplate = "AMER_UNI_Nemesis_Rune_9d0e48c4-fa53-484c-8ee9-616094ed18ca",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Nightmare = {
            ID = "Artifact_Nightmare",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Nightmare_Spear_5a551e28-f20a-427f-98f3-3ab3e7e6e76b",
            RuneTemplate = "AMER_UNI_Nightmare_Rune_e9314437-7664-4b33-8e4d-2fb65b4f3fc4",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Nihility = {
            ID = "Artifact_Nihility",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_Nihility_Platemail_ae72ebc1-446a-4808-980f-bb06997929f0",
            RuneTemplate = "AMER_UNI_Nihility_Rune_05e6365b-39f9-438b-899b-235de8b9e7e1",
            KeywordActivators = {"VitalityVoid"},
            KeywordMutators = {},
        },
        Artifact_Obelisk = {
            ID = "Artifact_Obelisk",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Obelisk_Staff_f123abbe-84ef-4f7b-a599-72825e41ae96",
            RuneTemplate = "AMER_UNI_Obelisk_Rune_5f58d8f6-ba3b-42d1-bece-4667b3397046",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Occam = {
            ID = "Artifact_Occam",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Occam_Dagger_4c5b5543-ca6e-407e-9278-66c8e27be0a4",
            RuneTemplate = "AMER_UNI_Occam_Rune_8483d917-dccd-45a5-b318-210adf8220f2",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Onslaught = {
            ID = "Artifact_Onslaught",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Onslaught_Platemail_285a972f-b30c-4424-9867-b527c8b8c47d",
            RuneTemplate = "AMER_UNI_Onslaught_Rune_c3809b72-7533-4bfa-9a84-7bcdf369df95",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Ouroboros = {
            ID = "Artifact_Ouroboros",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_Ouroboros_Leather_e2d1edf3-4a1c-4a7b-9ab5-12cad07db2ee",
            RuneTemplate = "AMER_UNI_Ouroboros_Rune_328a74b5-a426-4b8d-a648-dd3c48abfffb",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Paragon = {
            ID = "Artifact_Paragon",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_Paragon_Robes_ddbd0267-2770-43d0-b5cf-f5a2f935ae9c",
            RuneTemplate = "AMER_UNI_Paragon_Rune_f9acc87d-c30c-4071-8748-6efe0ae5f33a",
            KeywordActivators = {"VitalityVoid"},
            KeywordMutators = {"VitalityVoid"},
        },
        Artifact_Pariah = {
            ID = "Artifact_Pariah",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Pariah_Wand_6951c90b-fbeb-447b-bf6e-f4422696c2c1",
            RuneTemplate = "AMER_UNI_Pariah_Rune_00a98dce-78d0-4c60-a7ad-56fc3697cfc4",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Pestilence = {
            ID = "Artifact_Pestilence",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Pestilence_Spear_788d8c42-d4f2-4da0-8293-1074453ad8e6",
            RuneTemplate = "AMER_UNI_Pestilence_Rune_c1af093a-7489-46b3-bbc2-011637abaad4",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_PrismaticBarrier = {
            ID = "Artifact_PrismaticBarrier",
            Slot = "Shield",
            ItemTemplate = "AMER_UNI_PrismaticBarrier_Shield_ac8122a2-9900-4b14-87da-bc1c5e3a9300",
            RuneTemplate = "AMER_UNI_PrismaticBarrier_Rune_d43243f6-2336-49cf-9360-8c4b169de09f",
            KeywordActivators = {},
            KeywordMutators = {"Prosperity"},
        },
        Artifact_Prophecy = {
            ID = "Artifact_Prophecy",
            Slot = "Ring",
            ItemTemplate = "AMER_UNI_Prophecy_94a7c392-b364-4d4d-a7e2-89e0374269ae",
            RuneTemplate = "AMER_UNI_Prophecy_Rune_94a62842-121e-4b2d-a080-8400fe195dac",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Pyre = {
            ID = "Artifact_Pyre",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_Pyre_Platemail_0d32f7a0-0a08-43a6-83ce-0fb31b2d4fb4",
            RuneTemplate = "AMER_UNI_Pyre_Rune_f6fb7fe6-a08a-40cd-9309-c9b62db9f52d",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Rapture = {
            ID = "Artifact_Rapture",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Rapture_Wand_5410e049-81a6-49cb-b4cb-61dd35123be4",
            RuneTemplate = "AMER_UNI_Rapture_Rune_64fe7208-a2d3-45e8-ace5-cfd85177438b",
            KeywordActivators = {"Purity"},
            KeywordMutators = {"Celestial"},
        },
        Artifact_RedOrison = {
            ID = "Artifact_RedOrison",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_RedOrison_Leather_48f6188d-6e85-4526-a8bb-58eb1fd3c7ef",
            RuneTemplate = "AMER_UNI_RedOrison_Rune_6673424d-88ae-4323-84a9-186739ff13d8",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_RodOfAbeyance = {
            ID = "Artifact_RodOfAbeyance",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_RodOfAbeyance_Wand_dccb9e34-1c3c-4faa-99e6-1e7fdceded1d",
            RuneTemplate = "AMER_UNI_RodOfAbeyance_Rune_fc2de115-7044-4424-8eea-6b26895e0dd5",
            KeywordActivators = {},
            KeywordMutators = {"Abeyance"},
        },
        Artifact_RodOfCommand = {
            ID = "Artifact_RodOfCommand",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_RodOfCommand_Wand_9a3a2a71-787f-442c-a7c0-d8e5d5d4253b",
            RuneTemplate = "AMER_UNI_RodOfCommand_Rune_68723eaa-c70d-4b1c-bf0f-715cdc00280e",
            KeywordActivators = {},
            KeywordMutators = {"ViolentStrike"},
        },
        Artifact_RodOfConviction = {
            ID = "Artifact_RodOfConviction",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_RodOfConviction_Wand_707a1cfa-2b4f-4855-beb4-49136bccf117",
            RuneTemplate = "AMER_UNI_RodOfConviction_Rune_4f2c3afb-6b44-43ba-bea7-dabda13230e8",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Salamander = {
            ID = "Artifact_Salamander",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Salamander_Platemail_b08e0423-a41f-4275-ad20-5844cd8b2431",
            RuneTemplate = "AMER_UNI_Salamander_Rune_609f79c7-8bb4-4eb9-a599-0014f92e5fb6",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_SanguineHarvest = {
            ID = "Artifact_SanguineHarvest",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_SanguineHarvest_Wand_6cfa99c4-85d2-450b-9f44-aa56f1997921",
            RuneTemplate = "AMER_UNI_SanguineHarvest_Rune_e41172c1-4bbf-4125-886e-b28a0d5a05aa",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Savage = {
            ID = "Artifact_Savage",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_TheSavage_Staff_389ca9d6-17b6-4f17-aa4e-036efc1521b9",
            RuneTemplate = "AMER_UNI_TheSavage_Rune_093da89a-cbfb-40c2-a5bb-03f5ab9e8f4e",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Seraph = {
            ID = "Artifact_Seraph",
            Slot = "Amulet",
            ItemTemplate = "AMER_UNI_Seraph_db8f2b31-e409-415c-89c5-d42c91a0f04f",
            RuneTemplate = "AMER_UNI_Seraph_Rune_29328bd4-e510-42c6-a6a8-86de1d4b6e29",
            KeywordActivators = {},
            KeywordMutators = {"Celestial"},
        },
        Artifact_Serenity = {
            ID = "Artifact_Serenity",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_Serenity_Robes_cc3d0fcc-45c1-48ad-9095-3090ebf64e20",
            RuneTemplate = "AMER_UNI_Serenity_Rune_a12da803-0fcc-4c03-a194-a29680101725",
            KeywordActivators = {},
            KeywordMutators = {"Purity"},
        },
        Artifact_Silkclimb = {
            ID = "Artifact_Silkclimb",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Silkclimb_Robes_74feda94-2651-4cdc-8cde-26885f41a31c",
            RuneTemplate = "AMER_UNI_Silkclimb_Rune_2444e1a5-fffc-43cb-ac1f-d3208011b9e3",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Smother = {
            ID = "Artifact_Smother",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_Smother_Leather_5419e1f2-c51b-45ac-96cb-767c56f8a33a",
            RuneTemplate = "AMER_UNI_Smother_Rune_5ab6d0f8-1e0b-4996-98a4-cf865b05540f",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Thirst = {
            ID = "Artifact_Thirst",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Thirst_Dagger_d381f754-9bbb-4418-a9ee-69ae699b00cf",
            RuneTemplate = "AMER_UNI_Thirst_Rune_5197b90b-2443-4d84-b8ca-ecabf33170bb",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_ThornHalo = {
            ID = "Artifact_ThornHalo",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_ThornHalo_Platemail_90484ec1-abd2-47a1-abb6-1fe300bc5baa",
            RuneTemplate = "AMER_UNI_ThornHalo_Rune_55cbe2a0-bba4-4a59-aef5-b9d697bf4f80",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Trample = {
            ID = "Artifact_Trample",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Trample_Platemail_36352ab1-d9f6-418e-b7e0-8a6834195358",
            RuneTemplate = "AMER_UNI_Trample_Rune_6ccc1e12-2b2a-4d19-8ed3-1405a0fdfe68",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Tundra = {
            ID = "Artifact_Tundra",
            Slot = "Helmet",
            ItemTemplate = "AMER_UNI_Tundra_Platemail_2031aad5-0c48-4288-926e-ffb802373f4c",
            RuneTemplate = "AMER_UNI_Tundra_Rune_b01b15df-f259-40f7-919b-66b42ec915c7",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Urgency = {
            ID = "Artifact_Urgency",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_Urgency_Leather_b64d339a-9cc3-4c33-8f15-ad86a8f82245",
            RuneTemplate = "AMER_UNI_Urgency_Rune_fab75597-3448-42de-8796-3a201cf13304",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Vault = {
            ID = "Artifact_Vault",
            Slot = "Breast",
            ItemTemplate = "AMER_UNI_TheVault_Platemail_fdabbaea-89d6-4ee0-ac5f-8c96d2345ea3",
            RuneTemplate = "AMER_UNI_TheVault_Rune_1cc1459e-490e-46d5-90f1-970ad625c548",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Vertigo = {
            ID = "Artifact_Vertigo",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Vertigo_Axe_1H_6ab20ae4-1ede-4544-ace1-0bc0ac14a72a",
            RuneTemplate = "AMER_UNI_Vertigo_Rune_1cf2fb87-45df-43b1-980d-52de5fb942d4",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Vortex = {
            ID = "Artifact_Vortex",
            Slot = "Boots",
            ItemTemplate = "AMER_UNI_Vortex_Robes_aa5f6f9f-af2d-493b-83f3-5958ed0eeb09",
            RuneTemplate = "AMER_UNI_Vortex_Rune_7770a77a-b0d0-4361-948b-26366f01c94a",
            KeywordActivators = {},
            KeywordMutators = {"VitalityVoid"},
        },
        Artifact_Wendigo = {
            ID = "Artifact_Wendigo",
            Slot = "Amulet",
            ItemTemplate = "AMER_UNI_Wendigo_c059b343-ec4e-4b03-a784-e9796d038f93",
            RuneTemplate = "AMER_UNI_Wendigo_Rune_7e053219-7d0d-4261-8a2e-c6ed9aa4502e",
            KeywordActivators = {},
            KeywordMutators = {"Predator"},
        },
        Artifact_WintersGrasp = {
            ID = "Artifact_WintersGrasp",
            Slot = "Gloves",
            ItemTemplate = "AMER_UNI_WintersGrasp_Platemail_2d3b1b8f-063b-429a-a6be-b79736614f61",
            RuneTemplate = "AMER_UNI_WintersGrasp_Rune_00b7fcc4-6625-4bf1-aa7d-1335a3c05e15",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Wraith = {
            ID = "Artifact_Wraith",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Wraith_Dagger_ca4acd8a-3886-4e62-8387-e4cbdcf85495",
            RuneTemplate = "AMER_UNI_Wraith_Rune_d476a1fc-74f0-4efc-acb9-816671c9e6eb",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Zeal = {
            ID = "Artifact_Zeal",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Zeal_Sword_2H_316082cd-5f2d-49d3-b910-a87abc2bd7fc",
            RuneTemplate = "AMER_UNI_Zeal_Rune_ae09c357-645a-47e7-8daf-3b704032e72b",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Zenith = {
            ID = "Artifact_Zenith",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Zenith_Bow_3d5974ab-a600-4e6f-9b07-a7aa5e0333bc",
            RuneTemplate = "AMER_UNI_Zenith_Rune_f089009a-2bdc-41c3-976f-192c98ad0e7d",
            KeywordActivators = {},
            KeywordMutators = {},
        },
        Artifact_Zodiac = {
            ID = "Artifact_Zodiac",
            Slot = "Weapon",
            ItemTemplate = "AMER_UNI_Zodiac_Staff_278345a9-3f2d-49a9-b1a2-05b68d91d86a",
            RuneTemplate = "AMER_UNI_Zodiac_Rune_eea08f98-dbce-4b28-9971-360c0c27b46b",
            KeywordActivators = {},
            KeywordMutators = {"Celestial"},
        },
    },
}
Game.Net = {}

Game.EDITOR_VERSION = "v3.6.51.9303"