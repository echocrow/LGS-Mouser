-- Package directory (set on init).
DIR = ""

--[[
  G HUB API.
]]

LGS_API = {
  outputLogMessage = OutputLogMessage,
  playMacro = function(macroName) return PlayMacro(macroName) end,
  abortMacro = function() return AbortMacro() end,
  pressKey = PressKey,
  releaseKey = ReleaseKey,
  pressAndReleaseKey = PressAndReleaseKey,
  getNow = GetRunningTime,
  getCursorPosition = GetMousePosition,
  sleep = Sleep,
  isMouseButtonPressed = IsMouseButtonPressed,
}

--[[
  Submodules.
]]

-- Load a submodule file.
function loadSubmodule(submoduleName)
  -- "require" is not available. Instead, load submodules via "dofile()".
  return dofile(DIR .. "/" .. submoduleName .. ".lua")
end

--[[
  Utils.
]]

utils = {}

function utils.getCurrentTimeCoords()
  local time = LGS_API.getNow()
  local posX, posY = LGS_API.getCursorPosition()
  return TimeCoord:new(time, posX, posY)
end

function utils.isButtonPressed(id)
  return LGS_API.isMouseButtonPressed(id)
end

--[[
  Debug.
]]

function utils.logMessage(...)
  if ENABLE_DEBUG then
    LGS_API.outputLogMessage(...)
    LGS_API.outputLogMessage("\n")
  end
end

--[[
  Config.
]]

-- Mouse for correct button layout.
MOUSE = 'G903'

-- Button layouts for different mice.
BUTTON_LAYOUTS = {
  G903 = {
    MEDIA = 4,
    WINDOW = 5,
    CLOSE = 7,
    VOL_DOWN = 8,
    VOL_UP = 9,
    SCROLL_LEFT = 10,
    SCROLL_RIGHT = 11,
  },
}

-- Buttons config (set on init).
BUTTONS_CONFIG = {}

-- Enable Debug.
ENABLE_DEBUG = true

--[[
  Module interface.
]]

module = {}

function module.init(dir)
  DIR = dir

  loadSubmodule("helpers/polyfills")
  helpers = loadSubmodule("helpers/helpers")

  ProfileController = loadSubmodule("components/ProfileController")
  Button = loadSubmodule("components/Button")
  ButtonGesture = loadSubmodule("components/ButtonGesture")
  TimeCoord = loadSubmodule("components/TimeCoord")
  ButtonPress = loadSubmodule("components/ButtonPress")
  actions = loadSubmodule("helpers/actions")

  BUTTONS_CONFIG = {
    WINDOW = {
      gestures = {
        swipeUp = actions.ui.showWindows,
        swipeDown = actions.ui.showAppInstances,
        swipeLeft = actions.ui.goToPrevDesktop,
        swipeRight = actions.ui.goToNextDesktop,
        double = actions.ui.showDesktop,
        long = actions.ui.showDashboard,
      },
    },
    MEDIA = {
      gestures = {
        swipeUp = actions.media.openMediaPlayer,
        swipeLeft = actions.media.playPrevTrack,
        swipeRight = actions.media.playNextTrack,
        tap = actions.media.togglePlayPause,
      },
    },
    CLOSE = {
      gestures = {
        tap = actions.ui.closeTab,
        long = actions.ui.closeApp,
      },
      featureGestures = {
        hideclose = {
          tap = actions.ui.hideWindow,
        },
        noclose = {
          tap = actions.none,
        },
      },
    },
  }
end

function module.buildController(profileName, profileFeatures)
  -- Build buttons config for the given profile.
  local buttons = {}
  for buttonName, buttonConfig in pairs(BUTTONS_CONFIG) do
    local id = BUTTON_LAYOUTS[MOUSE][buttonName]
    local gestures = helpers.copy(buttonConfig.gestures or {})
    -- Extend gestures.
    if buttonConfig.featureGestures then
      for _, featureName in pairs(profileFeatures) do
        if buttonConfig.featureGestures[featureName] then
          gestures = helpers.merge(gestures, buttonConfig.featureGestures[featureName])
        end
      end
    end
    buttons[id] = Button:new(id, buttonName, gestures)
  end

  utils.logMessage("CONTROLLER_ENABLED :: %s", profileName)
  return ProfileController:new(profileName, buttons)
end

function module.handleLGSEvent(controller, eventName, payload)
  utils.logMessage("EVENT :: %s // PAYLOAD :: %s", eventName, payload)
  local timeCoord = utils.getCurrentTimeCoords()

  if eventName == "MOUSE_BUTTON_PRESSED" then
    return controller:handlePressStart(payload, timeCoord)
  end

  if eventName == "MOUSE_BUTTON_RELEASED" then
    return controller:handlePressEnd(payload, timeCoord)
  end
end

return module
