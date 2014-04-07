require( "AssetLocation" )

player = {}

function player:new( status )

	local x, y = display.contentCenterX, display.contentHeight - 160
	local newPlayer = display.newGroup( )
	local playerWalk

	function newPlayer:init( )

		local spriteLocation = sprite[1].location

		local sheetData =  sprite[1].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[1].sequenceData

		playerWalk = display.newSprite( mySheet, sequenceData )
		playerWalk.name = "player"
		playerWalk.x , playerWalk.y = x,y
		playerWalk.anchorX, playerWalk.anchorY = .5,1
		
		-- physics.addBody( playerWalk, {density=1, friction=0, bounce=0 } )

		self:insert( playerWalk )

		if (status) then
			playerWalk:play( )
		end

	end

	function newPlayer:jump( )
		playerWalk:applyForce( 0, -5000*2, playerWalk.x,playerWalk.y )
	end

	function newPlayer:died( )
		
	end

	newPlayer:init( )
	return newPlayer
end

