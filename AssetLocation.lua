-- game = 30 fps
-- 200 ms == 6 frame

_cW = display.contentWidth
_cH = display.contentHeight

sprite = {}


sprite[1] = {}
sprite[1].name = "playerRun"
sprite[1].location = "Asset/Sprite2DRunning.png"
sprite[1].sheetData = {	numFrames = 4*3 ,
						sheetContentWidth = 640,
						sheetContentHeight = 510, 
						width = 640/4,
						height = 510/3,
						}
sprite[1].sequenceData = {name = "playerRun", start = 1, count = 12, time = 400, loopCount = 0}


sprite[2] = {}
sprite[2].name = "playerWalk"
sprite[2].location = "Asset/Sprite3DWalking.png"
sprite[2].sheetData = {	numFrames = 4*3 ,
						sheetContentWidth = 2560,
						sheetContentHeight = 1860,
						width = 2560/4,
						height = 1860/3,
						}
sprite[2].sequenceData = {name = "playerWalk", start = 1, count = 12, time = 400, loopCount = 0}

sprite[3] = {}
sprite[3].name = "coinRed"
sprite[3].location = "Asset/Sprite2DCoinRed.png"
sprite[3].sheetData = {	numFrames = 3*2,
						sheetContentWidth = 105,
						sheetContentHeight = 80,
						width = 105/3,
						height = 80/2,
						}
sprite[3].sequenceData = {name = "coinRed", start = 1, count = 6, time = 200, loopCount = 0}

sprite[4] = {}
sprite[4].name = "coinYellow"
sprite[4].location = "Asset/Sprite2DCoinYellow.png"
sprite[4].sheetData = {	numFrames = 3*2,
						sheetContentWidth = 105,
						sheetContentHeight = 80,
						width = 105/3,
						height = 80/2,
						}
sprite[4].sequenceData = {name = "coinYellow", start = 1, count = 6, time = 200, loopCount = 0}

sprite[5] = {}
sprite[5].name = "crack"
sprite[5].location = "Asset/Sprite2DCrack.png"
sprite[5].sheetData = {	numFrames = 6*1,
						sheetContentWidth = 3840,
						sheetContentHeight = 1280,
						width = 3840/6,
						height = 1280/1,
						}
sprite[5].sequenceData = {name = "crack", start = 1, count = 6, time = 200, loopCount = 1}

sprite[6] = {}
sprite[6].name = "blood"
sprite[6].location = "Asset/Sprite2DBlood.png"
sprite[6].sheetData = {	numFrames = 6*1,
						sheetContentWidth = 3840,
						sheetContentHeight = 1280,
						width = 3840/6,
						height = 1280/1,
						}
sprite[6].sequenceData = {name = "blood", start = 1, count = 6, time = 200, loopCount = 1}




imageLocation = {}

imageLocation.title = "Asset/TitleEndless.png"

imageLocation.floor = "Asset/Bg2DFloor.png"

imageLocation.background2D = "Asset/Bg2DMatte.png"

imageLocation.floor3D = "Asset/Bg3DGroundTile.png"

imageLocation.background3D = "Asset/Bg3DMatte.png"

imageLocation.scoreBoard = "Asset/BrdScore.png"

imageLocation.iPhone = "Asset/Obj3DiPhone.png"


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

