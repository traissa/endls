require( "AssetLocation" )

opponent = {}

function opponent:new( status, touchGroup, number )

	-- generating random x position
	local x = math.random(0, display.contentWidth)
	-- local x = 320
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
		playerWalk.anchorX, playerWalk.anchorY = .5,1
		playerWalk.xScale, playerWalk.yScale = .3, .3
		playerWalk:toBack( )

		local animation = true

		function setAnimation(event)
			if (playerWalk) then
				animation = false
				print( "PAUSING PLAYERWALK " .. tostring( number ) )
				transition.pause( "opponentWalk")
				if (event.state == "crushed3D") then
					playerWalk:pause( )
				end
			end
		end

		Runtime:addEventListener( "turnTranslationOff", setAnimation )

		local initx = touchGroup.x
		transition.to( playerWalk, {tag = "opponentWalk",time = 1000, xScale = .3, yScale = .3, y = display.contentHeight - 410, onComplete = function()
			-- timer.performWithDelay( 20, function() end )
			if (animation) then
				transition.to( playerWalk, {tag = "opponentWalk",time = 7000, xScale = 3, yScale = 3, y = display.contentHeight + 1260, transition = easing.inCubic , onComplete = function()
					if (animation) then
						print( "blbbblab" .. tostring( number ) )
						-- print( "DISPATCHING FINAL LOCATION BE CAREFUL " .. tostring( touchGroup.x - initx ) )
						local finalx = x + (touchGroup.x - initx)
						newPerson:dispatchEvent( {name = "personOnScreen", position = finalx} )
						Runtime:removeEventListener( "turnTranslationOff", setAnimation )
						if (playerWalk) then
							-- print( "removing person number " .. tostring( number ) )
							playerWalk:removeSelf( )
							-- print( "final position " .. tostring( finalx ) )
							playerWalk = nil
						end
					end
				end} )
			end
		end} )

		newPerson:insert( playerWalk )

		playerWalk:play( )


		-- return playerWalk
	-- end

	-- newPerson:init( )
	return newPerson
end

