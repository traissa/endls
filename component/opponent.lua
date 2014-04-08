require( "AssetLocation" )

opponent = {}

function opponent:new( status )

	-- generating random x position
	local x = math.random(0, display.contentWidth)
	local y = display.contentHeight - 200
	local newPerson = display.newGroup( )
	local playerWalk

	function newPerson:init( )

		local spriteLocation = sprite[2].location

		local sheetData =  sprite[2].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[2].sequenceData

		playerWalk = display.newSprite( mySheet, sequenceData )
		playerWalk.name = "player"
		playerWalk.x , playerWalk.y = x,y
		playerWalk.anchorX, playerWalk.anchorY = .5,1
		playerWalk.xScale, playerWalk.yScale = .8, .8
		playerWalk:toBack( )
		transition.to( playerWalk, {time = 2500, xScale = 2, yScale = 2, y = display.contentHeight + 100, onComplete = function()
			if (playerWalk) then
				playerWalk:removeSelf( )
				playerWalk = nil
			end
		end} )

		self:insert( playerWalk )

		if (status) then
			playerWalk:play( )
		end

	end

	function newPerson:died( )
		
	end

	newPerson:init( )
	return newPerson
end

