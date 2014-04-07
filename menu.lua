-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local imageData = require ("AssetLocation")
local physics = require "physics"

function scene:create( event )
	local sceneGroup = self.view

	function sceneGroup:init( )
	 	local background = display.newImage( imageLocation.background2D, display.contentCenterX, display.contentCenterY )
		self:insert( background)

		local floor = display.newImage( imageLocation.floor )
		floor.x, floor.y = 0, display.contentHeight 
		floor.anchorX, floor.anchorY = 0,1
		self:insert( floor )   

		local playerComponent = require "component.player"

		-- physics.start( )
		-- local player = player:new("walk")
		-- self:insert( player)
		-- player.anchorY = 1
		-- player.y = floor.y - floor.height

		local title = display.newText( self, "endless", display.contentCenterX , .3* display.contentHeight , "Visitor TT1 BRK" , 120 )
		title:setFillColor(  119/255, 86/255,41/255 )

		local playBtn = display.newImage( imageLocation.button.play , display.contentWidth*.25, display.contentHeight*.5 )
		playBtn.name  = "playBtn"
		self:insert(playBtn)
		playBtn:addEventListener( "touch", self )

		local rateBtn = display.newImage( imageLocation.button.rate, display.contentWidth*.75, display.contentHeight*.5 )
		rateBtn.name  = "rateBtn"
		self:insert( rateBtn )
		rateBtn:addEventListener( "touch", self )
	end

	function sceneGroup:touch (e )
		if e.phase == "ended"  then
			if e.target.name == "playBtn" then
				composer.gotoScene( "gamePlay2D" )
			elseif e.target.name == "rateBtn" then
				
			end
		end
	end

	sceneGroup:init( )

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
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view

	sceneGroup:removeSelf( )
	sceneGroup = nil
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene