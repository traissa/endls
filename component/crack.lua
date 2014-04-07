require( "AssetLocation" )


crack = {}

function crack:new( x, y)
	local newCrack = display.newGroup( )

	function newCrack:init( )

		local spriteLocation = sprite[5].location

		local sheetData =  sprite[5].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[5].sequenceData

		screenCrack = display.newSprite( mySheet, sequenceData )
		screenCrack.name = "sprite"
		screenCrack.x , screenCrack.y = x,y

		self:insert( screenCrack )

		screenCrack:play( )
	end

	function newCrack:remove( )
		newCrack:removeSelf( )
		newCrack = nil
	end

	newCrack:init( )
	return newCrack
end

