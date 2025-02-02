-- KeyHandler class
local KeyHandler = {}
KeyHandler.__index = KeyHandler

function KeyHandler:new()
    local obj = setmetatable({}, self)
    obj.keyMappings = {}
    return obj
end

function KeyHandler:registerKey(key, action)
    self.keyMappings[key] = action
end

function KeyHandler:handleKey(key)
    if self.keyMappings[key] then
        self.keyMappings[key]()
    end
end

return KeyHandler  