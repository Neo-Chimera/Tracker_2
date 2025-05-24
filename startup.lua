local modem = peripheral.wrap("back")
local basalt = require("basalt")
local track_screen = require("track_screen")
local be_tracked_screen = require("be_tracked_screen")
local by_screen = require("by_screen")
local main = basalt.getMainFrame()



local tabs = {be_tracked_screen, track_screen, by_screen}
local function selectTab(index)
    for id, item in pairs(tabs) do
        item:setVisible(id == index)
    end
end

local menu = main:addMenu():setItems(
{
    {text="Be tracked", callback= function() selectTab(1) end}, 
    {separator=true},
    {text="Track" ,callback= function() selectTab(2) end},
    {separator=true},
    {text="By" ,callback= function() selectTab(3) end}
})
-- Start Basalt
basalt.run()