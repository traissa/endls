-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local imageData = require ("AssetLocation")
local physics = require "physics"
local playerComponent = require "component.player"
local fileService = require "readFile"

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

		-- local title = display.newText( self, "endless", display.contentCenterX , .3* display.contentHeight , "Visitor TT1 BRK" , 120 )
		-- title:setFillColor(  119/255, 86/255,41/255 )

		local title = display.newImage( imageLocation.title, display.contentCenterX, display.contentHeight*(231/679) )
		self:insert(title)

		local playBtn = display.newImage( imageLocation.button.play , display.contentWidth*.25, display.contentHeight*(331/679) )
		playBtn.name  = "playBtn"
		self:insert(playBtn)
		playBtn:addEventListener( "touch", self )

		local rateBtn = display.newImage( imageLocation.button.rate, display.contentWidth*.75, display.contentHeight*(331/679) )
		rateBtn.name  = "rateBtn"
		self:insert( rateBtn )
		rateBtn:addEventListener( "touch", self )
	end

	function sceneGroup:touch (e )
		if e.phase == "ended"  then
			local callback
			if e.target.name == "playBtn" then
				function callback( )
					-- composer.gotoScene( "gamePlay3D" )
					composer.gotoScene( "gamePlay2D")
				end
			elseif e.target.name == "rateBtn" then
				function callback( )
					local device = system.getInfo("platformName")

					if device == "Android" then

					elseif device == "iPhone OS" then
						-- local yourAppID = ""

						-- local storeReviewURLApple = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8&id=" .. yourAppID

						-- system.openURL(storeReviewURLApple)   
					end
				end
			end
			self:buttonAnimation(e.target, callback)
		end
	end

	function sceneGroup:buttonAnimation(object, callback )
		object.alpha = .8
		transition.to( object, {time = 800, onComplete = callback} )
		timer.performWithDelay( 800, function ()
			object.alpha = 1
		end )
	end

	sceneGroup:init( )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- physics.start( )
		-- physics.setGravity( 0,0 )
		-- local player1 = player:new( "start")

	
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
		settings = loadTable ("settings.json", system.DocumentsDirectory)
		if settings then
			print( "local settings found" )
			if not sound then
				audio.setVolume( 0)
			end
		else
			print("local settings not found, create table")
			settings = {}
			settings.sound = true
			settings.highScore = 0
			settings.currentScore = 0
			saveTable("settings.json", system.DocumentsDirectory, settings)
		end

	end	
end

function scene:destroy( event )
	local sceneGroup = self.view

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