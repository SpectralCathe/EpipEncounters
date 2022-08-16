
---@class LoadingScreenUI : UI
local Loading = {
    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Events = {
        ProgressChanged = {}, ---@type SubscribableEvent<LoadingScreenUI_Event_ProgressChanged>
    },
    Hooks = {
        GetHintText = {}, ---@type SubscribableEvent<LoadingScreenUI_Hook_GetHintText>
    }
}
Client.UI.LoadingScreen = Loading
Epip.InitializeUI(23, "LoadingScreen", Loading)

---------------------------------------------
-- EVENTS
---------------------------------------------

---Fired when the progress bar is updated.
---@class LoadingScreenUI_Event_ProgressChanged
---@field Progress number As a fraction (0.0 - 1.0)

---Fires when the engine sets the hint text.
---@class LoadingScreenUI_Hook_GetHintText
---@field Hint string Hookable.

---------------------------------------------
-- METHODS
---------------------------------------------

---Sets the subtitle hint, below the name of the level being loaded.
---@param text string
function Loading.SetHintText(text)
    local root = Loading:GetRoot()

    root.setInfoText(text)
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

Loading:RegisterInvokeListener("setBar1Progress", function(_, value)
    Loading.Events.ProgressChanged:Throw({
        Progress = value,
    })
end)

Loading:RegisterInvokeListener("setInfoText", function(ev, text)
    local hook = {Hint = text} ---@type LoadingScreenUI_Hook_GetHintText

    Loading.Hooks.GetHintText:Throw(hook)

    -- Arg replacement does not seem to work for invokes.
    ev.UI:GetRoot().setInfoText(hook.Hint)
    ev:PreventAction()
end, "Before")