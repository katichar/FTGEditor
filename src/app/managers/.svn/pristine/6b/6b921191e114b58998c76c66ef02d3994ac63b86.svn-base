local timer={}

local scheduler=require("framework.scheduler")
local unpack=unpack
-- 缺省执行间隔（单位秒）
local defaultscap = 0.1
--定时任务列表
timer.tasklist={}
--定时调用的索引
timer.index=0
--服务器时间
timer.SERVER_TIME=os.time()

function timer.start()
	timer.handler=scheduler.scheduleGlobal(timer.onTimer, defaultscap)
end

--每秒执行defaultscap次
function timer.onTimer(dt)
	timer.SERVER_TIME=timer.SERVER_TIME+defaultscap
	timer.exec()
end

--执行方法
function timer.exec()
	local var
	for i=#timer.tasklist, 1,-1 do
		var=timer.tasklist[i]
		if (var) then
			var.currtimer=var.currtimer+1
			if (var.currtimer>=var.interval) then
				var.currtimer=0
				if type(var.func)=="function" then
					pcall(function ()
						var.func(unpack(var.args))
					end)
				end
				if (var.isLoop==false) then
					var.countdown=var.countdown-1
					if (var.countdown<=0) then
						timer.delTimer(var.serial)
					end
				end
			end
		end
	end
end

--补充执行在游戏在后台的时间差
function timer.balanceTimer(Balance)
	--	补偿Timer
	for var=1, Balance do
		timer.exec()
	end
end

--添加定时任务
--@Func定时调用的方法
--@倒计时时间
--@Interval 每次执行的时间间隔 缺省为1 单位为 defaultscap 秒
--其他参数不限
function timer.addTimer(Func,CountDown,Interval,...)
	timer.index=timer.index+1
	Interval=(Interval or defaultscap)/defaultscap
	if (CountDown>0) then
		table.insert(timer.tasklist,{serial=timer.index,func=Func,args={...},countdown=CountDown,isLoop=false,currtimer=0,interval=Interval})
	else
		table.insert(timer.tasklist,{serial=timer.index,func=Func,args={...},countdown=CountDown,isLoop=true,currtimer=0,interval=Interval})
	end
	return timer.index
end

--延迟调用(1秒后调用）
--@Func方法
--@... 不限定参数
function timer.callLater(Func,...)
	return timer.addTimer(Func,1,1,...)
end

--延迟N秒调用(N秒后调用）
--@Func 方法
--@Second 延迟的时间
--@... 不限定参数
function timer.callAfter(Func,Second,...)
	return timer.addTimer(Func,1,Second or 1,...)
end

--删除定时任务
function timer.delTimer(Serial)
	if not Serial then return false end
	for key, var in ipairs(timer.tasklist) do
		if Serial==var.serial then
			table.remove(timer.tasklist,key)
			return true
		end
	end
	return false
end

--立即执行某个任务
--@Serial 任务序号
function timer.execTimer(Serial)
	if not Serial then return false end
	for key, var in ipairs(timer.tasklist) do
		if Serial==var.serial then
			var.currtimer=var.interval+1
			return true
		end
	end
	return false
end

function timer.stop()
	if timer.handler then
		scheduler.unscheduleGlobal(timer.handler)
		timer.handler = nil
	end
end

-- 修改计时器
-- 
function timer.changeTimerCountDown(i_Serial,i_CountDown)
	if timer.tasklist[i_Serial] then 
		timer.tasklist[i_Serial].countdown = i_CountDown
	end
end

--启动定时
timer.start()

return timer
