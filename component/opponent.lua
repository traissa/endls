require( "AssetLocation" )

opponent = {}

function opponent:new( status )

	-- generating random x position
	local x = math.random(0, display.contentWidth)
	local y = display.contentHeight - 400
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
		playerWalk.xScale, playerWalk.yScale = .8, .8
		playerWalk:toBack( )
		transition.to( playerWalk, {time = 3500, xScale = 3, yScale = 3, y = display.contentHeight + 700, onComplete = function()
			if (playerWalk) then
				playerWalk:removeSelf( )
				playerWalk = nil
			end
		end} )

		newPerson:insert( playerWalk )

		playerWalk:play( )

		-- return playerWalk
	-- end

	-- newPerson:init( )
	return newPerson
end

