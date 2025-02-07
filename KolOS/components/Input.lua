-- Input class
local Input = {}
Input.__index = Input

function Input:new(x, y, width, maxLength, bgColor, textColor, replaceChar, history, completeFn, default, callback, deactivateOnEnter, zIndex)
    if type(x) == "table" then
        local params = x
        x = params.x
        y = params.y
        width = params.width
        maxLength = params.maxLength
        bgColor = params.bgColor
        textColor = params.textColor
        replaceChar = params.replaceChar
        history = params.history
        completeFn = params.completeFn
        default = params.default
        callback = params.callback
        deactivateOnEnter = params.deactivateOnEnter
        zIndex = params.zIndex
    end
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.width = width or 10
    obj.text = default or ""
    obj.active = false
    obj.cursorPos = #obj.text
    obj.scrollOffset = 0
    obj.maxLength = maxLength or obj.width
    obj.bgColor = bgColor or colors.white
    obj.textColor = textColor or colors.black
    obj.replaceChar = replaceChar
    obj.history = history or {}
    obj.completeFn = completeFn
    obj.historyIndex = #obj.history + 1
    obj.completions = {}
    obj.completionIndex = 0
    obj.callback = callback
    obj.deactivateOnEnter = deactivateOnEnter ~= false
    obj.zIndex = zIndex or 0
    return obj
end

function Input:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    self.frame:draw()
    return self
end

function Input:setSize(width, maxLength)
    self.width = width or self.width
    self.maxLength = maxLength or self.maxLength
    self.frame:draw()
    return self
end

function Input:setColors(bgColor, textColor)
    self.bgColor = bgColor or self.bgColor
    self.textColor = textColor or self.textColor
    self.frame:draw()
    return self
end

function Input:setReplaceChar(replaceChar)
    self.replaceChar = replaceChar
    self.frame:draw()
    return self
end

function Input:setHistory(history)
    self.history = history or {}
    self.historyIndex = #self.history + 1
    self.frame:draw()
    return self
end

function Input:setCompleteFn(completeFn)
    self.completeFn = completeFn
    self.frame:draw()
    return self
end

function Input:setDefault(default)
    self.text = default or ""
    self.cursorPos = #self.text
    self.scrollOffset = 0
    self.frame:draw()
    return self
end

function Input:setCallback(callback)
    self.callback = callback
    self.frame:draw()
    return self
end

function Input:setDeactivateOnEnter(deactivateOnEnter)
    self.deactivateOnEnter = deactivateOnEnter
    self.frame:draw()
    return self
end

function Input:setZIndex(zIndex)
    self.zIndex = zIndex or self.zIndex
    self.frame:draw()
    return self
end

function Input:addHistory(item)
    table.insert(self.history, item)
    self.historyIndex = #self.history + 1
    self.frame:draw()
    return self
end

function Input:draw(canvas)
    for i = 1, self.width do
        local x = self.x + i - 1
        local y = self.y
        if canvas[y] and canvas[y][x] then
            if self.bgColor ~= "alpha" then
                canvas[y][x].bgColor = self.bgColor
            end
            local char = self.text:sub(self.scrollOffset + i, self.scrollOffset + i)
            if self.replaceChar then
                char = char ~= "" and self.replaceChar or " "
            end
            canvas[y][x].char = char ~= "" and char or " "
            canvas[y][x].charColor = self.textColor
        end
    end
    if self.active then
        local cursorX = self.x + self.cursorPos - self.scrollOffset
        if canvas[self.y] and canvas[self.y][cursorX] then
            canvas[self.y][cursorX].bgColor = self.textColor
            canvas[self.y][cursorX].charColor = self.bgColor
            local char = self.text:sub(self.cursorPos + 1, self.cursorPos + 1)
            if self.replaceChar then
                char = char ~= "" and self.replaceChar or "_"
            end
            canvas[self.y][cursorX].char = char ~= "" and char or "_"
        end
    end
    if self.active and #self.completions > 0 then
        local suggestion = self.completions[self.completionIndex]
        for i = 1, #suggestion do
            local x = self.x + self.cursorPos - self.scrollOffset + i
            if canvas[self.y + 1] and canvas[self.y + 1][x] then
                canvas[self.y + 1][x].bgColor = self.textColor
                canvas[self.y + 1][x].char = suggestion:sub(i, i)
                canvas[self.y + 1][x].charColor = self.bgColor
            end
        end
    end
end

function Input:handleClick(mx, my)
    if mx >= self.x and mx < self.x + self.width and my == self.y then
        self.active = true
        self.cursorPos = math.min(mx - self.x + self.scrollOffset, #self.text)
    else
        self.active = false
    end
end

function Input:updateCompletions()
    if self.completeFn then
        self.completions = self.completeFn(self.text:sub(1, self.cursorPos)) or {}
        self.completionIndex = 1
    else
        self.completions = {}
        self.completionIndex = 0
    end
end

function Input:handleInput(event, param)
    if self.active and event == "char" then
        self.historyIndex = #self.history + 1
        if #self.text < self.maxLength then
            self.text = self.text:sub(1, self.cursorPos) .. param .. self.text:sub(self.cursorPos + 1)
            self.cursorPos = self.cursorPos + 1
            if self.cursorPos > self.scrollOffset + self.width then
                self.scrollOffset = self.scrollOffset + 1
            end
        end
        self:updateCompletions()
    elseif self.active and event == "key" then
        if param == keys.backspace then
            self.historyIndex = #self.history + 1
            if self.cursorPos > 0 then
                self.text = self.text:sub(1, self.cursorPos - 1) .. self.text:sub(self.cursorPos + 1)
                self.cursorPos = self.cursorPos - 1
                if self.cursorPos < self.scrollOffset then
                    self.scrollOffset = self.scrollOffset - 1
                end
            end
            if #self.text == 0 then
                self.completions = {}
                self.completionIndex = 0
            else
                self:updateCompletions()
            end
        elseif param == keys.enter then
            if self.history[#self.history] ~= self.text then
                table.insert(self.history, self.text)
            end
            self.historyIndex = #self.history + 1
            if self.callback then
                self.callback(self.text)
            end
            self.text = ""
            self.cursorPos = 0
            if self.deactivateOnEnter then
                self.active = false
            end
            self:updateCompletions()
        elseif param == keys.left then
            if self.cursorPos > 0 then
                self.cursorPos = self.cursorPos - 1
                if self.cursorPos < self.scrollOffset then
                    self.scrollOffset = self.scrollOffset - 1
                end
                self:updateCompletions()
            end
        elseif param == keys.right then
            if self.cursorPos < #self.text then
                self.cursorPos = self.cursorPos + 1
                if self.cursorPos > self.scrollOffset + self.width then
                    self.scrollOffset = self.scrollOffset + 1
                end
                self:updateCompletions()
            end
        elseif param == keys.up then
            if #self.completions > 0 then
                self.completionIndex = (self.completionIndex - 2) % #self.completions + 1
            elseif self.history and self.historyIndex > 1 then
                self.historyIndex = self.historyIndex - 1
                self.text = self.history[self.historyIndex] or ""
                self.cursorPos = #self.text
                self.scrollOffset = math.max(0, self.cursorPos - self.width)
            end
        elseif param == keys.down then
            if #self.completions > 0 then
                self.completionIndex = self.completionIndex % #self.completions + 1
            elseif self.history and self.historyIndex < #self.history then
                self.historyIndex = self.historyIndex + 1
                self.text = self.history[self.historyIndex] or ""
                self.cursorPos = #self.text
                self.scrollOffset = math.max(0, self.cursorPos - self.width)
            end
        elseif param == keys.tab and #self.completions > 0 then
            local completion = self.completions[self.completionIndex]
            self.text = self.text:sub(1, self.cursorPos) .. completion
            self.cursorPos = #self.text
            self.scrollOffset = math.max(0, self.cursorPos - self.width)
            self:updateCompletions()
        end
    elseif self.active and event == "paste" then
        local pasteText = param
        if #self.text + #pasteText <= self.maxLength then
            self.text = self.text:sub(1, self.cursorPos) .. pasteText .. self.text:sub(self.cursorPos + 1)
            self.cursorPos = self.cursorPos + #pasteText
            if self.cursorPos > self.scrollOffset + self.width then
                self.scrollOffset = self.scrollOffset + #pasteText
            end
        end
        self:updateCompletions()
    end
end

return Input