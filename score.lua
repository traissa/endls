--settings.currentScore
local function scoreFunction (e)
	if e.value > 0 then
		settings.currentScore = settings.currentScore + e.value
		print( settings.currentScore )
	elseif e.value < 0 then
		Runtime:dispatchEvent( {name = "gameOver"} )
		print ("gameOver")
	end
end

Runtime:addEventListener( "score", scoreFunction )