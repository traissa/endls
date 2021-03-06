-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local imageData  = require "AssetLocation"
local playerComponent = require "component.player"
local coinComponent = require "component.coin"
local scoreFile = require "score"

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local animation = true

function scene:create( event )


	local sceneGroup = self.view
	sceneGroup.animation = true
	sceneGroup.coins = display.newGroup( )
	
	Runtime:addEventListener( "gameOver", sceneGroup )


	function sceneGroup:floor( onMove )

		local delta = 12
		local x = display.contentCenterX
		local y = display.viewableContentHeight
		local _2DFloor = {}

		local newFloor = display.newGroup( )

		function newFloor:init( )
			for i=1,2 do
				_2DFloor[i] = display.newImage( imageLocation.floor )
				_2DFloor[i].anchorX, _2DFloor[i].anchorY = 1,1
				_2DFloor[i].x, _2DFloor[i].y = x+((_2DFloor[i].width)*(i-1)) - 7*(i-1), y
				_2DFloor[i].onScreen = true
				self:insert( _2DFloor[i] )
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

		local delta = .1
		local x = display.contentCenterX
		local y = display.contentHeight
		local _2Dbackground= {}

		local newBg = display.newGroup( )

		self:insert( newBg )

		function newBg:init( )
			for i=1,2 do
				_2Dbackground[i] = display.newImage( imageLocation.background2D )
				_2Dbackground[i].anchorX, _2Dbackground[i].anchorY = 1,1
				_2Dbackground[i].x, _2Dbackground[i].y = x+((_2Dbackground[i].width)*(i-1))-7*(i-1), y
				_2Dbackground[i].onScreen = true
				self:insert( _2Dbackground[i] )
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

					if _2Dbackground[1].x < 0 then
						_2Dbackground[1].x = _2Dbackground[2].x+ _2Dbackground[1].width - 7
					end

					if _2Dbackground[2].x < 0 then
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
		-- local y = math.random(display.contentCenterY , display.contentCenterY + 200)
		local y = math.random(display.contentCenterY - 500, display.contentCenterY + 200)
		-- local y = display.contentCenterY + 300
		local time = math.random( 2000, 10000 )
		-- local time = 500

		timer.performWithDelay( time, function ( )
			if (self.coins) then
				if num > 50 then
					local coins = coinRed:new( display.contentWidth , y );
					self:insert( coins )
					self.coins:insert( coins )
				else
					local coins = coinYellow:new( display.contentWidth , y )
					self:insert( coins )
					self.coins:insert(coins)
				end
			end
			if animation then self:addcoins() end
		end )
	end

	function sceneGroup:addForeTouch( )
		local rect = display.newRect( display.contentCenterX, display.contentCenterY, display.viewableContentWidth, display.contentHeight )
		self:insert( rect )
		rect.alpha = 0.01

		rect:addEventListener( "touch", sceneGroup )
	end

	

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	
	-- local player1 = player:new( "start")
	
	if phase == "will" then

		animation = true
		local background = sceneGroup:background( animation)
		sceneGroup:insert( background )
		local floors = sceneGroup:floor( animation)
		sceneGroup:insert( floors )
		sceneGroup:addcoins( )

	elseif phase == "did" then
		physics.start( true )
		physics.setGravity( 0, 30 )
		-- physics.setDrawMode( "hybrid" )
		Runtime:dispatchEvent( {name = "score", value = 0} )
		-- Runtime:addEventListener("touch", sceneGroup)
		
		
		local player1 = player:new( "start", sceneGroup)

		sceneGroup:addForeTouch()

		function sceneGroup:touch(e)
			-- if drag to bottom, switch to gamePlay3D
			if e.phase == "ended" then
				player1:jump()
				-- switch to gamePlay3D
				local yDrag = e.y - e.yStart
				if (yDrag > 200) then
					Runtime:dispatchEvent( {name = "turnTranslationOff"} )
					transition.to( sceneGroup, {time = 350, y = display.contentHeight , onComplete = function()
						composer.gotoScene("gamePlay3D")
					end} )
				end
			end
		end

		function sceneGroup:gameOver( )
			animation = false
			-- physics.stop( )
			timer.performWithDelay( 10, function ( )
				composer.gotoScene( "finishGame" )
			end )
		end				
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		animation = false
		print( "set animation false" )
		-- sceneGroup:removeSelf( )
		sceneGroup.coins:removeSelf( )
		sceneGroup.coins = nil
		-- physics.stop( )
	elseif phase == "did" then
		physics.stop()
		sceneGroup.animation = false
		composer.removeScene("gamePlay2D")
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	print( "destroying scene" )
	animation = false
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