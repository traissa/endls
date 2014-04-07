require( "AssetLocation" )

coinRed = {}

function coinRed:new( x, y)
	local newCoin = display.newGroup( )

	function newCoin:init( )

		local spriteLocation = sprite[3].location

		local sheetData =  sprite[3].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[3].sequenceData

		coin = display.newSprite( mySheet, sequenceData )
		coin.name = "sprite"
		coin.x , coin.y = x,y

		self:insert( coin )

		coin:play( )
	end

	newCoin:init( )
	return newCoin
end

coinYellow = {}

function coinYellow:new( x, y)
	local newCoin = display.newGroup( )
	local coin
	local delta = 1
	local onTranslation = true

	function newCoin:init( )

		local spriteLocation = sprite[4].location

		local sheetData =  sprite[4].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[4].sequenceData

		coin = display.newSprite( mySheet, sequenceData )
		coin.name = "coin"
		coin.x , coin.y = x,y

		physics.addBody( coin, "static", {density=1, friction=0, bounce=0, radius = 20 } )

		coin.isSensor = true

		self:insert( coin )

		coin:play( )

		newCoin:autoRemove( )

		newCoin:move( )
	end

	function newCoin:autoRemove( )
		
		if newCoin.x < 0 then
			newCoin:remove( )
		end

	end

	function newCoin:remove( )
		newCoin:removeSelf( )
		newCoin = nil
		onTranslation = false
	end

	function newCoin:move( )
		local function move (  )
			if onTranslation then
				coin.x = coin.x - delta
			else 
				Runtime:removeEventListener( "enterFrame", move )
			end
		end
		Runtime:addEventListener( "enterFrame", move )
	end

	newCoin:init( )
	

	return newCoin
end

