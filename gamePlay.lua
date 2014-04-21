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

-- gamePlay required files
local imageData  = require "AssetLocation"
local personComponent = require "component.opponent"
local playerComponent = require "component.player"
local coinComponent = require "component.coin"
local scoreFile = require "score"
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	local sceneGroup = self.view
	sceneGroup:addEventListener( "movePhone", self )
	sceneGroup:addEventListener( "gameOver", self )

	-- GAMEPLAY 3D
	local gamePlay3D = display.newGroup( )
	self.gamePlay3D = gamePlay3D

	local x = display.contentCenterX
	local y = display.viewableContentHeight

	local farBackground = display.newImage( imageLocation.background3D)
	farBackground.anchorX, farBackground.anchorY = .5, 1
	farBackground.x, farBackground.y = x, y

	local listenerBox = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	self.listenerBox = listenerBox
	listenerBox.anchorX, listenerBox.anchorY = .5, 0
	listenerBox.x, listenerBox.y = halfW, 0
	listenerBox:addEventListener( "touch", self )
	listenerBox.alpha = .01

	-- so fake 3D moving tiles
	local spriteLocation = sprite[7].location
	local sheetData =  sprite[7].sheetData
	local mySheet = graphics.newImageSheet( spriteLocation, sheetData )
	local sequenceData = sprite[7].sequenceData
	local animatedTiles = display.newSprite( mySheet, sequenceData )
	animatedTiles.anchorX, animatedTiles.anchorY = .5, 0
	animatedTiles.x, animatedTiles.y = display.contentCenterX, 720

	local mySheet2 = graphics.newImageSheet( sprite[8].location, sprite[8].sheetData )
	local sequenceData2 = sprite[8].sequenceData
	local animatedTilesRight = display.newSprite( mySheet2, sequenceData2 )
	animatedTilesRight.anchorX, animatedTilesRight.anchorY = .5, 0
	animatedTilesRight.x, animatedTilesRight.y = display.contentCenterX, 720

	local mySheet3 = graphics.newImageSheet( sprite[9].location, sprite[9].sheetData )
	local sequenceData3 = sprite[9].sequenceData
	local animatedTilesLeft = display.newSprite( mySheet3, sequenceData3 )
	animatedTilesLeft.anchorX, animatedTilesLeft.anchorY = .5, 0
	animatedTilesLeft.x, animatedTilesLeft.y = display.contentCenterX, 720

	self.tiles = animatedTiles
	self.tilesRight = animatedTilesRight
	self.tilesLeft = animatedTilesLeft

	-- Groups of people passing by
	local peopleFar = display.newGroup( )
	self.peopleFar = peopleFar

	local peopleClose = display.newGroup( )
	self.peopleClose = peopleClose

	animatedTiles:play()
	animatedTilesRight:play()
	animatedTilesLeft:play()

	local person = {}
	self.personGroup = person
	local i = 0

	-- receive final position of closePeople, determining the game over
	local function listenerFunction(event)
		-- print( tostring( event.position ) )
		print("ALERT EVENT POSITION " .. tostring( event.position ) )
		if ((event.position > -50) and (event.position < display.contentWidth + 50 )) then
			if (sceneGroup.animation) then
				if (self.gamePlay == "gamePlay2D") then
					sceneGroup:dispatchEvent( {name = "gameOver", state = "crushed2D"} )
				elseif (self.gamePlay == "gamePlay3D") then
					sceneGroup:dispatchEvent( {name = "gameOver", state = "crushed3D"} )
				end
			end
		end
	end

	local function switchGroup(i)
		timer.performWithDelay( 1001, function()
			-- print( "removing " .. tostring( i ))
			if (person[i]) and peopleClose and sceneGroup.animation then
				peopleClose:insert(person[i])
				for j=i,0,-1 do
					if (person [j]) then
						if (person[j].isLive) then
							person[j]:toFront( )
						end
					end
				end
			end
		end )
	end


	local function removePerson(object)
		timer.performWithDelay( 8900, function()
			-- if the object still exist, remove listener
			if (sceneGroup.animation) then
				object.isLive = false
				object:removeEventListener( "personOnScreen", listenerFunction )
			end
		end )
	end

	timer.performWithDelay( 3500, function()
		local randomNumber = math.random( )
		if (randomNumber > .35) then
			if (sceneGroup.animation) then
				i = i+1
				person[i] = opponent:new(true, peopleClose, i)
				person[i].isLive = true
				person[i].x = person[i].x + -1*(peopleFar.x)
				peopleFar:insert(person[i])
				person[i]:toBack( )
				switchGroup(i)
				removePerson(person[i])
				person[i]:addEventListener( "personOnScreen", listenerFunction )
			end
		end
	end, -1 )
	animatedTilesRight.alpha = 0
	animatedTilesLeft.alpha = 0
	-- animatedTiles.alpha = 0
	
	-- -- all display objects must be inserted into group
	gamePlay3D:insert( farBackground )
	gamePlay3D:insert( peopleFar)
	gamePlay3D:insert( animatedTiles)
	gamePlay3D:insert( animatedTilesRight)
	gamePlay3D:insert( animatedTilesLeft)
	gamePlay3D:insert( listenerBox)
	gamePlay3D:insert( peopleClose)

	--=============================================================================================
	-- gamePlay2D
	local gamePlay2D = {}
	self.gamePlay2D = gamePlay2D

	-- local world2D = display.newContainer(display.contentWidth/4, display.contentHeight/4 )
	-- self.world2D = world2D

	gamePlay2D.coins = display.newGroup( )
	gamePlay2D.frame = display.newGroup( )
	gamePlay2D.display = display.newGroup( )
	gamePlay2D.display.anchorChildren = true
	gamePlay2D.frame.anchorChildren = true
	-- print( gamePlay2D.display.x, gamePlay2D.display.y )
	-- -- print( gamePlay2D.frame.x, gamePlay2D.frame.y )
	gamePlay2D.display.x, gamePlay2D.display.y = display.contentCenterX, display.contentCenterY
	gamePlay2D.frame.x, gamePlay2D.frame.y = display.contentCenterX, display.contentCenterY

	-- world2D:insert( gamePlay2D.display )
	gamePlay2D.display.anchorX, gamePlay2D.display.anchorY = .5, .5
	gamePlay2D.frame.anchorX, gamePlay2D.frame.anchorY = .5, .48
	-- gamePlay2D.display:insert( gamePlay2D.frame )

	sceneGroup.animation = true
	-- sceneGroup.coins = display.newGroup( )
	
	Runtime:addEventListener( "gameOver", sceneGroup )


	function sceneGroup:floor( onMove )

		local delta = 12
		local x = display.contentCenterX
		local y = display.viewableContentHeight
		local _2DFloor = {}

		local newFloor = display.newGroup( )

		function newFloor:init( )
			local nothing = display.newRect( display.contentCenterX, display.contentCenterY, 2000, 1 )
			nothing.anchorX, nothing.anchorY = .5, .5
			scene.gamePlay2D.display:insert( nothing )
			nothing.isVisible = false

			for i=1,2 do
				_2DFloor[i] = display.newImage( imageLocation.floor )
				_2DFloor[i].anchorX, _2DFloor[i].anchorY = 1,1
				_2DFloor[i].x, _2DFloor[i].y = x+((_2DFloor[i].width)*(i-1)) - 7*(i-1), y
				_2DFloor[i].onScreen = true
				gamePlay2D.display:insert( _2DFloor[i] )
			end
		end

		function newFloor:removePhysicsProp( object)
			physics.removeBody( object )
		end

		function newFloor:check( object )
			if object.x  > display.contentWidth then
				object.x = x
			end
		end

		function newFloor:move()
			local function move( )
				if sceneGroup.animation then
					for i=1,2 do
						_2DFloor[i].x = _2DFloor[i].x - delta
					end

					if _2DFloor[1].x < 0 then
						_2DFloor[1].x = _2DFloor[2].x + _2DFloor[1].width - 7
					end

					if _2DFloor[2].x < 0 then
						_2DFloor[2].x = _2DFloor[1].x + _2DFloor[1].width - 7
					end
				else 
					Runtime:removeEventListener( "enterFrame", move )
				end	
			end

			Runtime:addEventListener( "enterFrame", move )
		end

		function newFloor:addFloor( )
			
		end

		newFloor:init()
		newFloor:move()

		return newFloor
	end


	function sceneGroup:background( onMove )

		local delta = .2
		local x = display.contentCenterX
		local y = display.contentHeight
		local _2Dbackground= {}

		local newBg = display.newGroup( )

		self:insert( newBg )

		function newBg:init( )
			for i=1,2 do
				_2Dbackground[i] = display.newImage( imageLocation.background2D )
				_2Dbackground[i].anchorX, _2Dbackground[i].anchorY = .5,1
				_2Dbackground[i].x, _2Dbackground[i].y = x+((_2Dbackground[i].width)*(i-1))-7*(i-1), y
				_2Dbackground[i].onScreen = true
				gamePlay2D.display:insert( _2Dbackground[i] )
				-- world2D:insert( _2Dbackground[i] )
			end

		end

		function newBg:removePhysicsProp( object)
			physics.removeBody( object )
		end

		function newBg:check( object )
			if object.x  > display.contentWidth then
				object.x = x
			end
		end

		function newBg:move()
			local function move( )
				if sceneGroup.animation then
					for i=1,2 do
						_2Dbackground[i].x = _2Dbackground[i].x  - delta
					end

					if _2Dbackground[1].x < - display.contentWidth/2 then
						_2Dbackground[1].x = _2Dbackground[2].x+ _2Dbackground[1].width - 7
					end

					if _2Dbackground[2].x < - display.contentWidth/2 then
						_2Dbackground[2].x = _2Dbackground[1].x+ _2Dbackground[2].width - 7
					end
				else
					Runtime:removeEventListener( "enterFrame", move )
				end
				
			end

			Runtime:addEventListener( "enterFrame", move )
		end


		newBg:init()
		newBg:move()

		return newBg
	end

	function sceneGroup:addcoins( )
		local num = math.random(1,100 )
		local y = math.random(display.contentCenterY - 500, display.contentCenterY + 200)
		-- local y = display.contentCenterY + 150
		-- local time = math.random( 2000, 10000 )
		local time = math.random(200, 1200)

		timer.performWithDelay( time, function ( )
			if (sceneGroup.animation) then
				if num > 60 then
					local coins = coinRed:new( display.contentWidth , y );
					gamePlay2D.display:insert( coins )
				else
					local coins = coinYellow:new( display.contentWidth , y )
					gamePlay2D.display:insert( coins )
				end
			end
			if self.animation then self:addcoins() end
		end )
	end

	function sceneGroup:addForeTouch( )
		local rect = display.newRect( display.contentCenterX, display.contentCenterY, display.viewableContentWidth, display.contentHeight )
		gamePlay2D.display:insert( rect )
		self.rect = rect
		rect.alpha = 0.01

		rect:addEventListener( "touch", self )
	end

	local background = sceneGroup:background( sceneGroup.animation)
	local floors = sceneGroup:floor( sceneGroup.animation)
	sceneGroup:addcoins( )
	sceneGroup:addForeTouch()

	local player1 = player:new( "start", sceneGroup)
	player1.anchorX, player1.anchorY = .5, .5
	self.player = player1
	self.gamePlay2D.display:insert(player1)

	-- reverse animation
	local function switchGamePlay(event)
		if (event.phase == "ended") then
			transition.cancel("swingPhone")
			self.gamePlay = "gamePlay2D"
			transition.to( scene.gamePlay2D.display, {time = 500, rotation = 0, y = display.contentCenterY, onComplete = function()
				transition.to( scene.gamePlay2D.display, {time = 300, x = display.contentCenterX, y = display.contentCenterY, xScale = 1, yScale = 1} )
			end } )
			transition.to( scene.gamePlay2D.frame, {time = 500, rotation = 0, y = display.contentCenterY, onComplete = function()
				sceneGroup:removeFrameListener()
				transition.to( scene.gamePlay2D.frame, {time = 300, x = display.contentCenterX, y = display.contentCenterY, xScale = 1, yScale = 1} )
			end } )
		end
		return true
	end

	-- add/remove event listener to phone frame (reverse animation)
	function sceneGroup:addFrameListener()
		scene.gamePlay2D.frame:addEventListener( "touch", switchGamePlay )
	end
	function sceneGroup:removeFrameListener()
		scene.gamePlay2D.frame:removeEventListener( "touch", switchGamePlay )
	end

	function sceneGroup:touch(e)
		-- if drag to bottom, switch to gamePlay3D
		if (e.target == self.rect) then
			if e.phase == "ended" then
				-- switch to gamePlay3D
				local yDrag = e.y - e.yStart
				if (yDrag > 200) then
					scene.gamePlay = "gamePlay3D"
					transition.to( scene.gamePlay2D.display, { time = 300, x = display.contentCenterX, xScale = .5, yScale = .5, onComplete = function()
						transition.to( scene.gamePlay2D.display, {time = 600, x = display.contentCenterX, y = display.contentHeight+200} )
					end} )
					transition.to( scene.gamePlay2D.frame, { time = 300, x = display.contentCenterX, xScale = .5, yScale = .5, onComplete = function()
						self.addFrameListener()
						transition.to( scene.gamePlay2D.frame, {time = 600, x = display.contentCenterX, y = display.contentHeight+200, onComplete = function()
							self:dispatchEvent( {name = "movePhone", direction = "updown"} )
						end} )
					end} )
				else
					player1:jump()
				end
			end
			return true
		end
	end

	function sceneGroup:gameOver( )
		print( "DISPATCH GAMEOVER" )
		if (sceneGroup.animation) then
			self:dispatchEvent( {name = "gameOver", state = "redCollision"} )
		end
	end

	-- create screen masking
	local screenMask = graphics.newMask( imageLocation.maskScreen, system.ResourceDirectory )
	gamePlay2D.display:setMask( screenMask )
	gamePlay2D.display.maskX, gamePlay2D.display.maskY = display.contentCenterX, display.contentCenterY +40
	gamePlay2D.display.maskScaleX, gamePlay2D.display.maskScaleY = 1.12, 1.12


	-- create iPhone frame
	local phoneFrame = display.newImageRect( gamePlay2D.frame, imageLocation.iPhone, 840, 1680 )
	phoneFrame.anchorX, phoneFrame.anchorY = .5, .5
	phoneFrame.x, phoneFrame.y = display.contentCenterX, display.contentCenterY+100
	phoneFrame.xScale, phoneFrame.yScale = 1.1, 1.1
	phoneFrame.alpha = 1
	phoneFrame:toFront( )


	--============================================================ game over animation assets
	-- 2D tiles (for gameOverAnimation)
	local tiles2D = display.newImageRect(imageLocation.floor3D, display.contentHeight, display.contentHeight*1.18 )
	tiles2D.anchorX, tiles2D.anchorY = .5, .5
	tiles2D.x, tiles2D.y = display.contentCenterX, display.contentCenterY
	tiles2D.isVisible = false

	-- phone crack sprite
	local crackSheet = graphics.newImageSheet( sprite[5].location, sprite[5].sheetData )
	local crackSequence = sprite[5].sequenceData
	local screenCrack = display.newSprite( crackSheet, crackSequence )
	screenCrack.anchorX, screenCrack.anchorY = .5,.5
	screenCrack.x, screenCrack.y = display.contentCenterX, display.contentCenterY
	screenCrack.isVisible = false

	-- blood splatter sprite
	local splatterSheet = graphics.newImageSheet( sprite[6].location, sprite[6].sheetData )
	local splatterSequence = sprite[6].sequenceData
	local splatter = display.newSprite( splatterSheet, splatterSequence )
	splatter.anchorX, splatter.anchorY = .5,.5
	splatter.x, splatter.y = display.contentCenterX, display.contentCenterY
	splatter.isVisible = false

	self.tiles2D = tiles2D
	self.screenCrack = screenCrack
	self.splatter = splatter

	gamePlay2D.display:insert( screenCrack)

	-- insert gamePlay2D and gamePlay3D to sceneGroup (gamePlay3D in the back)
	sceneGroup:insert( gamePlay3D)
	sceneGroup:insert( tiles2D)
	sceneGroup:insert( splatter)
	sceneGroup:insert( gamePlay2D.display)
	sceneGroup:insert( gamePlay2D.coins)
	sceneGroup:insert( gamePlay2D.frame)

end

function scene:touch( event )
	local sceneGroup = self.view

	if (event.target == self.listenerBox) then
	    if event.phase == "began" then

	        self.markX = self.peopleClose.x    -- store x location of object
		
	    elseif event.phase == "moved" then
		
	        -- local x = (event.x - event.xStart) + self.markX
        elseif event.phase == "ended" then
        	-- "move" to right/left by tapping
	        local xPos
	        local slideTime = 500
	        self.slideTime = slideTime

	        if (event.x > 320 ) then
	        	xPos = self.markX - display.contentWidth/2
		        self.tilesRight.alpha = 1
		        self.tiles.alpha = 0
		        timer.performWithDelay( slideTime, function()
		        	self.tiles.alpha = 1
		        	self.tilesRight.alpha = 0
		        end )
		        sceneGroup:dispatchEvent( {name = "movePhone", direction = "right" } )
	        else
	        	xPos = self.markX + display.contentWidth/2
	        	self.tilesLeft.alpha = 1
		        self.tiles.alpha = 0
		        timer.performWithDelay( slideTime, function()
		        	self.tiles.alpha = 1
		        	self.tilesLeft.alpha = 0
		        end )
		        sceneGroup:dispatchEvent( {name = "movePhone", direction = "left" } )
	        end


	        transition.to( self.peopleClose, {time = slideTime, x = xPos, transition = easing.inOutSine} )
	        transition.to( self.peopleFar, {time = slideTime, x = xPos, transition = easing.inOutSine} )
	    end
	    return true
	end
end

function scene:movePhone(event)
	local sceneGroup = scene.view
	local direction = event.direction

	if (direction == "updown" ) then
		transition.to( scene.gamePlay2D.display, {time = 300, tag = "swingPhone", y = display.contentHeight+185, onComplete = function()
			transition.to( scene.gamePlay2D.display, {time = 300, tag = "swingPhone", y = display.contentHeight+200})
		end} )

		transition.to( scene.gamePlay2D.frame, {time = 300, tag = "swingPhone", y = display.contentHeight+185, onComplete = function ()
			transition.to( scene.gamePlay2D.frame, {time = 300, tag = "swingPhone", y = display.contentHeight+200, onComplete = function()
				if (scene.gamePlay == "gamePlay3D") and (sceneGroup.animation) then
					sceneGroup:dispatchEvent( {name = "movePhone", direction = "updown" } )
				end
			end})
		end} )
	elseif (direction == "right") then
		transition.pause("swingPhone")
		transition.to( scene.gamePlay2D.display, {time = scene.slideTime/2, tag = "tapRight",rotation = 5, onComplete = function()
			transition.to( scene.gamePlay2D.display, {time = scene.slideTime/2, tag = "tapRight", rotation = 0} )
		end} )
		transition.to( scene.gamePlay2D.frame, {time = scene.slideTime/2, tag = "tapRight",rotation = 5, onComplete = function()
			transition.to( scene.gamePlay2D.frame, {time = scene.slideTime/2, tag = "tapRight", rotation = 0, onComplete = function()
				transition.resume("swingPhone")
			end} )
		end} )
	elseif (direction == "left") then
		transition.pause("swingPhone")
		transition.to( scene.gamePlay2D.display, {time = scene.slideTime/2, tag = "tapLeft",rotation = -5, onComplete = function()
			transition.to( scene.gamePlay2D.display, {time = scene.slideTime/2, tag = "tapLeft", rotation = 0} )
		end} )
		transition.to( scene.gamePlay2D.frame, {time = scene.slideTime/2, tag = "tapLeft",rotation = -5, onComplete = function()
			transition.to( scene.gamePlay2D.frame, {time = scene.slideTime/2, tag = "tapLeft", rotation = 0, onComplete = function()
				transition.resume("swingPhone")
			end} )
		end} )
	end
end

function scene:gameOver(event)
	local sceneGroup = self.view
	local state = event.state
	print( "blabalas " .. tostring(event.state) )

	animation = false
	sceneGroup.animation = false
	Runtime:dispatchEvent( {name = "turnTranslationOff", state = state } )
	sceneGroup.rect:removeEventListener( "touch", self )


	local function toFinishGame(options)
		composer.gotoScene("finishGame", options)
	end

	local function gameOverAnimation(sequence)



	end


	local options = {
		effect = "crossFade",
		time = 1200,
		params = {
	        state = state
	    }
	}

	if (state == "redCollision") then
		-- blood
		-- transition.to( scene.player, {rotation = -90} )
		scene.splatter.isVisible = true
		scene.splatter:toFront( )
		scene.splatter:play()
		timer.performWithDelay( 1200, function ()
			toFinishGame(options)
		end )
	elseif (state == "crushed2D") then
		-- animation 2D crack, blood
		scene.screenCrack.isVisible = true
		scene.screenCrack:toFront( )
		scene.tiles2D.isVisible = true
		scene.screenCrack:play()
		transition.to( scene.gamePlay2D.display, {delay = 800, xScale = .5, yScale = .5} )
		transition.to( scene.gamePlay2D.frame, {delay = 800, xScale = .5, yScale = .5, onComplete = function ()
			scene.splatter.isVisible = true
			scene.splatter:toFront( )
			scene.splatter:play()
			timer.performWithDelay( 1200, function ()
				toFinishGame(options)
			end )
		end} )
	elseif (state == "crushed3D") then
		-- animation 3D, blood
		scene.tiles:pause( )
		scene.tilesRight:pause()
		scene.tilesLeft:pause()
		transition.to( scene.gamePlay2D.frame, {time = 500, y = display.contentHeight-400, onComplete = function()
			transition.to( scene.gamePlay2D.frame, {time = 1000, y = display.contentHeight + 450, x = 140, rotation = 90, transition = easing.inOutSine} )
		end} )
		transition.to( scene.gamePlay2D.display, {time = 500, y = display.contentHeight-400, onComplete = function()
			scene.splatter.isVisible = true
			scene.splatter:play()
			timer.performWithDelay( 1500, function ()
				toFinishGame(options)
			end )
			transition.to( scene.gamePlay2D.display, {time = 1000, y = display.contentHeight + 450, x = 140, rotation = 90, transition = easing.inOutSine} )
		end} )
	end
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		animation = true
		sceneGroup.animation = true

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		self.gamePlay = "gamePlay2D"
		physics.start( true )
		physics.setGravity( 0, 30 )
		physics.setDrawMode( "hybrid" )
		Runtime:dispatchEvent( {name = "score", value = 0} )
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		animation = false
		self.animation = false
		print( "set animation false" )
		-- sceneGroup:removeSelf( )
		sceneGroup.animation = false
		scene.gamePlay2D.coins:removeSelf( )
		scene.gamePlay2D.coins = nil
		physics.stop( )
	elseif phase == "did" then
		-- physics.stop()
		composer.removeScene("gamePlay")
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )
	local sceneGroup = self.view
	print( "destroying scene" )
	-- animation = false
	sceneGroup:removeEventListener( "movePhone", self )
	Runtime:removeEventListener( "gameOver", sceneGroup )
	package.loaded[physics] = nil
	physics = nil

	sceneGroup:removeSelf( )
	sceneGroup = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene