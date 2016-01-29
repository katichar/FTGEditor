--记录玩家的行为类

local manager={}

manager.initflag = false

function manager.init()
	if device.platform=="ios" or device.platform == "android" then
		manager.initflag = true
		TalkingDataGA:setVerboseLogDisabled()
		if device.platform=="ios" then
			TalkingDataGA:onStart("3225FE293983D7E8BCF3A82E85F6766D","AppStore")
		end
	else
		manager.initflag = false
	end
end

function manager.destroy()
	manager.initflag = false
end

-- 返回设备ID
function manager.getDeviceId()
	if manager.initflag == false then
		return device.getOpenUDID()
	end
	return TalkingDataGA:getDeviceId()
end

--返回IDFA
function manager.getIDFA()
	if device.platform == "ios" then
        local ret,idfa=luaoc.callStaticMethod("ThirdSDK","getIDFA")
    	if ret then
    		return idfa
    	end
	end
	return manager.getDeviceId()
end

-- 记录角色信息
function manager.recordRole(i_Info)
	if manager.initflag == false then return end

	TDGAAccount:setAccount(g_User.userid)
	-- TDGAAccount:setAccountType(kAccountAnonymous)
	TDGAAccount:setAccountName(g_User.name or g_Dict.getDescrByKey("OBJ_TYPE",i_Info.type))
	TDGAAccount:setLevel(i_Info.lvl)
	TDGAAccount:setGameServer("一服")
end

-- 记录升级
function manager.recordLevelUP(i_Lvl)
	if manager.initflag == false then return end

	TDGAAccount:setLevel(i_Lvl)
end

--任务开始
function manager.gameLvlBegin(i_Info)
	if manager.initflag == false then return end

	i_Info = i_Info or string.format("关卡：%d-%d",g_User.glinfo.glvlid,g_User.glinfo.subglvlid)
	TDGAMission:onBegin(i_Info)
end

--关卡完成
function manager.gameLvlSuccess(i_Info)
	if manager.initflag == false then return end

	i_Info = i_Info or string.format("关卡：%d-%d",g_User.glinfo.glvlid,g_User.glinfo.subglvlid)
	TDGAMission:onCompleted(i_Info)
end

--关卡失败
function manager.gameLvlFailed(i_Info)
	if manager.initflag == false then return end
	
	i_Info = i_Info or string.format("关卡：%d-%d",g_User.glinfo.glvlid,g_User.glinfo.subglvlid)
	TDGAMission:onFailed(i_Info,"角色死亡")
end

-- 充值记录
function manager.onCharge(i_OrderId,i_ProductId,i_PaymentPart)
	if manager.initflag == false then return end

	local info = g_Shop.getDiamondInfoByIndentifiers(i_ProductId)
	if info then
		TDGAVirtualCurrency:onChargeRequest(i_OrderId,info.name,info.price,"CNY",info.num,i_PaymentPart)
		TDGAVirtualCurrency:onChargeSuccess(i_OrderId)
	end
	info = nil
end

-- 钻石购买消耗
-- @i_PrdName 	购买商品名称
-- @i_Num 		购买数量
-- @i_Money 	购买花费
function manager.onPurchase(i_Info)
	if manager.initflag == false then return end

	if i_Info.type==INCOME_EXPENSE.CHARGE then
		return
	elseif i_Info.type==INCOME_EXPENSE.ACTIVITY_REWARD or i_Info.type==INCOME_EXPENSE.EMAIL_REWARD or i_Info.type==INCOME_EXPENSE.GAME_LVL_REWARD then
		if checknumber(i_Info.gold)>0 then
			TDGAVirtualCurrency:onReward(i_Info.gold,i_Info.type)
		end
		if checknumber(i_Info.diamond)>0 then
			TDGAVirtualCurrency:onReward(i_Info.diamond,i_Info.type)
		end
	elseif i_Info.type==INCOME_EXPENSE.GOLD_LOTTERY then
		TDGAItem:onPurchase(string.format("D_%s",i_Info.type),1,math.abs(checknumber(i_Info.gold)))
	else
		TDGAItem:onPurchase(string.format("D_%s",i_Info.type),1,math.abs(checknumber(i_Info.diamond)))
	end
end

--消耗物品，如出售装备
-- @i_Name 物品名称
-- @i_Num 	物品数量
function manager.onUse(i_Name,i_Num)
	if manager.initflag == false then return end

	TDGAItem:onUse(i_Name,i_Num)
end

--记录打开界面的次数
--@UICode 页面ID
function manager.openUI(i_UICode)
	if manager.initflag == false then return end

	if g_CommonUtil.isEmpty(i_UICode) then return end
	TalkingDataGA:onEvent("OpenUI",{PageName=i_UICode})
end

--作弊
--@i_Type 作弊类型
function manager.cheatInfo(i_Type)
	if manager.initflag == false then return end

	if g_CommonUtil.isEmpty(i_Type) then return end
	TalkingDataGA:onEvent("Cheat",{Type=i_Type})
end

manager.init()

return manager
