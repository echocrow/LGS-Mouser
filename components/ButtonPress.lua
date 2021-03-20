ButtonPress = {
  startTC = nil,
  currentTC = nil,
  endTC = nil,
}

function ButtonPress:new(timeCoord)
  local mp = {}
  self.__index = self
  mp = setmetatable(mp, ButtonPress)
  if timeCoord then
    mp:handleStart(timeCoord)
  end
  return mp
end

function ButtonPress:handleStart(timeCoord)
  self.startTC = timeCoord
  self:handleCont(timeCoord)
  self.endTC = nil
end

function ButtonPress:handleCont(timeCoord)
  self.currentTC = timeCoord
end

function ButtonPress:handleEnd(timeCoord)
  self:handleCont(timeCoord)
  self.endTC = timeCoord
end

function ButtonPress:isActive()
  return self:hasStarted() and (not self.endTC)
end

function ButtonPress:hasStarted()
  return not not self.startTC
end

function ButtonPress:hasEnded()
  return self:hasStarted() and (not not self.endTC)
end

function ButtonPress:calcPressDuration()
  if not self:hasStarted() then
    return nil
  end
  return self.currentTC:timeDelta(self.startTC)
end

function ButtonPress:calcMoveDelta()
  if not self:hasStarted() then
    return nil, nil, nil, nil
  end
  return self.currentTC:moveDelta(self.startTC)
end

return ButtonPress
