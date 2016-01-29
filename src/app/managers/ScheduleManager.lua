-- 游戏中需要根据时间重置的一些东西
local schedule = {}
schedule.timer=require("framework.scheduler")
--定时handler
local t_schedule
--最后更新挑战的时间
schedule.lastChallenge_ = 0
--检查邮件
schedule.mailcheck_ = 0

-- 更新挑战次数
-- 每天一更新
function schedule.updateChallenge()
	local server_time_ = os.date("%x",g_Timer.SERVER_TIME)
	-- 如果刚刚登录
	if schedule.lastChallenge_ == 0 then
		local challenge_info_ = g_DB.getActivityByType(GAME_MODE.NORMAL,g_User.userid)
		if challenge_info_ == nil then
			schedule.lastChallenge_ = os.date("%x",g_Timer.SERVER_TIME)
			g_DB.updateActivity(GAME_MODE.NORMAL,MODE_COUNT[GAME_MODE.NORMAL],g_User.userid,g_Timer.SERVER_TIME)
			return
		else
			schedule.lastChallenge_ = os.date("%x",challenge_info_.lasttime)
		end
	end
	if schedule.lastChallenge_ ~= server_time_ then
		schedule.lastChallenge_ = os.date("%x",g_Timer.SERVER_TIME)
		local activitys={}
		table.insert(activitys,{num=MODE_COUNT[GAME_MODE.EASY],activityid=GAME_MODE.EASY})
		table.insert(activitys,{num=MODE_COUNT[GAME_MODE.NORMAL],activityid=GAME_MODE.NORMAL})
		table.insert(activitys,{num=MODE_COUNT[GAME_MODE.HARD],activityid=GAME_MODE.HARD})
		table.insert(activitys,{num=MODE_COUNT[GAME_MODE.PVP],activityid=GAME_MODE.PVP})
		g_DB.batchUpdateActivity(activitys,g_User.userid)
		activitys = nil
	end
end

--检查是否有要开启的活动
function schedule.checkActivity()
	--检查挑战塔次数
	schedule.updateChallenge()
end

--检查新邮件
function schedule.checkMail()
	schedule.mailcheck_ = schedule.mailcheck_ + 1
	if schedule.mailcheck_ >= 5 then
		schedule.mailcheck_ = 0
		g_Request.getMails()
	end
end

--每分钟处理
function schedule.onMinute()
	--检查是否有要开启的活动
	schedule.checkActivity()
	schedule.checkMail()
end

--初始
function schedule.init()
	--检查活动开关
	schedule.checkActivity()
	--启动定时
	t_schedule=schedule.timer.scheduleGlobal(schedule.onMinute, 60)
	--30秒后检查邮件
	g_Timer.callAfter(g_Request.getMails,30)
	--更新邮件
	g_Timer.callAfter(g_DB.updateMail,31)
	--进入游戏三秒后检查票据
    g_Timer.callAfter(g_Request.batchPayments,3)
end

--销毁
function schedule.destroy()
	if t_schedule then
		schedule.timer.unscheduleGlobal(t_schedule)
		t_schedule=nil
	end
end

return schedule
