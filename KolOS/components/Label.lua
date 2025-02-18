-- Label class
local Label = {}
Label.__index = Label

function Label:new(x, y, text, textColor, bgColor, zIndex)
    if type(x) == "table" then
        local params = x
        x = params.x
        y = params.y
        text = params.text
        textColor = params.textColor
        bgColor = params.bgColor
        zIndex = params.zIndex
    end
    local obj = setmetatable({}, self)
    obj.x = x or 1
    obj.y = y or 1
    obj.text = text or " "
    obj.textColor = textColor or colors.white
    obj.bgColor = bgColor or colors.black
    obj.zIndex = zIndex or 0
    return obj
end

function Label:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    self.frame.update = true
    return self
end

function Label:setText(newText)
    self.text = newText
    self.frame.update = true
    return self
end

function Label:setColors(textColor, bgColor)
    self.textColor = textColor or self.textColor
    self.bgColor = bgColor or self.bgColor
    self.frame.update = true
    return self
end

function Label:setZIndex(zIndex)
    self.zIndex = zIndex or self.zIndex
    self.frame.update = true
    return self
end

function Label:draw(canvas)
    for i = 1, #self.text do
        local x = self.x + i - 1
        local y = self.y
        if canvas[y] and canvas[y][x] then
            if self.bgColor ~= "alpha" then
                canvas[y][x].bgColor = self.bgColor
            end
            canvas[y][x].char = self.text:sub(i, i)
            canvas[y][x].charColor = self.textColor
        end
    end
end

function Label:setParams(params)
    if params.x then self.x = params.x end
    if params.y then self.y = params.y end
    if params.text then self.text = params.text end
    if params.textColor then self.textColor = params.textColor end
    if params.bgColor then self.bgColor = params.bgColor end
    if params.zIndex then self.zIndex = params.zIndex end
    self.frame.update = true
    return self
end

return Label