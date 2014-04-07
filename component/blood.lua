require( "AssetLocation" )


blood = {}

function blood:new( x, y)
	local newBloodSplat = display.newGroup( )

	function newBloodSplat:init( )

		local spriteLocation = sprite[6].location

		local sheetData =  sprite[6].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[6].sequenceData

		bloodSplat = display.newSprite( mySheet, sequenceData )
		bloodSplat.name = "sprite"
		bloodSplat.x , bloodSplat.y = x,y

		self:insert( bloodSplat )

		bloodSplat:play( )
	end

	function newBloodSplat:remove( )
		newBloodSplat:removeSelf( )
		newBloodSplat = nil
	end

	newBloodSplat:init( )
	return newBloodSplat
end




local x, y = display.contentCenterX, display.contentCenterY


blood:new( x, y)