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
local Image = require("Image")

-- Frame class
function Frame:new(x, y, width, height, parent, name)
    local termWidth, termHeight = term.getSize()
    x = x or 1
    y = y or 1
    width = width or termWidth
    height = height or termHeight
    local obj = setmetatable({}, self)
    obj.win = parent or term.current()
    obj.name = name
    obj.components = {}
    obj.keyHandler = KeyHandler:new()
    obj.canvas = {}
    obj.visible = true
    for i = 1, height do
        obj.canvas[i] = {}
        for j = 1, width do
            obj.canvas[i][j] = { bgColor = colors.black, char = " ", charColor = colors.white }
        end
    end
    return obj
end

function Frame:setVisible(visible)
    self.visible = visible or true
end

function Frame:addLabel(x, y, text, textColor, zIndex)
    local label = Label:new(x, y, text, textColor, zIndex or #self.components)
    label.frame = self
    table.insert(self.components, label)
    return label
end

function Frame:addButton(x, y, label, callback, bgColor, textColor, width, height, zIndex)
    local button = Button:new(x, y, label, callback, bgColor, textColor, width, height, zIndex or #self.components)
    button.frame = self
    table.insert(self.components, button)
    return button
end

function Frame:addInput(x, y, width, maxLength, bgColor, textColor, replaceChar, history, completeFn, default, callback,
                        deactivateOnEnter, zIndex)
    local input = Input:new(x, y, width, maxLength, bgColor, textColor, replaceChar, history, completeFn, default,
        callback, deactivateOnEnter, zIndex or #self.components)
    input.frame = self
    table.insert(self.components, input)
    return input
end

function Frame:addTextarea(x, y, width, height, bgColor, textColor, zIndex)
    local textarea = Textarea:new(x, y, width, height, bgColor, textColor, zIndex or #self.components)
    textarea.frame = self
    table.insert(self.components, textarea)
    return textarea
end

function Frame:addRect(x, y, width, height, bgColor, fill, char, charColor, zIndex)
    local rect = Rect:new(x, y, width, height, bgColor, fill, char, charColor, zIndex or #self.components)
    rect.frame = self
    table.insert(self.components, rect)
    return rect
end

function Frame:addDropdown(x, y, width, items, bgColor, textColor, zIndex)
    local dropdown = Dropdown:new(x, y, width, items, bgColor, textColor, zIndex or #self.components)
    dropdown.frame = self
    table.insert(self.components, dropdown)
    return dropdown
end

function Frame:addSwitch(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor,
                         inactiveTextColor, zIndex)
    local switch = Switch:new(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor,
        activeTextColor, inactiveTextColor, zIndex or #self.components)
    switch.frame = self
    table.insert(self.components, switch)
    return switch
end

function Frame:addLine(x1, y1, x2, y2, color, bgColor, char, zIndex)
    local line = Line:new(x1, y1, x2, y2, color, bgColor, char, zIndex or #self.components)
    line.frame = self
    table.insert(self.components, line)
    return line
end

function Frame:addCircle(x1, y1, x2, y2, color, fill, char, charColor, zIndex)
    local circle = Circle:new(x1, y1, x2, y2, color, fill, char, charColor, zIndex or #self.components)
    circle.frame = self
    table.insert(self.components, circle)
    return circle
end

function Frame:addImage(x, y, filePath, zIndex)
    local image = Image:new(x, y, filePath, zIndex or #self.components)
    image.frame = self
    table.insert(self.components, image)
    return image
end

function Frame:addKeyHandler()
    return self.keyHandler
end

function Frame:draw()
    if not self.visible then return end
    local win = self.win
    -- Clear the canvas
    for y, row in ipairs(self.canvas) do
        for x, _ in ipairs(row) do
            self.canvas[y][x] = { bgColor = colors.black, char = " ", charColor = colors.white }
        end
    end

    -- Sort components by zIndex
    table.sort(self.components, function(a, b)
        return (a.zIndex or 0) < (b.zIndex or 0)
    end)

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
            if pixel.bgColor ~= "alpha" and pixel.bgColor then
                win.setBackgroundColor(pixel.bgColor)
            end
            if pixel.charColor then
                win.setTextColor(pixel.charColor)
            end
            if pixel.char then
                win.write(pixel.char)
            end
        end
    end
    -- win.redraw()
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
    if not self.visible then return end
    if self.name then
        if event == "monitor_touch" and self.name == param1 then
            self:handleClick(param2, param3)
        end
    else
        if event == "mouse_click" then
            self:handleClick(param2, param3)
        elseif event == "key" or event == "char" or event == "paste" then
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
    end
    self:draw()
end

return Frame
