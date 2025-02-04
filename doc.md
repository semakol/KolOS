# KolOS Documentation

## GUI

### Methods
- `new(x, y, width, height, parent)`: Creates a new GUI instance.
- `addLabel(x, y, text, textColor)`: Adds a label to the GUI.
- `addButton(x, y, label, callback, bgColor, textColor, width, height)`: Adds a button to the GUI.
- `addInput(x, y, width, maxLength, bgColor, textColor)`: Adds an input field to the GUI.
- `addTextarea(x, y, width, height, bgColor, textColor)`: Adds a textarea to the GUI.
- `addRect(x, y, width, height, bgColor, fill, char, charColor)`: Adds a rectangle to the GUI.
- `addDropdown(x, y, width, items, bgColor, textColor)`: Adds a dropdown to the GUI.
- `addSwitch(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)`: Adds a switch to the GUI.
- `addLine(x1, y1, x2, y2, color, bgColor, char)`: Adds a line to the GUI.
- `addCircle(x1, y1, x2, y2, color, fill, char, charColor)`: Adds a circle to the GUI.
- `addKeyHandler()`: Adds a key handler to the GUI.
- `draw()`: Draws the GUI.
- `handleClick(x, y)`: Handles mouse click events.
- `handleKey(key)`: Handles key events.
- `update(event, param1, param2, param3)`: Updates the GUI based on events.
- `run(...)`: Runs the GUI event loop.

## Button

### Methods
- `new(x, y, label, callback, bgColor, textColor, width, height)`: Creates a new Button instance.
- `setPosition(x, y)`: Sets the position of the button.
- `setSize(width, height)`: Sets the size of the button.
- `setLabel(label, width, height)`: Sets the label and size of the button.
- `setBgColor(bgColor, textColor)`: Sets the background and text color of the button.
- `addCallback(callback)`: Adds a callback function to the button.
- `draw(canvas)`: Draws the button on the canvas.
- `handleClick(mx, my)`: Handles mouse click events.

## Input

### Methods
- `new(x, y, width, maxLength, bgColor, textColor)`: Creates a new Input instance.
- `setPosition(x, y)`: Sets the position of the input field.
- `setSize(width, maxLength)`: Sets the size and maximum length of the input field.
- `setColors(bgColor, textColor)`: Sets the background and text color of the input field.
- `draw(canvas)`: Draws the input field on the canvas.
- `handleClick(mx, my)`: Handles mouse click events.
- `handleInput(event, param)`: Handles input events.

## Label

### Methods
- `new(x, y, text, textColor, bgColor)`: Creates a new Label instance.
- `setPosition(x, y)`: Sets the position of the label.
- `setText(newText)`: Sets the text of the label.
- `setColors(textColor, bgColor)`: Sets the text and background color of the label.
- `draw(canvas)`: Draws the label on the canvas.

## KeyHandler

### Methods
- `new()`: Creates a new KeyHandler instance.
- `registerKey(key, action)`: Registers a key with an action.
- `handleKey(key)`: Handles key events.

## Textarea

### Methods
- `new(x, y, width, height, bgColor, textColor)`: Creates a new Textarea instance.
- `setPosition(x, y)`: Sets the position of the textarea.
- `setSize(width, height)`: Sets the size of the textarea.
- `setColors(bgColor, textColor)`: Sets the background and text color of the textarea.
- `draw(canvas)`: Draws the textarea on the canvas.
- `updateTextList()`: Updates the text list for the textarea.
- `setText(newText)`: Sets the text of the textarea.
- `addLine(line)`: Adds a line to the textarea.
- `scrollUp()`: Scrolls the textarea up.
- `scrollDown()`: Scrolls the textarea down.
- `isMouseOver(mx, my)`: Checks if the mouse is over the textarea.

## Rect

### Methods
- `new(x, y, width, height, bgColor, fill, char, charColor)`: Creates a new Rect instance.
- `setPosition(x, y)`: Sets the position of the rectangle.
- `setSize(width, height)`: Sets the size of the rectangle.
- `setColors(bgColor, charColor)`: Sets the background and character color of the rectangle.
- `setChar(char)`: Sets the character of the rectangle.
- `setFill(fill)`: Sets the fill property of the rectangle.
- `draw(canvas)`: Draws the rectangle on the canvas.

## Dropdown

### Methods
- `new(x, y, width, items, bgColor, textColor)`: Creates a new Dropdown instance.
- `setPosition(x, y)`: Sets the position of the dropdown.
- `setSize(width)`: Sets the width of the dropdown.
- `setItems(items)`: Sets the items of the dropdown.
- `setColors(bgColor, textColor)`: Sets the background and text color of the dropdown.
- `draw(canvas)`: Draws the dropdown on the canvas.
- `handleClick(mx, my)`: Handles mouse click events.
- `handleScroll(direction)`: Handles scroll events.
- `handleKey(key)`: Handles key events.
- `isExpanded()`: Checks if the dropdown is expanded.
- `getSelectedOption()`: Gets the selected option of the dropdown.

## Switch

### Methods
- `new(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)`: Creates a new Switch instance.
- `setPosition(x, y)`: Sets the position of the switch.
- `setState(state)`: Sets the state of the switch.
- `setCallback(callback)`: Sets the callback function of the switch.
- `setColors(activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)`: Sets the colors of the switch.
- `setTexts(activeText, inactiveText)`: Sets the texts of the switch.
- `draw(canvas)`: Draws the switch on the canvas.
- `handleClick(x, y)`: Handles mouse click events.

## Line

### Methods
- `new(x1, y1, x2, y2, color, bgColor, char)`: Creates a new Line instance.
- `setCoordinates(x1, y1, x2, y2)`: Sets the coordinates of the line.
- `setColors(color, bgColor)`: Sets the colors of the line.
- `setChar(char)`: Sets the character of the line.
- `draw(canvas)`: Draws the line on the canvas.

## Circle

### Methods
- `new(x1, y1, x2, y2, color, fill, char, charColor)`: Creates a new Circle instance.
- `setPosition(x1, y1, x2, y2)`: Sets the position of the circle.
- `setColors(color, charColor)`: Sets the colors of the circle.
- `setFill(fill)`: Sets the fill property of the circle.
- `setChar(char)`: Sets the character of the circle.
- `update()`: Updates the circle's pixels.
- `draw(canvas)`: Draws the circle on the canvas.
