
---------------------------------------------
-- Script for timers.
---------------------------------------------

---@class TimerLib : Feature
Timer = {
    UI = nil,
    Root = nil,

    eventHandlers = {},

    ---@type TimerLib_Entry[]
    activeTimers = {},
    previousTime = nil,

    USE_LEGACY_EVENTS = false,
    USE_LEGACY_HOOKS = false,

    Events = {
        TimerCompleted = {}, ---@type SubscribableEvent<TimerLib_Event_TimerCompleted>
    },
}
Epip.InitializeLibrary("Timer", Timer)
Timer:Debug()

---------------------------------------------
-- EVENTS/HOOKS
---------------------------------------------

---@class TimerLib_Event_TimerCompleted
---@field Timer TimerLib_Entry

---------------------------------------------
-- TIMER ENTRY
---------------------------------------------

---@class TimerLib_Entry
---@field ID string?
---@field DurationLeft number
---@field InitiialDuration number
---@field RepeatCount integer How many times the timer has repeated.
---@field Paused boolean
local _TimerEntry = {
    MaxRepeatCount = 1,
    RepeatCount = 0,
    ID = "",
}

function _TimerEntry:Pause()
    self.Paused = true
end

function _TimerEntry:Resume()
    self.Paused = false
end

function _TimerEntry:Cancel()
    Timer.Remove(self) 
end

---@param repeats integer
function _TimerEntry:SetRepeatCount(repeats)
    self.MaxRepeatCount = repeats
end


---@param fun fun(ev:TimerLib_Event_TimerCompleted)
function _TimerEntry:Subscribe(fun)
    Timer.Events.TimerCompleted:Subscribe(function(ev)
        if ev.Timer == self then
            fun(ev)
        end
    end)
end

---------------------------------------------
-- METHODS
---------------------------------------------

---@overload fun(seconds:number, handler?:fun(ev:TimerLib_Event_TimerCompleted), id?:string)
---@param id string?
---@param seconds number
---@param handler fun(ev:TimerLib_Event_TimerCompleted)
---@return TimerLib_Entry
function Timer.Start(id, seconds, handler)
    -- Overload
    if type(id) ~= "string" then
        seconds = id
        ---@diagnostic disable-next-line: cast-local-type
        id = handler
        handler = seconds
    end

    seconds = seconds or 0.001

    ---@type TimerLib_Entry
    local entry = {
        ID = id,
        InitialDuration = seconds,
        DurationLeft = seconds,
        MaxRepeatCount = 1,
        RepeatCount = 0,
    }
    Inherit(entry, _TimerEntry)

    -- Auto-subscribe handler
    if handler then
        entry:Subscribe(handler)
    end

    table.insert(Timer.activeTimers, entry)

    return entry
end

---@param timer TimerLib_Entry
function Timer.Remove(timer)
    local index

    for i,entry in ipairs(Timer.activeTimers) do
        if entry == timer then
            index = i
            break
        end
    end

    if index then
        table.remove(Timer.activeTimers, index)
    else
        Timer:LogError("Failed to remove timer")
        Timer:Dump(timer)
    end
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Decrement timer durations.
Ext.Events.Tick:Subscribe(function()
    local time = Ext.MonotonicTime()
    if not Timer.previousTime then
        Timer.previousTime = time
        return nil
    end

    local deltaTime = time - Timer.previousTime

    for _,timer in ipairs(Timer.activeTimers) do
        if not timer.Paused then
            timer.DurationLeft = timer.DurationLeft - (deltaTime / 1000)
    
            if timer.DurationLeft <= 0 then
    
                Timer.Events.TimerCompleted:Throw({
                    Timer = timer,
                })
    
                Utilities.Hooks.FireEvent("Timer", "TimerComplete_" .. timer.ID)
    
                Timer:DebugLog("Timer finished: " .. timer.ID)
    
                timer.RepeatCount = timer.RepeatCount + 1
                timer.DurationLeft = timer.InitiialDuration
            end
        end
    end

    -- Remove timers once their deplete their repeats
    for i=#Timer.activeTimers,1,-1 do
        local timer = Timer.activeTimers[i]

        if timer.RepeatCount >= timer.MaxRepeatCount then
            Timer.Remove(timer)
        end
    end

    Timer.previousTime = time
end)