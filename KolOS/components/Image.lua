local Image = {}
Image.__index = Image

function Image:new(x, y, filePath, zIndex)
    if type(x) == 'table' then
        local params = x
        x = params.x
        y = params.y
        filePath = params.filePath
        zIndex = params.zIndex
    end
    local obj = setmetatable({}, self)
    obj.x = x or 1
    obj.y = y or 1
    obj.canvas = {}
    obj.zIndex = zIndex or 0
    if filePath then
        self:loadFile(filePath)
    end
    return obj
end

function Image:loadFile(filePath)
    local file = fs.open(filePath, "r")
    if not file then
        error("File not found: " .. filePath)
    end
    local content = file.readAll()
    file.close()
    self.canvas = self:unserialize(content)
    return self
end

function Image:unserialize(content)
    local data = textutils.unserialize(content)
    local canvas = {}
    for i, row in ipairs(data) do
        canvas[i] = {}
        for j, pixel in ipairs(row) do
            canvas[i][j] = {
                char = pixel[1],
                charColor = pixel[2],
                bgColor = pixel[3]
            }
        end
    end
    return canvas
end

function Image:draw(canvas)
    for i, row in ipairs(self.canvas) do
        for j, pixel in ipairs(row) do
            local x = self.x + j - 1
            local y = self.y + i - 1
            if canvas[y] and canvas[y][x] then
                if pixel.bgColor ~= "alpha" then
                    canvas[y][x].bgColor = pixel.bgColor
                end
                canvas[y][x].char = pixel.char
                canvas[y][x].charColor = pixel.charColor
            end
        end
    end
end

function Image:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    self.frame.update = true
    return self
end

function Image:setZIndex(zIndex)
    self.zIndex = zIndex or self.zIndex
    self.frame.update = true
    return self
end

function Image:setParams(params)
    if params.x then self.x = params.x end
    if params.y then self.y = params.y end
    if params.filePath then self:loadFile(params.filePath) end
    if params.zIndex then self.zIndex = params.zIndex end
    self.frame.update = true
    return self
end

return Image
