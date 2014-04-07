-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local imageData  = require "AssetLocation"
local playerComponent = require "component.player"

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local animation = start

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view


	function sceneGroup:floor( onMove )

		local delta = 4
		local x = display.contentCenterX
		local y = display.viewableContentHeight
		local _2DFloor = {}

		local newFloor = display.newGroup( )

		function newFloor:init( )
			for i=1,2 do
				_2DFloor[i] = display.newImage( imageLocation.floor )
				_2DFloor[i].anchorX, _2DFloor[i].anchorY = 1,1
				_2DFloor[i].x, _2DFloor[i].y = x+((_2DFloor[i].width)*(i-1)), y
				_2DFloor[i].onScreen = true
				self:insert( _2DFloor[i] )
				physics.addBody( _2DFloor[i], "static" , {density=1, friction=0, bounce=0 } )
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
				if onMove then
					for i=1,2 do
						_2DFloor[i].x = _2DFloor[i].x - delta
						-- newFloor:check(_2DFloor[i])
					end

					if _2DFloor[1].x < 0 then
						_2DFloor[1].x = _2DFloor[2].x + _2DFloor[1].width
					end

					if _2DFloor[2].x < 0 then
						_2DFloor[2].x = _2DFloor[1].x + _2DFloor[1].width
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
	end


	function sceneGroup:background( onMove )

		local delta =1
		local x = display.contentCenterX
		local y = display.contentHeight - 160
		local _2Dbackground= {}

		local newBg = display.newGroup( )

		function newBg:init( )
			for i=1,2 do
				_2Dbackground[i] = display.newImage( imageLocation.background2D )
				_2Dbackground[i].anchorX, _2Dbackground[i].anchorY = 1,1
				_2Dbackground[i].x, _2Dbackground[i].y = x+((_2Dbackground[i].width)*(i-1)), y
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
				if onMove then
					for i=1,2 do
						_2Dbackground[i].x = _2Dbackground[i].x  - delta
					end

					if _2Dbackground[1].x < 0 then
						_2Dbackground[1].x = _2Dbackground[2].x+ _2Dbackground[1].width
					end

					if _2Dbackground[2].x < 0 then
						_2Dbackground[2].x = _2Dbackground[1].x+ _2Dbackground[1].width
					end
				else
					Runtime:removeEventListener( "enterFrame", move )
				end
				
			end

			Runtime:addEventListener( "enterFrame", move )
		end


		newBg:init()
		newBg:move()
	end

	function sceneGroup:addCoins( )
		
	end

	
	-- require "physics"
	-- physics.start( )
	-- physics.setGravity( 0, 9.8 )
	-- -- physics.setDrawMode( "hybrid" )

	-- require "component.player"
	-- require "component.coin"

	-- player1 = player:new( )

	-- --randomcoins

	-- local coins = {}

	-- local function addCoin( )
	-- 	

	-- end
	-- addCoin( )


	-- function listen(event )
	-- 	if (event.phase == "ended") then
	-- 		player1:jump()
	-- 	end
	-- end

	-- Runtime:addEventListener( "touch", listen )

	-- Runtime:addEventListener("collision" , function (e )

	-- 	print( e.object1.name )
	-- 	if e.phase == "began" then
	-- 		-- print( ... )
	-- 		if e.object1.name == "coin" then e.object1.isVisible = false
	-- 		elseif e.object2.name == "coin" then  e.object2.isVisible = false
	-- 		end
	-- 	end

		
	-- end)

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		animation = true

		local floors = sceneGroup:floor( animation)
		sceneGroup:insert( floors )
		local background = sceneGroup:background( animation)
		sceneGroup:insert( background )

		local player1 = player:new( "start")

	elseif phase == "did" then
		physics.start( )
		physics.setDrawMode( "hybrid" )
		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		animation = false
		physics.stop( )
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )
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