--
-- Author: rsma
-- Date: 2015-08-31 13:54:04
--
local ai={}
ai.debugFlag=false
ai.msg={}
function ai.debug(i_role,...)
    if ai.debugFlag then
        local buf = {...}
        for i=1, select("#", ...) do
            buf[i] = tostring(buf[i])
        end
        local i_msg = table.concat(buf, "\t")
        if ai.msg[i_role.RID] == nil then
            ai.msg[i_role.RID]={}
        end
        table.insert(ai.msg[i_role.RID], i_msg)
        if #ai.msg[i_role.RID]>20 then
            while #ai.msg[i_role.RID]>20 do
                table.removebyvalue(ai.msg[i_role.RID], ai.msg[i_role.RID][1])
            end
        end
        local CID=g_Timer.callAfter(function(i_role)
                g_Timer.delTimer(CID)
                if not i_role.RID or g_fight.gameOver==true then
                    return
                end
                if i_role.actionName == ROLE_ACTION.stand and i_role.fight.recoverTID == -1 and i_role.fight.awaitTID == -1 then
                    print("RID=",i_role.RID)
                    dump(ai.msg[i_role.RID])
                end
            end,60,i_role)
    end
end
--计算追击位置
function ai.calcHuntPos(i_my)
    if not i_my.action.huntObj then
        print("logic error!! calcHuntPos")
        return -1,-1
    end
	local tPosX,tPosY = i_my.action.huntObj:getPos()
    tPosX = tPosX+(i_my.size.hw*0.5+i_my.action.huntObj.size.hw*0.5-15+i_my.action.attackSite.offX)*i_my.action.attackSite.dirc
    tPosY = tPosY+i_my.action.attackSite.offY
    -- print(i_my.action.huntObj.pos.x,i_my.action.huntObj.pos.y,"calcHuntPos---",tPosX,tPosY)
    return tPosX,tPosY
end
--计算逃离位置
function ai.calcEvadePos(i_my)
    local offX=0
    local diss = i_my.fleeOffset
    local pPos = g_RoleManager.player.pos
    local wpPos = g_Map.getScreenPos(pPos.x,pPos.y)
    local tPos = i_my.pos
    local wtPos = g_Map.getScreenPos(tPos.x,tPos.y)
    -- print(">>>ai.calcEvadePos",diss,wpPos.x,wtPos.x)
    --左边
    if wpPos.x>wtPos.x then
        if wpPos.x-diss >=0 then
            offX=-(diss-(wpPos.x-wtPos.x))
        else
            offX=diss*1.5
        end
    else --右边
        if wpPos.x+diss <= display.width then
            offX=wpPos.x+diss-wtPos.x
        else
            offX=-diss*1.5
        end
    end
    g_fight.AI.debug(i_my,"ai.calcEvadePos-return->",tPos.x+offX,pPos.y)
    return tPos.x+offX,pPos.y
end
--计算逃离位置
function ai.calcFleePos(i_my)
    local offX=0
    local diss = i_my.fleeOffset+math.random(100,200)
    local pPos = g_RoleManager.player.pos
    local wpPos = g_Map.getScreenPos(pPos.x,pPos.y)
    local tPos = i_my.pos
    local wtPos = g_Map.getScreenPos(tPos.x,tPos.y)
    -- print(">>>ai.calcFleePos",diss,wpPos.x,wtPos.x)
    --左边
    if wpPos.x>wtPos.x then
        if wpPos.x-diss >=0 then
            offX=-(diss-(wpPos.x-wtPos.x))
        else
            offX=diss*1.5
        end
    else --右边
        if wpPos.x+diss <= display.width then
            offX=wpPos.x+diss-wtPos.x
        else
            offX=-diss*1.5
        end
    end
    g_fight.AI.debug(i_my,"ai.calcFleePos-return->",tPos.x+offX,pPos.y)
    local offY=tPos.y+math.random(50,100)*math.random(-1,1)
    if offY>g_Map.getMapTop() then
        offY = g_Map.getMapTop()-5
    elseif offY<=0 then
        offY=5
    end
    return tPos.x+offX,offY
end
--计算出巡逻的位置
function ai.calcPatrolPos(i_my)
	local tPosX,tPosY = i_my:getPos()
	local hPosX,hPosY = i_my.action.huntObj:getPos()
	tPosX = tPosX+150*i_my.dirc
	if tPosX < g_LayerManager.mapinfo.roleleft then
            tPosX=g_LayerManager.mapinfo.roleleft
    end
    if tPosX > g_LayerManager.mapinfo.roleright then
        tPosX=g_LayerManager.mapinfo.roleright
    end
	if hPosY>tPosY then
		tPosY=tPosY+50
	else
		tPosY=tPosY-50
	end
	if tPosY < g_LayerManager.mapinfo.rolebottom  then
        tPosY = g_LayerManager.mapinfo.rolebottom
    end
    if tPosY > g_LayerManager.mapinfo.roletop then
    	tPosY = g_LayerManager.mapinfo.roletop
    end
    return tPosX,tPosY
end
--水平距离
function ai.hdist(i_me,i_target)
    if tolua.isnull(i_target) then
        return false
    end
    if math.abs(i_me.pos.x-i_target.pos.x)>=i_me.size.RW*0.8 and i_me.fight.remoteAttack then
        return true
    end
    return false
end
--水平&垂值距离
function ai.hvdist(i_me,i_target)
    if tolua.isnull(i_target) then
        return false
    end
    if math.abs(i_me.pos.x-i_target.pos.x)>=i_me.size.RW*0.8 and i_me.fight.remoteAttack and math.abs(i_me.standLine - i_target.standLine) <= MAX_VALID_ATTACK_DIST then
        return true
    end
    return false
end
--跳起攻击
function ai.jump(i_me,i_target)
    if tolua.isnull(i_target) then
        return false
    end
    if i_me.pos:getDistance(i_target.pos)>=i_me.size.S*0.8 and i_me.fight.remoteAttack then
        return true
    end
    return false
end
--猛冲袭击
function ai.onrush(i_me,i_target)
    if tolua.isnull(i_target) then
        return false
    end
    if i_me.pos:getDistance(i_target.pos)>=i_me.size.S*0.8 and i_me.fight.remoteAttack then
        return true
    end
    return false
end
--近身距离-
function ai.closeDist(i_me,i_target)
    if i_me.remoteFlag and not tolua.isnull(i_target) then
        local dissOffset = i_me.size.S>0 and i_me.size.S or 0
        dissOffset = i_me.size.R>0 and i_me.size.R or dissOffset
        if dissOffset>0 then
            print("多角度攻击范围内=dissOffset",dissOffset,i_me.pos:getDistance(i_target.pos),dissOffset*0.5)
            if i_me.pos:getDistance(i_target.pos)<=dissOffset*0.5 then
                return true
            end
        else
            dissOffset = i_me.size.RW>0 and i_me.size.RW or 0
            if dissOffset>0 then
                -- print("直线攻击范围内=dissOffset",dissOffset)
                if math.abs(i_me.pos.x-i_target.pos.x)<=dissOffset*0.5 and math.abs(i_me.standLine - i_target.standLine) <= MAX_VALID_ATTACK_DIST then
                    return true
                end
            end
        end
    end
    return false
end
--近身攻击
function ai.closeAttack(i_me,i_target)
    if i_me.fight.canAttack then
        return true
    end
    return false
end
return ai