
-- Module/class for tank

-- Use this as a template to build an in-game tank
--*****MAY NEED TO UNMUTE LATER
local fx = require( "com.ponywolf.ponyfx" )
local composer = require( "composer" )

-- Define Module
local M = {}

function M.new(tank, options)
    -- Get the current scene
    local scene = composer.getScene(composer.getSceneName("current"))

    --***for future sound implementation
    --local sounds = scene.sounds

    --**Might not need options
    options = options or {}

	-- Store map placement and hide placeholder
	--tank.isVisible = false
	local parent = tank.parent
	local x, y = tank.x, tank.y

    -- Load tank
    tank.x = display.contentCenterX
    tank.y = display.contentCenterY+100

    --Add physics
    --May need to add more physics later
    --have to use half width/length because of lua
    physics.setGravity(0,0)

    physics.addBody( tank, "dynamic", { box = {halfWidth=50, halfHeight=50}, friction=2, isSensor=true } )
    --tank.myName = "tank"
    -- ***Mess around with this later
    -- tank.isFixedRotation = true
	-- tank.anchorY = 0.77

    --Keyboard controls for direction (left, right, up, down)
    local acceleration, left, right, moveup, movedown, flip = 25, 0, 0, 0, 0, 0
    local lastEvent = {}
    
    -- Sets variables when they keys are pressed
    local function key(event)
        local phase = event.phase
        local name = event.keyName
        if (phase == lastEvent.phase) and (name == lastEvent.keyName) then return false end -- Filter repeating keys
        -- if phase == "down" refers to a key being pressed down, NOT the direction down (Corona SDK weird)
        if phase == "down" then
            -- move left
            if "left" == name or "a" == name then
                left = -acceleration
                --flip = -1
            end
            
            --move right
            if "right" == name or "d" == name then
                right = acceleration
                --flip = 1
            end

            --move up *refers to direction up and not no keys being pressed
            if "up" == name or "w" == name then
                moveup = -acceleration
            end

            --move down *refers to direction down
            if "down" == name or "s" == name then
                movedown = acceleration
            end
        --phase == "up" refers to no keys being pressed and not direction up. Basically do nothing
        elseif phase == "up" then
            if "left" == name or "a" == name then
                left = 0
            end
             
             if "right" == name or "d" == name then
                right = 0
            end

           
            if "up" == name or "w" == name then
                moveup = 0
            end

            if "down" == name or "s" == name then
                movedown = 0
            end
        end
        lastEvent = event
    end
    
    --actual code that defines the movement
    local function enterFrame()
        -- Do this for every frame
        local vx, vy = tank:getLinearVelocity()
        local dx = left + right
        local dy = moveup + movedown
        tank:rotate(left)
        tank:rotate(right)

        --updates the tank position
        --tank.x = tank.x + dx
        tank.y = tank.y + dy

        --tank.xScale = math.min( 1, math.max( tank.xScale + flip, -1 ) ) 
    end

    --not sure what this does just yet. I think it makes objects invisible?
    function tank:finalize()
    Runtime:removeEventListener( "enterFrame", enterFrame )
    Runtime:removeEventListener( "key", key )
    end

    --Finalize listener
    tank:addEventListener("finalize")

    --Add enterFrame listener
    Runtime:addEventListener("enterFrame", enterFrame)

    --Add key/joystick listeners
    Runtime:addEventListener("key", key)

    --return tank
    tank.name = "tank"
    tank.type = "tank"
    return tank
end

return M



