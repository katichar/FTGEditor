-- 游戏中指引相关管理
local guide = {}
-- -------------指引ID对应行动
-- 1,2 装载技能
-- 3 阵营指引
-- 4 指引领取签到奖励
-- 5 指引点击领取按钮
-- 6 关闭奖励按钮
-- 7 指引点击剧情模式
-- 8 指引点击第一大关第一小关卡
-- 9 指引点击进入关卡
-- 10 点击角色按钮
-- 11 点击关闭角色界面
-- 12 点击寻宝
-- 13 点击经验栏
-- 14 点击金币单抽
-- 15 指引确定 结束抽装备指引

-- 16 点击属性按钮
-- 17 点击+攻击按钮
-- 18 点击确定

-- 19 点击装备按钮
-- 20 点击装备
-- 21 点击穿戴
-- 22 结束语

-- 23 点击挑战模式(1)

-- 24 提示开始起名

-- 25 点击挑战模式(2)
-- 26 点击无尽模式关卡
-- 27 点击开始挑战按钮

-- 指引对象存储
guide.objects = {
	--[1]技能1
	--[2]技能槽1
}
-- 指引方向指示
guide.dir = {
	[1]={rotation=0,pos=cc.p(-80,0),hold=true},
	[2]={rotation=0,pos=cc.p(-80,0),hold=true},
	[4]={rotation=0,pos=cc.p(-80,0),hold=false},
	[5]={rotation=0,pos=cc.p(-80,0),hold=false},
	[6]={rotation=0,pos=cc.p(-80,0),hold=false},
	[7]={rotation=0,pos=cc.p(-80,0),hold=false},
	[8]={rotation=0,pos=cc.p(-80,0),hold=false},
	[9]={rotation=0,pos=cc.p(-80,0),hold=false},
	[10]={rotation=0,pos=cc.p(-80,0),hold=false},
	[11]={rotation=0,pos=cc.p(-80,0),hold=false},
	[12]={rotation=0,pos=cc.p(-80,0),hold=false},
	[13]={rotation=0,pos=cc.p(-80,0),hold=false},
	[14]={rotation=0,pos=cc.p(-80,0),hold=false},
	[15]={rotation=0,pos=cc.p(-80,0),hold=false},
}
local function init()
	g_EventManager.addListener(MESSAGE_EVENT.GUIDE_BEGIN,guide.beginGuide)
	g_EventManager.addListener(MESSAGE_EVENT.GUIDE_END,guide.endGuide)
end

--@ i_Guideid 指引id
--@ i_Index 指引阶段
function guide.beginGuide(i_EventName,i_GuideId)
	-- 是否已经指引
	if guide.currGuideId then 
		return
	end
	if g_DB.getExinfoByType(ROLE_EXINFO_TYPE.GUIDE,g_User.userid)[i_GuideId] then
		return
	end
	guide.currGuideId = i_GuideId
	if g_Task.guide[i_GuideId] then
		g_LayerManager:addMaskUI(require("app.ui.guide.GuidePlotUI").new(g_Task.guide[i_GuideId],guide.callBack,i_GuideId))
	else 
		guide.callBack(i_GuideId)
	end
end

function guide.endGuide(i_EventName,i_GuideId,i_IsOver)
	if i_GuideId == guide.currGuideId then
		if i_IsOver == false then

		else 
			g_DB.addExinfo(ROLE_EXINFO_TYPE.GUIDE,i_GuideId,g_User.userid)
		end
		guide.currGuideId = nil
		if guide.currGuideNode then
			guide.currGuideNode:removeSelf()
			guide.currGuideNode=nil
		end
	end
end

function guide.getScenePos(i_Obj)
	local point = cc.p(i_Obj:getContentSize().width/2,i_Obj:getContentSize().height/2)
	local point = i_Obj:convertToWorldSpace(point)
	return point.x,point.y
end

function guide.setGuideObj(i_GuideId,i_Obj)
	if i_Obj then 
		guide.objects[i_GuideId] = i_Obj
	end
end

function guide.getGuideObj(i_GuideId)
	return guide.objects[i_GuideId]
end

function guide.getDirById(i_GuideId)
	return guide.dir[i_GuideId]
end

-- 具体指引实施
function guide.callBack(i_GuideId)
	-- 阵营指引
	if i_GuideId == 3 then
		g_EventManager.dispatch(MESSAGE_EVENT.GUIDE_END,3)
	-- 结束抽取装备指引
	elseif i_GuideId == 14 then
		g_EventManager.dispatch(MESSAGE_EVENT.GUIDE_END,14)
	elseif i_GuideId == 15 then
		g_EventManager.dispatch(MESSAGE_EVENT.GUIDE_END,15)
	-- 结束穿装备指引
	elseif i_GuideId == 22 then
		g_EventManager.dispatch(MESSAGE_EVENT.GUIDE_END,22)
	elseif i_GuideId == 24 then
		g_EventManager.dispatch(MESSAGE_EVENT.GUIDE_END,24)
	else 
		local obj = guide.getGuideObj(i_GuideId)
		if not obj then
			return
		end
		local x,y = guide.getScenePos(obj)
		guide.currGuideNode = require("app.ui.guide.GuideUI").new(i_GuideId,x,y)
    	g_LayerManager:addMaskUI(guide.currGuideNode)
	end
end

init()
return guide