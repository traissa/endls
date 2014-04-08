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
	local randomPerson = display.newGroup( )
	self.randomPerson = randomPerson

	local x = display.contentCenterX
	local y = display.viewableContentHeight

	local farBackground = display.newImage( imageLocation.background3D)
	farBackground.anchorX, farBackground.anchorY = .5, 1
	farBackground.x, farBackground.y = x, y

	local tiles = display.newImageRect( imageLocation.floor3D, 1280*.6, 1440*.6)
	tiles.anchorX, tiles.anchorY = .5, 0
	tiles.x, tiles.y = display.contentCenterX, 750
	farBackground:toBack( )
	tiles:toBack( )

	local listenerBox = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	self.listenerBox = listenerBox
	listenerBox.anchorX, listenerBox.anchorY = .5, 0
	listenerBox.x, listenerBox.y = halfW, 0
	listenerBox:addEventListener( "touch", self )
	listenerBox.alpha = .01

	local person = {}
	self.personGroup = person
	local i = 0
	timer.performWithDelay( 300, function()
		local randomNumber = math.random( )
		if (randomNumber > .05) then
			i = i+1
			-- print( "Le wild person appear" )
			person[i] = opponent:new(true)
			person[i].isLive = true
			person[i].x = math.random(0, display.contentWidth)
			randomPerson:insert(person[i])

			for j=i,0,-1 do
				if (person [j]) then
					if (person[j].isLive) then
						person[j]:toFront( )
					end
				end
			end
			removePerson(person[i])
		end
	end, -1 )
	
	-- -- all display objects must be inserted into group
	sceneGroup:insert( farBackground )
	sceneGroup:insert( tiles)
	sceneGroup:insert( listenerBox)
	sceneGroup:insert( randomPerson)
end

function removePerson(object)
	timer.performWithDelay( 3000, function()
		object.isLive = false
	end )
end

function scene:touch( event )
	if (event.target == self.listenerBox) then
	    if event.phase == "began" then
		
	        self.markX = self.randomPerson.x    -- store x location of object
	        -- self.markY = self.randomPerson.y    -- store y location of object
		
	    elseif event.phase == "moved" then
		
	        local x = (event.x - event.xStart) + self.markX
	        -- local y = (event.y - event.yStart) + self.markY
	        print( x )
	        
	        self.randomPerson.x = x    -- move object based on calculations above
        elseif event.phase == "ended" then
	        -- composer.gotoScene( "gamePlay2D" )
	    end
	    return true
	end
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