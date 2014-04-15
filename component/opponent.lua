require( "AssetLocation" )

opponent = {}

function opponent:new( status, touchGroup )

	-- generating random x position
	local x = math.random(0, display.contentWidth)
	-- local x = 320
	-- local x = math.random(0, 3000)
	local y = display.contentHeight - 150
	local newPerson = display.newGroup( )

	-- function newPerson:init( )

		local spriteLocation = sprite[2].location

		local sheetData =  sprite[2].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[2].sequenceData

		local playerWalk = display.newSprite( mySheet, sequenceData )
		playerWalk.name = "opponent"
		playerWalk.x , playerWalk.y = x,y
		-- playerWalk.y = y
		playerWalk.anchorX, playerWalk.anchorY = .5,1
		playerWalk.xScale, playerWalk.yScale = .3, .3
		playerWalk:toBack( ) 

		local initx = touchGroup.x
		transition.to( playerWalk, {time = 1000, xScale = .3, yScale = .3, y = display.contentHeight - 410, onComplete = function()
			-- timer.performWithDelay( 20, function() end )
			transition.to( playerWalk, {time = 7000, xScale = 5, yScale = 5, y = display.contentHeight + 1870, transition = easing.inSine , onComplete = function() 
				if (playerWalk) then
					playerWalk:removeSelf( )
					local finalx = x + (touchGroup.x - initx)
					-- print( "final position " .. tostring( finalx ) )
					playerWalk = nil
					newPerson:dispatchEvent( {name = "personOnScreen", position = finalx} )
				end
			end} )
		end} )

		newPerson:insert( playerWalk )

		playerWalk:play( )

		-- return playerWalk
	-- end

	-- newPerson:init( )
	return newPerson
end

