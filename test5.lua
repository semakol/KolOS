local wh = colors.white
local re = colors.red
local gr = colors.green
local bu = colors.blue
local lb = colors.lightBlue
local ye = colors.yellow
local ma = colors.magenta
local oa = colors.orange
local bl = colors.black
local ga = colors.gray
local lg = colors.lightGray
local br = colors.brown
local pn = colors.pink
local cy = colors.cyan
local pu = colors.purple
local li = colors.lime
local al = "alpha"

canvasChars = {
    {'\x7f', '\x7f', '\x7f', '\x7f', '\x7f', '\x7f'}, 
    {'\x7f', '\x7f', '\x7f', '\x7f', '\x7f', '\x7f'}, 
    {'\x7f', '\x7f', '\x7f', '\x7f', '\x7f', '\x7f'}, 
    {'\x7f', '\x7f', '\x7f', '\x7f', '\x7f', '\x7f'}, 
    {'\x7f', '\x7f', '\x7f', '\x7f', '\x7f', '\x7f'}, 
    {'\x7f', '\x7f', '\x7f', '\x7f', '\x7f', '\x7f'}
}

canvasColChar = {
    {ye, ye, ye, ye, ye, ye}, 
    {ye, ye, ye, ye, ye, ye}, 
    {ye, ye, ye, ye, ye, ye}, 
    {ye, ye, ye, ye, ye, ye}, 
    {ye, ye, ye, ye, ye, ye}, 
    {ye, ye, ye, ye, ye, ye}
}

canvasColBg = {
    {bl, bl, bl, bl, bl, bl}, 
    {bl, bl, bl, bl, bl, bl}, 
    {bl, bl, bl, bl, bl, bl}, 
    {bl, bl, bl, bl, bl, bl}, 
    {bl, bl, bl, bl, bl, bl}, 
    {bl, bl, bl, bl, bl, bl}
}

local file = fs.open("img_test", "w")

local canvas = {}

for i, row in ipairs(canvasChars) do
    canvas[i] = {}
    for j, pixel in ipairs(row) do
        canvas[i][j] = {
            canvasChars[i][j],
            canvasColChar[i][j],
            canvasColBg[i][j]
        }
    end
end

file.write(textutils.serialize(canvas))

file.close()    