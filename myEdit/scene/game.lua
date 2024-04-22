--***THIS IS WHERE OTHER OBJECTS WILL BE IMPORTED AND SET-- i think


--Include libraries
local composer = require("composer")
local fx = require("com.ponywolf.ponyfx")
local physics = require("physics")
local json = require( "json" )
--change to "blueTank" later. this is just for reference for now
local blueTank = require("scene.game.lib.blueTank")
local redTank = require("scene.game.lib.redTank")

--Variables local to scene(scene- Which part of the game you are viewing, ex. the menu, the actual game, ending credits)
--but in this case, these local variable apply to things that are currently included in the actual game scene
-- local map, blueTank

--Creating Composer for scene
--Basically this this line is creating the game scene
local scene = composer.newScene()

-- This is called when scene is created
function scene:create(event)
    
    --add scene display objects
    local sceneGroup = self.view

    --This is where sounds would be added but muted for now since i have not created soundtrack
    -- local sndDir = "scene/game/sfx/"
	-- scene.sounds = {
	-- 	thud = audio.loadSound( sndDir .. "thud.mp3" ),
	-- 	sword = audio.loadSound( sndDir .. "sword.mp3" ),
	-- 	squish = audio.loadSound( sndDir .. "squish.mp3" ),
	-- 	slime = audio.loadSound( sndDir .. "slime.mp3" ),
	-- 	wind = audio.loadSound( sndDir .. "loops/spacewind.mp3" ),
	-- 	door = audio.loadSound( sndDir .. "door.mp3" ),
	-- 	hurt = {
	-- 		audio.loadSound( sndDir .. "hurt1.mp3" ),
	-- 		audio.loadSound( sndDir .. "hurt2.mp3" ),
	-- 	},
	-- 	hit = audio.loadSound( sndDir .. "hit.mp3" ),
	-- 	coin = audio.loadSound( sndDir .. "coin.mp3" ),
    -- }

    --Start physics
	physics.start()
	physics.setGravity(0,0)


    -- Loading map (hardcoded for now)
    local background = display.newImageRect(sceneGroup, "scene/game/map/background.png", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

	local wallTable = {}

	local function wallCollide(event)
		if (event.phase == "began") then

            --removes bullets on impact with wall
            if(event.other.myName == "redBullet" or  event.other.myName == "blueBullet") then
                event.other:removeSelf()
            end
        end
	end

	local function createWalls()
		local wallArray = {}
		for i=0,12 do
			for j=0,7 do
				if (i==0 and (j==0 or j==1 or j==5 or j==6)) or
				(i==1 and (j==4)) or (i==2 and (j==2)) or (i==3 and (j==3 or j==6)) or
				(i==4 and (j==0 or j==1 or j==5)) or (i==5 and (j==5)) or (i==6 and (j==2 or j==5)) or
				(i==7 and (j==0)) or (i==8 and (j==4)) or (i==9 and (j==2 or j==3)) or
				(i==11 and (j==0 or j==1 or j==6 or j==7)) or (i==12 and (j==2)) then
					for k=1,4 do
						local wall = display.newImageRect(sceneGroup, "scene/game/map/wall.png", 100, 100)
						table.insert(wallTable, wall)
						if k==1 then
							wall.x = display.contentCenterX + (100*i)
    						wall.y = display.contentCenterY + (100*j)
						elseif k==2 then
							wall.x = display.contentCenterX - (100*i)
    						wall.y = display.contentCenterY + (100*j)
						elseif k==3 then
							wall.x = display.contentCenterX + (100*i)
    						wall.y = display.contentCenterY - (100*j)
						elseif k==4 then
							wall.x = display.contentCenterX - (100*i)
    						wall.y = display.contentCenterY - (100*j)
						end
						physics.addBody( wall, "static", { box = {halfWidth=50, halfHeight=50}} )
						wall.myName = "wall"
						wall:addEventListener("collision", wallCollide)
					end
				end
			end
		end
	end

	createWalls()

-- Your code here

	

    -- Load our map
    --***This is for loading the map that is created and NOT the background
	-- local filename = event.params.map or "scene/game/map/sandbox.json"
	-- local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ) )
	-- map = tiled.new( mapData, "scene/game/map" )

    -- --**This loads the blueTank on the map, but is not needed yet since I am hardcoding for testing
    -- map.extensions = "scene.game.lib."
	-- map:extend("blueTank")
	-- blueTank = map:findObject("blueTank")
	-- blueTank.filename = filename
    --calling blueTank (hardcoded)
    local blueTank = blueTank.new(display.newImageRect("scene/game/img/blueTank.png", 80, 80), 180)
	local redTank = redTank.new(display.newImageRect("scene/game/img/redTank.png", 80, 80), 0)
end

--eventListeners
scene:addEventListener("create")

--More code will go under this
return scene

