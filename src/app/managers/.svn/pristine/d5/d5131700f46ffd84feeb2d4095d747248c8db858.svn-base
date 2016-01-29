--
-- Author: rsma
-- Date: 2015-05-15 16:44:46
--
require("app.objects.RoleObject")
require("app.objects.NPCObject")
require("app.objects.BlockObject")
require("app.objects.GoodsObject")
require("app.objects.LPoint")
require("app.objects.LRect")
local rolemanager = {}
rolemanager.player=nil ---玩家
rolemanager.allRole={}

--构建在地图可控制角色
function rolemanager.addPlayer(i_X,i_Y)
	if rolemanager.player then
		return
	end
	i_X = i_X or display.cx
	i_Y = i_Y or 100
	rolemanager.player = RoleObject.new()
	rolemanager.player:buildAnimal(g_User.getCurrRole())--g_User.getCurrRole()
	rolemanager.player:setSkillInfo(g_User.getSkillInfo())--g_User.getSkillInfo()
    rolemanager.player:init()
	rolemanager.player:setPos(i_X,i_Y)
	g_Map.addObjs(rolemanager.player)
	rolemanager.player.collider:enable()
	table.insert(rolemanager.allRole, rolemanager.player)
	return rolemanager.player
end

--重新构建在地图可控制角色
function rolemanager.reAddPlayer(i_X,i_Y)
	local roleinfo = clone(g_User.getCurrRole())
	if rolemanager.player then
		roleinfo.hp = rolemanager.player.HP
	    roleinfo.MaxHP=rolemanager.player.MaxHP
	    roleinfo.mp=rolemanager.player.mp
	    roleinfo.def=rolemanager.player.def
	    roleinfo.avoidinjury=rolemanager.player.avoidinjury
	    roleinfo.atk=rolemanager.player.atk
	    -- 移除原来的对象
	    rolemanager.player:deleteSelf()
	end
	i_X = i_X or BODY_SIZE.WIDTH
	i_Y = i_Y or 100
	rolemanager.player = RoleObject.new()
	rolemanager.player:buildAnimal(roleinfo)
	rolemanager.player.MaxHP = roleinfo.MaxHP
	rolemanager.player:setSkillInfo(g_User.getSkillInfo())
    rolemanager.player:init()
	rolemanager.player:setPos(i_X,i_Y)
	g_Map.addObjs(rolemanager.player)
	rolemanager.player.collider:enable()
	table.insert(rolemanager.allRole, rolemanager.player)
	return rolemanager.player
end

--创建供UI使用的人物动画
function rolemanager.buildRole(i_RoleId)
	if not g_RoleConfig[i_RoleId] then
		print("RoleId:",i_RoleId,"(no configuration)")
		return
	end
	local role = RoleObject.new()
	role:buildAnimal(g_RoleConfig[i_RoleId])
	return role
end

--增加角色的生命、精神
function rolemanager.addHealth(i_HP,i_MP)
	if rolemanager.player then
		rolemanager.player:addHealth(i_HP,i_MP)
	end
	local factory = db.DBCCFactory:getInstance()
    factory:loadDragonBonesData("effects/600213_s.xml", "600213");
    factory:loadTextureAtlas("effects/600213_t.xml", "600213");
    local animalObj = factory:buildArmatureNode("600213")
    rolemanager.player:addChild(animalObj)
    if i_HP>0 and i_MP>0 then
    	animalObj:getAnimation():gotoAndPlay("600215")
    elseif i_HP>0 then
    	animalObj:getAnimation():gotoAndPlay("600213")
    else
    	animalObj:getAnimation():gotoAndPlay("600214")
    end

	-- 派发生命、精神变化
	g_EventManager.dispatch(MESSAGE_EVENT.ROLE_BAR_CHANGE,{hp=checknumber(i_HP),mp=checknumber(i_MP)})
end

--构建在地图可控制NPC对象
function rolemanager.addNPC(i_Data)
	if iskindof(g_LogicUtil.getCurrScene(),"GameScene") and g_LogicUtil.getCurrScene():isVictory() then
		return 
	end

	if isset(i_Data,"npcid") == false then
		return
	end

	local npcinfo = g_LogicUtil.initNPCByLvl(i_Data)
	if not npcinfo then
		return
	end
	local npc = nil
	if npcinfo.animalData then
		npc = NPCObject.new()
	elseif npcinfo.img then
		npc = BlockObject.new()
	end
	npc:buildAnimal(npcinfo)
    npc:init()

    --如果是道具，不修改坐标，使用其原始坐标
    if (npcinfo.type==OBJ_TYPE.ITEM) then
    	g_EventManager.dispatch(MESSAGE_EVENT.OBJECT_DEAD,{isRole=false,type=npcinfo.type})
    else
	    if i_Data.x < 0 then
	    	i_Data.x = math.abs(g_Map.getMapOffset().x) + i_Data.x
		else
			i_Data.x = math.abs(g_Map.getMapOffset().x) + i_Data.x + display.width
		end
	end
	npc:setPos(i_Data.x,i_Data.y)
	npc:setPosition(i_Data.x,i_Data.y)
	npc.auto = true
	g_Map.addObjs(npc)
	npc.collider:enable()
	npc.action:huntTarget(g_RoleManager.player)
	table.insert(rolemanager.allRole, npc)
	if npcinfo.type==OBJ_TYPE.BOSS then
		g_EventManager.dispatch(MESSAGE_EVENT.GAME_PERCENT)
	else 
		g_EventManager.dispatch(MESSAGE_EVENT.GAME_PERCENT,1)
	end
	return npc
end

function rolemanager.buildGoods(i_GoodsInfo)
	local item=GoodsObject.new(i_GoodsInfo.equipid)
	item:buildAnimal(i_GoodsInfo)
    item:init()
    g_Map.addObjs(item)
    table.insert(rolemanager.allRole, item)
    return item
end


function rolemanager.getRoleByRID(i_RID)
	for _,obj in pairs(rolemanager.allRole) do
		if obj and obj.RID == i_RID then
			return obj
		end
	end
	return nil
end

function rolemanager.pause()
	for _,robj in pairs(rolemanager.allRole) do
		if not tolua.isnull(robj) then
			robj.fight:pause()
		end
	end
end
function rolemanager.cleanGoods()
	local temp={}
	for _,robj in pairs(rolemanager.allRole) do
		if not tolua.isnull(robj) and (robj.name == "Goods" or robj.name == "Block" ) then
			table.insert(temp, robj)
		end
	end
	for _,robj in pairs(temp) do
		robj:cleanSelf()
	end
	temp=nil
end
function rolemanager.cleanALLNPC()
	local temp={}
	for _,robj in pairs(rolemanager.allRole) do
		if not tolua.isnull(robj) and (robj.name == "NPC" and robj.isBoss==false) then
			table.insert(temp, robj)
		end
	end
	for _,robj in pairs(temp) do
		robj:getKilled()
	end
	temp=nil
end
function rolemanager.destroy()
	for _,robj in pairs(rolemanager.allRole) do
		if not tolua.isnull(robj) then
			robj:cleanSelf()
		end
	end
	rolemanager.allRole={}
	rolemanager.player=nil
	g_fight.battleState=-1
end

-- 绘制人物对象
function rolemanager.render(dt)
	for i,v in ipairs(rolemanager.allRole) do
		v:setLocalZOrder(g_Map.getMapZorderY()-v.pos.y)
		v:render(dt)
	end
end

return rolemanager