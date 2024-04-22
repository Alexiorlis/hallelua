
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

	local parent = blueTank.parent
	local x, y = blueTank.x, blueTank.y

    -- Load blueTank
    blueTank.x = display.contentCenterX-1300
    blueTank.y = display.contentCenterY
    blueTank:rotate(startAngle)

    physics.setGravity(0,0)

    physics.addBody( blueTank, "dynamic", { radius = 40, friction=2, bounce = 0.3} )
    blueTank.myName = "blueTank"

    -- creating scoreboard
        local score = 0
        local scoreText = display.newText("Red Score: ", 2600, 100)

        local blueTankNeedsRepositioning = falseWW
        local function restartGame()
            -- reset game variables, clear the screen, and restart gameplay
            score = 0
            scoreText.text = "Red Score: 0"
            gameOverText:removeSelf()
            restartText:removeSelf()

            blueTankNeedsRepositioning = true
            if blueTankNeedsRepositioning then
                blueTank.y = display.contentCenterY
                blueTank.x = display.contentCenterX-1300
                blueTankNeedsRepositioning = false  -- Reset the flag  
            end
        end

        local function gameOver()
            gameOverText = display.newText("Game Over", display.contentCenterX, display.contentCenterY, native.systemFontBold, 400)
            restartText = display.newText("Tap to restart", display.contentCenterX, display.contentCenterY + 200, native.systemFontBold, 150)
            restartText:addEventListener("tap", restartGame)
        end

    -- updates score 
    local function updateScore(value)
        max_score = 3
        score = score + value
        if score <= max_score then
        scoreText.text = "Red Score: ".. score
        end

        if score == 3 then
            gameOver()
        end
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
        local bullet = display.newCircle(blueTank.x, blueTank.y, 10) 
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

    --tank collision
    local function blueTankCollide(event)
        if (event.phase == "began") then 
            if(event.other.myName == "redBullet") then
                updateScore(1)
                event.other:removeSelf()
                blueTankNeedsRepositioning = true
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
        -- Reposition blue tank if needed
        if blueTankNeedsRepositioning then
            blueTank.y = display.contentCenterY
            blueTank.x = display.contentCenterX-1300
            blueTankNeedsRepositioning = false  -- Reset the flag
        end
    end

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



