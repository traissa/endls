-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
system.setIdleTimer( false )

-- splashScreen
-- local splash = display.newGroup( )
-- local background = display.newRect(splash, 0, 0, display.actualContentWidth, display.actualContentHeight)
-- local splashScreen = display.newImageRect(splash, "splash.png", display.contentWidth, display.contentHeight)

-- splash.anchorX, splash.anchorY = 0.5,0.5
-- splash.x, splash.y = display.contentCenterX, display.contentCenterY
-- splashScreen.alpha = 0
-- transition.to( splashScreen, { delay =300,alpha=1} )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )

