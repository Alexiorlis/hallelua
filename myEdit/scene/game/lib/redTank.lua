
-- Module/class for redTank

-- Use this as a template to build an in-game redTank
--*****MAY NEED TO UNMUTE LATER
local fx = require( "com.ponywolf.ponyfx" )
local composer = require( "composer" )
local physics = require("physics")
local count = 0

-- Define Module
local M = {}

function M.new(redTank, startAngle)
    -- Get the current scene
    local scene = composer.getScene(composer.getSceneName("current"))

    --***for future sound implementation
    --local sounds = scene.sounds

	-- Store map placement and hide placeholder
	--redTank.isVisible = false
	local parent = redTank.parent
	local x, y = redTank.x, redTank.y

    -- Load redTank
    redTank.x = display.contentCenterX+1300
    redTank.y = display.contentCenterY
    redTank:rotate(startAngle)

    --Add physics
    --May need to add more physics later
    --have to use half width/length because of lua
    physics.setGravity(0,0)

    physics.addBody( redTank, "dynamic", { box = {halfWidth=40, halfHeight=40}, friction=2, bounce = 0.3} )
    --redTank.myName = "redTank"
    -- ***Mess around with this later
    -- redTank.isFixedRotation = true
	-- redTank.anchorY = 0.77

    -- creating scoreboard
        local score = 0
        local scoreText = display.newText("Blue Score: ", 200, 100)
    
        local function gameOver()
            local gameOverText = display.newText("Game Over", display.contentCenterX, display.contentCenterY, native.systemFontBold, 550)
        end

    -- updates score  -- needs to go on bullet to redTank collision -- temporarily on create bullet
        local function updateScore(value)
            score = score + value
            scoreText.text = "Blue Score: ".. score
            if score >= 3 then
                gameOver()
                display.remove(redTank)
            end
        end

    --bullet function
    local function createBullet() 
        --local bullet = display.newImageRect("scene/game/img/bullet.png", redTank.x, redTank.y, 5, 5)
        local bullet = display.newCircle(redTank.x, redTank.y, 10)
        physics.addBody(bullet, "dynamic", {radius = 5, isSensor = true})
        bullet.isBullet = true
        bullet.shootBullet = "bullet"
        bullet.myName = "redBullet"

        --Finds direction redTank is facing
        local angle = math.rad(redTank.rotation)
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
                if "left" == name then
                    left = -turnRadius
                    --flip = -1
                end
            
                --move right
                if "right" == name then
                    right = turnRadius
                    --flip = 1
                end

                --move up *refers to direction up and not no keys being pressed
                if "up" == name then
                    moveup = -acceleration
                end

                --move down *refers to direction downlw
                if "down" == name then
                    movedown = acceleration
                end
                --shoot
                if "/" == name then
                    local redBullet = createBullet()
                end
            --phase == "up" refers to no keys being pressed and not direction up. Basically do nothing
            elseif phase == "up" then
                if "left" == name then
                    left = 0
                end
             
                if "right" == name then
                    right = 0
                end

           
                if "up" == name then
                    moveup = 0
                end

                if "down" == name then
                    movedown = 0
                end
            end
        lastEvent = event
    end
    
    local redTankNeedsRepositioning = false
    local function redTankCollide(event)
        if (event.phase == "began") then
            if(event.other.myName == "blueBullet") then
                updateScore(1)
                event.other:removeSelf()
                redTankNeedsRepositioning = true
            end
        end
    end
    

    --actual code that defines the movement
    local function enterFrame()
        -- Do this for every frame
        count = count+1
        if count == 5 then
            -- move()
            count = 0
        end
        local vx, vy = redTank:getLinearVelocity()
        local dx = (moveup + movedown) * math.cos(math.rad(getAngle(redTank)))
        local dy =  (moveup + movedown) * math.sin(math.rad(getAngle(redTank)))
        redTank:rotate(left)
        redTank:rotate(right)

        --updates the redTank position
        redTank.x = redTank.x + dx
        redTank.y = redTank.y + dy

        local minX = 0
        local maxX = display.contentWidth
        local minY = 0
        local maxY = display.contentHeight
    
        -- doesnt allow redTank to go past the edge of the screen
        if redTank.x < minX then
            redTank.x = minX
        elseif redTank.x > maxX then
            redTank.x = maxX
        end

        if redTank.y < minY then
            redTank.y = minY
        elseif redTank.y > maxY then
            redTank.y = maxY
        end
            -- Reposition red tank if needed
        if redTankNeedsRepositioning then
            redTank.y = display.contentHeight - redTank.height * 0.5
            redTank.x = display.contentWidth - redTank.width * 1.5
            redTankNeedsRepositioning = false  -- Reset the flag
        end
        --redTank.xScale = math.min( 1, math.max( redTank.xScale + flip, -1 ) ) 
    end
    
    --not sure what this does just yet. I think it makes objects invisible?
    function redTank:finalize()
    Runtime:removeEventListener( "enterFrame", enterFrame )
    Runtime:removeEventListener( "key", key )
    end

    --Finalize listener
    redTank:addEventListener("finalize")

    --Add enterFrame listener
    Runtime:addEventListener("enterFrame", enterFrame)

    --Add key/joystick listeners
    Runtime:addEventListener("key", key)

    redTank:addEventListener("collision", redTankCollide)

    --return redTank
    redTank.name = "redTank"
    redTank.type = "redTank"
    return redTank
end

return M


