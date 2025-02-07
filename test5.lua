canvas = {
    {
        {"A", colors.white, "alpha"},
        {" ", colors.white, colors.red},
        {" ", colors.white, colors.red}
    },
    {
        {" ", colors.white, colors.green},
        {" ", colors.white, colors.green},
        {" ", colors.white, colors.green}
    },
    {
        {" ", colors.white, colors.blue},
        {" ", colors.white, colors.blue},
        {" ", colors.white, colors.blue}
    }
}

local file = fs.open("img_test", "w")

file.write(textutils.serialize(canvas))

file.close()    