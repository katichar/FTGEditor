local manager = {
	-- 玩家唯一标识
	userid = 0,
	-- 玩家状态，是否正常/作弊
	flag = USER_DEFAULT.STATUS_NORMAL,
	-- 角色列表
	rolelist = {},
	-- 当前角色
	roleinfo = {},
	-- 装备信息
	equipinfo={},
	-- 当前关卡信息
	glinfo={},
	-- 阵营
	camp = nil,
	-- 阵营成绩
	campscore=0,
	-- 阵营排名
	camprank=0,
}

--基本信息初始化
local function init()
	manager.userid = g_CommonUtil.md5(g_UA.getDeviceId())
	local info_ = g_DB.getUserInfo(manager.userid)
	--如果用户存在
	if info_.isexist then
		manager.sid = info_.sid
		manager.flag = info_.flag or USER_DEFAULT.STATUS_NORMAL
		if not g_CommonUtil.isEmpty(info_.name) then
			manager.name = info_.name
		end
		manager.rolelist = info_.rolelist
		--默认第一个角色为缺省角色
		for k,v in pairs(manager.rolelist) do
			manager.roleinfo = v
			break;
		end
	end
	--初始化监听
	manager.setupListener()
	local setinfo = g_DB.getExinfoByType(ROLE_EXINFO_TYPE.SOUND,manager.userid)
    if setinfo and setinfo[1] then
        EFFECT_SOUND = tonumber(setinfo[1].exinfovalue)==1
    end
    setinfo = g_DB.getExinfoByType(ROLE_EXINFO_TYPE.MUSIC,manager.userid)
    if setinfo and setinfo[1] then
        EFFECT_MUSIC = tonumber(setinfo[1].exinfovalue)==1
    end
    setinfo = g_DB.getExinfoByType(ROLE_EXINFO_TYPE.ROCKER,manager.userid)
    if setinfo and setinfo[1] then
        EFFECT_ROCKER = tonumber(setinfo[1].exinfovalue)==1
    end
	audio.setSoundsVolume(EFFECT_SOUND==true and 1 or 0)
	audio.setMusicVolume(EFFECT_MUSIC==true and 1 or 0)
end

-- 建立监听
function manager.setupListener()
	g_EventManager.addListener(MESSAGE_EVENT.MONEY_CHANGE, manager.changeMoney)
end

-- 去除监听
function manager.removeListener()
	g_EventManager.removeListener(MESSAGE_EVENT.MONEY_CHANGE, manager.changeMoney)
end

-- 创建用户
function manager.createUser(i_Info)
	manager.sid = i_Info.sid
	g_DB.createUser(i_Info,manager.userid)
end

-- 更新用户信息
function manager.updateUser(i_Info)
	manager.flag = USER_DEFAULT.STATUS_NORMAL
	if i_Info then
		if i_Info.ban then
			manager.flag = USER_DEFAULT.STATUS_ILLEGAL
		end
		if i_Info.myCamp then
			manager.campscore = i_Info.myCamp.score
			manager.camprank = i_Info.myCamp.value
		end
	end
	g_DB.updateUserStatus(manager.flag,manager.userid)
end

-- 玩家更名
function manager.updateName(i_Name)
	if g_DB.updateUserName(i_Name,manager.userid) then
		manager.name = i_Name
		--更名同步
		g_EventManager.dispatch(MESSAGE_EVENT.ROLE_EXP_CHANGE)
		return true
	end
	return false
end

--创建新角色
function manager.createRole(i_RoleType)
	local roleid = g_DB.createRole(i_RoleType,manager.userid)
	manager.rolelist[roleid]={roleid=roleid,lvl=1,type=i_RoleType}
	manager.setCurrRole(roleid)
end

--更新角色信息
-- @i_Data 角色对象
function manager.updateRole(i_Data)
	if i_Data then
		local tmpattr = checknumber(i_Data.attrhp)
		tmpattr = tmpattr + checknumber(i_Data.attratk)
		tmpattr = tmpattr + checknumber(i_Data.attrdef)
		tmpattr = tmpattr + checknumber(i_Data.attrmp)
		tmpattr = tmpattr + checknumber(i_Data.attrluck)
		tmpattr = tmpattr + checknumber(i_Data.attr)
		if tmpattr >  g_LogicUtil.getMaxAttrNum(manager.roleinfo.type,manager.roleinfo.lvl) then
			--记录玩家作弊信息
			pcall(g_UA.cheatInfo,"属性点修改")
			return
		end
		g_DB.updateRole(i_Data,true)
		manager.loadRoleInfo(manager.roleinfo.roleid)
	end
end

--设置当前角色ID
function manager.setCurrRole(i_RoleId)
	manager.loadRoleInfo(i_RoleId)
	--设置剧情缺省关卡
	local glvl_ = math.ceil((#manager.getGameLvl()+1)/5)
	CURR_CASE_INDEX = math.min(glvl_,#g_GameLvl.glvl)

	--记录玩家使用的角色信息
	pcall(g_UA.recordRole,manager.roleinfo)
end

-- 加载角色信息
function manager.loadRoleInfo(i_RoleId)
	manager.roleinfo = g_DB.getRoleInfo(i_RoleId,manager.userid)
	local baseinfo = g_RoleConfig[manager.roleinfo.type]

	table.merge(manager.roleinfo,baseinfo)

	manager.roleinfo.hp = g_DataUtil.getHP(baseinfo.basehp,baseinfo.grouphp,manager.roleinfo.attrhp)
	manager.roleinfo.atk = g_DataUtil.getATK(baseinfo.baseatk,baseinfo.groupatk,manager.roleinfo.attratk)
	manager.roleinfo.mp = g_DataUtil.getMP(baseinfo.basemp,baseinfo.groupmp,manager.roleinfo.attrmp)
	manager.roleinfo.def = manager.roleinfo.attrdef
	manager.roleinfo.luck = manager.roleinfo.attrluck

	local equipinfo = manager.getEquipByRoleId()
	for i,obj in ipairs(equipinfo) do
		for _,v in ipairs(obj.attrlist) do
			if v.type == g_Dict.hp.tag then
				manager.roleinfo.hp = manager.roleinfo.hp + v.attrvalue
			elseif v.type == g_Dict.atk.tag then
				manager.roleinfo.atk = manager.roleinfo.atk + v.attrvalue
			elseif v.type == g_Dict.mp.tag then
				manager.roleinfo.mp = manager.roleinfo.mp + v.attrvalue
			elseif v.type == g_Dict.def.tag then
				manager.roleinfo.def = manager.roleinfo.def + v.attrvalue
			elseif v.type == g_Dict.luck.tag then
				manager.roleinfo.luck = manager.roleinfo.luck + v.attrvalue
			elseif v.type == g_Dict.restoremp.tag then
				manager.roleinfo.restoremp = manager.roleinfo.restoremp + v.attrvalue 
			elseif v.type == g_Dict.critchance.tag then
				manager.roleinfo.critchance = manager.roleinfo.critchance + v.attrvalue
			elseif v.type == g_Dict.critdamage.tag then
				manager.roleinfo.critdamage = manager.roleinfo.critdamage + v.attrvalue
			elseif v.type == g_Dict.atkp.tag then
				manager.roleinfo.atkp = manager.roleinfo.atkp + v.attrvalue
			elseif v.type == g_Dict.hpp.tag then
				manager.roleinfo.hpp = manager.roleinfo.hpp + v.attrvalue
			elseif v.type == g_Dict.mpp.tag then
				manager.roleinfo.mpp = manager.roleinfo.mpp + v.attrvalue
			elseif v.type == g_Dict.defp.tag then
				manager.roleinfo.defp = manager.roleinfo.defp + v.attrvalue
			end
		end
	end
	manager.roleinfo.hp = math.modf(manager.roleinfo.hp*(1+manager.roleinfo.hpp*0.01))
	manager.roleinfo.mp = math.modf(manager.roleinfo.mp*(1+manager.roleinfo.mpp*0.01))
	manager.roleinfo.atk = math.modf(manager.roleinfo.atk*(1+manager.roleinfo.atkp*0.01))
	manager.roleinfo.def = math.modf(manager.roleinfo.def*(1+manager.roleinfo.defp*0.01))
	-- 幸运转化为暴击
	manager.roleinfo.critchance = manager.roleinfo.critchance + manager.roleinfo.luck/4
	-- 计算免伤值(玩家为显示数值/10)
	manager.roleinfo.avoidinjury = g_DataUtil.getDef(manager.roleinfo.def/10)

	g_EventManager.dispatch(MESSAGE_EVENT.ROLE_ATTR_CHANGE,{type=g_UI.ATTR_CHANGE_TYPE.ATTR})
end

--获取当前角色
function manager.getCurrRole()
	return manager.roleinfo
end

--返回装备信息
function manager.getEquip(i_UserEquipId)
	if i_UserEquipId then
		return g_DB.getEquip(manager.userid,i_UserEquipId)[1]
	else
		if manager.roleinfo then
			manager.equipinfo = g_DB.getEquip(manager.userid,i_UserEquipId,manager.roleinfo.roleid)
		else
			manager.equipinfo = g_DB.getEquip(manager.userid,i_UserEquipId)
		end
		return manager.equipinfo
	end
end

-- 返回角色的装备信息
-- @i_RoleId 角色ID，缺省为当前角色
function manager.getEquipByRoleId(i_RoleId)
	i_RoleId = i_RoleId or manager.roleinfo.roleid
	return g_DB.getEquipByRoleId(i_RoleId,manager.userid)
end

--穿装备
function manager.wearEquip(i_OldUserEquipId,i_UserEquipId)
	g_DB.wearEquip(i_OldUserEquipId,i_UserEquipId,manager.roleinfo.roleid)
	manager.loadRoleInfo(manager.roleinfo.roleid)
end

--强化装备
--@i_UserEquipId 装备唯一ID
--@i_Ehexp 最终强化经验
function manager.equipEnhancement(i_UserEquipId,i_Ehexp)
	if checknumber(i_UserEquipId)>0 and checknumber(i_Ehexp) >0 then
		g_DB.equipEnhancement(i_UserEquipId,i_Ehexp,manager.userid)
		manager.loadRoleInfo(manager.roleinfo.roleid)
		return manager.getEquip(i_UserEquipId)
	else
		return nil
	end
end

-- 返回当前角色装备的技能信息
function manager.getSkillInfo()
	return g_DB.getSkillInfo(manager.roleinfo)
end

-- 更新/添加 角色技能
function manager.updateSkill(i_SkillId,i_Lvl)
	g_DB.updateSkill(i_SkillId,i_Lvl,manager.roleinfo.roleid)
end

-- 更新 角色技能等级/装备位置
-- @i_Data={{skillid,lvl,sn}}
function manager.updateSkillSN(i_Data)
	g_DB.updateSkillSN(i_Data,manager.roleinfo.roleid)
end

-- 更新技能槽
-- @i_SkillNum
function manager.updateSkillNum(i_SkillNum)
	if i_SkillNum then
		g_DB.updateSkillNum(i_SkillNum,manager.roleinfo.roleid,manager.userid)
		manager.roleinfo.skillnum = i_SkillNum or manager.roleinfo.skillnum
	end
end

-- 返回当前角色的关卡信息
function manager.getGameLvl()
	local gamelvl_,userstart_= g_DB.getGameLvl(manager.userid)
	local totalstar_ = (#g_GameLvl.glvl)*5*3
	return gamelvl_,userstart_,totalstar_
end

-- 更新关卡信息
function manager.updateGameLvl(i_Score,i_FinishTime,i_Star,i_SubGLvlId)
	g_DB.updateGameLvl(i_Score,i_FinishTime,i_Star,i_SubGLvlId,manager.roleinfo.roleid,manager.userid)
end

-- 保存当前的关卡
function manager.setCurrGameLvl(i_Info)
	manager.glinfo = i_Info
end

-- 玩家添加经验
function manager.addExp(i_Exp, i_RoleId)
	--是否升级
	local lvlup = false

	i_Exp = checknumber(i_Exp)
	if i_Exp <=0 then
		return
	end

	i_RoleId = i_RoleId or manager.roleinfo.roleid
	local roleinfo = g_DB.getRoleInfo(i_RoleId,manager.userid)
	if roleinfo == nil then
		return
	end
	if roleinfo.lvl < USER_DEFAULT.MAX_LVL then
		roleinfo.exp = roleinfo.exp + i_Exp
		for i=roleinfo.lvl,USER_DEFAULT.MAX_LVL do
			if roleinfo.exp<g_DataUtil.getLvlUpExp(i) then
				break;
			else
				roleinfo.exp = roleinfo.exp - g_DataUtil.getLvlUpExp(i)
				roleinfo = g_DataUtil.getRoleLvlUp(roleinfo,1)
				lvlup = true
			end
		end
	else
		-- 最大经验值不超过最大等级要求
		roleinfo.exp = math.min((roleinfo.exp + i_Exp),g_DataUtil.getLvlUpExp(USER_DEFAULT.MAX_LVL))
	end
	--更新数据库
	g_DB.updateRole(roleinfo)
	
	if i_RoleId == manager.roleinfo.roleid then
		manager.roleinfo.lvl = roleinfo.lvl
		manager.roleinfo.exp = roleinfo.exp
		manager.roleinfo.attr = roleinfo.attr
	end
	--通知经验变化
	g_EventManager.dispatch(MESSAGE_EVENT.ROLE_EXP_CHANGE)
	
	--记录玩家升级
	if lvlup then
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.ATTR)
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.ROLE)
		pcall(g_UA.recordLevelUP,roleinfo.lvl)
		for _,value in ipairs(SKILL_LOCK_LVL) do
			if roleinfo.lvl == value then
				local info = {descr="有新解锁的技能，快去看看吧！"}
    			g_LayerManager:addPopUI(require("app.ui.popdialog.PopDialogUI").new(info))
			end
		end

		--等级变化，更新List
		if manager.rolelist[i_RoleId] then
			manager.rolelist[i_RoleId].lvl=roleinfo.lvl
		end
	end
end

-- 更新财富
function manager.changeMoney(i_EventName,i_Info)
	if i_Info then
		--抽取装备时，确保货币为-值
		if i_Info.type == INCOME_EXPENSE.DIAMOND_LOTTERY or i_Info.type == INCOME_EXPENSE.GOLD_LOTTERY then
			if i_Info.gold then
				i_Info.gold = -math.abs(checknumber(i_Info.gold))
			end
			if i_Info.diamond then
				i_Info.diamond = -math.abs(checknumber(i_Info.diamond))
			end
		end

		if i_Info.gold or i_Info.diamond then
			g_DB.updateAsset(i_Info,manager.userid)

			--添加购买记录
			pcall(g_UA.onPurchase,i_Info)
		end
	end
end

-- 返回金币
function manager.getMoney()
	local money = g_DB.getAsset(manager.userid)
	return money
end

-- 返回钻石
function manager.getDiamond()
	local money,diamond = g_DB.getAsset(manager.userid)
	return diamond
end

function manager.onSkill(i_Mp)
	if tolua.isnull(g_UI.child.hpbar) then
		return true
	else 
		if i_Mp <= g_UI.child.hpbar.mp then
			return true
		else
			-- 蓝不够 需要提示玩家 
			return false
		end
	end
end

-- 针对装备属性
-- MP恢复
function manager.restore()
	local mp = manager.roleinfo.restoremp/5
	g_EventManager.dispatch(MESSAGE_EVENT.ROLE_BAR_CHANGE,{mp=mp})	
end

-- 销毁
function manager.destroy()
	manager.removeListener()
end

init()
return manager