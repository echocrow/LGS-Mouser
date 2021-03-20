ProfileController = {
  name = "main",
  buttons = {},
}

function ProfileController:new(name, buttons)
  local mc = {}
  mc.name = name or self.name
  mc.buttons = buttons or self.buttons
  self.__index = self
  return setmetatable(mc, ProfileController)
end

function ProfileController:hasButton(btn)
  return self.buttons[btn] ~= nil
end

function ProfileController:handlePressStart(btn, timeCoord)
  if self:hasButton(btn) then
    local button = self.buttons[btn]
    button:handlePressStart(timeCoord)
  end
end

function ProfileController:handlePressEnd(btn, timeCoord)
  if self:hasButton(btn) then
    local button = self.buttons[btn]
    button:handlePressEnd(timeCoord)
  end
end

return ProfileController
