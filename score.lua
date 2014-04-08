--settings.currentScore
local function scoreFunction (e)
	if e.value > 0 then
		settings.currentScore = settings.currentScore + e.value
		print( settings.currentScore )

	elseif e.value < 0 then
		print ("gameOver")

		Runtime:dispatchEvent( {name = "gameOver"} )
		
		if settings.currentScore > settings.highScore then
			settings.highScore = settings.currentScore
		end
		saveTable("settings.json", system.DocumentsDirectory, settings)

	elseif e.value == 0 then
			settings.currentScore = 0
	end
end

Runtime:addEventListener( "score", scoreFunction )