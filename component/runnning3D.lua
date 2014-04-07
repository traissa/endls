require( "AssetLocation" )

people = {}

function people:new( x, y)
	local newPlayer = display.newGroup( )

	function newPlayer:init( )

		local spriteLocation = sprite[2].location

		local sheetData =  sprite[2].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[2].sequenceData

		playerWalk = display.newSprite( mySheet, sequenceData )
		playerWalk.name = "sprite"
		playerWalk.x , playerWalk.y = x,y
		-- playerWalk:scale( .5,.5)

		self:insert( playerWalk )

		playerWalk:play( )
	end

	newPlayer:init( )
	return newPlayer
end

local x, y = display.contentCenterX, display.contentCenterY


people:new( x, y)