TimeCoord = {
  time = nil,
  x = 0,
  y = 0,
}

function TimeCoord:new(time, x, y)
  local tc = {}
  tc.time = time
  tc.x = x
  tc.y = y
  self.__index = self
  return setmetatable(tc, TimeCoord)
end

function TimeCoord:timeDelta(tc)
  return self.time - tc.time
end

function TimeCoord:moveDelta(tc)
  local dx = self.x - tc.x
  local dy = self.y - tc.y
  local totalDistance = math.sqrt(dx^2 + dy^2)
  local angle = math.atan2(dx, dy)
  return dx, dy, totalDistance, angle
end

return TimeCoord
