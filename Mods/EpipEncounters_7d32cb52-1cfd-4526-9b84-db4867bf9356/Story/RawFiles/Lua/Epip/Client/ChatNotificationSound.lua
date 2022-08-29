
local Chat = Client.UI.ChatLog

---@class Feature_ChatNotificationSound
local Sound = {
    -- Indexes correspond to dropdown setting.
    SOUNDS = {
        "UI_Gen_BigButton_Click",
        "UI_Game_Craft_Click",
        "Synth_440tone_200ms",
    },
    SETTING_ID = "Chat_MessageSound",
    USER_MESSAGE_PATTERN = "^<font size=16 color=#bbbbbb>.+:</font> <font size=16 color=#ffffff>.+</font>$"
}
Epip.RegisterFeature("ChatNotificationSound", Sound)

---------------------------------------------
-- METHODS
---------------------------------------------

---@param sound string? Defaults to using the setting.
function Sound.PlaySound(sound)
    if Sound:IsEnabled() then
        sound = sound or Sound.SOUNDS[Client.UI.OptionsSettings.GetOptionValue("EpipEncounters", Sound.SETTING_ID) - 1]
    
        Chat:PlaySound(sound)
    end
end

---@override
function Sound:IsEnabled()
    return Client.UI.OptionsSettings.GetOptionValue("EpipEncounters", Sound.SETTING_ID) > 1 and _Feature.IsEnabled(self)
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Play the sound when a chat message is received from another user.
Chat.Events.MessageAdded:Subscribe(function (ev)
    if not ev.IsFromClient and ev.Text:match(Sound.USER_MESSAGE_PATTERN) then
        Sound.PlaySound()
    end
end)