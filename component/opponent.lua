require( "AssetLocation" )

opponent = {}

function opponent:new( status )

	-- generating random x position
	local x = math.random(0, display.contentWidth)
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
		transition.to( playerWalk, {time = 1000, xScale = .45, yScale = .45, y = display.contentHeight - 410, onComplete = function()
			transition.to( playerWalk, {time = 6000, xScale = 3, yScale = 3, y = display.contentHeight + 1000, onComplete = function() 
				if (playerWalk) then
					playerWalk:removeSelf( )
					playerWalk = nil
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

