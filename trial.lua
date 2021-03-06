-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local imageData  = require "AssetLocation"
local fileService = require "readFile"
local facebookfile = require "services.facebookService"



--------------------------------------------

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local scoreTxt 


function scene:create( event )

	local sceneGroup = self.view

	function sceneGroup:init( )
		local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth , display.contentHeight )
		background:setFillColor( 20/255,55/255,55/255 )
		self:insert( background)

		local location = imageLocation.text.fired
		local firedTextx = display.newImage(location , display.contentCenterX, display.contentHeight*(145/679) )
		self:insert( firedTextx ); firedTextx.anchorY = 0

		local description = "red coin is a trap" 
		local textDesc = display.newText( self, description, display.contentCenterX, display.contentHeight*(195/679),  "Half Bold Pixel-7", 40  )
		textDesc.anchorY = 0
		
		local scoreBoard = display.newImage( imageLocation.scoreBoard, display.contentCenterX, display.contentHeight*(244/679) )
		self:insert( scoreBoard)
		scoreBoard.anchorY = 0

		local okayBtn = display.newImage( imageLocation.button.okay , display.contentWidth*.25, display.contentHeight*(471/679) )
		okayBtn.name  = "okayBtn"
		self:insert(okayBtn)
		okayBtn:addEventListener( "touch", self )
		okayBtn.anchorY = 0

		local shareBtn = display.newImage( imageLocation.button.share, display.contentWidth*.75, display.contentHeight*(471/679) )
		shareBtn.name  = "shareBtn"
		self:insert( shareBtn )
		shareBtn:addEventListener( "touch", self )
		shareBtn.anchorY = 0

		-- scoreTxt = display.newText( self, "", display.contentWidth*(92/321) , display.contentHeight*(300/567),  "Visitor TT1 BRK", 120  )

		-- local highSCoreTxt = display.newText( self, tostring(settings.highScore), display.contentWidth*(235/321) , display.contentHeight*(300/567),  "Visitor TT1 BRK", 120  )
		timer.performWithDelay( 800, function()
			-- phone crack sprite
			local crackSheet = graphics.newImageSheet( sprite[5].location, sprite[5].sheetData )
			local crackSequence = sprite[5].sequenceData
			local screenCrack = display.newSprite( crackSheet, crackSequence )
			screenCrack.anchorX, screenCrack.anchorY = .5,.5
			screenCrack.x, screenCrack.y = display.contentCenterX, display.contentCenterY

			screenCrack:play( )

			-- blood splatter sprite
			local splatterSheet = graphics.newImageSheet( sprite[6].location, sprite[6].sheetData )
			local splatterSequence = sprite[6].sequenceData
			local splatter = display.newSprite( splatterSheet, splatterSequence )
			splatter.anchorX, splatter.anchorY = .5,.5
			splatter.x, splatter.y = display.contentCenterX, display.contentCenterY

			splatter:play( )
		end )
	end

	function sceneGroup:touch(e)
		if e.phase == "ended" then 
			local callback
			if e.target.name == "okayBtn" then
				function callback( )
					composer.gotoScene( "menu" )
				end
			elseif e.target.name == "shareBtn" then
				function callback( )
					local share = facebookService:new(settings.currentScore)
				end
			end

			self:buttonAnimation(e.target, callback)
		end
	end

	function sceneGroup:buttonAnimation(object, callback )
		object.alpha = .8
		transition.to( object, {time = 800, onComplete = callback} )
		timer.performWithDelay( 800, function ( )
			object.alpha = 1
		end )
	end
	sceneGroup:init()

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- local currentTxt = 0
		-- local function scrolltext( )
		-- 	if currentTxt <= settings.currentScore then
		-- 		scoreTxt.text = tostring(currentTxt)
		-- 		currentTxt = currentTxt + 1
		-- 		timer.performWithDelay( 100, scrolltext )
		-- 	end
		-- end
		-- scrolltext()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		
		
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