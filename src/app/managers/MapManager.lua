-- 地图管理
local map = {}

function map.setCurrMap(i_GmaeMode,i_Index,i_SubIndex)
	if map.currMap then 
		-- 暂时保存原地图
		map.tempMap = map.currMap
	end
	-- 当前地图阶段
	map.index = i_Index or 1
	map.subIndex = i_SubIndex or 1

	if not i_GmaeMode or i_GmaeMode == GAME_MODE.EASY then
		map.mapInfo = g_GameLvl.subglvl[g_User.glinfo.glvlid][((g_User.glinfo.subglvlid-1)%5)+1].mapinfo
		map.currMap = g_LayerManager:setMapLevel(g_User.glinfo.glvlid,map.mapInfo[map.index].mapid,map.mapInfo[map.index].gap)
	elseif i_GmaeMode == GAME_MODE.NORMAL then
		map.mapInfo = g_GameLvl.normal[CURR_NORMAL_INDEX]
		map.currMap = g_LayerManager:setMapLevel(map.mapInfo.id,math.random(1,5),1)
	elseif i_GmaeMode == GAME_MODE.HAED then

	elseif i_GmaeMode == GAME_MODE.PVP then
	
	end

	map.tip = false
	map.focusObj = {pos={x=display.cx,y=display.cy}}
	map.lastx = 0
	map.lasty = 0
end

function map.addObjs(i_Obj)
	map.currMap:addObj(i_Obj)
	if i_Obj == g_RoleManager.player then
        map.setFocusObj(i_Obj)
    end
end

function map.offsetMap(i_X,i_Y)
	map.currMap:offset(i_X)
end

function map.getMapOffset()
	local result = {x=map.currMap.offsetX,y=map.currMap.offsetY}
	return result
end

function map.getScreenPos(i_X,i_Y)
	return {x=i_X+map.currMap.offsetX,y=i_Y+map.currMap.offsetY}
end

-- 获得当前地图右边界
function map.getMapRight()
	return map.currMap.roleright
end

function map.getMapLeft()
	return map.currMap.roleleft
end

function map.getMapTop()
	return map.currMap.roletop
end

function map.getMapBottom()
	return map.currMap.rolebottom
end

function map.getMapZorderY()
	return 2000
end

function map.getMapPhase()
	return map.index
end

function map.setFocusObj(i_Obj)
    --地图聚焦人物
    map.focusObj = i_Obj
end

-- 地图自动追踪
function map.scrollMap()
	if not g_RoleManager.player then return end
	local x = map.focusObj.pos.x
	local y = map.focusObj.pos.y
	local offsetR_X = 0
	local offsetR_Y = 0
	local offsetL_X = 0
	local offsetL_Y = 0
	-- 切换地图阶段
    if map.tip and x + g_Map.getMapOffset().x >= display.width/6*5 and map.focusObj.dirc == DIRC.RIGHT and map.focusObj.action.speedX ~= 0 then
    	map.nextPhase()
    end

    if map.focusObj.dirc == DIRC.RIGHT then
    	offsetR_X = display.width - g_Map.getMapOffset().x - g_Map.getMapRight() - BODY_SIZE.WIDTH
		if offsetR_X >= 0 or x + g_Map.getMapOffset().x <= display.cx then
			return
		end 
	end

	if map.focusObj.dirc == DIRC.LEFT then
		offsetL_X = g_Map.getMapLeft() - math.abs(g_Map.getMapOffset().x) - BODY_SIZE.WIDTH
		if offsetL_X >= 0 or x + g_Map.getMapOffset().x >= display.cx then
			return
		end
	end

	-- 偏移量 距地图边界 最小值
	local gap = math.min(math.abs(display.cx-(x+g_Map.getMapOffset().x)),10)

	if map.focusObj.dirc == DIRC.RIGHT then
		g_Map.offsetMap(-(math.min(gap,math.abs(offsetR_X))))
	elseif map.focusObj.dirc == DIRC.LEFT then
		g_Map.offsetMap((math.min(gap,math.abs(offsetL_X))))
	end

end

function map.nextPhase()
	map.tip = false
	map.subIndex = map.subIndex + 1
	if map.subIndex <= map.mapInfo[map.index].gap then
		map.currMap:nextPhase()
	else 
		map.changeMap()
	end
end

-- 切换地图
function map.changeMap()
	if map.index >= #map.mapInfo then return end
	map.changemapflag = true
	--  屏幕特效 黑屏
	g_Effect.blink("BLACK",1,2)
	--  移除旧地图 添加新地图 初始坐标 产生敌人
	map.setCurrMap(CURR_GAME_MODE,map.index+1,1)
	g_RoleManager.reAddPlayer(180,100)
	g_LogicUtil.getCurrScene():changeMap()
	map.tempMap:removeSelf()
end

function map.removeTipGo()
	if not map.tipGo then return end
	local function remove()
		map.tipGo:removeSelf()
		map.tipGo=nil
		--如果为同关卡切换地图，怪延迟产生
		if map.changemapflag then
			map.changemapflag = false
			g_Timer.callAfter(g_LogicUtil.getCurrScene().genGameEnemy,2.5,g_LogicUtil.getCurrScene())
		else
			g_LogicUtil.getCurrScene():genGameEnemy()
		end
	end
	g_Timer.callAfter(remove,0.5)
end

function map.showGoUI()
	map.tip = true
	map.tipGo = require("app.ui.tip.TipGoUI").new()
	g_LayerManager:addPopUI(map.tipGo)
end

-- 当每个小关卡结束时 检查地图阶段
function map.checkMapIndex()
	-- 小阶段未结束
	if map.subIndex < map.mapInfo[map.index].gap then
		g_Map.showGoUI()
	else  
		if map.index < #map.mapInfo then
			g_Map.showGoUI()
		else 
			g_LogicUtil.getCurrScene():setStatus(FIGHT_STATUS.VICTORY)
		end
	end
end

function map.getBg()
	return map.currMap:getBg()
end

function map.isEnd()
	if CURR_GAME_MODE == GAME_MODE.EASY then
		if map.index >= #map.mapInfo and map.subIndex >= map.mapInfo[map.index].gap then
			return true
		else 
			return false
		end
	end
	return false
end

return map