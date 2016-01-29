--数据库操作类

local dbmanager={}
local db = require("app.modules.BaseDB")

local function init()
	dbmanager.conn = db.getConnection()
end

--格式化字符
local function sqlStr(i_Data)
	i_Data = string.gsub(i_Data, "'", "''")
	return string.format("'%s'", i_Data)
end

--根据用户ID返回用户信息
function dbmanager.getUserInfo(i_UserId)
	if i_UserId == nil then
		printError("i_RoleId or i_UserId is nil")
		return
	end

	-- 用户缺省信息
	local result={
		rolelist={},
		isexist=false
	}
	-- 用户信息
	for row in dbmanager.conn:nrows("select * from user_info u where u.userid="..sqlStr(i_UserId)) do
		result.sid = row.sid
		result.name = row.name
		result.flag = row.userflag
		result.isexist = true
	end

	-- 角色信息
	if result.isexist then
		for row in dbmanager.conn:nrows("select * from role_info r where r.userid="..sqlStr(i_UserId)) do
			result.rolelist[row.roleid]={roleid=row.roleid,lvl=row.lvl,type=row.type}
		end
	end
	return result
end

-- 创建用户信息
function dbmanager.createUser(i_Data,i_UserId)
	if i_Data == nil or i_UserId == nil then
		printError("i_Data or i_UserId is nil")
		return
	end

	local vm=dbmanager.conn:prepare("insert into user_info (userid,sid,money,diamond,userflag,lasttime) values(?,?,?,?,?,?)")
	-- vm:bind_values(i_UserId,i_Data.sid,i_Data.money,i_Data.diamond,USER_DEFAULT.STATUS_NORMAL,g_Timer.SERVER_TIME)
	vm:bind_values(i_UserId,i_Data.sid,0,0,USER_DEFAULT.STATUS_NORMAL,g_Timer.SERVER_TIME)
	vm:step()
	vm:finalize()

	--创建相关信息
	local sqls={}
	table.insert(sqls,"insert into user_activity (lasttime,activityid,num,userid) values(")
	table.insert(sqls,g_Timer.SERVER_TIME)
	table.insert(sqls,"," .. GAME_MODE.NORMAL)
	table.insert(sqls,"," .. MODE_COUNT[GAME_MODE.NORMAL])
	table.insert(sqls,"," .. sqlStr(i_UserId))
	table.insert(sqls,") ; \n ")
	table.insert(sqls,"insert into user_activity (lasttime,activityid,num,userid) values(")
	table.insert(sqls,g_Timer.SERVER_TIME)
	table.insert(sqls,"," .. GAME_MODE.HARD)
	table.insert(sqls,"," .. MODE_COUNT[GAME_MODE.HARD])
	table.insert(sqls,"," .. sqlStr(i_UserId))
	table.insert(sqls,") ; \n ")
	table.insert(sqls,"insert into user_activity (lasttime,activityid,num,userid) values(")
	table.insert(sqls,g_Timer.SERVER_TIME)
	table.insert(sqls,"," .. GAME_MODE.PVP)
	table.insert(sqls,"," .. MODE_COUNT[GAME_MODE.PVP])
	table.insert(sqls,"," .. sqlStr(i_UserId))
	table.insert(sqls,") ; \n ")

	dbmanager.conn:exec("begin transaction")
	dbmanager.conn:exec(table.concat(sqls))
	dbmanager.conn:exec("commit transaction")
	sqls = nil
end

-- 更新用户状态
function dbmanager.updateUserStatus(i_Status,i_UserId)
	if i_Status == nil or i_UserId == nil then
		printError("i_Status or i_UserId is nil")
		return
	end

	local vm=dbmanager.conn:prepare("update user_info set userflag=?,lasttime=? where userid=?")
	vm:bind_values(i_Status,g_Timer.SERVER_TIME,i_UserId)
	vm:step()
	vm:finalize()
end

-- 更新玩家名称
function dbmanager.updateUserName(i_Name,i_UserId)
	if i_Name == nil or i_UserId == nil then
		printError("i_Name or i_UserId is nil")
		return false
	end

	local vm=dbmanager.conn:prepare("update user_info set name=? ,lasttime=? where userid=?")
	vm:bind_values(i_Name,g_Timer.SERVER_TIME,i_UserId)
	vm:step()
	vm:finalize()
	return true
end

-- 更新资产信息
function dbmanager.updateAsset(i_Info,i_UserId)
	local money = checknumber(i_Info.gold)
	local diamond = checknumber(i_Info.diamond)

	local sql={}
	table.insert(sql,"update user_info set ")
	table.insert(sql," lasttime=" .. sqlStr(g_Timer.SERVER_TIME))
	table.insert(sql,",money=money+" .. money)
	table.insert(sql,",diamond=diamond+" .. diamond)
	table.insert(sql," where userid=" .. sqlStr(i_UserId))
	dbmanager.conn:exec(table.concat(sql))
	money=0
	diamond=0
	sql = nil
end

--返回财富信息
function dbmanager.getAsset(i_UserId)
	local money,diamond=0,0
	for row in dbmanager.conn:nrows("select * from user_info u where u.userid="..sqlStr(i_UserId)) do
		money = row.money
		diamond = row.diamond
	end
	return money,diamond
end

--根据roleID返回角色信息
function dbmanager.getRoleInfo(i_RoleId,i_UserId)
	if i_RoleId == nil or i_UserId == nil then
		printError("i_RoleId or i_UserId is nil")
		return
	end

	local sql = {}
	table.insert(sql,"select * from role_info where roleid=")
	table.insert(sql,i_RoleId)
	table.insert(sql," and userid=")
	table.insert(sql, sqlStr(i_UserId))
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		return {
					roleid=row.roleid,
					type=row.type,
					lvl=row.lvl,
					attrhp = row.hp,
					attratk = row.atk,
					attrdef = row.def,
					attrmp = row.mp,
					attrluck = row.luck,
					attr=row.attr,
					exp=row.exp,
					skillnum = row.skillnum,
					userid=i_UserId
				}
	end
	sql=nil
end

--根据角色类型创建新角色
function dbmanager.createRole(i_Type,i_UserId)
	if i_Type == nil or i_UserId == nil then
		printError("i_Type or i_UserId is nil")
		return
	end

	local sql={}
	table.insert(sql,"select * from role_info where type=")
	table.insert(sql,i_Type)
	table.insert(sql," and userid=")
	table.insert(sql, sqlStr(i_UserId))
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		sql = nil
		return row.roleid
	end
	sql = {}
	table.insert(sql,"insert into role_info (type,lvl,hp,atk,def,mp,luck,attr,exp,skillnum,userid) values(")
	table.insert(sql,i_Type)
	table.insert(sql,",1")
	table.insert(sql,",".. USER_DEFAULT.ATTRHP)
	table.insert(sql,",".. USER_DEFAULT.ATTRATK)
	table.insert(sql,",".. USER_DEFAULT.ATTRDEF[i_Type])
	table.insert(sql,",".. USER_DEFAULT.ATTRMP)
	table.insert(sql,",".. USER_DEFAULT.ATTRLUCK)
	table.insert(sql,",0,0,2")
	table.insert(sql,","..sqlStr(i_UserId))
	table.insert(sql,")")
	dbmanager.conn:exec(table.concat(sql))
	sql = nil
	
	local serial
	for row in dbmanager.conn:nrows("select last_insert_rowid() as id from role_info") do
		serial=row.id
	end
	return serial
end

--更新角色信息
-- @i_Data 角色对象
function dbmanager.updateRole(i_Data,i_AttrFlag)
	if i_Data == nil then
		printError("i_Data is nil")
		return 
	end
	
	local sql={}
	table.insert(sql,"update role_info set ")
	table.insert(sql," attr=" .. i_Data.attr)
	if i_AttrFlag then
		table.insert(sql,",hp=" .. i_Data.attrhp)
		table.insert(sql,",atk=" .. i_Data.attratk)
		table.insert(sql,",def=" .. i_Data.attrdef)
		table.insert(sql,",mp=" .. i_Data.attrmp)
		table.insert(sql,",luck=" .. i_Data.attrluck)
	else
		table.insert(sql,",lvl=" .. i_Data.lvl)
		table.insert(sql,",exp=" .. i_Data.exp)
	end
	-- table.insert(sql,",skillnum=" .. i_Data.skillnum)
	table.insert(sql," where roleid=" .. i_Data.roleid)
	table.insert(sql," and userid=" .. sqlStr(i_Data.userid))
	dbmanager.conn:exec(table.concat(sql))
	sql = nil
end

--更新技能槽
function dbmanager.updateSkillNum(i_SkillNum,i_RoleId,i_UserId)
	if i_SkillNum == nil or i_RoleId==nil or i_UserId==nil then
		printError("i_SkillNum or i_RoleId or i_UserId is nil")
		return 
	end
	
	local sql={}
	table.insert(sql,"update role_info set ")
	table.insert(sql," skillnum=" .. i_SkillNum)
	table.insert(sql," where roleid=" .. i_RoleId)
	table.insert(sql," and userid=" .. sqlStr(i_UserId))
	dbmanager.conn:exec(table.concat(sql))
	sql = nil
end

--新增装备信息
function dbmanager.addEquip(i_EquipData,i_UserId)
	if i_EquipData == nil then
		printError("i_EquipData is nil")
		return
	end
	-- 判断是否为装备列表Table，如果不是，加上列表
	if i_EquipData.equipid then
		i_EquipData = {i_EquipData}
	end	

	local sqls={}
	local errornum_ = 0
	dbmanager.conn:exec("begin transaction")
	for i,info in ipairs(i_EquipData) do
		local sql={}
		table.insert(sql,"insert into user_equip (ehexp,lvl,roleid,userid,equipid,quality) values(0,1")
		table.insert(sql,",0")
		table.insert(sql,",".. sqlStr(i_UserId))
		table.insert(sql,",".. info.equipid)
		table.insert(sql,",".. info.quality)
		table.insert(sql,")")
		dbmanager.conn:exec(table.concat(sql))
		sql = nil
		
		local serial
		for row in dbmanager.conn:nrows("select last_insert_rowid() as id from user_equip") do
			serial=row.id
		end

		--添加属性信息
		if serial then
			for k,v in pairs(info.attrlist) do
				table.insert(sqls,"insert into user_equip_attr (userequipid,attrid,attrvalue) values(")
				table.insert(sqls,serial)
				table.insert(sqls,",".. v.attrid)
				table.insert(sqls,",".. v.attrvalue)
				table.insert(sqls,"); \n ")
			end
		end
	end

	if table.nums(sqls)>0 then
		errornum_ = dbmanager.conn:exec(table.concat(sqls))
	end
	if errornum_ == 0 then
		dbmanager.conn:exec("commit transaction")
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.EQUIP)
		g_EventManager.dispatch(MESSAGE_EVENT.UI_NEW_TIP,g_UI.TIP_TYPE.ROLE)
	else
		dbmanager.conn:exec("rollback transcation")
	end
	sqls = nil
end

-- 返回装备信息
function dbmanager.getEquip(i_UserId,i_UserEquipId,i_RoleId)
	if i_UserId == nil then
		printError("i_UserId is nil")
		return
	end

	local sql = {"select e.*,ea.id,ea.attrid,ea.attrvalue from user_equip e, user_equip_attr ea where ea.userequipid=e.userequipid and e.userid="}
	table.insert(sql,sqlStr(i_UserId))
	if i_UserEquipId then
		table.insert(sql," and e.userequipid= ")
		table.insert(sql,i_UserEquipId)
	end
	table.insert(sql," order by e.userequipid asc")

	local result={}
	local tmpueid=0
	local tmpequip = {}
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		if not i_RoleId or row.roleid == 0 or row.roleid == i_RoleId then
			if tmpueid ~= row.userequipid then
				tmpueid = row.userequipid
				local edata = g_Equip.equipinfo[row.equipid]
				tmpequip = {
								userequipid=row.userequipid,
								ehexp=checknumber(row.ehexp),
								lvl=row.lvl,
								equipid=row.equipid,
								index=edata.index,
								userid=row.userid,
								roleid=row.roleid,
								name=edata.name,
								descr=edata.descr,
								currency=edata.currency,
								currencydesc=g_Dict.getDescrByKey("currency",edata.currency),
								price=edata.price,
								type=edata.type,
								quality=row.quality,
								requirelist=clone(edata.requirelist),
								image=edata.image,
								attrlist={}
							}
				table.insert(result,tmpequip)
			end
			local atdata = g_EquipAttr[tmpequip.index][row.attrid]
			if atdata then
				local tmpattr = {attrid=atdata.attrid,type=atdata.type,formula=atdata.formula,attrvalue=row.attrvalue,descr=g_Dict.getDescr(atdata.type)}
				-- 强化值
				tmpattr.ehvalue = checknumber(g_Equipment.getEnhanceValue(row.equipid,row.ehexp,row.attrid,tmpequip.quality))
				tmpattr.attrvalue = tmpattr.attrvalue + tmpattr.ehvalue
				table.insert(tmpequip.attrlist,tmpattr)
			end
		end
	end
	return result
end

-- 返回角色装备信息
function dbmanager.getEquipByRoleId(i_RoleId,i_UserId)
	if i_RoleId == nil or i_UserId == nil then
		printError("i_RoleId or i_UserId is nil")
		return
	end

	local sql = {"select e.*,ea.id,ea.attrid,ea.attrvalue from user_equip e, user_equip_attr ea where ea.userequipid=e.userequipid and e.userid="}
	table.insert(sql,sqlStr(i_UserId))
	table.insert(sql," and e.roleid= ")
	table.insert(sql,i_RoleId)
	table.insert(sql," order by e.userequipid asc")

	local result={}
	local tmpueid=0
	local tmpequip = {}
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		if tmpueid ~= row.userequipid then
			tmpueid = row.userequipid
			local edata = g_Equip.equipinfo[row.equipid]
			tmpequip = {
							userequipid=row.userequipid,
							ehexp=checknumber(row.ehexp),
							lvl=row.lvl,
							equipid=row.equipid,
							userid=row.userid,
							roleid=row.roleid,
							name=edata.name,
							descr=edata.descr,
							currency=edata.currency,
							currencydesc=g_Dict.getDescrByKey("currency",edata.currency),
							price=edata.price,
							type=edata.type,
							index=edata.index,
							quality=row.quality,
							requirelist=clone(edata.requirelist),
							image=edata.image,
							attrlist={}
						}
			table.insert(result,tmpequip)
		end
		local atdata = g_EquipAttr[tmpequip.index][row.attrid]
		if atdata then
			local tmpattr = {attrid=atdata.attrid,type=atdata.type,formula=atdata.formula,attrvalue=row.attrvalue,descr=g_Dict.getDescr(atdata.type)}
			-- 强化值
			tmpattr.ehvalue = checknumber(g_Equipment.getEnhanceValue(row.equipid,row.ehexp,row.attrid,tmpequip.quality))
			tmpattr.attrvalue = tmpattr.attrvalue + tmpattr.ehvalue
			table.insert(tmpequip.attrlist,tmpattr)
		end
	end
	return result
end

--穿装备
-- @i_UserEquipId 玩家装备唯一值
function dbmanager.wearEquip(i_OldUserEquipId,i_UserEquipId,i_RoleId)
	if i_OldUserEquipId == nil or i_UserEquipId == nil or i_RoleId == nil then
		printError("i_UserEquipId or i_OldUserEquipId or i_RoleId is nil")
		return
	end

	local sqls={}
	--卸下原装备信息
	table.insert(sqls," update user_equip set roleid=0 where userequipid=")
	table.insert(sqls,i_OldUserEquipId)
	table.insert(sqls," ; \n ")
	--穿上新装备
	table.insert(sqls," update user_equip set roleid=")
	table.insert(sqls,i_RoleId)
	table.insert(sqls," where userequipid=")
	table.insert(sqls,i_UserEquipId)
	table.insert(sqls," ; \n ")
	dbmanager.conn:exec("begin transaction")
	dbmanager.conn:exec(table.concat(sqls))
	dbmanager.conn:exec("commit transaction")
	sqls = nil
end

--出售装备
-- @i_EquipInfo 玩家装备{唯一值,品阶} (多个为{{11,1},{13,2},{15,1})
-- @i_Money 出售的价格
function dbmanager.sellEquip(i_EquipInfo,i_UserId)
	if not g_CommonUtil.isTable(i_EquipInfo) or i_UserId == nil then
		printError("i_EquipInfo or i_UserId is nil")
		return
	end

	local sqls={}
	local money_ = 0
	if #i_EquipInfo>0 then
		for i,info_ in ipairs(i_EquipInfo) do
			--删除装备
			table.insert(sqls," delete from user_equip where userequipid=")
			table.insert(sqls,info_.userequipid)
			table.insert(sqls," ; \n ")

			money_ = money_ + g_DataUtil.getEquipSellPrice(info_.quality)

			pcall(g_UA.onUse,string.format("装备:%d,品阶:%d",info_.equipid or 0,info_.quality),1)
		end
	else
		--删除装备
		table.insert(sqls," delete from user_equip where userequipid=")
		table.insert(sqls,i_EquipInfo.userequipid)
		table.insert(sqls," ; \n ")

		money_ = money_ + g_DataUtil.getEquipSellPrice(i_EquipInfo.quality)

		pcall(g_UA.onUse,string.format("装备:%s,品阶:%s",i_EquipInfo.equipid or 0,i_EquipInfo.quality),1)
	end

	dbmanager.conn:exec("begin transaction")
	dbmanager.conn:exec(table.concat(sqls))
	dbmanager.conn:exec("commit transaction")
	-- end
	sqls = nil
	return money_
end

--装备强化
function dbmanager.equipEnhancement(i_UserEquipId,i_Ehexp,i_UserId)
	if i_UserEquipId==nil or i_Ehexp==nil or i_UserId == nil then
		printError("i_UserEquipId or i_Ehexp or i_UserId is nil")
		return
	end

	local sql={}
	--穿上新装备
	table.insert(sql," update user_equip set ehexp=")
	table.insert(sql,i_Ehexp)
	table.insert(sql," where userequipid=")
	table.insert(sql,i_UserEquipId)
	table.insert(sql," and userid=")
	table.insert(sql,sqlStr(i_UserId))
	dbmanager.conn:exec(table.concat(sql))
	sql = nil
end

--根据roleid返回该角色的技能信息
function dbmanager.getSkillInfo(i_RoleInfo)
	if i_RoleInfo == nil or i_RoleInfo.roleid == nil then
		printError("i_RoleInfo is nil")
		return
	end

	local sql = {}
	local result={}
	table.insert(sql,"select * from role_skill where roleid=")
	table.insert(sql,i_RoleInfo.roleid)
	table.insert(sql," order by sn asc")
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		if g_Skill[row.skillid] then
			local tmpdata = clone(g_Skill[row.skillid])
			tmpdata.lvl=row.lvl
			tmpdata.sn=row.sn or 0
			tmpdata.roleid=row.roleid
			--计算技能的伤害
			tmpdata.atk = (tmpdata.damage*i_RoleInfo.atk)*(1+tmpdata.upvalue*tmpdata.lvl)
			tmpdata.mp = g_DataUtil.getMPByLvl(tmpdata.basemp,tmpdata.lvl)
			table.insert(result,tmpdata)
		end
	end
	sql=nil
	return result
end

--更新技能顺序
function dbmanager.updateSkillSN(i_Data,i_RoleId)
	if i_Data == nil or table.nums(i_Data)<=0 or i_RoleId == nil then
		printError("i_Data（SkillInfo） or i_RoleId is nil")
		return
	end

	local sqls={}

	-- 更新技能信息
	for i,v in ipairs(i_Data) do
		table.insert(sqls," update role_skill set lvl=")
		table.insert(sqls,v.lvl)
		table.insert(sqls," , sn=")
		table.insert(sqls,v.sn)
		table.insert(sqls," where skillid=")
		table.insert(sqls,v.skillid)
		table.insert(sqls," and roleid=")
		table.insert(sqls,i_RoleId)
		table.insert(sqls," ; \n ")
	end
	dbmanager.conn:exec("begin transaction")
	dbmanager.conn:exec(table.concat(sqls))
	dbmanager.conn:exec("commit transaction")
	sqls = nil
end

--更新技能等级
function dbmanager.updateSkill(i_SkillId,i_Lvl,i_RoleId)
	if i_SkillId == nil or i_Lvl == nil or i_RoleId == nil then
		printError("i_SkillId or i_Lvl or i_RoleId is nil")
		return
	end

	local sql={}
	--更新信息
	table.insert(sql,"update role_skill set lvl=")
	table.insert(sql,i_Lvl)
	table.insert(sql," where skillid=")
	table.insert(sql,i_SkillId)
	table.insert(sql," and roleid=")
	table.insert(sql,i_RoleId)
	dbmanager.conn:exec(table.concat(sql))

	if dbmanager.conn:changes()==0 then
		dbmanager.conn:exec("insert into role_skill (skillid,roleid,lvl) values("..i_SkillId..","..i_RoleId..","..i_Lvl..")")
	end
	sql = nil
end

--根据角色返回关卡信息
function dbmanager.getGameLvl(i_UserId)
	if i_UserId == nil then
		printError("i_UserId is nil")
		return
	end

	local sql = {"select * from role_gamelvl where userid="}
	table.insert(sql,sqlStr(i_UserId))
	table.insert(sql," order by subglvlid asc")

	local result={}
	local resultstar = 0
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		result[row.subglvlid]={subglvlid=row.subglvlid,roleid=row.roleid,userid=row.userid,finishtime=row.finishtime,star=row.star,num=row.num,score=row.score}
		resultstar = resultstar + row.star or 0
	end
	return result,resultstar
end

--更新角色关卡信息
function dbmanager.updateGameLvl(i_Score,i_Finishtime,i_Star,i_SubGLvlId,i_RoleId,i_UserId)
	if i_Score == nil or i_Finishtime == nil or i_Star == nil or i_SubGLvlId == nil or i_RoleId == nil or i_UserId == nil then
		printError("i_Score or i_Finishtime or i_Star or i_SubGLvlId or i_RoleId or i_UserId is nil")
		return
	end

	local sql = {"update role_gamelvl set lasttime="}
	table.insert(sql,g_Timer.SERVER_TIME)
	table.insert(sql,",finishtime=min(finishtime,")
	table.insert(sql,i_Finishtime ..")")
	table.insert(sql,", star=max(star,")
	table.insert(sql,i_Star ..")")
	table.insert(sql,", score=max(score,")
	table.insert(sql,i_Score ..")")
	table.insert(sql,", roleid=")
	table.insert(sql,i_RoleId)
	table.insert(sql ," where subglvlid=")
	table.insert(sql,i_SubGLvlId)
	table.insert(sql," and userid=")
	table.insert(sql,sqlStr(i_UserId))
	dbmanager.conn:exec(table.concat(sql))

	if dbmanager.conn:changes()==0 then
		sql = {"insert into role_gamelvl (num,subglvlid,roleid,userid,finishtime,star,score) values("}
		table.insert(sql,MODE_COUNT[GAME_MODE.EASY]-1)
		table.insert(sql,",")
		table.insert(sql,i_SubGLvlId)
		table.insert(sql,",")
		table.insert(sql,i_RoleId)
		table.insert(sql,",")
		table.insert(sql,sqlStr(i_UserId))
		table.insert(sql,",")
		table.insert(sql,i_Finishtime)
		table.insert(sql,",")
		table.insert(sql,i_Star)
		table.insert(sql,",")
		table.insert(sql,i_Score)
		table.insert(sql,")")
		dbmanager.conn:exec(table.concat(sql))
	end
	sql = nil
end

-- 更新关卡次数
-- @i_SelectFlag 是否查询
function dbmanager.updateGameLvlNum(i_SubGLvlId,i_UserId,i_SelectFlag)
	if i_SubGLvlId == nil or i_UserId == nil then
		printError("i_SubGLvlId or i_UserId is nil")
		return
	end

	local isexist = false
	local result = MODE_COUNT[GAME_MODE.EASY]
	local sql = {"select num from role_gamelvl where userid="}
	table.insert(sql,sqlStr(i_UserId))
	table.insert(sql," and subglvlid=")
	table.insert(sql,i_SubGLvlId)
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		isexist = true
		result = row.num or result
	end
	--如果是查询次数，直接返回
	if i_SelectFlag then
		return result
	else
		result = result-1
	end

	if isexist then
		sql = {"update role_gamelvl set num=num-1, lasttime="}
		table.insert(sql,g_Timer.SERVER_TIME)
		table.insert(sql," where userid=")
		table.insert(sql,sqlStr(i_UserId))
		table.insert(sql," and subglvlid=")
		table.insert(sql,i_SubGLvlId)
		dbmanager.conn:exec(table.concat(sql))
	end
	sql = nil
	return result
end

-- 根据类型返回角色拓展信息
function dbmanager.getExinfoByType(i_ExinfoType,i_UserId)
	if not i_ExinfoType or i_UserId==nil then
		printError("i_ExinfoType or i_UserId is nil")
		return
	end

	local sql = {"select * from user_exinfo where type="}
	table.insert(sql,i_ExinfoType)
	table.insert(sql," and userid=" .. sqlStr(i_UserId))

	local result={}
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		result[row.exinfoid]={exinfoid=row.exinfoid,type=row.type,exinfovalue=row.exinfovalue}
	end
	sql = nil

	return result
end

-- 新增/更新扩展信息
function dbmanager.addExinfo(i_ExinfoType,i_ExinfoId,i_UserId,i_ExinfoValue)
	if i_ExinfoType == nil or i_ExinfoId == nil or i_UserId==nil then
		printError("i_ExinfoType or i_ExinfoId or i_UserId is nil")
		return
	end

	-- -- 更新信息
	-- local sql={"insert into user_exinfo (lasttime,type,exinfoid,userid) values("}
	-- table.insert(sql,g_Timer.SERVER_TIME)
	-- table.insert(sql,"," .. i_ExinfoType)
	-- table.insert(sql,"," .. i_ExinfoId)
	-- table.insert(sql,"," .. sqlStr(i_UserId))
	-- table.insert(sql,")")
	-- dbmanager.conn:exec(table.concat(sql))
	-- sql = nil
	local vm=dbmanager.conn:prepare("insert into user_exinfo (lasttime,type,exinfoid,userid,exinfovalue) values(?,?,?,?,?)")
	vm:bind_values(g_Timer.SERVER_TIME,i_ExinfoType,i_ExinfoId,i_UserId,i_ExinfoValue)
	local errornum_ = vm:step()
	vm:finalize()
	if errornum_ == db.getErrorCode("CONSTRAINT") then
		vm=dbmanager.conn:prepare("update user_exinfo set lasttime=?,exinfovalue=? where type=? and exinfoid=? and userid=?")
		vm:bind_values(g_Timer.SERVER_TIME,i_ExinfoValue,i_ExinfoType,i_ExinfoId,i_UserId)
		vm:step()
		vm:finalize()
	end
end

-- 根据类型返回角色剩余挑战次数
function dbmanager.getActivityByType(i_Activityid,i_UserId)
	if not i_Activityid or i_UserId==nil then
		printError("i_Activityid or i_UserId is nil")
		return
	end

	local sql = {"select * from user_activity where activityid="}
	table.insert(sql,i_Activityid)
	table.insert(sql," and userid="..sqlStr(i_UserId))

	local result={}
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		result = {activityid=row.activityid,num=row.num,lasttime=row.lasttime}
	end
	sql = nil

	return result
end

-- 更新扩展信息
function dbmanager.updateActivity(i_Activityid,i_Num,i_UserId,i_Timer)
	if i_Activityid == nil or i_Num == nil or i_UserId==nil then
		printError("i_Activityid or i_Num or i_UserId is nil")
		return
	end

	local sql={}
	--更新信息
	table.insert(sql,"update user_activity set num=")
	table.insert(sql,i_Num)
	if i_Timer then
		table.insert(sql," ,lasttime="..i_Timer)
	end
	table.insert(sql," where activityid=")
	table.insert(sql,i_Activityid)
	table.insert(sql," and userid=")
	table.insert(sql,sqlStr(i_UserId))
	dbmanager.conn:exec(table.concat(sql))

	if dbmanager.conn:changes()==0 then
		sql={"insert into user_activity (lasttime,activityid,num,userid) values("}
		table.insert(sql,g_Timer.SERVER_TIME)
		table.insert(sql,"," .. i_Activityid)
		table.insert(sql,"," .. i_Num)
		table.insert(sql,"," .. sqlStr(i_UserId))
		table.insert(sql,")")
		dbmanager.conn:exec(table.concat(sql))
	end
	sql = nil
end

--批量更新活动
-- @i_Info格式为{{num=9,activityid=1},{num=3,activityid=2}}
function dbmanager.batchUpdateActivity(i_Info,i_UserId)
	local sqls={}
	for i,v in ipairs(i_Info) do
		if v.activityid == GAME_MODE.EASY then
			--更新各任务关卡的次数
			table.insert(sqls," update role_gamelvl set num=")
			table.insert(sqls,MODE_COUNT[GAME_MODE.EASY])
			table.insert(sqls," ,lasttime="..g_Timer.SERVER_TIME)
			table.insert(sqls," where userid=")
			table.insert(sqls,sqlStr(i_UserId))
			table.insert(sqls," ; \n ")
		else
			table.insert(sqls," update user_activity set num=")
			table.insert(sqls,v.num)
			table.insert(sqls," ,lasttime="..g_Timer.SERVER_TIME)
			table.insert(sqls," where activityid=")
			table.insert(sqls,v.activityid)
			table.insert(sqls," and userid=")
			table.insert(sqls,sqlStr(i_UserId))
			table.insert(sqls," ; \n ")
		end
	end
	
	if #sqls>0 then
		dbmanager.conn:exec("begin transaction")
		dbmanager.conn:exec(table.concat(sqls))
		dbmanager.conn:exec("commit transaction")
	end
	sqls = nil
end

-- 根据模式类型 ID 返回对应的纪录
function dbmanager.getModeRecord(i_ModeType,i_ModeId,i_UserId)
	if not i_ModeType or i_ModeId == nil then
		printError("i_ModeType or i_ModeId is nil")
		return
	end

	local sql = {"select * from role_modeinfo where modetype="}
	table.insert(sql,i_ModeType)
	table.insert(sql," and modeid="..i_ModeId)
	table.insert(sql," and userid="..sqlStr(i_UserId))

	local result={}
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		result = {record=row.record,combo=row.combo,time=row.time}
	end
	sql = nil

	return result
end

-- 更新特殊模式关卡信息
function dbmanager.updateModeRecord(i_ModeType,i_ModeId,i_UserId,i_Params)
	if i_ModeType == nil or i_ModeId == nil or i_UserId == nil then
		printError("i_ModeType or i_ModeId or i_UserId is nil")
		return
	end

	local sql={}
	--更新信息
	table.insert(sql,"update role_modeinfo set lasttime=")
	table.insert(sql,g_Timer.SERVER_TIME)
	table.insert(sql," ,record=max(record," .. (i_Params.record or 0)..")")
	table.insert(sql," ,combo=max(combo," .. (i_Params.combo or 0)..")")
	table.insert(sql," ,time=min(time," .. (i_Params.time or 0)..")")
	table.insert(sql," where modetype=")
	table.insert(sql,i_ModeType)
	table.insert(sql," and modeid=")
	table.insert(sql,i_ModeId)
	table.insert(sql," and userid=")
	table.insert(sql,sqlStr(i_UserId))
	dbmanager.conn:exec(table.concat(sql))

	if dbmanager.conn:changes()==0 then
		sql={"insert into role_modeinfo (modetype,modeid,record,combo,time,lasttime,userid) values("}
		table.insert(sql,i_ModeType)
		table.insert(sql,"," .. i_ModeId)
		table.insert(sql,"," .. (i_Params.record or 0))
		table.insert(sql,"," .. (i_Params.combo or 0))
		table.insert(sql,"," .. (i_Params.time or 0))
		table.insert(sql,"," .. g_Timer.SERVER_TIME)
		table.insert(sql,"," .. sqlStr(i_UserId))
		table.insert(sql,")")
		dbmanager.conn:exec(table.concat(sql))
	end
	sql = nil
end

--插入新的邮件
function dbmanager.insertMails(i_Mails,i_UserId)
	if i_Mails == nil or i_UserId == nil then
		printError("i_Mails or i_UserId is nil")
		return false
	end

	local errornum_ = 0
	local sqls={}
	for i,mailinfo_ in ipairs(i_Mails) do
		table.insert(sqls," insert into user_mail(sync,mailid,mfrom,mto,content,mailtime,flag,lasttime,userid) values(0,")
		table.insert(sqls,sqlStr(mailinfo_.uid))
		table.insert(sqls," ,"..sqlStr(mailinfo_.from))
		table.insert(sqls," ,"..sqlStr(mailinfo_.to))
		table.insert(sqls," ,"..sqlStr(mailinfo_.content))
		table.insert(sqls," ,"..sqlStr(mailinfo_.time))
		table.insert(sqls," ,"..MAIL_STATUS.NEW)
		table.insert(sqls," ,"..g_Timer.SERVER_TIME)
		table.insert(sqls," ,"..sqlStr(i_UserId))
		table.insert(sqls,") ; \n ")
		if mailinfo_.atts then
			for x,v in ipairs(mailinfo_.atts) do
				table.insert(sqls," insert into user_mailatts(mailid,type,quality,value) values(")
				table.insert(sqls,sqlStr(mailinfo_.uid))
				table.insert(sqls," ,"..v.type)
				table.insert(sqls," ,"..v.quality)
				table.insert(sqls," ,"..v.value)
				table.insert(sqls,") ; \n ")
			end
		end
	end
	
	if #sqls>0 then
		dbmanager.conn:exec("begin transaction")
		errornum_ = dbmanager.conn:exec(table.concat(sqls))
		dbmanager.conn:exec("commit transaction")
	end
	sqls = nil
	return (errornum_ == 0)
end

--获取邮件
function dbmanager.getMails(i_UserId)
	if i_UserId == nil then
		printError("i_UserId is nil")
		return
	end

	local sql = {"select m.*,mt.attid,mt.type,mt.quality,mt.value from user_mail m left outer join user_mailatts mt on m.mailid=mt.mailid and m.userid="}
	table.insert(sql,sqlStr(i_UserId))
	table.insert(sql," and m.flag<>"..MAIL_STATUS.DELETED)
	table.insert(sql," order by m.flag asc, m.mailtime desc")

	local result={}
	local mailid_ = 0
	local tmpmail = {}
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		if mailid_ ~= row.mailid then
			mailid_ = row.mailid
			tmpmail = {
				mailid = mailid_,
				from = row.mfrom,
				to = row.mto,
				content = row.content,
				mailtime = os.date("%Y年%m月%d日",math.floor(row.mailtime or g_Timer.SERVER_TIME)),
				flag = row.flag,
				attlist = {}
			}
			table.insert(result,tmpmail)
		end
		if row.attid then
			table.insert(tmpmail.attlist,{attid=row.attid,type=row.type,quality=row.quality,value=row.value})
		end
	end
	sql = nil
	return result
end

--返回未读邮件数量
function dbmanager.getUnReadedMail(i_UserId)
	local result = 0
	if i_UserId == nil then
		printError("i_UserId is nil")
		return result
	end

	local sql = {"select count(mailid) num from user_mail where userid="}
	table.insert(sql,sqlStr(i_UserId))
	table.insert(sql," and flag="..MAIL_STATUS.NEW)
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		result = row.num
	end
	return result
end

--返回未同步到服务器状态的邮件ID
function dbmanager.getUnSyncMail(i_UserId)
	local result={}
	if i_UserId == nil then
		printError("i_UserId is nil")
		return result
	end

	local sql = {"select mailid from user_mail where userid="}
	table.insert(sql,sqlStr(i_UserId))
	table.insert(sql," and sync<>"..MAIL_STATUS.SYNC)
	
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		table.insert(result,{uid=row.mailid})
	end
	sql = nil
	return result
end

--更新邮件同步状态
function dbmanager.syncMails(i_Info)
	if i_Info == nil then
		printError("i_Info is nil")
		return
	end

	local mailid_ = {}
	for i,v in ipairs(i_Info) do
		table.insert(mailid_, sqlStr(v.id))
	end
	if g_CommonUtil.isEmpty(mailid_) then
		return
	else
		local sql={}
		table.insert(sql," update user_mail set sync=")
		table.insert(sql,MAIL_STATUS.SYNC)
		table.insert(sql," where mailid in (")
		table.insert(sql,table.concat(mailid_, ","))
		table.insert(sql,")")
		dbmanager.conn:exec(table.concat(sql))
		sql = nil
	end
end

--更新邮件信息
-- @i_Info中需要有{mailid=XXX,flag=XXX}
function dbmanager.updateMail(i_Info,i_UserId)
	local errornum_ = 0
	local sqls={}
	--更新信息
	if not g_CommonUtil.isEmpty(i_Info) and not g_CommonUtil.isEmpty(i_UserId) then
		table.insert(sqls," update user_mail set flag=")
		table.insert(sqls,i_Info.flag)
		table.insert(sqls," where mailid=")
		table.insert(sqls,sqlStr(i_Info.mailid))
		table.insert(sqls," and userid=")
		table.insert(sqls,sqlStr(i_UserId))
		table.insert(sqls," ; \n ")
	end
	table.insert(sqls," delete from user_mail where sync="..MAIL_STATUS.SYNC)
	table.insert(sqls,string.format(" and (%d-mailtime)>=604800 ",math.floor(g_Timer.SERVER_TIME)))
	table.insert(sqls," and (")
	table.insert(sqls,string.format("(flag=%d and mailid not in (select distinct mailid from user_mailatts))",MAIL_STATUS.READED))
	table.insert(sqls," or ")
	table.insert(sqls,string.format("flag=%d",MAIL_STATUS.GET))
	table.insert(sqls," )")
	table.insert(sqls," ; \n ")
	table.insert(sqls," delete from user_mailatts where mailid not in (select mailid from user_mail)")
	table.insert(sqls," ; \n ")
	errornum_ = dbmanager.conn:exec(table.concat(sqls))
	sqls = nil
	return (errornum_==0)
end

---------------------------------票据信息-------开始----------------------------------------

-- 添加新的票据
function dbmanager.addIosReceipt(i_Receipt,i_Price,i_UserId)
	local serial = math.floor(g_Timer.SERVER_TIME)
	local vm=dbmanager.conn:prepare('insert into iosreceipt(tid,receipt,status,price,userid) values(?,?, ? ,? ,?)')
	vm:bind_values(serial,i_Receipt,"none",i_Price,i_UserId)
	vm:step()
	vm:finalize()
	-- for row in dbmanager.conn:nrows("select last_insert_rowid() as id from iosreceipt") do
	-- 	serial=row.id
	-- end
	return serial
end

-- 服务器验证后更新票据状态
-- @i_Transactionid 票据id
function dbmanager.updateIosReceipt(i_Transactionid,i_Success,i_UserId)
	local sqls={}
	if checkbool(i_Success) then
		local transinfo = dbmanager.getUnCheckedIOSReceipt(i_UserId,i_Transactionid)
		if #transinfo>0 then
			table.insert(sqls," update iosreceipt set status='success' where tid=")
		else
			return false
		end
	else
		table.insert(sqls," update iosreceipt set status='failed' where tid=")
	end
	table.insert(sqls,i_Transactionid)
	dbmanager.conn:exec("begin transaction")
	dbmanager.conn:exec(table.concat(sqls))
	dbmanager.conn:exec("commit transaction")
	return true
end

-- 获取没有验证状态的票据
function dbmanager.getUnCheckedIOSReceipt(i_UserId,i_Transactionid)
	local result={}
	local sql = {}
	table.insert(sql,"SELECT * FROM iosreceipt where status='none' and userid=")
	table.insert(sql,sqlStr(i_UserId))
	if i_Transactionid then
		table.insert(sql," and tid="..i_Transactionid)
	end
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		table.insert(result,{tid=row.tid,receipt=row.receipt,status=row.status})
	end
	return result
end

-- 添加Android的票据
function dbmanager.addAndroidReceipt(i_Tradeno,i_Identifier,i_Price,i_UserId)
	local vm=dbmanager.conn:prepare('insert into androidreceipt(tradeno,identifier,status,price,userid) values(?, ?, ? ,? ,?)')
	vm:bind_values(i_Tradeno,i_Identifier,"none",i_Price,i_UserId)
	vm:step()
	vm:finalize()
	return i_Tradeno
end

-- 服务器验证后更新Android的票据状态
-- @i_Tradeno 票据id
function dbmanager.updateAndroidReceipt(i_Tradeno,i_Success,i_UserId)
	local sqls={}
	if checkbool(i_Success) then
		local transinfo = dbmanager.getUnCheckedAndroidReceipt(i_UserId,i_Tradeno)
		if #transinfo>0 then
			table.insert(sqls," update androidreceipt set status='success' where tradeno=")
		else
			return false
		end
	else
		table.insert(sqls," update androidreceipt set status='failed' where tradeno=")
	end
	table.insert(sqls,sqlStr(i_Tradeno))
	dbmanager.conn:exec("begin transaction")
	dbmanager.conn:exec(table.concat(sqls))
	dbmanager.conn:exec("commit transaction")
	return true
end

-- 获取没有验证状态的Android的票据
function dbmanager.getUnCheckedAndroidReceipt(i_UserId,i_Tradeno)
	local result={}
	local sql = {}
	table.insert(sql,"SELECT * FROM androidreceipt where status='none' and userid=")
	table.insert(sql,sqlStr(i_UserId))
	if i_Tradeno then
		table.insert(sql," and tradeno="..sqlStr(i_Tradeno))
	end
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		table.insert(result,{tradeno=row.tradeno,identifier=row.identifier,status=row.status})
	end
	return result
end

-- 返回充值总额
function dbmanager.getTotalCharge(i_UserId)
	if i_UserId == nil then
		printError("i_UserId is nil")
		return
	end
	local result = 0
	local sql={"select sum(price) pricetotal from "}
	if device.platform == "ios" then
		table.insert(sql," iosreceipt ")
	else
		table.insert(sql," androidreceipt ")
	end
	table.insert(sql," where status='success' and userid=")
	table.insert(sql,sqlStr(i_UserId))
	for row in dbmanager.conn:nrows(table.concat(sql)) do
		result = row.pricetotal or result
	end
	return result
end

---------------------------------票据信息-------结束----------------------------------------

init()

return dbmanager