--[[--
	此类处理消息的监听与分发
--]]--

require ("app.modules.BaseEvent")
local eventmanager={}

--	消息分发、监听
local msgevent=BaseEvent.New()

--添加监听事件消息
function eventmanager.addListener(i_EventName, i_Func, i_Self, i_DataInfo)
	msgevent:Add(i_EventName, i_Func, i_Self, i_DataInfo)
end

--添加指令
function eventmanager.addCmdListener(i_EventName, i_Func, i_Self, i_DataInfo)
	msgevent:AddCmd(i_EventName, i_Func, i_Self, i_DataInfo)
end

--派发消息
function eventmanager.dispatch(i_EventName, ... )
	msgevent:Dispatch(i_EventName, ... )
end

--派发服务器消息
function eventmanager.dispatchCmd(i_EventName, ... )
	msgevent:DispatchCmd(i_EventName, ... )
end

--注销事件监听
function eventmanager.removeListener(i_EventName, i_Func, i_Self)
	msgevent:Remove(i_EventName, i_Func, i_Self)
end

--注销指令事件监听
function eventmanager.removeCmdListener(i_EventName, i_Func, i_Self)
	msgevent:RemoveCmd(i_EventName, i_Func, i_Self)
end

return eventmanager