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


	local x = display.contentCenterX
	local y = display.viewableContentHeight

	local farBackground = display.newImage( imageLocation.background3D)
	farBackground.anchorX, farBackground.anchorY = .5, 1
	farBackground.x, farBackground.y = x, y

	-- local tiles = display.newImageRect( imageLocation.floor3D, 1280*.6, 1440*.6)
	-- tiles.anchorX, tiles.anchorY = .5, 0
	-- tiles.x, tiles.y = display.contentCenterX, 750
	-- farBackground:toBack( )
	-- tiles:toBack( )

	local listenerBox = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	self.listenerBox = listenerBox
	listenerBox.anchorX, listenerBox.anchorY = .5, 0
	listenerBox.x, listenerBox.y = halfW, 0
	listenerBox:addEventListener( "touch", self )
	listenerBox.alpha = .01


	local spriteLocation = sprite[7].location
	local sheetData =  sprite[7].sheetData
	local mySheet = graphics.newImageSheet( spriteLocation, sheetData )
	local sequenceData = sprite[7].sequenceData
	local animatedTiles = display.newSprite( mySheet, sequenceData )
	animatedTiles.anchorX, animatedTiles.anchorY = .5, 0
	animatedTiles.x, animatedTiles.y = display.contentCenterX, 720

	local peopleFar = display.newGroup( )
	self.peopleFar = peopleFar

	local peopleClose = display.newGroup( )
	self.peopleClose = peopleClose

	animatedTiles:play()

	local person = {}
	self.personGroup = person
	local i = 0

	local function switchGroup(i)
		timer.performWithDelay( 1001, function()
			print( "removing " .. tostring( i ))
			-- peopleFar:remove(person[i])
			-- person[i].x = person[i].x + -1*(peopleClose.x)
			peopleClose:insert(person[i])
			for j=i,0,-1 do
				if (person [j]) then
					if (person[j].isLive) then
						person[j]:toFront( )
					end
				end
			end
			
		end )
	end

	timer.performWithDelay( 3500, function()
		local randomNumber = math.random( )
		if (randomNumber) then
			i = i+1
			-- print( "Le wild person appear" )
			person[i] = opponent:new(true, peopleClose)
			person[i].isLive = true
			-- person[i].x = math.random(0, display.contentWidth)
			-- peopleClose:insert(person[i])
			person[i].x = person[i].x + -1*(peopleFar.x)
			peopleFar:insert(person[i])
			person[i]:toBack( )
			switchGroup(i)
			removePerson(person[i])
		end
	end, -1 )
	
	-- -- all display objects must be inserted into group
	sceneGroup:insert( farBackground )
	sceneGroup:insert( peopleFar)
	sceneGroup:insert( animatedTiles)
	sceneGroup:insert( listenerBox)
	sceneGroup:insert( peopleClose)
end

function removePerson(object)
	timer.performWithDelay( 8000, function()
		object.isLive = false
	end )
end

function scene:touch( event )
	if (event.target == self.listenerBox) then
	    if event.phase == "began" then

	        self.markX = self.peopleClose.x    -- store x location of object
		
	    elseif event.phase == "moved" then
		
	        -- local x = (event.x - event.xStart) + self.markX
        elseif event.phase == "ended" then
        	-- "move" to right/left by tapping
	        local xPos
	        print( event.x )

	        if (event.x > 320 ) then
	        	xPos = self.markX - display.contentWidth/3
	        else
	        	xPos = self.markX + display.contentWidth/3
	        end

	        transition.to( self.peopleClose, {time = 300, x = xPos, transition = easing.inOutSine} )
	        transition.to( self.peopleFar, {time = 300, x = xPos, transition = easing.inOutSine} )
        	-- switch to gamePlay2D
	        local yDrag = event.y - event.yStart
	        -- print( yDrag )
	        if (yDrag < - 200) then
	        	composer.gotoScene("gamePlay2D")
	        end
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