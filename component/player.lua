require( "AssetLocation" )

player = {}

function player:new( status , parentGroup )


	local x, y = display.contentCenterX -170, display.contentHeight - 165
	local newPlayer = display.newGroup( )
	local playerWalk
	-- local rotation = 0

	if parentGroup then parentGroup:insert(newPlayer) end

	function newPlayer:init( )

		local spriteLocation = sprite[1].location

		local sheetData =  sprite[1].sheetData

		local mySheet = graphics.newImageSheet( spriteLocation, sheetData )

		local sequenceData = sprite[1].sequenceData

		playerWalk = display.newSprite( mySheet, sequenceData )
		playerWalk.name = "player"
		playerWalk.x , playerWalk.y = x,y
		playerWalk.anchorX, playerWalk.anchorY = .5,1
		playerWalk.xScale, playerWalk.yScale = .75, .75
		-- player.rotation = rotation
		playerWalk.isFixedRotation = true
		playerWalk.isSensor = true

		self:insert( playerWalk )

		if (status) then
			playerWalk:play( )
		end

		Runtime:addEventListener( "turnTranslationOff", self )
	end

	function newPlayer:jump( )
		-- playerWalk:applyForce( 0, -2500*2, playerWalk.x,playerWalk.y )
		playerWalk:setLinearVelocity( 0,-900 )
		timer.performWithDelay( 460, function ()
			-- playerWalk:a
			playerWalk:setLinearVelocity( 0, 150 )
		end )
	end

	function newPlayer:addBody( )
		-- local shapePlayer  = {-17,-67,  18,-67,  18,-6,  53,-6,  56,84,  -52,84,  -52,-6,  -17,-6}
		local shapePlayer = {-15,-40, 15,-40, 15,0, 37,0, 37,83, -37,83, -37,0, -15,0}
		physics.addBody( playerWalk, {density=1, friction=0, bounce=0, shape = shapePlayer } )
		playerWalk.isAwake = true
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
		self.boundary1:removeSelf( )
		self.boundary2:removeSelf( )
		self.boundary1, self.boundary2 = nil, nil
		playerWalk:pause( )
		playerWalk.isAwake = false
		playerWalk.isSensor = false


		if (event.state == "redCollision") then
			-- playerWalk.isFixedRotation = false
			physics.setGravity( 0, 6 )
			transition.to( playerWalk, {delay = 100, rotation = -90, onComplete = function()
				physics.setGravity( 0, 30 )
			end} )
		else
			playerWalk:setLinearVelocity( 0, 0 )
			physics.setGravity( 0, 0 )
			playerWalk:setLinearVelocity( 0, 0 )
		end
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
	newPlayer:addBody( )
	newPlayer:addBoundary( )
	newPlayer:alwaysAwake( )

	
	return newPlayer
end

