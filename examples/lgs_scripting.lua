-- Load Mouser module.
MOUSER_DIR = "/path/to/mouser"
MOUSER_MOD = dofile(MOUSER_DIR .. "/mouser.lua")

-- Init Mouser module.
MOUSER_MOD.init(MOUSER_DIR)

-- Config: Name identifier of this profile.
PROFILE_NAME = "main"
PROFILE_FEATURES = {}

-- Build Mouser.
mouser = MOUSER_MOD.buildController(PROFILE_NAME, PROFILE_FEATURES)

-- Primary event handler.
function OnEvent(eventName, payload)
  MOUSER_MOD.handleLGSEvent(mouser, eventName, payload)
end
