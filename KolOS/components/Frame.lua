local Frame = {}
Frame.__index = Frame

package.path = package.path .. ";KolOS/components/?.lua"

local Button = require("Button")
local Input = require("Input")
local Label = require("Label")
local KeyHandler = require("KeyHandler")
local Textarea = require("Textarea")
local Rect = require("Rect")
local Dropdown = require("Dropdown")
local Switch = require("Switch")
local Line = require("Line")
local Circle = require("Circle")

-- Frame class
function Frame:new(x, y, width, height, parent)
    local termWidth, termHeight = term.getSize()
    x = x or 1
    y = y or 1
    width = width or termWidth
    height = height or termHeight
    local obj = setmetatable({}, self)
    obj.win = window.create(parent or term.current(), x, y, width, height)
    obj.components = {}
    obj.keyHandler = KeyHandler:new()
    obj.canvas = {}
    for i = 1, height do
        obj.canvas[i] = {}
        for j = 1, width do
            obj.canvas[i][j] = {bgColor = colors.black, char = " ", charColor = colors.white}
        end
    end
    return obj
end

function Frame:addLabel(x, y, text, textColor)
    local label = Label:new(x, y, text, textColor)
    label.frame = self
    table.insert(self.components, label)
    return label
end

function Frame:addButton(x, y, label, callback, bgColor, textColor, width, height)
    local button = Button:new(x, y, label, callback, bgColor, textColor, width, height)
    button.frame = self
    table.insert(self.components, button)
    return button
end

function Frame:addInput(x, y, width, maxLength, bgColor, textColor, replaceChar, history, completeFn, default, callback, deactivateOnEnter)
    local input = Input:new(x, y, width, maxLength, bgColor, textColor, replaceChar, history, completeFn, default, callback, deactivateOnEnter)
    input.frame = self
    table.insert(self.components, input)
    return input
end

function Frame:addTextarea(x, y, width, height, bgColor, textColor)
    local textarea = Textarea:new(x, y, width, height, bgColor, textColor)
    textarea.frame = self
    table.insert(self.components, textarea)
    return textarea
end

function Frame:addRect(x, y, width, height, bgColor, fill, char, charColor)
    local rect = Rect:new(x, y, width, height, bgColor, fill, char, charColor)
    rect.frame = self
    table.insert(self.components, rect)
    return rect
end

function Frame:addDropdown(x, y, width, items, bgColor, textColor)
    local dropdown = Dropdown:new(x, y, width, items, bgColor, textColor)
    dropdown.frame = self
    table.insert(self.components, dropdown)
    return dropdown
end

function Frame:addSwitch(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)
    local switch = Switch:new(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)
    switch.frame = self
    table.insert(self.components, switch)
    return switch
end

function Frame:addLine(x1, y1, x2, y2, color, bgColor, char)
    local line = Line:new(x1, y1, x2, y2, color, bgColor, char)
    line.frame = self
    table.insert(self.components, line)
    return line
end

function Frame:addCircle(x1, y1, x2, y2, color, fill, char, charColor)
    local circle = Circle:new(x1, y1, x2, y2, color, fill, char, charColor)
    circle.frame = self
    table.insert(self.components, circle)
    return circle
end

function Frame:addKeyHandler()
    return self.keyHandler
end

function Frame:draw()
    local win = self.win
    -- Clear the canvas
    for y, row in ipairs(self.canvas) do
        for x, _ in ipairs(row) do
            self.canvas[y][x] = {bgColor = colors.black, char = " ", charColor = colors.white}
        end
    end
    -- Draw components
    for _, comp in ipairs(self.components) do
        if comp.draw then
            comp:draw(self.canvas)
        end
    end    
    -- Render canvas to window
    for y, row in ipairs(self.canvas) do
        for x, pixel in ipairs(row) do
            win.setCursorPos(x, y)
            win.setBackgroundColor(pixel.bgColor)
            win.setTextColor(pixel.charColor)
            win.write(pixel.char)
        end
    end
    win.redraw()
end

function Frame:handleClick(x, y)
    for _, comp in ipairs(self.components) do
        if getmetatable(comp) == Dropdown and comp:isExpanded() then
            comp:handleClick(x, y)
            return
        end
    end
    for _, comp in ipairs(self.components) do
        if comp.handleClick then
            comp:handleClick(x, y)
        end
    end
end

function Frame:handleKey(key)
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

function Frame:update(event, param1, param2, param3)
    if event == "mouse_click" then
        self:handleClick(param2, param3)
    elseif event == "key" or event == "char" then
        self:handleKey(param1)
        for _, comp in ipairs(self.components) do
            if comp.handleInput then
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

return Frame
