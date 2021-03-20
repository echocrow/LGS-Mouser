ButtonGesture = {
  name = "Unnamed Button Gesture",
  handler = nil,
  -- repeats = false,
  -- cooldown = 0,
  -- isValid = false, -- Autoset.
  -- lastFired = 0, -- Autoset.
}

BUTTON_GESTURES_TYPES = {
  pressStart = true,
  pressEnd = true,
  tap = true,
  long = true,
  double = true,
  swipeUp = true,
  swipeDown = true,
  swipeLeft = true,
  swipeRight = true,
}

function ButtonGesture:new(gestureOptions)
  local bg = gestureOptions or {}
  bg.isValid = (
    BUTTON_GESTURES_TYPES[bg.name] == true and
    type(bg.handler) == "function"
  )
  self.__index = self
  return setmetatable(bg, ButtonGesture)
end

function ButtonGesture:fire(currentPress)
  if not self.isValid then return false end
  self.handler(currentPress)
  return true
end

return ButtonGesture
