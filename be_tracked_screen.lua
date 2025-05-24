local modem = peripheral.wrap("back")
local basalt = require("basalt")
local main = basalt.getMainFrame()


main:initializeState("channel", "", true)
main:initializeState("coords", {x="?",y="?",z="?"}) 
local be_traced_screen = main:addFrame():setSize("{parent.width}", "{parent.height-1}"):setPosition(1,2)


local form = be_traced_screen:addFrame()
    :setSize("{parent.width}", "{parent.height}"):setBackground(colors.white)

local coords_label = form:addLabel():setPosition(1,4)

local function locate()
    while true do
        local x, y, z = gps.locate()

        if x and y and z then
            coords_label:setText(string.format("X:%d, Y:%d, Z:%d", x, y, z))
            main:setState("coords", { x = x, y = y, z = z })
        else
            coords_label:setText("X:?, Y:?, Z:?")
            main:setState("coords", { x = "?", y = "?", z = "?" })
            print("GPS locate failed")
        end

        sleep(1.5)
    end
end

basalt.schedule(locate)

local tracked_label = form:addLabel()
:setText("Be tracked"):setPosition(1,2)
local function updateTrackingLabel()
    local channel = main:getState("channel")
    if(channel ~= "") then
        tracked_label:setText("Being Tracked")
    else
        tracked_label:setText("Be tracked")
    end
end
updateTrackingLabel()
main:onStateChange("channel", updateTrackingLabel)

form:addLabel()
:setText("Your position:"):setPosition(1,3)
form:addLabel():setPosition("{parent.width / 2 - 4}", "{parent.height - 3}"):setText("Channel:")
form:addInput():setPosition("{parent.width / 2 - 4}", "{parent.height - 2}"):setSize(12, 1):bind("text", "channel")
local error_label = form:addLabel():setPosition("{parent.width / 2 - 4}", "{parent.height - 1}"):setText("")

local function validate_channel()
    local channel = main:getState("channel")
    local channel_number = tonumber(channel)

    if(channel:match("^%d+$") and channel_number and channel_number <= 65533) then 
        error_label:setText("")
    else
        error_label:setText("Invalid")
    end
end

validate_channel()
main:onStateChange("channel", validate_channel)

local function broadcast()
    while true do
        local channel = main:getState("channel")
        local coords = main:getState("coords")
        local channel_number = tonumber(channel)

        if channel and channel:match("^%d+$") and channel_number and channel_number <= 65533 then
            modem.transmit(channel_number, channel_number, textutils.serialize(coords))
        end

        sleep(1.5)
    end
end
basalt.schedule(broadcast)
return be_traced_screen