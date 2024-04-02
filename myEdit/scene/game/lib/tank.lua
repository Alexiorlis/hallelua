
-- Module/class for tank

-- Use this as a template to build an in-game tank
--*****MAY NEED TO UNMUTE LATER
local fx = require( "com.ponywolf.ponyfx" )
local composer = require( "composer" )

-- Define Module
local M = {}

function M.new(tank, startAngle)
    -- Get the current scene
    local scene = composer.getScene(composer.getSceneName("current"))

    --***for future sound implementation
    --local sounds = scene.sounds

    --**Might not need options
    --options = options or {}


	-- Store map placement and hide placeholder
	--tank.isVisible = false
	local parent = tank.parent
	local x, y = tank.x, tank.y

    -- Load tank
    tank.x = display.contentCenterX
    tank.y = display.contentCenterY+100
    tank:rotate(startAngle)

    --Add physics
    --May need to add more physics later
    --have to use half width/length because of lua
    physics.setGravity(0,0)

    physics.addBody( tank, "dynamic", { box = {halfWidth=50, halfHeight=50}, friction=2, isSensor=true } )
    --tank.myName = "tank"
    -- ***Mess around with this later
    -- tank.isFixedRotation = true
	-- tank.anchorY = 0.77

    --bullet function
    local function createBullet() 
        --local bullet = display.newImageRect("scene/game/img/bullet.png", tank.x, tank.y, 5, 5)
        local bullet = display.newCircle(tank.x, tank.y, 5)
        physics.addBody(bullet, "dynamic", {radius = 5})
        bullet.isBullet = true
        bullet.shootBullet = "bullet"

        --Finds direction tank is facing
        local angle = math.rad(tank.rotation)
        local speed = -1000
        local vx = math.cos(angle) * speed
        local vy = math.sin(angle) * speed

        --applies force to the bullet
        bullet:setLinearVelocity(vx, vy)

        return bullet
    end    

    --Keyboard controls for direction (left, right, up, down)
    local acceleration, left, right, moveup, movedown, flip = 25, 0, 0, 0, 0, 0
    local lastEvent = {}
    local turnRadius = 8
    

    --turns the rotation into a usable angle value
    local function getAngle(object)
        
        if (object.rotation) < 0 then
            object.rotation = 360
        end
        if (object.rotation) > 360 then
            object.rotation = 0
        end
        return (object.rotation)
    end
    
    -- Sets variables when they keys are pressed
    local function key(event)
        local phase = event.phase
        local name = event.keyName
        if (phase == lastEvent.phase) and (name == lastEvent.keyName) then return false end -- Filter repeating keys
        -- if phase == "down" refers to a key being pressed down, NOT the direction down (Corona SDK weird)
        if phase == "down" then
            -- move left
            if "left" == name or "a" == name then
                left = -turnRadius
                --flip = -1
            end
            
            --move right
            if "right" == name or "d" == name then
                right = turnRadius
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
            -- shoot bullet
            --move down *refers to direction down
            if "space" == name then
                local bullet = createBullet()
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
        
        local dx = (moveup + movedown) * math.cos(math.rad(getAngle(tank)))
        local dy =  (moveup + movedown) * math.sin(math.rad(getAngle(tank)))
        tank:rotate(left)
        tank:rotate(right)
        
        --test
        print(getAngle(tank))
        --updates the tank position
        tank.x = tank.x + dx
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



