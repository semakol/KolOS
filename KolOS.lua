local GUI = {}
GUI.__index = GUI

local Button = {}
Button.__index = Button

-- Button class
function Button:new(x, y, label, callback, bgColor, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.label = label
    obj.callback = callback or function() end
    obj.bgColor = bgColor or colors.gray
    obj.textColor = textColor or colors.white
    return obj
end

function Button:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Button:setSize(width)
    local winWidth, _ = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
end

function Button:addCallback(callback)
    self.callback = callback or function() end
end

function Button:draw(win)
    win.setCursorPos(self.x, self.y)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    win.write("[" .. self.label .. "]")
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
end

function Button:handleClick(mx, my)
    if mx >= self.x and mx < self.x + #self.label + 2 and my == self.y then
        self.callback()
    end
end

-- Input class
local Input = {}
Input.__index = Input

function Input:new(x, y, width, maxLength, bgColor, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.text = ""
    obj.active = false
    obj.cursorPos = 0
    obj.scrollOffset = 0
    obj.maxLength = maxLength or width  -- Add maxLength property
    obj.bgColor = bgColor or colors.white
    obj.textColor = textColor or colors.black
    return obj
end

function Input:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Input:setSize(width)
    local winWidth, _ = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
end

function Input:draw(win)
    win.setCursorPos(self.x, self.y)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    local displayText = self.text:sub(self.scrollOffset + 1, self.scrollOffset + self.width)
    win.write(displayText .. string.rep(" ", self.width - #displayText))
    if self.active then
        win.setCursorPos(self.x + self.cursorPos - self.scrollOffset, self.y)
        if self.cursorPos + 1 <= #self.text then
            win.setBackgroundColor(self.textColor)
            win.setTextColor(self.bgColor)
            win.write(self.text:sub(self.cursorPos+1, self.cursorPos+1))
        else
            win.write("_")
        end
    end
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
end

function Input:handleClick(mx, my)
    if mx >= self.x and mx < self.x + self.width and my == self.y then
        self.active = true
        self.cursorPos = math.min(mx - self.x + self.scrollOffset, #self.text)
    else
        self.active = false
    end
end

function Input:handleInput(event, param)
    if self.active and event == "char" then
        if #self.text < self.maxLength then
            self.text = self.text:sub(1, self.cursorPos) .. param .. self.text:sub(self.cursorPos + 1)
            self.cursorPos = self.cursorPos + 1
            if self.cursorPos > self.scrollOffset + self.width then
                self.scrollOffset = self.scrollOffset + 1
            end
        end
    elseif self.active and event == "key" then
        if param == keys.backspace then
            if self.cursorPos > 0 then
                self.text = self.text:sub(1, self.cursorPos - 1) .. self.text:sub(self.cursorPos + 1)
                self.cursorPos = self.cursorPos - 1
                if self.cursorPos < self.scrollOffset then
                    self.scrollOffset = self.scrollOffset - 1
                end
            end
        elseif param == keys.enter then
            self.active = false
        elseif param == keys.left then
            if self.cursorPos > 0 then
                self.cursorPos = self.cursorPos - 1
                if self.cursorPos < self.scrollOffset then
                    self.scrollOffset = self.scrollOffset - 1
                end
            end
        elseif param == keys.right then
            if self.cursorPos < #self.text then
                self.cursorPos = self.cursorPos + 1
                if self.cursorPos > self.scrollOffset + self.width then
                    self.scrollOffset = self.scrollOffset + 1
                end
            end
        end
    end
end

-- Label class
local Label = {}
Label.__index = Label

function Label:new(x, y, text, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.text = text
    obj.textColor = textColor or colors.white
    return obj
end

function Label:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Label:setSize(width)
    local winWidth, _ = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
end

function Label:draw(win)
    win.setCursorPos(self.x, self.y)
    win.setTextColor(self.textColor)
    win.write(self.text)
    win.setTextColor(colors.white)
end

function Label:setText(newText)
    self.text = newText
    if self.gui then
        self.gui:draw()
    end
end

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

-- Textarea class
local Textarea = {}
Textarea.__index = Textarea

function Textarea:new(x, y, width, height, bgColor, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.list = {}
    obj.textList = {}
    obj.active = false
    obj.bgColor = bgColor or colors.white
    obj.textColor = textColor or colors.black
    obj.scrollOffset = 0
    return obj
end

function Textarea:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Textarea:setSize(width, height)
    local winWidth, winHeight = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
    self.height = math.max(1, math.min(height, winHeight - self.y + 1))
    self:updateTextList()
end

function Textarea:draw(win)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    for i = 1, self.height do
        win.setCursorPos(self.x, self.y + i - 1)
        local line = self.textList[i + self.scrollOffset] or ""
        win.write(line .. string.rep(" ", self.width - #line))
    end
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
end

function Textarea:updateTextList()
    self.textList = {}
    for _, line in ipairs(self.list) do
        while #line > self.width do
            table.insert(self.textList, line:sub(1, self.width))
            line = line:sub(self.width + 1)
        end
        table.insert(self.textList, line)
    end
    self.scrollOffset = math.max(0, #self.textList - self.height)
end

function Textarea:setText(newText)
    self.list = {}
    for line in newText:gmatch("[^\r\n]+") do
        table.insert(self.list, line)
    end
    self:updateTextList()
    if self.gui then
        self.gui:draw()
    end
end

function Textarea:addLine(line)
    table.insert(self.list, line)
    self:updateTextList()
    if self.gui then
        self.gui:draw()
    end
end

function Textarea:scrollUp()
    if self.scrollOffset > 0 then
        self.scrollOffset = self.scrollOffset - 1
        if self.gui then
            self.gui:draw()
        end
    end
end

function Textarea:scrollDown()
    if self.scrollOffset < #self.textList - self.height then
        self.scrollOffset = self.scrollOffset + 1
        if self.gui then
            self.gui:draw()
        end
    end
end

function Textarea:isMouseOver(mx, my)
    return mx >= self.x and mx < self.x + self.width and my >= self.y and my < self.y + self.height
end

-- Rect class
local Rect = {}
Rect.__index = Rect

function Rect:new(x, y, width, height, bgColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.bgColor = bgColor or colors.gray
    return obj
end

function Rect:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Rect:setSize(width, height)
    local winWidth, winHeight = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
    self.height = math.max(1, math.min(height, winHeight - self.y + 1))
end

function Rect:draw(win)
    win.setBackgroundColor(self.bgColor)
    for i = 0, self.height - 1 do
        win.setCursorPos(self.x, self.y + i)
        win.write(string.rep(" ", self.width))
    end
    win.setBackgroundColor(colors.black)
end

-- GUI class
function GUI:new(x, y, width, height, parent)
    local termWidth, termHeight = term.getSize()
    x = x or 0
    y = y or 0
    width = width or termWidth
    height = height or termHeight
    local obj = setmetatable({}, self)
    obj.win = window.create(parent or term.current(), x, y, width, height)
    obj.components = {}
    obj.keyHandler = KeyHandler:new()
    return obj
end

function GUI:addLabel(x, y, text, textColor)
    local label = Label:new(x, y, text, textColor)
    label.gui = self
    table.insert(self.components, label)
    return label
end

function GUI:addButton(x, y, label, callback, bgColor, textColor)
    local button = Button:new(x, y, label, callback, bgColor, textColor)
    button.gui = self
    table.insert(self.components, button)
    return button
end

function GUI:addInput(x, y, width, maxLength, bgColor, textColor)
    local input = Input:new(x, y, width, maxLength, bgColor, textColor)
    input.gui = self
    table.insert(self.components, input)
    return input
end

function GUI:addTextarea(x, y, width, height, bgColor, textColor)
    local textarea = Textarea:new(x, y, width, height, bgColor, textColor)
    textarea.gui = self
    table.insert(self.components, textarea)
    return textarea
end

function GUI:addRect(x, y, width, height, bgColor)
    local rect = Rect:new(x, y, width, height, bgColor)
    rect.gui = self
    table.insert(self.components, rect)
    return rect
end

function GUI:addKeyHandler()
    return self.keyHandler
end

function GUI:draw()
    local win = self.win
    win.setBackgroundColor(colors.black)
    win.clear()
    win.setTextColor(colors.white)
    for _, comp in ipairs(self.components) do
        win.setCursorPos(comp.x, comp.y)
        if comp.type == "label" then
            win.write(comp.text)
        elseif getmetatable(comp) == Button then
            comp:draw(win)
        elseif getmetatable(comp) == Input then
            comp:draw(win)
        elseif getmetatable(comp) == Label then
            comp:draw(win)
        elseif getmetatable(comp) == Textarea then
            comp:draw(win)
        elseif getmetatable(comp) == Rect then
            comp:draw(win)
        end
    end
    win.redraw()
end

function GUI:handleClick(x, y)
    for _, comp in ipairs(self.components) do
        if getmetatable(comp) == Button then
            comp:handleClick(x, y)
        elseif getmetatable(comp) == Input then
            comp:handleClick(x, y)
        end
    end
end

function GUI:handleKey(key)
    for _, comp in ipairs(self.components) do
        if getmetatable(comp) == Input and comp.active then
            return
        end
    end
    self.keyHandler:handleKey(key)
end

function GUI:update(event, param1, param2, param3)
    if event == "mouse_click" then
        self:handleClick(param2, param3)
    elseif event == "key" or event == "char" then
        self:handleKey(param1)
        for _, comp in ipairs(self.components) do
            if getmetatable(comp) == Input then
                comp:handleInput(event, param1)
            elseif getmetatable(comp) == Textarea then
                if param1 == keys.up then
                    comp:scrollUp()
                elseif param1 == keys.down then
                    comp:scrollDown()
                end
            end
        end
    elseif event == "mouse_scroll" then
        for _, comp in ipairs(self.components) do
            if getmetatable(comp) == Textarea and comp:isMouseOver(param2, param3) then
                if param1 == -1 then
                    comp:scrollUp()
                elseif param1 == 1 then
                    comp:scrollDown()
                end
            end
        end
    end
    self:draw()
end

function GUI:run(...)
    local functions = {...}
    self:draw()
    parallel.waitForAny(
        function ()
            while true do
                local event, param1, param2, param3 = os.pullEvent()
                self:update(event, param1, param2, param3)
            end
        end,
        table.unpack(functions)
    )
end

return GUI
