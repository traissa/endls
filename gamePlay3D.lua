-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
local imageData  = require "AssetLocation"
local playerComponent = require "component.opponent"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	local newFloor = display.newGroup( )

	local x = display.contentCenterX
	local y = display.viewableContentHeight

	local farBackground = display.newImage( imageLocation.background3D)
	farBackground.anchorX, farBackground.anchorY = .5, 1
	farBackground.x, farBackground.y = x, y

	local tiles = display.newImageRect( imageLocation.floor3D, 1280*.6, 1440*.6)
	tiles.anchorX, tiles.anchorY = .5, 0
	tiles.x, tiles.y = display.contentCenterX, 750

	
	-- -- all display objects must be inserted into group
	sceneGroup:insert( farBackground )
	sceneGroup:insert( tiles)
	-- sceneGroup:insert( background )
	-- sceneGroup:insert( grass)
	-- sceneGroup:insert( crate )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		local person = {}
		local i = 0
		timer.performWithDelay( 1500, function()
			local randomNumber = math.random( )
			if (randomNumber > .75) then
				i = i+1
				person[i] = opponent:new(true)
			end
		end, -1 )

		-- give a touch listener on screen
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene