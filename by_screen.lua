local basalt = require("basalt")
local main = basalt.getMainFrame()

local by_screen = main:addFrame():setSize("{parent.width}", "{parent.height-1}"):setPosition(1,2):setVisible(false)
local form = by_screen:addFrame({flexDirection="column", flexSpacing=0})
    :setSize("{parent.width}", "{parent.height}"):setBackground(colors.white)
    
form:addLabel():setText("By:"):setPosition(1,2)
form:addLabel():setText("-Bot_Zero"):setColor(colors.purple):setPosition(1,3)

form:addLabel():setText("Honor of:"):setPosition(1,5)
form:addLabel():setText("Johannes Kepler Mancini von Neumann da Vinci of Marghita"):setPosition(1,6):setAutoSize(false):setSize(26,3)
form:addLabel():setText("-Madman of Wardenclyffe"):setColor(colors.purple):setPosition(1,9)

form:addLabel():setText("Lab Neo-Chimera"):setPosition(1,16)
form:addLabel():setText("Lab Mancini"):setPosition(1,17)

return by_screen
