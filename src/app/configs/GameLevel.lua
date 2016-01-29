-- 关卡配置表

-- glvlid		关卡ID
-- parentid		父关卡ID
-- name 		关卡名称
-- title 		关卡标题
-- subglvlid	子关卡名称
-- glvltime		关卡完成时间
-- sn 			关卡顺序
-- mapinfo      关卡阶段配置
-- condition={type=GAME_CONDITION.TIME,num=180} 时间限制
local data={}
-- 主任务信息
data.glvl={
	{glvlid=1,parentid=0,name="案件第一号",title="赎金风暴"},
	{glvlid=2,parentid=0,name="案件第二号",title="泣    壁"},
	{glvlid=3,parentid=0,name="案件第三号",title="失    童"},
	{glvlid=4,parentid=0,name="案件第四号",title="复仇的cos"},
	{glvlid=5,parentid=0,name="案件第五号",title="宿    命"},
	{glvlid=6,parentid=0,name="案件第六号",title="心    穴"},
}
-- 子任务信息
data.subglvl={
    [1] = {
		{subglvlid=1,glvlid=1,name="突发事件",lvl=1,condition={},sn=1,mapinfo={{mapid=1,gap=2}}},
		{subglvlid=2,glvlid=1,name="追踪线索",lvl=2,condition={},sn=2,mapinfo={{mapid=2,gap=2},{mapid=2,gap=1}}},
		{subglvlid=3,glvlid=1,name="贪狼",lvl=3,condition={},sn=3,mapinfo={{mapid=3,gap=2},{mapid=3,gap=1}}},
		{subglvlid=4,glvlid=1,name="欺骗",lvl=4,condition={},sn=4,mapinfo={{mapid=4,gap=1}}},
		{subglvlid=5,glvlid=1,name="胜负已分",lvl=5,condition={type=GAME_CONDITION.TIME,num=360},sn=5,mapinfo={{mapid=5,gap=2}}},},
	[2] = {
		{subglvlid=6,glvlid=2,name="罪行调查",lvl=6,condition={},sn=1,mapinfo={{mapid=1,gap=2},{mapid=1,gap=1}}},
		{subglvlid=7,glvlid=2,name="信息",lvl=7,condition={},sn=2,mapinfo={{mapid=2,gap=2},{mapid=2,gap=1}}},
		{subglvlid=8,glvlid=2,name="求助信号",lvl=8,condition={},sn=3,mapinfo={{mapid=3,gap=1}}},
		{subglvlid=9,glvlid=2,name="失踪",lvl=9,condition={},sn=4,mapinfo={{mapid=4,gap=2},{mapid=4,gap=1}}},
		{subglvlid=10,glvlid=2,name="制裁",lvl=10,condition={type=GAME_CONDITION.TIME,num=180},sn=5,mapinfo={{mapid=5,gap=2}}},},
	[3] = {
		{subglvlid=11,glvlid=3,name="取证",lvl=11,condition={},sn=1,mapinfo={{mapid=1,gap=2},{mapid=1,gap=2}}},
		{subglvlid=12,glvlid=3,name="困惑",lvl=12,condition={},sn=2,mapinfo={{mapid=2,gap=2},{mapid=2,gap=2}}},
		{subglvlid=13,glvlid=3,name="突破重围",lvl=13,condition={},sn=3,mapinfo={{mapid=3,gap=1}}},
		{subglvlid=14,glvlid=3,name="伸张正义",lvl=14,condition={},sn=4,mapinfo={{mapid=4,gap=2},{mapid=4,gap=2}}},
		{subglvlid=15,glvlid=3,name="绝杀",lvl=15,condition={type=GAME_CONDITION.TIME,num=300},sn=5,mapinfo={{mapid=5,gap=2},{mapid=5,gap=2}}},},
	[4] = {
		{subglvlid=16,glvlid=4,name="杀人狂",lvl=16,condition={},sn=1,mapinfo={{mapid=1,gap=2},{mapid=1,gap=2}}},
		{subglvlid=17,glvlid=4,name="追查",lvl=17,condition={},sn=2,mapinfo={{mapid=2,gap=2},{mapid=2,gap=2},{mapid=2,gap=1}}},
		{subglvlid=18,glvlid=4,name="内情",lvl=18,condition={},sn=3,mapinfo={{mapid=3,gap=2},{mapid=3,gap=2},{mapid=3,gap=1}}},
		{subglvlid=19,glvlid=4,name="残酷真相",lvl=19,condition={},sn=4,mapinfo={{mapid=4,gap=1}}},
		{subglvlid=20,glvlid=4,name="正义永存",lvl=20,condition={type=GAME_CONDITION.TIME,num=240},sn=5,mapinfo={{mapid=5,gap=2},{mapid=5,gap=2},{mapid=5,gap=1}}},},
	[5] = {
		{subglvlid=21,glvlid=5,name="线索聚集",lvl=22,condition={},sn=1,mapinfo={{mapid=1,gap=2},{mapid=1,gap=2},{mapid=1,gap=2}}},
		{subglvlid=22,glvlid=5,name="雾霭",lvl=24,condition={},sn=2,mapinfo={{mapid=2,gap=2},{mapid=2,gap=2},{mapid=2,gap=2}}},
		{subglvlid=23,glvlid=5,name="惊心",lvl=26,condition={},sn=3,mapinfo={{mapid=3,gap=1}}},
		{subglvlid=24,glvlid=5,name="七杀",lvl=28,condition={},sn=4,mapinfo={{mapid=4,gap=2},{mapid=4,gap=2},{mapid=4,gap=2}}},
		{subglvlid=25,glvlid=5,name="破军",lvl=30,condition={type=GAME_CONDITION.TIME,num=300},sn=5,mapinfo={{mapid=5,gap=2},{mapid=5,gap=2},{mapid=5,gap=2}}},},
	[6] = {
		{subglvlid=26,glvlid=6,name="迷雾重重",lvl=31,condition={},sn=1,mapinfo={{mapid=1,gap=2},{mapid=1,gap=2},{mapid=1,gap=2},{mapid=1,gap=1}}},
		{subglvlid=27,glvlid=6,name="暴动之城",lvl=32,condition={},sn=2,mapinfo={{mapid=2,gap=2},{mapid=2,gap=2},{mapid=2,gap=2},{mapid=2,gap=1}}},
		{subglvlid=28,glvlid=6,name="魔由心生",lvl=33,condition={},sn=3,mapinfo={{mapid=3,gap=1}}},
		{subglvlid=29,glvlid=6,name="千钧一发",lvl=34,condition={type=GAME_CONDITION.TIME,num=300},sn=4,mapinfo={{mapid=4,gap=2},{mapid=4,gap=2},{mapid=4,gap=2},{mapid=4,gap=1}}},
		{subglvlid=30,glvlid=6,name="幻术师",lvl=35,condition={type=GAME_CONDITION.TIME,num=300},sn=5,mapinfo={{mapid=5,gap=2},{mapid=5,gap=2},{mapid=5,gap=2},{mapid=5,gap=2}}},},
}
data.npc={
	[ 1]= require("app.gamelevels.subgl_01"),
	[ 2]= require("app.gamelevels.subgl_02"),
	[ 3]= require("app.gamelevels.subgl_03"),
	[ 4]= require("app.gamelevels.subgl_04"),
	[ 5]= require("app.gamelevels.subgl_05"),	
	[ 6]= require("app.gamelevels.subgl_06"),
	[ 7]= require("app.gamelevels.subgl_07"),
	[ 8]= require("app.gamelevels.subgl_08"),
	[ 9]= require("app.gamelevels.subgl_09"),
	[10]= require("app.gamelevels.subgl_10"),	
	[11]= require("app.gamelevels.subgl_11"),
	[12]= require("app.gamelevels.subgl_12"),
	[13]= require("app.gamelevels.subgl_13"),
	[14]= require("app.gamelevels.subgl_14"),
	[15]= require("app.gamelevels.subgl_15"),
	[16]= require("app.gamelevels.subgl_16"),	
	[17]= require("app.gamelevels.subgl_17"),
	[18]= require("app.gamelevels.subgl_18"),
	[19]= require("app.gamelevels.subgl_19"),
	[20]= require("app.gamelevels.subgl_20"),
	[21]= require("app.gamelevels.subgl_21"),
	[22]= require("app.gamelevels.subgl_22"),	
	[23]= require("app.gamelevels.subgl_23"),
	[24]= require("app.gamelevels.subgl_24"),
	[25]= require("app.gamelevels.subgl_25"),
	[26]= require("app.gamelevels.subgl_26"),	
	[27]= require("app.gamelevels.subgl_27"),
	[28]= require("app.gamelevels.subgl_28"),
	[29]= require("app.gamelevels.subgl_29"),
	[30]= require("app.gamelevels.subgl_30"),
}

-- 挑战模式
data.normal = {
	[1] = {id=1,baselvl=5,uplvl=1,basenum=5,upnum=1,npc={1,2,11,13,3},elite={2,3,13},boss={4},baseexp=9000,basegold=3000,upgold=280},
	[2] = {id=2,baselvl=10,uplvl=1,basenum=5,upnum=1,npc={11,3,6,8,14},elite={6,8,14},boss={10},baseexp=12000,basegold=5000,upgold=450},
	[3] = {id=3,baselvl=15,uplvl=1,basenum=5,upnum=1,npc={12,6,8,14,7},elite={6,7,8,14},boss={9},baseexp=15000,basegold=6000,upgold=560},
	[4] = {id=4,baselvl=20,uplvl=1,basenum=5,upnum=1,npc={12,13,6,7,5},elite={13,6,7,5},boss={15},baseexp=18000,basegold=7000,upgold=660},
	[5] = {id=5,baselvl=25,uplvl=1,basenum=5,upnum=1,npc={14,6,8,7,5},elite={14,6,8,7,5},boss={15},baseexp=21000,basegold=8000,upgold=750},
	[6] = {id=6,baselvl=35,uplvl=1,basenum=5,upnum=1,npc={19,22,23,24,25,26,28},elite={19,23,24,25,26,28},boss={20,21,27},baseexp=21000,basegold=8000,upgold=750},
}

-- 通天塔
data.hard = {
	mapinfo={{mapid=1,gap=1}},
	layer={
		[5]={condition={type=GAME_CONDITION.TIME,num=180},lvl=15},
		[10]={condition={type=GAME_CONDITION.TIME,num=180},lvl=20},
		[15]={condition={type=GAME_CONDITION.TIME,num=180},lvl=25},
		[20]={condition={type=GAME_CONDITION.TIME,num=240},lvl=30},
		[25]={condition={type=GAME_CONDITION.TIME,num=240},lvl=35},
		[30]={condition={type=GAME_CONDITION.TIME,num=240},lvl=40},
		[35]={condition={type=GAME_CONDITION.TIME,num=180},lvl=45},
	},
	boss1 = {
		{id=4,num=10},
		{id=10,num=19},
		{id=9,num=28},
		{id=15,num=60},
	},
	boss2 = {
		{id=4,num=10},
		{id=10,num=19},
		{id=9,num=28},
		{id=15,num=60},
		{id=21,num=67},
		{id=20,num=84},
		{id=27,num=98},
	},
	normal = {1,2,3,5,6,7,8,11,12,13,14,19,22,23,24,25,26,28},
}

data.lock = {
	[5] = {star=8},
	[10] = {star=20},
	[15] = {star=35},
	[20] = {star=45},
	[25] = {star=55},
	[30] = {star=80},
}

--根据关卡ID返回关卡中NPC的数量
function data.getNPCNum(i_SubGlvlId)
	local result_ = 0
	if i_SubGlvlId then
		i_SubGlvlId = checknumber(i_SubGlvlId)
		local npcinfo_ = data.npc[i_SubGlvlId]
		if npcinfo_ then
			for m,n in ipairs(npcinfo_) do
				for i,v in ipairs(n) do
					result_ = result_ + #n[i]
				end
			end
		end
	end
	return result_
end

return data
