while true do
    local event, param1, param2, param3, param4 = os.pullEvent()
    print(event, param1, param2, param3, param4)
end