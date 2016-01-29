local condition = {}

local function init()
	g_EventManager.addListener(MESSAGE_EVENT.FIGHT_SCORE,condition.upDateScore)
	g_EventManager.addListener(MESSAGE_EVENT.FIGHT_STAR,condition.upDateStar)
	g_EventManager.addListener(MESSAGE_EVENT.FIGHT_PHASE,condition.upDatePhase)
	g_EventManager.addListener(MESSAGE_EVENT.FIGHT_TIME,condition.setTime)
end

function condition.run(i_Info,i_IsFirst)
	-- 初始化评分系统
	if i_IsFirst then
		condition.destroy()
		-- 无尽 挑战
		condition.phase = 1
		-- 复活次数
		condition.relife = 0
		if i_Info then
			-- 初始星
			condition.star = 3
			-- 基础得分
			condition.basescore = 1000 + i_Info.lvl*GAME_SCORE.EXLVL
			-- 实时得分
			condition.score = condition.basescore
		end
	else 
		condition.relife = condition.relife + 1
	end
	-- 剧情模式
	if i_Info then
		if i_Info.condition then
			if i_Info.condition.type == GAME_CONDITION.TIME then
				condition.info = i_Info.condition
				condition.num = 0
				condition.gap = 1
				if not condition.timer then
					condition.timer = g_Timer.addTimer(condition.runTime,0,1)
				end
				if not condition.timeTip then
					condition.timeTip = require("app.ui.tip.TipCountDownUI").new()
					g_LayerManager:addEffectUI(condition.timeTip)
				end
			elseif i_Info.condition.type == GAME_CONDITION.BOSS then

			elseif i_Info.condition.type == GAME_CONDITION.ALL then

			end
		end
	else

	end
end

--返回当前胜利条件
function condition.getConditionType()
	if condition.info then
		return condition.info.type
	else
		return GAME_CONDITION.BOSS
	end
end

function condition.upDateScore(i_EventName,i_Msg)
	if condition.score then
		condition.score = condition.score + i_Msg
	end
end

function condition.upDateStar(i_EventName,i_Msg)
	if condition.star then
		condition.star = condition.star + i_Msg
	end
end

function condition.upDatePhase(i_EventName,i_Msg)
	if condition.phase then
		condition.phase = condition.phase + i_Msg
	end
end

-- 停止计时 0 开始计时 1
function condition.setTime(i_EventName,i_Msg)
	if i_Msg == 0 then
		condition.gap = 0
	elseif  i_Msg == 1 then
		condition.gap = 1
	end
end

function condition.getReLife()
	return condition.relife
end

-- 获取关卡得分 返回得分和评分
function condition.getFightScore()
	if condition.score < 0 then
		condition.score = 0 
	end
	condition.score = math.ceil(condition.score)

	local temp = condition.score/condition.basescore*100
	local quality = "d"
	if temp >= 90 then 
		quality = "s"
	elseif temp < 90 and temp >= 80 then
		quality = "a"
		g_EventManager.dispatch(MESSAGE_EVENT.FIGHT_STAR,-1)
	elseif temp < 80 and temp >= 70 then
		quality = "b"
		g_EventManager.dispatch(MESSAGE_EVENT.FIGHT_STAR,-1)
	elseif temp < 70 then
		quality = "c"
		g_EventManager.dispatch(MESSAGE_EVENT.FIGHT_STAR,-1)
	end

	return condition.score,quality
end

function condition.getFightStar()
	if condition.star < 1 then
		condition.star = 1 
	end
	return condition.star
end

function condition.getFightPhase()
	return condition.phase-1
end

function condition.runTime()
	condition.num = condition.num + condition.gap
	if condition.num <= condition.info.num then
		local t = condition.info.num - condition.num
		local b = false
		if t < 0 then
			t = 0
		end
		if t <= 30 then
			b = true
		end
		condition.timeTip:upDateTime(t,b)
	else
		g_Timer.delTimer(condition.timer)
		condition.timer=nil
		g_fight.setFightResult(FIGHT_STATUS.FAILURE)
	end
end

function condition.showCount()
	if condition.countTip then
		condition.countTip:removeSelf()
		condition.countTip = nil
	end
	condition.countTip = require("app.ui.tip.TipCountUI").new(condition.phase)
	g_LayerManager:addEffectUI(condition.countTip)
end

function condition.destroy()
	if condition.timer then
		g_Timer.delTimer(condition.timer)
		condition.timer=nil
		if condition.timeTip and not tolua.isnull(condition.timeTip) then
			condition.timeTip:removeSelf()
			condition.timeTip = nil
		end
	end
	if condition.countTip then
		condition.countTip:removeSelf()
		condition.countTip = nil
	end
end

init()

return condition