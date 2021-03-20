Button = {
  id = 0,
  name = "No Name",
  gestures = {},
  currentPress = nil,
  prevPress = nil,
}

BUTTON_LISTEN_DELAY = 20
BUTTON_LISTEN_MAX = 2000

function Button:new(id, name, gestures)
  local btn = {}
  btn.id = id or self.id
  btn.name = name or self.name
  btn.gestures = {}
  -- Set gestures.
  for gestureName, gestureEntry in pairs(gestures) do
    local gestureOptions = {
      name = gestureName,
    }
    if type(gestureEntry) == "function" then
      gestureOptions.handler = gestureEntry
    elseif type(gestureEntry) == "table" then
      gestureOptions = helpers.merge(gestureOptions, gestureEntry)
    end
    local gesture = ButtonGesture:new(gestureOptions)
    if gesture.isValid then
      btn.gestures[gestureName] = gesture
    else
      utils.logMessage("Invalid Gesture setup detected for \"%s\" of button \"%s\".", gestureName, btn.name)
    end
  end
  self.__index = self
  return setmetatable(btn, Button)
end

function Button:handlePressStart(timeCoord)
  if self.currentPress then return false end

  self.currentPress = ButtonPress:new(timeCoord)
  self:invokeGesture("pressStart")
  -- self:listenToPress()
  return true
end

-- function Button:listenToPress()
--   if not self.currentPress then return false end

--   local currentPress = self.currentPress
--   repeat
--     -- Sleep.
--     LGS_API.sleep(BUTTON_LISTEN_DELAY)
--     -- Get state.
--     local timeCoord = utils.getCurrentTimeCoords()
--     local isStillPressed = utils.isButtonPressed(self.id)
--     -- Update press.
--     if isStillPressed then
--       self:handlePressCont(timeCoord)
--     else
--       self:handlePressEnd(timeCoord)
--     end
--     local listenDuration = currentPress:calcPressDuration()
--     local conitnueListening = isStillPressed and notlistenDuration < BUTTON_LISTEN_MAX
--   until not conitnueListening
--   return true
-- end

-- function Button:handlePressCont(timeCoord)
--   if self.currentPress then return false end

--   local currentPress = self.currentPress
--   self.currentPress:handleCont(timeCoord)
--   self:invokeGesture("pressCont")
--   return true
-- end

function Button:handlePressEnd(timeCoord)
  if not self.currentPress then return false end

  self.currentPress:handleEnd(timeCoord)
  self:invokeGesture("pressEnd")

  local currentPress = self.currentPress
  local prevPress = self.prevPress

  local pressDuration = currentPress:calcPressDuration()
  local moveX, moveY, moveDistance, moveAngle = currentPress:calcMoveDelta()
  -- utils.logMessage("PRESS_DURATION: %sms", pressDuration)
  -- utils.logMessage("MOVE_DELTA: %s x %s", moveX, moveY)
  -- utils.logMessage("MOVE_DISTANCE: %s", moveDistance)
  -- utils.logMessage("MOVE_ANGLE: %s", moveAngle)

  local pressPause = currentPress.startTC.time - (prevPress and prevPress.endTC.time or 0)
  -- utils.logMessage("PRESS_PAUSE: %sms", pressPause)

  -- Detect swipes.
  if moveDistance > 50 then
    -- Determine swipe direction.
    local moveDirection = moveAngle / math.pi
    if math.abs(moveDirection) <= .25 then
      self:invokeGesture("swipeUp")
    elseif math.abs(moveDirection) >= .75 then
      self:invokeGesture("swipeDown")
    elseif moveDirection < 0 then
      self:invokeGesture("swipeLeft")
    else
      self:invokeGesture("swipeRight")
    end
  -- Detect double-presses.
  elseif pressPause <= 300 then
    local doubleInvoked = self:invokeGesture("double")
    if not doubleInvoked then self:invokeGesture("tap") end
  -- Detect long-presses.
  elseif pressDuration > 300 then
    self:invokeGesture("long")
  -- Fallback to tap.
  else
    self:invokeGesture("tap")
  end

  self.prevPress = self.currentPress
  self.currentPress = nil

  return true
end

function Button:invokeGesture(gestureName)
  if not self.gestures[gestureName] then return false end

  local currentPress = self.currentPress
  local gesture = self.gestures[gestureName]
  return gesture:fire(currentPress)
end

return Button
