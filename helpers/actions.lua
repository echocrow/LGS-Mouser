-- Macro control: Build function that invokes macro.
function triggerMacro(macroTitle, keepRunning)
  LGS_API.abortMacro()
  LGS_API.playMacro(macroTitle)
  if not keepRunning then
    LGS_API.abortMacro()
  end
end

-- Key control: Build function that presses & release one or more keys
function tapKey(key)
  LGS_API.pressAndReleaseKey(unpack(arg))
end

-- Key control: Build function that presses & releases a combination of keys.
function tapKeyCombo(modifiers, ...)
  LGS_API.pressKey(unpack(modifiers))
  LGS_API.pressAndReleaseKey(unpack(arg))
  LGS_API.releaseKey(unpack(modifiers))
end

--[[
  Actions.
]]

actions = {
  none = function() --[[Do nothing.]] end,
  ui = {
    showWindows = function() tapKeyCombo({"lctrl"}, "up") end,
    showAppInstances = function() tapKeyCombo({"lctrl"}, "down") end,
    goToPrevDesktop = function() tapKeyCombo({"lctrl"}, "left") end,
    goToNextDesktop = function() tapKeyCombo({"lctrl"}, "right") end,
    showDesktop = function() tapKey("f11") end,
    showDashboard = function() tapKey("f12") end,
    closeTab = function() tapKeyCombo({"lgui"}, "w") end,
    closeApp = function() tapKeyCombo({"lgui"}, "q") end,
    hideWindow = function() tapKeyCombo({"lgui"}, "h") end,
  },
  media = {
    togglePlayPause = function() tapKey("f14") end,
    playPrevTrack = function() tapKey("f13") end,
    playNextTrack = function() tapKey("f15") end,
    openMediaPlayer = function() triggerMacro("Open Media Player") end,
  },
}

return actions
