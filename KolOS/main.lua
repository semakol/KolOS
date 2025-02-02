package.path = package.path .. ";KolOS/?.lua"

local GUI = {}
GUI.__index = GUI

local Button = require("components.Button")
local Input = require("components.Input")
local Label = require("components.Label")
local KeyHandler = require("components.KeyHandler")
local Textarea = require("components.Textarea")
local Rect = require("components.Rect")
local Dropdown = require("components.Dropdown")
local Switch = require("components.Switch")
local Line = require("components.Line")

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

function GUI:addDropdown(x, y, width, items, bgColor, textColor)
    local dropdown = Dropdown:new(x, y, width, items, bgColor, textColor)
    dropdown.gui = self
    table.insert(self.components, dropdown)
    return dropdown
end

function GUI:addSwitch(x, y, state, callback, bgColor)
    local switch = Switch:new(x, y, state, callback, bgColor)
    switch.gui = self
    table.insert(self.components, switch)
    return switch
end

function GUI:addLine(x1, y1, x2, y2, color, bgColor, char)
    local line = Line:new(x1, y1, x2, y2, color, bgColor, char)
    line.gui = self
    table.insert(self.components, line)
    return line
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
        if getmetatable(comp) == Label then
            comp:draw(win)
        elseif getmetatable(comp) == Button then
            comp:draw(win)
        elseif getmetatable(comp) == Input then
            comp:draw(win)
        elseif getmetatable(comp) == Textarea then
            comp:draw(win)
        elseif getmetatable(comp) == Rect then
            comp:draw(win)
        elseif getmetatable(comp) == Dropdown then
            comp:draw(win)
        elseif getmetatable(comp) == Switch then
            comp:draw(win)
        elseif getmetatable(comp) == Line then
            comp:draw(win)
        end
    end
    win.redraw()
end

function GUI:handleClick(x, y)
    for _, comp in ipairs(self.components) do
        if getmetatable(comp) == Dropdown and comp:isExpanded() then
            comp:handleClick(x, y)
            return
        end
    end
    for _, comp in ipairs(self.components) do
        if getmetatable(comp) == Button then
            comp:handleClick(x, y)
        elseif getmetatable(comp) == Input then
            comp:handleClick(x, y)
        elseif getmetatable(comp) == Dropdown then
            comp:handleClick(x, y)
        elseif getmetatable(comp) == Switch then
            comp:handleClick(x, y)
        end
    end
end

function GUI:handleKey(key)
    for _, comp in ipairs(self.components) do
        if getmetatable(comp) == Input and comp.active then
            return
        elseif getmetatable(comp) == Dropdown and comp.expanded then
            comp:handleKey(key)
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
            if getmetatable(comp) == Dropdown and comp.expanded then
                comp:handleScroll(param1)
            elseif getmetatable(comp) == Textarea and comp:isMouseOver(param2, param3) then
                if param1 == 0 then
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
