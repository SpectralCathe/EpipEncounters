
local T = Epip.GetFeature("Feature_GenericUITextures")
local ButtonTextures = T.TEXTURES.BUTTONS
local StateButtonTextures = T.TEXTURES.STATE_BUTTONS
local Generic = Client.UI.Generic

local Button = Generic.GetPrefab("GenericUI_Prefab_Button")

---@type table<string, GenericUI_Prefab_Button_Style>
local styles = {
    ArrowDown = {
        IdleTexture = ButtonTextures.ARROWS.DOWN.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.DOWN.HIGHLIGHTED,
        PressedTexture = ButtonTextures.ARROWS.DOWN.PRESSED,
    },
    ArrowUp = {
        IdleTexture = ButtonTextures.ARROWS.UP.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.UP.HIGHLIGHTED,
        PressedTexture = ButtonTextures.ARROWS.UP.PRESSED,
    },
    DiamondDown = {
        IdleTexture = ButtonTextures.ARROWS.DIAMOND.DOWN.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.DIAMOND.DOWN.HIGHLIGHTED,
    },
    Diamond = {
        IdleTexture = ButtonTextures.ARROWS.DIAMOND.NORMAL.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.DIAMOND.NORMAL.HIGHLIGHTED,
    },
    DiamondUp = {
        IdleTexture = ButtonTextures.ARROWS.DIAMOND.UP.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.DIAMOND.UP.HIGHLIGHTED,
    },
    DoubleDiamond = {
        IdleTexture = ButtonTextures.ARROWS.DIAMOND.DOUBLE.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.DIAMOND.DOUBLE.HIGHLIGHTED,
    },
    DownSlate = {
        IdleTexture = ButtonTextures.ARROWS.DOWN_SLATE.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.DOWN_SLATE.HIGHLIGHTED,
        PressedTexture = ButtonTextures.ARROWS.DOWN_SLATE.PRESSED,
    },
    SquareUp = {
        IdleTexture = ButtonTextures.ARROWS.SQUARE.UP.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.SQUARE.UP.HIGHLIGHTED,
        PressedTexture = ButtonTextures.ARROWS.SQUARE.UP.PRESSED,
    },
    SquareDown = {
        IdleTexture = ButtonTextures.ARROWS.SQUARE.DOWN.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.SQUARE.DOWN.HIGHLIGHTED,
        PressedTexture = ButtonTextures.ARROWS.SQUARE.DOWN.PRESSED,
    },
    UpSlate = {
        IdleTexture = ButtonTextures.ARROWS.UP_SLATE.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.UP_SLATE.HIGHLIGHTED,
        PressedTexture = ButtonTextures.ARROWS.UP_SLATE.PRESSED,
    },
    LeftTall = {
        IdleTexture = ButtonTextures.ARROWS.LEFT_TALL.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.LEFT_TALL.HIGHLIGHTED,
        PressedTexture = ButtonTextures.ARROWS.LEFT_TALL.PRESSED,
    },
    RightTall = {
        IdleTexture = ButtonTextures.ARROWS.RIGHT_TALL.IDLE,
        HighlightedTexture = ButtonTextures.ARROWS.RIGHT_TALL.HIGHLIGHTED,
        PressedTexture = ButtonTextures.ARROWS.RIGHT_TALL.PRESSED,
    },
    EditGreen = {
        IdleTexture = ButtonTextures.EDIT.GREEN.IDLE,
        HighlightedTexture = ButtonTextures.EDIT.GREEN.HIGHLIGHTED,
        PressedTexture = ButtonTextures.EDIT.GREEN.PRESSED,
    },
    SaveGreen = {
        IdleTexture = ButtonTextures.SAVE.GREEN.IDLE,
        HighlightedTexture = ButtonTextures.SAVE.GREEN.HIGHLIGHTED,
        PressedTexture = ButtonTextures.SAVE.GREEN.PRESSED,
    },
    Blue = {
        IdleTexture = ButtonTextures.BLUE.IDLE,
        HighlightedTexture = ButtonTextures.BLUE.HIGHLIGHTED,
        PressedTexture = ButtonTextures.BLUE.PRESSED,
        DisabledTexture = ButtonTextures.BLUE.DISABLED,
    },
    GreenMedium = {
        IdleTexture = ButtonTextures.GREEN.MEDIUM.IDLE,
        HighlightedTexture = ButtonTextures.GREEN.MEDIUM.HIGHLIGHTED,
        PressedTexture = ButtonTextures.GREEN.MEDIUM.PRESSED,
        DisabledTexture = ButtonTextures.GREEN.MEDIUM.DISABLED,
    },
    Close = {
        IdleTexture = ButtonTextures.CLOSE.IDLE,
        HighlightedTexture = ButtonTextures.CLOSE.HIGHLIGHTED,
        PressedTexture = ButtonTextures.CLOSE.PRESSED,
    },
    CloseGreen = {
        IdleTexture = ButtonTextures.CLOSE_GREEN.IDLE,
        HighlightedTexture = ButtonTextures.CLOSE_GREEN.HIGHLIGHTED,
        PressedTexture = ButtonTextures.CLOSE_GREEN.PRESSED,
    },
    LargeBrown = {
        IdleTexture = ButtonTextures.BROWN.LARGE.IDLE,
        HighlightedTexture = ButtonTextures.BROWN.LARGE.HIGHLIGHTED,
        PressedTexture = ButtonTextures.BROWN.LARGE.PRESSED,
    },
    SmallBrown = {
        IdleTexture = ButtonTextures.BROWN.SMALL.IDLE,
        HighlightedTexture = ButtonTextures.BROWN.SMALL.HIGHLIGHTED,
        PressedTexture = ButtonTextures.BROWN.SMALL.PRESSED,
        DisabledTexture = ButtonTextures.BROWN.SMALL.DISABLED,
    },
    DOS1DecrementLarge = {
        IdleTexture = ButtonTextures.COUNTER.DOS1.DECREMENT.IDLE,
        HighlightedTexture = ButtonTextures.COUNTER.DOS1.DECREMENT.HIGHLIGHTED,
        PressedTexture = ButtonTextures.COUNTER.DOS1.DECREMENT.PRESSED,
    },
    DOS1IncrementLarge = {
        IdleTexture = ButtonTextures.COUNTER.DOS1.INCREMENT.IDLE,
        HighlightedTexture = ButtonTextures.COUNTER.DOS1.INCREMENT.HIGHLIGHTED,
        PressedTexture = ButtonTextures.COUNTER.DOS1.INCREMENT.PRESSED,
    },
    LargeNotch = {
        IdleTexture = ButtonTextures.NOTCHES.LARGE.IDLE,
        HighlightedTexture = ButtonTextures.NOTCHES.LARGE.HIGHLIGHTED,
    },
    Notch = {
        IdleTexture = ButtonTextures.NOTCHES.SMALL.IDLE,
        HighlightedTexture = ButtonTextures.NOTCHES.SMALL.HIGHLIGHTED,
        PressedTexture = ButtonTextures.NOTCHES.SMALL.PRESSED,
    },
    Transparent = {
        IdleTexture = ButtonTextures.TRANSPARENT.IDLE,
        HighlightedTexture = ButtonTextures.TRANSPARENT.HIGHLIGHTED,
        PressedTexture = ButtonTextures.TRANSPARENT.PRESSED,
    },
    LargeRed = {
        IdleTexture = ButtonTextures.RED.LARGE.IDLE,
        HighlightedTexture = ButtonTextures.RED.LARGE.HIGHLIGHTED,
        PressedTexture = ButtonTextures.RED.LARGE.PRESSED,
    },
    SmallRed = {
        IdleTexture = ButtonTextures.RED.SMALL.IDLE,
        HighlightedTexture = ButtonTextures.RED.SMALL.HIGHLIGHTED,
        PressedTexture = ButtonTextures.RED.SMALL.PRESSED,
    },
    SquareStone = {
        IdleTexture = ButtonTextures.SQUARE.STONE.IDLE,
        HighlightedTexture = ButtonTextures.SQUARE.STONE.HIGHLIGHTED,
        PressedTexture = ButtonTextures.SQUARE.STONE.PRESSED,
        DisabledTexture = ButtonTextures.SQUARE.STONE.DISABLED,
    },

    -- State Buttons
    SimpleCheckbox = {
        IdleTexture = StateButtonTextures.CHECKBOXES.SIMPLE.BACKGROUND,
        HighlightedTexture = StateButtonTextures.CHECKBOXES.SIMPLE.BACKGROUND_HIGHLIGHTED,
        ActiveOverlay = StateButtonTextures.CHECKBOXES.SIMPLE.CHECKMARK,
        HighlightedActiveOverlay = StateButtonTextures.CHECKBOXES.SIMPLE.CHECKMARK_HIGHLIGHTED,
    },
    RoundCheckbox = {
        IdleTexture = StateButtonTextures.CHECKBOXES.ROUND.BACKGROUND,
        ActiveOverlay = StateButtonTextures.CHECKBOXES.ROUND.CHECKMARK,
    },
}

for id,style in pairs(styles) do
    Button:RegisterStyle(id, style)
end