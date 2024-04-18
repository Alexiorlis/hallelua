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

	local wall = display.newImageRect(sceneGroup, "scene/game/map/wall.png", 100, 100)
	wall.x = display.contentCenterX+500
    wall.y = display.contentCenterY-150
	physics.addBody( wall, "static", { box = {halfWidth=50, halfHeight=50}} )

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
    local blueTank = blueTank.new(display.newImageRect("scene/game/img/blueTank.png", 100, 100), 90 , "blueTank")
	local redTank = redTank.new(display.newImageRect("scene/game/img/redTank.png", 100, 100), 90 , "redTank")
	--local cpu = blueTank.new(display.newImageRect("scene/game/img/cpu.png", 100, 100), "" , "cpu")
end

--eventListeners
scene:addEventListener("create")

--More code will go under this
return scene

