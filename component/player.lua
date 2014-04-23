require( "AssetLocation" )

player = {}

function player:new( status , parentGroup )


	local x, y = display.contentCenterX -170, display.contentHeight - 165
	local newPlayer = display.newGroup( )
	self.newPlayer = newPlayer
	local playerWalk
	self.playerWalk = playerWalk
	local animation = true
	-- local rotation = 0

	if parentGroup then parentGroup:insert(newPlayer) end

	function newPlayer:init( )

		local spriteLocation = sprite[1].location

		local sheetData =  sprite[1].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[1].sequenceData

		playerWalk = display.newSprite( mySheet, sequenceData )
		playerWalk.name = "player"
		-- playerWalk.x , playerWalk.y = x,y
		-- playerWalk.anchorX, playerWalk.anchorY = .5,1
		-- playerWalk.xScale, playerWalk.yScale = .75, .75
		-- playerWalk.isSensor = true
		-- playerWalk:play( )

		self:insert( playerWalk )

		-- Runtime:addEventListener( "turnTranslationOff", self )
		-- self:alwaysAwake()

		-- self:addBody()
		-- self:addBoundary()
	end

	function newPlayer:reinit()
		print( "reinitiating" )
		playerWalk.x , playerWalk.y = x,y
		playerWalk.anchorX, playerWalk.anchorY = .5,1
		playerWalk.xScale, playerWalk.yScale = .75, .75
		playerWalk.isSensor = true
		playerWalk:play( )

		-- self:insert( playerWalk )

		Runtime:addEventListener( "turnTranslationOff", self )
		self:addBody()
		self:addBoundary()
		self:alwaysAwake()
	end

	function newPlayer:jump( )
		playerWalk:setLinearVelocity( 0, 0 )
		playerWalk:applyForce( 0, -1000, playerWalk.x, playerWalk.y )
		playerWalk:pause( )
		playerWalk:setFrame( 5 )
		timer.performWithDelay( 300, function()
			if (animation) then
				playerWalk:play( )
			end
		end )
	end

	function newPlayer:addBody( )
		print( "adding body" )
		local shapePlayer = {-15,-40, 15,-40, 15,0, 37,0, 37,83, -37,83, -37,0, -15,0}
		physics.addBody( playerWalk, {density=.1, friction=1, bounce=.1, shape = shapePlayer } )
		playerWalk.isAwake = true
		playerWalk.isFixedRotation = true
	end


	function newPlayer:removePhysicsBody( )
		physics.removeBody( playerWalk )
	end

	function newPlayer:died( )
		self:removePhysicsBody()
		transition.to( newPlayer, {rotation = -90, time = 5000} )
	end

	function newPlayer:addBoundary( )
		local boundary1= display.newRect(playerWalk.x+ (playerWalk.width/2), 0, 4,display.contentHeight)
		boundary1.alpha = 0.01
		boundary1.anchorY, boundary1.anchorY = 0,0
		self:insert( boundary1)
		physics.addBody( boundary1, "static", {density=1, friction=0, bounce=0 } )
		self.boundary1 = boundary1


		local boundary2= display.newRect(playerWalk.x-playerWalk.width/2, 0, 4,display.contentHeight)
		boundary2.alpha = 0.01
		boundary2.anchorX, boundary2.anchorY = 1,0
		self:insert( boundary2)
		physics.addBody( boundary2, "static", {density=1, friction=0, bounce=0 } )
		self.boundary2 = boundary2

		local floorBody = display.newRect( 0, display.contentHeight - 160 ,display.contentWidth, 4)
		floorBody.anchorX, floorBody.anchorY = 0,1
		floorBody.alpha = 0.01
		self:insert( floorBody)
		physics.addBody( floorBody, "static", {density=1, friction=0, bounce=0} )

		local roof = display.newRect( 0, 0,display.contentWidth, 4)
		roof.anchorX, roof.anchorY = 0,1
		roof.alpha = 0.01
		self:insert( roof)
		physics.addBody( roof, "static", {density=1, friction=0, bounce=0} )
	end

	function newPlayer:turnTranslationOff(event)
		Runtime:removeEventListener( "turnTranslationOff", self )

		animation = false
		self.boundary1:removeSelf( )
		self.boundary2:removeSelf( )
		self.boundary1, self.boundary2 = nil, nil
		-- playerWalk.isAwake = false
		playerWalk.isSensor = false
		playerWalk:pause( )

		-- if (event.state == "redCollision") then
		-- 	-- playerWalk.isFixedRotation = false
		-- 	physics.setGravity( 0, 6 )
		-- 	transition.to( playerWalk, {delay = 100, rotation = -90, onComplete = function()
		-- 		physics.setGravity( 0, 30 )
		-- 	end} )
		-- else
			-- playerWalk:setLinearVelocity( 0, 0 )
			physics.setGravity( 0, 0 )
			playerWalk:setLinearVelocity( 0, 0 )
			timer.performWithDelay( 30, function()
				physics.removeBody( playerWalk )
			end ) 
		-- end
	end

	function newPlayer:alwaysAwake( )
		function funct( )
			if newPlayer then
				playerWalk.isAwake = true
			else
				Runtime:removeEventListener( "enterFrame", funct )
			end
		end
		Runtime:addEventListener( "enterFrame", funct )
	end

	newPlayer:init( )
	-- newPlayer:addBody( )
	-- newPlayer:addBoundary( )
	-- newPlayer:alwaysAwake( )

	
	return newPlayer
end

function player:reinit()
	self.newPlayer:reinit()
end

