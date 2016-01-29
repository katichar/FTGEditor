-- UI 图形 声音 管理
local ui = {}

ui.files = {
	-- 普通点击
	[1] = "sounds/90025.mp3",
	-- 进入主界面
	[2] = "sounds/90027.mp3",
	-- 人物升级
	[3] = "sounds/90028.mp3",
	-- 金币掉落 金币花费
	[4] = "sounds/90029.mp3",
	-- 切换页面用
	[5] = "sounds/900210.mp3",
	-- 技能 装备 强化升级
	[6] = "sounds/900211.mp3",
	-- 穿装备
	[7] = "sounds/900212.mp3",
	-- 点击被锁定无效
	[8] = "sounds/900213.mp3",
	-- 选中罗飞
	[9] = "sounds/900234.mp3",
	-- 选中剑云1
	[10] = "sounds/900235.mp3",
	-- 选中剑云2
	[11] = "sounds/900236.mp3",
	-- 选中Darker
	[12] = "sounds/900237.mp3",
	-- 数字滚动声音
	[13] = "sounds/900238.mp3",
}

ui.child = {}

ui.TIP_TYPE = {
	-- 角色按钮
	ROLE = 1,
	-- 属性按钮
	ATTR = 2,
	-- 装备按钮
	EQUIP = 3,
	-- 签到
	LOGIN = 4,
	-- 首冲
	FIRSTPAY = 5,
	-- 充值奖励
	PAYREWARD = 6,
	-- 新手礼包
	NEW_PLAYER = 7,
	-- 新邮件
	MAIL1 = 8,
	-- 通知单
	MAIL2 = 9,
}
ui.tips = {
	[ui.TIP_TYPE.ROLE] = {flag=false,obj=nil},
	[ui.TIP_TYPE.ATTR] = {flag=false,obj=nil},
	[ui.TIP_TYPE.EQUIP] = {flag=false,obj=nil},
	[ui.TIP_TYPE.LOGIN] = {flag=false,obj=nil},
	[ui.TIP_TYPE.FIRSTPAY] = {flag=false,obj=nil},
	[ui.TIP_TYPE.PAYREWARD] = {flag=false,obj=nil},
	[ui.TIP_TYPE.NEW_PLAYER] = {flag=false,obj=nil},
	[ui.TIP_TYPE.MAIL1] = {flag=false,obj=nil},
	[ui.TIP_TYPE.MAIL2] = {flag=false,obj=nil},
}

-- 装备属性对比类别
ui.ATTR_CHANGE_TYPE = {
	EQUIP = 1,
	ATTR = 2,
}

local function init()
	--预加载UI音效 
	for i,v in ipairs(ui.files) do
		audio.preloadSound(v)
	end
	ui.addListener()
end

function ui.addListener()
	g_EventManager.addListener(MESSAGE_EVENT.UI_NEW_TIP,ui.newTip)
end

function ui.playSound(i_SoundId,i_Bool)
	if ui.files[i_SoundId] then
		return audio.playSound(ui.files[i_SoundId],i_Bool)
	end
end

function ui.stopSound(i_Sound)
	audio.stopSound(i_Sound)
end

function ui.unloadSounds()
	-- 释放开始游戏按钮声音资源
	audio.unloadSound("sounds/90026.mp3")
	for i,v in ipairs(ui.files) do
		audio.unloadSound(v)
	end
end

function ui.showTip(i_Type,i_Obj,i_X,i_Y,i_First)
	-- 初次创建 检查是否需要提示
	if i_First then
		
	else 
		ui.tips[i_Type].flag = true
	end

	if not i_Obj then return end
	if ui.tips[i_Type].flag then
		if ui.tips[i_Type].obj and not tolua.isnull(ui.tips[i_Type].obj) then
			ui.tips[i_Type].obj.newTip:removeSelf()
			ui.tips[i_Type].obj.newTip=nil
		end
		ui.tips[i_Type].obj = i_Obj
		i_Obj.newTip = display.newSprite("ui/common/ui_common_newtip.png")
            :align(display.CENTER,i_X,i_Y)
            :addTo(i_Obj)
	end
end

function ui.hideTip(i_Type)
	ui.tips[i_Type].flag = false
	if ui.tips[i_Type].obj and not tolua.isnull(ui.tips[i_Type].obj) then
		ui.tips[i_Type].obj.newTip:removeSelf()
	end
	ui.tips[i_Type].obj=nil
end

function ui.isShow(i_Type)
	return ui.tips[i_Type].flag
end

function ui.newTip(eventname,msg)
	ui.tips[msg].flag = true
end

function ui.initNewTips()
	ui.initAttr()
	ui.initLogin()
	ui.initFirstPay()
	ui.initBigReward()
	ui.initMail()
end

function ui.initAttr()
	-- 角色属性
	if g_User.roleinfo.attr and g_User.roleinfo.attr ~= 0 then
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.ATTR)
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.ROLE)
	end
end

function ui.initLogin()
	-- 签到
	local dbinfo = g_DB.getActivityByType(ACTIVITY_TYPE.LOGIN,g_User.userid)
	if dbinfo.num then
		if os.date("%x",g_Timer.SERVER_TIME) ~= os.date("%x",dbinfo.lasttime) then
			g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.LOGIN)		
		end
	else 
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.LOGIN)
	end
end

function ui.initFirstPay()
	-- 首冲
	local dbinfo = g_DB.getExinfoByType(ROLE_EXINFO_TYPE.FIRST_PAY,g_User.userid)
	if dbinfo[1] and not dbinfo[2] then
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.FIRSTPAY)
	end
end

function ui.initBigReward()
	-- 大礼包
	local dbinfo = g_DB.getTotalCharge(g_User.userid)
	local n = 0
	local temp = 0
	if dbinfo >= 10 then n = n + 1 end
	if dbinfo >= 50 then n = n + 1 end
	if dbinfo >= 100 then n = n + 1 end
	if dbinfo >= 200 then n = n + 1 end
	if dbinfo >= 400 then n = n + 1 end
	dbinfo = g_DB.getExinfoByType(ROLE_EXINFO_TYPE.PAY_REWARD,g_User.userid)
	for k,v in pairs(dbinfo) do
		temp = temp + 1
	end
	if temp < n then
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.PAYREWARD)
	end
end

function ui.initMail()
	for i,v in ipairs(g_DB.getMails(g_User.userid)) do
		if v.flag == MAIL_STATUS.NEW then
			g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.MAIL1)
			g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.MAIL2)
			return
		end
	end
end

-- 开启触摸显示详细信息
-- 显示信息默认存储为  i_Object.ui_info
function ui.setTouch(i_Object,i_Info)
	i_Object.ui_info = i_Info
    local function onTouch(i_Event)
        if i_Event.name == "began" then
        	ui.playSound(1)
            ui.showItemTip(i_Object.ui_info)
        end
        return true
    end

    i_Object:setTouchEnabled(true)
    i_Object:setTouchSwallowEnabled(false)
    i_Object:addNodeEventListener(cc.NODE_TOUCH_EVENT,onTouch)
end

function ui.showItemTip(i_Info)
	g_LayerManager:addPopUI(require("app.ui.tip.TipItemInfoUI").new(i_Info))
end

function ui.showEquipInfo(i_Info,i_InfoEx,i_ShowEh)
	g_LayerManager:addPopUI(require("app.ui.tip.TipEquipInfoUI").new(i_Info,i_InfoEx,i_ShowEh))
end

-- 盖章动画
function ui.caseEndEffect(i_Obj,i_IsAction)
	if i_IsAction then
		local sp = display.newSprite("ui/case/ui_case_end.png")
			:align(display.CENTER,i_Obj:getContentSize().width/2,i_Obj:getContentSize().height/2+30)
			:addTo(i_Obj)
			:setScale(2)
		local act = cc.ScaleTo:create(0.2,0.5)
		sp:runAction(act)
	else
		local sp = display.newSprite("ui/case/ui_case_end.png")
			:align(display.CENTER,i_Obj:getContentSize().width/2,i_Obj:getContentSize().height/2+30)
			:addTo(i_Obj)
			:setScale(0.5)
	end
end

-- 关卡结束盖章动画
function ui.bossEndEffect(i_Func,...)
	local node = g_BasePopUI.new()
	args = {...}
	g_LayerManager:addEffectUI(node)
	local bg = display.newSprite(string.format("ui/case/ui_case_boss%d.png",CURR_CASE_INDEX))
		:align(display.CENTER,display.cx,display.cy)
		:addTo(node)
		:setScale(2)

	local function gonext()
		local sp = display.newSprite("ui/case/ui_case_end.png")
		:align(display.CENTER,bg:getContentSize().width/4*3,bg:getContentSize().height/4*3)
		:addTo(bg)
		:setScale(3)

		sp:runAction(cc.ScaleTo:create(0.1,1))
	end

	local act = transition.sequence({cc.ScaleTo:create(0.2,1),cc.DelayTime:create(0.2),cc.CallFunc:create(gonext)})
	bg:runAction(act)


	local function actend()
		if type(i_Func) == "function" then
			i_Func(unpack(args))
		end
		node:removeSelf()
	end
	g_Timer.callAfter(actend,2)
end

-- 新玩家操作指引
function ui.showNewPlayerGuide(i_Func,...)
	g_LayerManager:addPopUI(require("app.ui.tip.TipNewPlayerUI").new(i_Func,...))
end

init()

return ui