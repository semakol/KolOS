# KolOS Documentation

## Components

### Label
A simple text label.

**Methods:**
- `Label:new(x, y, text, textColor, bgColor, zIndex)`
- `Label:setPosition(x, y)`
- `Label:setText(newText)`
- `Label:setColors(textColor, bgColor)`
- `Label:setZIndex(zIndex)`
- `Label:draw(canvas)`

### KeyHandler
Handles key events.

**Methods:**
- `KeyHandler:new()`
- `KeyHandler:registerKey(key, action)`
- `KeyHandler:handleKey(key)`

### Input
A text input field.

**Methods:**
- `Input:new(x, y, width, maxLength, bgColor, textColor, replaceChar, history, completeFn, default, callback, deactivateOnEnter, zIndex)`
- `Input:setPosition(x, y)`
- `Input:setSize(width, maxLength)`
- `Input:setColors(bgColor, textColor)`
- `Input:setReplaceChar(replaceChar)`
- `Input:setHistory(history)`
- `Input:setCompleteFn(completeFn)`
- `Input:setDefault(default)`
- `Input:setCallback(callback)`
- `Input:setDeactivateOnEnter(deactivateOnEnter)`
- `Input:setZIndex(zIndex)`
- `Input:addHistory(item)`
- `Input:draw(canvas)`
- `Input:handleClick(mx, my)`
- `Input:updateCompletions()`
- `Input:handleInput(event, param)`

### Image
Displays an image.

**Methods:**
- `Image:new(x, y, filePath, zIndex)`
- `Image:loadFile(filePath)`
- `Image:unserialize(content)`
- `Image:draw(canvas)`
- `Image:setPosition(x, y)`
- `Image:setZIndex(zIndex)`

### Frame
A container for other components.

**Methods:**
- `Frame:new(x, y, width, height, parent, name)`
- `Frame:setVisible(visible)`
- `Frame:addLabel(x, y, text, textColor, zIndex)`
- `Frame:addButton(x, y, label, callback, bgColor, textColor, width, height, zIndex)`
- `Frame:addInput(x, y, width, maxLength, bgColor, textColor, replaceChar, history, completeFn, default, callback, deactivateOnEnter, zIndex)`
- `Frame:addTextarea(x, y, width, height, bgColor, textColor, zIndex)`
- `Frame:addRect(x, y, width, height, bgColor, fill, char, charColor, zIndex)`
- `Frame:addDropdown(x, y, width, items, bgColor, textColor, zIndex)`
- `Frame:addSwitch(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor, zIndex)`
- `Frame:addLine(x1, y1, x2, y2, color, bgColor, char, zIndex)`
- `Frame:addCircle(x1, y1, x2, y2, color, fill, char, charColor, zIndex)`
- `Frame:addImage(x, y, filePath, zIndex)`
- `Frame:addKeyHandler()`
- `Frame:draw()`
- `Frame:handleClick(x, y)`
- `Frame:handleKey(key)`
- `Frame:update(event, param1, param2, param3)`

### Dropdown
A dropdown menu.

**Methods:**
- `Dropdown:new(x, y, width, items, bgColor, textColor, zIndex)`
- `Dropdown:setPosition(x, y)`
- `Dropdown:setSize(width)`
- `Dropdown:setItems(items)`
- `Dropdown:setColors(bgColor, textColor)`
- `Dropdown:setZIndex(zIndex)`
- `Dropdown:draw(canvas)`
- `Dropdown:handleClick(mx, my)`
- `Dropdown:handleScroll(direction)`
- `Dropdown:handleKey(key)`
- `Dropdown:isExpanded()`
- `Dropdown:getSelectedOption()`

### Circle
Draws a circle.

**Methods:**
- `Circle:new(x1, y1, x2, y2, color, fill, char, charColor, zIndex)`
- `Circle:setPosition(x1, y1, x2, y2)`
- `Circle:setColors(color, charColor)`
- `Circle:setFill(fill)`
- `Circle:setChar(char)`
- `Circle:setZIndex(zIndex)`
- `Circle:update()`
- `Circle:draw(canvas)`

### Button
A clickable button.

**Methods:**
- `Button:new(x, y, label, callback, bgColor, textColor, width, height, zIndex)`
- `Button:setPosition(x, y)`
- `Button:setSize(width, height)`
- `Button:setLabel(label, width, height)`
- `Button:setBgColor(bgColor, textColor)`
- `Button:setZIndex(zIndex)`
- `Button:addCallback(callback)`
- `Button:draw(canvas)`
- `Button:handleClick(mx, my)`

### GUI
Manages frames and events.

**Methods:**
- `GUI:new(frames)`
- `GUI:addFrame(x, y, width, height, parent, name)`
- `GUI:update(event, param1, param2, param3)`
- `GUI:run(...)`

### Textarea
A scrollable text area.

**Methods:**
- `Textarea:new(x, y, width, height, bgColor, textColor, zIndex)`
- `Textarea:setPosition(x, y)`
- `Textarea:setSize(width, height)`
- `Textarea:setColors(bgColor, textColor)`
- `Textarea:setZIndex(zIndex)`
- `Textarea:draw(canvas)`
- `Textarea:setText(newText)`
- `Textarea:addLine(line)`
- `Textarea:scrollUp()`
- `Textarea:scrollDown()`
- `Textarea:isMouseOver(mx, my)`

### Switch
A toggle switch.

**Methods:**
- `Switch:new(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor, zIndex)`
- `Switch:setPosition(x, y)`
- `Switch:setState(state)`
- `Switch:setCallback(callback)`
- `Switch:setColors(activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)`
- `Switch:setTexts(activeText, inactiveText)`
- `Switch:setZIndex(zIndex)`
- `Switch:draw(canvas)`
- `Switch:handleClick(x, y)`

### Rect
Draws a rectangle.

**Methods:**
- `Rect:new(x, y, width, height, bgColor, fill, char, charColor, zIndex)`
- `Rect:setPosition(x, y)`
- `Rect:setSize(width, height)`
- `Rect:setColors(bgColor, charColor)`
- `Rect:setChar(char)`
- `Rect:setFill(fill)`
- `Rect:setZIndex(zIndex)`
- `Rect:draw(canvas)`

### Line
Draws a line.

**Methods:**
- `Line:new(x1, y1, x2, y2, color, bgColor, char, zIndex)`
- `Line:setCoordinates(x1, y1, x2, y2)`
- `Line:setColors(color, bgColor)`
- `Line:setChar(char)`
- `Line:setZIndex(zIndex)`
- `Line:draw(canvas)`
