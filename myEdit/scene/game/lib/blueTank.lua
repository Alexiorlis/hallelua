
-- Module/class for blueTank

-- Use this as a template to build an in-game blueTank
--*****MAY NEED TO UNMUTE LATER
local fx = require( "com.ponywolf.ponyfx" )
local composer = require( "composer" )
local physics = require("physics")
local count = 0

-- Define Module
local M = {}

function M.new(blueTank, startAngle)
    -- Get the current scene
    local scene = composer.getScene(composer.getSceneName("current"))

    --***for future sound implementation
    --local sounds = scene.sounds

	-- Store map placement and hide placeholder
	--blueTank.isVisible = false
	local parent = blueTank.parent
	local x, y = blueTank.x, blueTank.y

    -- Load blueTank
    blueTank.x = display.contentCenterX-500
    blueTank.y = display.contentCenterY
    blueTank:rotate(startAngle)

    --Add physics
    --May need to add more physics later
    --have to use half width/length because of lua
    physics.setGravity(0,0)

    physics.addBody( blueTank, "dynamic", { box = {halfWidth=50, halfHeight=50}, friction=2, bounce = 0.3} )
    blueTank.myName = "blueTank"
    -- ***Mess around with this later
    -- blueTank.isFixedRotation = true
	-- blueTank.anchorY = 0.77

    -- creating scoreboard
        local score = 0
        local scoreText = display.newText("Score: ", 150, 100)
    
    -- updates score  -- needs to go on bullet to blueTank collision -- temporarily on create bullet
        local function updateScore(value)
            local score = score + value
            scoreText.text = "Score: ".. score
        end

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

    --bullet function
    local function createBullet() 
        --local bullet = display.newImageRect("scene/game/img/bullet.png", blueTank.x, blueTank.y, 5, 5)
        

        local bullet = display.newCircle(blueTank.x, blueTank.y, 10) --the bullet colliding with the tank is making it stop. make it not
        physics.addBody(bullet, "dynamic", {radius = 5, isSensor = true})
        bullet.isBullet = true
        bullet.shootBullet = "bullet"

        bullet.myName = "blueBullet"

        --Finds direction blueTank is facing
        local angle = math.rad(blueTank.rotation)
        --Negative because image is flipped upside down.
        local speed = -600
        local vx = math.cos(angle) * speed
        local vy = math.sin(angle) * speed
        --applies force to the bullet
        bullet:setLinearVelocity(vx, vy)
    end 



    --Keyboard controls for direction (left, right, up, down)
    local acceleration, left, right, moveup, movedown, flip = 5, 0, 0, 0, 0, 0
    local lastEvent = {}
    local turnRadius = 4

    
    
    -- Sets variables when they keys are pressed
    local function key(event)
        local phase = event.phase
        local name = event.keyName
        if (phase == lastEvent.phase) and (name == lastEvent.keyName) then return false end -- Filter repeating keys
            
        -- if phase == "down" refers to a key being pressed down, NOT the direction down (Corona SDK weird)
            if phase == "down" then

                --shoot
                if "q" == name then
                    local blueBullet = createBullet()
                end

                -- move left
                if "a" == name then
                    left = -turnRadius
                    --flip = -1
                end
            
                --move right
                if "d" == name then
                    right = turnRadius
                    --flip = 1
                end

                --move up *refers to direction up and not no keys being pressed
                if "w" == name then
                    moveup = -acceleration
                end

                --move down *refers to direction down
                if "s" == name then
                    movedown = acceleration
                end
                
            --phase == "up" refers to no keys being pressed and not direction up. Basically do nothing
            elseif phase == "up" then
                if "a" == name then
                    left = 0
                end
             
                if "d" == name then
                    right = 0
                end

           
                if "w" == name then
                    moveup = 0
                end

                if "s" == name then
                    movedown = 0
                end
            end
        lastEvent = event
    end

    -- local function move()
    --     if flag == "cpu" then 
    --         local action = math.random(0,4)
    --         if action == 0 then
    --             left, right, moveup, movedown= 0, 0, 0, 0
    --         elseif action == 1 then
    --             moveup = -acceleration
    --             left, right, movedown= 0, 0, 0
    --         elseif action == 2 then
    --             movedown = acceleration
    --             left, right, moveup= 0, 0, 0
    --         elseif action == 3 then
    --             left = -turnRadius
    --             right, moveup, movedown= 0, 0, 0
    --         elseif action == 4 then
    --             right = turnRadius
    --             left, moveup, movedown= 0, 0, 0
    --         end
    --     end
    -- end
    
    
    
    

    --actual code that defines the movement
    local function enterFrame()
        -- Do this for every frame
        count = count+1
        if count == 5 then
            -- move()
            count = 0
        end

        

        local vx, vy = blueTank:getLinearVelocity()
        local dx = (moveup + movedown) * math.cos(math.rad(getAngle(blueTank)))
        local dy =  (moveup + movedown) * math.sin(math.rad(getAngle(blueTank)))
        blueTank:rotate(left)
        blueTank:rotate(right)
        
        --updates the blueTank position
        blueTank.x = blueTank.x + dx
        blueTank.y = blueTank.y + dy

        local minX = 0
        local maxX = display.contentWidth
        local minY = 0
        local maxY = display.contentHeight
    
        -- doesnt allow blueTank to go past the edge of the screen
        if blueTank.x < minX then
            blueTank.x = minX
        elseif blueTank.x > maxX then
            blueTank.x = maxX
        end

        if blueTank.y < minY then
            blueTank.y = minY
        elseif blueTank.y > maxY then
            blueTank.y = maxY
        end

        --blueTank.xScale = math.min( 1, math.max( blueTank.xScale + flip, -1 ) ) 
    end

    --tank collision
    local function blueTankCollide(event)
        if (event.phase == "began") then
            
            --dont collide with own bullets
            if(event.other.myName == "redBullet") then
                event.other:removeSelf()
                print("Blue Tank hit")
            end
        end
    end

    --not sure what this does just yet. I think it makes objects invisible?
    function blueTank:finalize()
    Runtime:removeEventListener( "enterFrame", enterFrame )
    Runtime:removeEventListener( "key", key )
    end

    --Finalize listener
    blueTank:addEventListener("finalize")

    --Add enterFrame listener
    Runtime:addEventListener("enterFrame", enterFrame)

    --Add key/joystick listeners
    Runtime:addEventListener("key", key)

    blueTank:addEventListener("collision", blueTankCollide)

    --return blueTank
    blueTank.name = "blueTank"
    blueTank.type = "blueTank"
    return blueTank
end

return M



