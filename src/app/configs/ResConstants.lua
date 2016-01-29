--
-- Author: rsma
-- Date: 2014-07-01 15:54:42
--

--按钮基类
g_BaseButton = require("app.ui.base.BaseButton")
--节点基类
g_BaseNode = require("app.ui.base.BaseNode")
--弹窗基类
g_BasePopUI = require("app.ui.base.BasePopUI")
--图片基类
g_BaseImage = require("app.ui.base.BaseImage")
--弹出提示框
g_TipUI = require("app.ui.popdialog.PopDialogUI")

-- 声音配置
GAME_SFX = {
	--背景音
	MUSIC={
		LOGINSCENE="musics/90011.mp3",
		MENUSCENE="musics/90011.mp3",
		--战斗背景音乐
		FIGHTSCENE={
			"musics/90012.mp3",
			"musics/90016.mp3",
			"musics/90012.mp3",
			"musics/90017.mp3",
			"musics/90016.mp3",
			"musics/90017.mp3",
			},
		--Boss出场
		FIGHTBOSS = "musics/90015.mp3",
		--剧情播放音乐
		PLOT="musics/90014.mp3",
	},
	FIGHT={
		attack1="sounds/90021.mp3",
	},
	MOVIE={
		BEGIN="movies/90031.mp4"
	},
	ui={
		--登录按钮
		tapButton="sound/ui/sfx_longin.mp3",
		--确定按钮
		okButtion  ="sound/ui/sfx_ok.mp3",
		--商城按钮
		shopButton  ="sound/ui/sfx_shop.mp3",
	},
	effect={
		
	},
}