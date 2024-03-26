-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require("physics")
physics.start()
physics.setGravity(0,0)

local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score

local background = display.newImageRect(backGroup, "background.png", 570, 360)
background.x = display.contentCenterX
background.y = display.contentCenterY

local tank = display.newImageRect(mainGroup, "tank.png", 20, 20)
tank.x = display.contentCenterX
tank.y = display.contentCenterY
physics.addBody( tank, { radius=30, isSensor=true } )
tank.myName = "tank"

local function dragTank( event )
 
    local tank = event.target
    local phase = event.phase
 
    if ( "began" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( tank )
        tank.touchOffsetX = event.x - tank.x
        tank.touchOffsetY = event.y - tank.y
    elseif ( "moved" == phase ) then
        -- Move the ship to the new touch position
        tank.x = event.x - tank.touchOffsetX
        tank.y = event.y - tank.touchOffsetY
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
    end
    return true
end

tank:addEventListener("touch", dragTank)