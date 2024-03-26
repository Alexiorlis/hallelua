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
tank.y = display.contentCenterY+100
physics.addBody( tank, { radius=30, isSensor=true } )
tank.myName = "tank"

local cpu = display.newImageRect(mainGroup, "cpu.png", 20, 20)
cpu.x = display.contentCenterX
cpu.y = display.contentCenterY-100
physics.addBody( cpu, { radius=30, isSensor=true } )
cpu.myName = "cpu"

local function fireLaser(event)
    if (event.keyName == "space" and event.phase == "down") then
        local newLaser = display.newImageRect( mainGroup, "bullet.png" , 10,10 )
        physics.addBody( newLaser, "dynamic", { isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "laser"
        
        newLaser.x = tank.x
        newLaser.y = tank.y
        transition.to( newLaser, { y=-40, time=500, onComplete = function() display.remove( newLaser ) end} )
    end
end

local function moveTank( event )
    local phase = event.phase
 
    if (event.keyName == "w" and "down" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( tank )
        tank.y = tank.y - 10
    elseif (event.keyName == "a" and "down" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( tank )
        tank.x = tank.x - 10
    elseif (event.keyName == "s" and "down" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( tank )
        tank.y = tank.y + 10
    elseif (event.keyName == "d" and "down" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( tank )
        tank.x = tank.x + 10
    end
    return true
end

Runtime:addEventListener( "key", fireLaser )
Runtime:addEventListener("key", moveTank)

local function moveCPU()
    cpu:setLinearVelocity( math.random( -20,20 ), math.random( -20,20 ) )
end

local function gameLoop ()
    moveCPU()
end

gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)