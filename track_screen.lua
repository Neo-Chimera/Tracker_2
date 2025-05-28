local basalt = require("basalt")
local main = basalt.getMainFrame()
local modem = peripheral.wrap("back")
local track_screen = main:addFrame():setSize("{parent.width}", "{parent.height-1}"):setPosition(1,2):setVisible(false)


main:initializeState("tracking_channel", "", true)
local form = track_screen:addFrame()
    :setSize("{parent.width}", "{parent.height}"):setBackground(colors.white)
form:addLabel():setText("Track Someone"):setPosition(1,2)
local distance_label =  form:addLabel():setText("Last distance: ?"):setPosition(1,3)

form:addLabel():setPosition(1,5):setText("Message:")
local message_label =  form:addLabel():setPosition(1,6):setText(""):setSize(26, 5):setAutoSize(false)


form:addLabel():setPosition("{parent.width / 2 - 4}", "{parent.height - 3}"):setText("Channel:")
form:addInput():setPosition("{parent.width / 2 - 4}", "{parent.height - 2}"):setSize(12, 1):bind("text", "tracking_channel")
local error_label = form:addLabel():setPosition("{parent.width / 2 - 4}", "{parent.height - 1}"):setText("")

local function reset_channel()
    local tracking_channel = main:getState("tracking_channel")
    local channel_number = tonumber(tracking_channel)

    if not tracking_channel:match("^%d+$") or not channel_number or channel_number > 65533 then
        return
    end

    modem.closeAll()
    modem.open(channel_number)
    message_label:setText("")
    distance_label:setText("Last distance: ?")
end
reset_channel()
local function validate_channel()
    local tracking_channel = main:getState("tracking_channel")
    local channel_number = tonumber(tracking_channel)

    if(tracking_channel:match("^%d+$") and channel_number and channel_number <= 65533) then 
        error_label:setText("")
    else
        error_label:setText("Invalid")
    end
end

validate_channel()
main:onStateChange("tracking_channel", reset_channel)
main:onStateChange("tracking_channel", validate_channel)


local function sanitize(input)
    return tostring(input):gsub("[^%w=,%.%-%s]", "")
end



local function hear()
    while true do
        modem.close(65534)
        local event, side, channel, reply_channel, message, distance = os.pullEvent("modem_message")    
        if channel ~= 65534 then
            distance_label:setText(string.format("Last distance: %d", distance or 0))
            if(type(message)=="string") then
                message_label:setText(sanitize(message))
            else
                local fallback = sanitize(textutils.serialize(message))
                local pretty = require("cc.pretty")
                message_label:setText(fallback)
            end
        end
        sleep(0.05)
    end
end
basalt.schedule(hear)


return track_screen