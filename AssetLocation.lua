-- game = 30 fps
-- 200 ms == 6 frame

_cW = display.contentWidth
_cH = display.contentHeight

sprite = {}


sprite[1] = {}
sprite[1].name = "playerRun"
sprite[1].location = "Asset/Sprite2DRunning.png"
sprite[1].sheetData = {	numFrames = 4*3 ,
						sheetContentWidth = 641,
						sheetContentHeight = 534, 
						width = 641/4,
						height = 534/3,
						}
sprite[1].sequenceData = {name = "playerRun", start = 1, count = 12, time = 800, loopCount = 0}


sprite[2] = {}
sprite[2].name = "playerWalk"
sprite[2].location = "Asset/Sprite3DWalking.png"
sprite[2].sheetData = {	numFrames = 4*3 ,
						sheetContentWidth = 2561,
						sheetContentHeight = 1884,
						width = 2561/4,
						height = 1884/3,
						}
sprite[2].sequenceData = {name = "playerWalk", start = 1, count = 12, time = 1000, loopCount = 0}

sprite[3] = {}
sprite[3].name = "coinRed"
sprite[3].location = "Asset/Sprite2DCoinRed.png"
sprite[3].sheetData = {	numFrames = 3*2,
						sheetContentWidth = 105,
						sheetContentHeight = 80,
						width = 105/3,
						height = 80/2,
						}
sprite[3].sequenceData = {name = "coinRed", start = 1, count = 6, time = 800, loopCount = 0}

sprite[4] = {}
sprite[4].name = "coinYellow"
sprite[4].location = "Asset/Sprite2DCoinYellow.png"
sprite[4].sheetData = {	numFrames = 3*2,
						sheetContentWidth = 105,
						sheetContentHeight = 80,
						width = 105/3,
						height = 80/2,
						}
sprite[4].sequenceData = {name = "coinYellow", start = 1, count = 6, time = 800, loopCount = 0}

sprite[5] = {}
sprite[5].name = "crack"
sprite[5].location = "Asset/Sprite2DCrack.png"
sprite[5].sheetData = {	numFrames = 6*1,
						sheetContentWidth = 3840,
						sheetContentHeight = 1280,
						width = 3840/6,
						height = 1280/1,
						}
sprite[5].sequenceData = {name = "crack", start = 1, count = 6, time = 800, loopCount = 1}

sprite[6] = {}
sprite[6].name = "blood"
sprite[6].location = "Asset/Sprite2DBlood.png"
sprite[6].sheetData = {	numFrames = 6*1,
						sheetContentWidth = 3840,
						sheetContentHeight = 1280,
						width = 3840/6,
						height = 1280/1,
						}
sprite[6].sequenceData = {name = "blood", start = 1, count = 6, time = 1000, loopCount = 1}

sprite[7] = {}
sprite[7].name = "tiles"
sprite[7].location = "Asset/Bg3DGroundSprite.png"
sprite[7].sheetData = {	numFrames = 4*4,
						sheetContentWidth = 2560,
						sheetContentHeight = 1660,
						width = 2560/4,
						height = 1660/4,
						}
sprite[7].sequenceData = {name = "tiles", start = 1, count = 16, time = 600, loopCount = 0}

sprite[8] = {}
sprite[8].name = "tilesRight"
sprite[8].location = "Asset/Bg3DGroundSpriteRight.png"
sprite[8].sheetData = {	numFrames = 4*4,
						sheetContentWidth = 2560,
						sheetContentHeight = 1660,
						width = 2560/4,
						height = 1660/4,
						}
sprite[8].sequenceData = {name = "tilesRight", start = 1, count = 16, time = 600, loopCount = 0}

sprite[9] = {}
sprite[9].name = "tilesLeft"
sprite[9].location = "Asset/Bg3DGroundSpriteLeft.png"
sprite[9].sheetData = {	numFrames = 4*4,
						sheetContentWidth = 2560,
						sheetContentHeight = 1660,
						width = 2560/4,
						height = 1660/4,
						}
sprite[9].sequenceData = {name = "tilesLeft", start = 1, count = 16, time = 600, loopCount = 0}

imageLocation = {}

imageLocation.title = "Asset/TitleEndless.png"

imageLocation.floor = "Asset/Bg2DFloor.png"

imageLocation.background2D = "Asset/Bg2DMatte.png"

imageLocation.floor3D = "Asset/Bg3DGroundTile.png"

imageLocation.background3D = "Asset/Bg3DMatte.png"

imageLocation.scoreBoard = "Asset/BrdScore.png"

imageLocation.iPhone = "Asset/Obj3DiPhone.png"

imageLocation.maskScreen = "Asset/Obj3DiPhoneMask.png"


imageLocation.button = {
	play = "Asset/BtnPlay.png",
	okay = "Asset/BtnOkay.png",
	share = "Asset/BtnShare.png",
	rate = "Asset/BtnRate.png",
}

imageLocation.text = {
	bumped = "Asset/TxtBumpedHdln.png",
	crushed = "Asset/TxtCrunchedHdln.png",
	fired = "Asset/TxtFiredHdln.png",
}

