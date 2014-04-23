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
		background:setFillColor( 255/255,55/255,55/255 )
		self.background = background
		self:insert( background )

		local frontDisplay = display.newGroup( )
		sceneGroup.frontDisplay = frontDisplay
		self:insert( frontDisplay )

		local location = imageLocation.text.fired
		local firedTextx = display.newImage(location , display.contentCenterX, display.contentHeight*(145/679) )
		frontDisplay:insert( firedTextx ); firedTextx.anchorY = 0

		local textDesc = display.newText( frontDisplay, "", display.contentCenterX, display.contentHeight*(195/679),  "Half Bold Pixel-7", 40  )
		textDesc.anchorY = 0
		self.textDesc = textDesc
		
		local scoreBoard = display.newImage( imageLocation.scoreBoard, display.contentCenterX, display.contentHeight*(244/679) )
		frontDisplay:insert( scoreBoard)
		scoreBoard.anchorY = 0

		local okayBtn = display.newImage( imageLocation.button.okay , display.contentWidth*.25, display.contentHeight*(471/679) )
		okayBtn.name  = "okayBtn"
		frontDisplay:insert(okayBtn)
		okayBtn:addEventListener( "touch", self )
		okayBtn.anchorY = 0

		local shareBtn = display.newImage( imageLocation.button.share, display.contentWidth*.75, display.contentHeight*(471/679) )
		shareBtn.name  = "shareBtn"
		frontDisplay:insert( shareBtn )
		shareBtn:addEventListener( "touch", self )
		shareBtn.anchorY = 0

		local scoreTxt = display.newText( frontDisplay, "0", display.contentWidth*(92/321) , display.contentHeight*(300/567),  "Visitor TT1 BRK", 120  )
		self.scoreTxt = scoreTxt

		local highSCoreTxt = display.newText( frontDisplay, tostring(settings.highScore), display.contentWidth*(235/321) , display.contentHeight*(300/567),  "Visitor TT1 BRK", 120  )
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
		if (event.params.state == "redCollision" ) then
			sceneGroup.textDesc.text = "red coin is a trap!!" 
		elseif (event.params.state == "crushed2D") then
			sceneGroup.textDesc.text = "mind the pedestrians!!"
		elseif (event.params.state == "crushed3D") then
			sceneGroup.textDesc.text = "you're crushed!!"
		end

		sceneGroup.scoreTxt.text = "0"

		sceneGroup.frontDisplay.alpha = 0

		transition.to( sceneGroup.frontDisplay, {alpha = 1, onComplete = function()
		  	-- sceneGroup:insert( self.background )
		end} )
	elseif phase == "did" then

		local currentTxt = 0
		local function scrolltext( )
			if currentTxt <= settings.currentScore then
				sceneGroup.scoreTxt.text = tostring(currentTxt)
				currentTxt = currentTxt + 1
				timer.performWithDelay( 100, scrolltext )
			end
		end
		scrolltext()
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