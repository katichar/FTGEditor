--
-- Author: rsma
-- Date: 2015-06-09 10:37:07
--
require("app.fight.ForceObject")
require("app.fight.FightAttribute")

local engine = {}
engine.effect=require("app.fight.FightEffect")
engine.actions=require("app.fight.FightActions")
engine.bd=require("app.fight.BoundData")
engine.AI=require("app.fight.FightAI")
engine.battleState=-1
engine.maxCombo=0
engine.comboScore=0
engine.startTime=0
engine.istory=false--剧情中
engine.gameOver=false
engine.isplayslow=false--慢放
engine.FPS=GAME_FPS
engine.aliveman=0
engine.onAttackFunc=nil --普通攻击延迟调用方法
engine.tweenFPS=1/24
engine.tweenSlow=1
engine.currAILvl=1
engine.currAIconfig=nil
engine.showRocker=EFFECT_ROCKER
function engine.setCurrAILevel(i_lvl)
	-- print(">>>setCurrAILevel",i_lvl)
	engine.currAIconfig=AILV[i_lvl]
	-- dump(engine.currAIconfig)
end
function engine.getAIProp(i_Prop)
	if engine.currAIconfig then
		return engine.currAIconfig[i_Prop]
	end
	print("can not find ai config!!!!")
	return AILV[1][i_Prop]
end
--多个effect之间相互关系
engine.excludeEffect={
	["hurtBack"]=(COMBO_ENABLE==false and {"hurtBack","moveToPlayer"} or {"hurtBack","moveToPlayer","hurtBounceOff","hurtBounceUp"}),
	["hurtHitWal"]={"hurtBack","moveToPlayer"},
	["hurtFallDown"]={"hurtFallDown","hurtBounceOff","hurtBounceUp","hartDown","moveToPlayer"},
	["hurtBounceUp"]={"hurtBounceOff","hurtBounceUp","hurtFallDown","hartDown","moveToPlayer"},
	["hurtBounceOff"]={"hurtBounceOff","hurtFallDown","hurtBack","hartDown","hurtBounceUp","moveToPlayer"},
	["hartDown"]={"hartDown","moveToPlayer"},
	["hurtBackBounce"]={"hurtBackBounce","moveToPlayer"},
	["hurtBackFailDown"]={"hurtBackBounce","moveToPlayer"},
}

engine.actionManager = cc.Director:getInstance():getActionManager()
-----被打击效果处理函数
function engine.buildEffectHandler(i_FightAttr)
	if not i_FightAttr then
		return nil
	end
	if i_FightAttr.effect and #i_FightAttr.effect>0 then
		local funcname = "return g_fight.actions.".. i_FightAttr.effect
		local func = loadstring(funcname)()
		local function effHandler(i_Role,i_CallBack)
			g_fight.checkLastEffects(i_FightAttr.effect,i_Role)
			local force = ForceObject.new(i_Role,i_FightAttr)
			force:setFinishedHandler(i_CallBack)
			local tweens = func(force)
			if i_FightAttr.target then
				local sequence = transition.sequence(tweens)
				i_FightAttr.target:runAction(sequence)
				return
			end
			local finishedActInt  = TweenObject.CallFunc(function()
	    		table.removebyvalue(i_Role.effects, force.effectObj)
	    		-- print("action ",i_FightAttr.effect," finished and removed!")
	        end)
	        table.insert(tweens, #tweens+1, finishedActInt)
			force.actioins = tweens
			force.effectObj = i_Role:pushEffect(i_FightAttr.effect,force,tweens)
			i_Role.action:runTweens(tweens)
		end
		return effHandler
	end
	return nil
end
--检查相互冲突的tween特效
function engine.checkLastEffects(i_CurrEFName,i_Role)
	for _,obj in pairs(i_Role.effects) do
		if g_fight.checkCanRemoveAction(obj.name,i_CurrEFName) and obj.tweens and obj.forceObj.valid==true then
			obj.forceObj.valid=false
			table.removebyvalue(i_Role.effects, obj)
			table.removebyvalue(i_Role.action.tweens,obj.tweens)
			-- print(obj.name," break-off and removed !")
		end
	end
end
--清除所有Tween特效
function engine.cleanTargetAllEffects(i_Role)
	for _,obj in pairs(i_Role.effects) do
		if obj.tweens then
			obj.forceObj.valid=false
			table.removebyvalue(i_Role.effects, obj)
			table.removebyvalue(i_Role.action.tweens,obj.tweens)
		end
	end
	i_Role.action.tweens={}
	if i_Role.inApplyForce==true then
        i_Role.inApplyForce = false
    end
    i_Role.tweenState=0
end
function engine.checkCanRemoveAction(i_last,i_curr)
	local exclude = g_fight.excludeEffect[i_curr]
	if exclude then
		for _,name in pairs(exclude) do
			if name == i_last then
				return true
			end
		end
	end
	return false
end
--绑定战斗属性
function engine.bindFightAttribute(i_Role,i_Data)
	i_Role:setFightAttribute(nil)
	i_Role:setAttackAttribute(nil)
	if not i_Data then
		return
	end
	if i_Data.hurtProp then
		local attribute = FightAttribute.new(i_Data.hurtProp)
		i_Role:setFightAttribute(attribute)
	end
	if i_Data.attackProp then
		local attrack = FightAttribute.new(i_Data.attackProp)
		i_Role:setAttackAttribute(attrack)
	end
end
function engine.buildAttackEFHandler(i_Role,i_Data)
	if i_Data then
		local attack = FightAttribute.new(i_Data)
		return engine.buildEffectHandler(attack)
	end
	return nil
end
--取消战斗属性
function engine.undoFightAttribute(i_Role)
	i_Role:setFightAttribute(nil)
end
--设置战斗结果
function engine.setFightResult(i_Result,i_IsShow)
	engine.battleState=i_Result
	math.newrandomseed()
	if g_fight.battleState == FIGHT_STATUS.VICTORY then

		g_EventManager.dispatch(MESSAGE_EVENT.FIGHT_SCORE,GAME_SCORE.COMBO*g_fight.comboScore)
		g_EventManager.dispatch(MESSAGE_EVENT.FIGHT_SCORE,GAME_SCORE.TIME*(engine.startTime))
		
		local score,quality = g_Condition.getFightScore()
		local reward = g_LogicUtil.getGameLvlReward(g_User.glinfo.lvl,g_User.glinfo.isfinish)
		local params = {
	        result = true,
	        time = engine.startTime,
	        combo = g_fight.maxCombo,
	        score = score,
	        gold = reward.gold or 0,
	        star = g_Condition.getFightStar(),
	        diamond = reward.diamond or 0,
	        exp = reward.exp or 0,
	        quality = quality,
	    }
	    g_LayerManager:addPopUI(require("app.ui.battleresult.BattleResultUI").new(params))
	elseif g_fight.battleState == FIGHT_STATUS.FAILURE then
		local params = {
			result = false,
	        time = engine.startTime,
	        combo = g_fight.maxCombo,
	        gold =  0,
	        diamond = 0,
	        exp =  0,
	        count = g_Condition.getFightPhase(),
	    }
		g_LayerManager:addPopUI(require("app.ui.battleresult.BattleResultUI").new(params,i_IsShow))
		for _,robj in pairs(g_RoleManager.allRole) do
			if not tolua.isnull(robj) and iskindof(robj, "NPCObject") then
				robj.fight:pauseBattle()
				robj.action:pauseAction()
			end
		end
	end
end
--进入战斗前初始化战斗信息
function engine.init()
	g_fight.comboScore=0
	g_fight.aliveman=0
	g_fight.gameOver=false
	engine.FPS=GAME_FPS
	g_fight.tweenFPS=1/24
	g_fight.tweenSlow=1
	engine.effect=require("app.fight.FightEffect")
	engine.effect.init()
	engine.actions=require("app.fight.FightActions")
	engine.bd=require("app.fight.BoundData")
	engine.battleState=-1
	engine.startTime=0--os.time()
	engine.tid = g_Timer.addTimer(function() 
			if g_LogicUtil.pauseflag == false then
				engine.startTime=engine.startTime+1
			end
		end,0,1)
end
function engine.destroy()
	g_Timer.delTimer(engine.tid)
	engine.FPS=GAME_FPS
	engine.effect.destroy()
	engine.effect=nil
	engine.actions=nil
	engine.bd=nil
	engine.battleState=-1
end
--活家复活
function engine.playerRelive()
	g_fight.gameOver=false
	engine.FPS=GAME_FPS
	for _,robj in pairs(g_RoleManager.allRole) do
		if not tolua.isnull(robj) then
			robj:playslow(false)
		end
	end
	engine.battleState=-1
	-- engine.startTime=os.time()
	g_RoleManager.player:relive()
	for _,robj in pairs(g_RoleManager.allRole) do
		if not tolua.isnull(robj) and iskindof(robj, "NPCObject") then
			robj.fight.canAttack=false
			robj.fight:readyBattle(math.random(0,5))
		end
	end
end
--检查战斗是否结束
function engine.checkGameOver(i_Role)
	if g_fight.aliveman<=0 and g_Map.isEnd() and not engine.istory then
	-- if i_Role.roleType == OBJ_TYPE.BOSS or iskindof(i_Role, "RoleObject") then
		return true
	end

	if not engine.istory and g_Map.isEnd() and i_Role.isBoss==true and g_Condition.getConditionType()==GAME_CONDITION.BOSS then
		-- print(i_Role.RID,"checkGameOver","BossFlag=",i_Role.isBoss,"getConditionType=",g_Condition.getConditionType(),GAME_CONDITION.BOSS)
		g_RoleManager.cleanALLNPC()
		return true
	end
	return false
end
--进入慢放
function engine.doPlaySlow()
	g_fight.tweenFPS=1/24*5
	g_fight.tweenSlow=5
	engine.isplayslow=true
	for _,robj in pairs(g_RoleManager.allRole) do
		if not tolua.isnull(robj) then
			robj:playslow(true)
		end
	end
	g_Effect.blink(nil,0,3)
end
--结束慢放
function engine.undoPlaySlow()
	for _,robj in pairs(g_RoleManager.allRole) do
		if not tolua.isnull(robj) then
			robj:playslow(false)
		end
	end
	g_fight.tweenFPS=1/24
	g_fight.tweenSlow=1
	engine.FPS=GAME_FPS
	engine.isplayslow=false
end
function engine.beginFight(i_me,i_Target)
	--先随机出攻击动作
	local nextState=nil
	local actName=nil
	local actType=-1
	if i_me.remote then
		local radom = math.random(1,100)
		for rname,robj in pairs(i_me.remote) do
			if radom>=robj[1] and radom <= robj[2] then
				actName=rname
				actType=robj[3]
				break
			end
		end
		-- print("random result actName:",actName,"actType=",actType,"actHandler=",i_me.attackHandler[actName])
		g_fight.AI.debug(i_me,"random result actName:",actName,"actType=",actType,"actHandler=",i_me.attackHandler[actName])
	end
	--近身
	if actType==0 then
		if g_fight.AI.closeAttack(i_me,i_Target) and engine.checkActionByHadnler(actName,i_me,i_Target) then
			nextState = actName
		else
			if i_me.remoteFlag==false then
				i_me.action:huntTarget(g_RoleManager.player,true)
				return
			elseif i_me.remoteFlag then
				actName = i_me:getAttackName(1)
				g_fight.AI.debug(i_me,"get remo anem=",actName,engine.checkActionByHadnler(actName,i_me,i_Target))
				if engine.checkActionByHadnler(actName,i_me,i_Target) then
					nextState = actName
				end
			end
		end
	elseif actType==1 then--远程
		if engine.checkActionByHadnler(actName,i_me,i_Target) then
			nextState = actName
		else
			--没有近身攻击情况，则躲开
			if i_me.size.hw<=0 then
				i_me.fleeFlag=true
				-- print(">>beginFight->fleeFlag->huntTarget->fleeFlag=",i_me.fleeFlag)
				i_me.action:moveTo(g_fight.AI.calcEvadePos(i_me))
				if i_me.action.targetPos then
        			i_me.action:updateFace(i_me.pos.x - i_me.action.targetPos.x)
        		end
				return
			end
			if g_fight.AI.closeAttack(i_me,i_Target) then
				nextState = i_me:getAttackName(0)
			end
		end
	elseif actType==-1 then
		actName = i_me:getAttackName(0)
		if g_fight.AI.closeAttack(i_me,i_Target) and engine.checkActionByHadnler(actName,i_me,i_Target) then
			nextState = actName
			g_fight.AI.debug(i_me,"actType=-1-->nextState=",nextState)
		end
	end
	if nextState then
		i_me.nextState = nextState
		i_me:stand()
		i_me.action:faceHuntTarget()
		i_me:attack()
	else
		g_fight.AI.debug(i_me,">>beginFight->huntTarget")
		i_me.action:huntTarget(g_RoleManager.player,i_me.remoteFlag)
	end
end
function engine.checkActionByHadnler(i_actionName,i_me,i_Target)
	local funcNames=i_me.attackHandler[i_actionName]
	if not funcNames then
		return true
	end
	funcNames = clone(funcNames)
	local funcs={}
	for fn in string.gmatch(funcNames, "%w+") do
		funcs[fn]=engine.execActionHandler(fn,i_me,i_Target)
	end
	funcNames = string.gsub(funcNames, "|", " or ")
  	funcNames = string.gsub(funcNames, "&", " and ")
	for fnn  in pairs(funcs) do
	    funcNames = string.gsub(funcNames, fnn, ' ' .. tostring(funcs[fnn]) .. ' ')
	end
	local sfunc=loadstring("return " .. funcNames)
  	return sfunc()
end
function engine.execActionHandler(i_actFuncName,i_me,i_Target)
	i_actFuncName = "return g_fight.AI.".. i_actFuncName
	i_actFuncName = loadstring(i_actFuncName)(i_me,i_Target)
	if i_actFuncName and i_actFuncName(i_me,i_Target) then
		return true
	else
		return false
	end
end
return engine