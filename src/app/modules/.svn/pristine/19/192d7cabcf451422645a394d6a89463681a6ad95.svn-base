--此类只能被app.module.MessageData所引用，其他类不能引用

local Global = _G
local package = _G.package
local setmetatable = _G.setmetatable
local assert = _G.assert
local table = _G.table
local pairs = _G.pairs
local ipairs = _G.ipairs
local MESSAGE_PREFIX_CMD="CMD_"

module ("BaseEvent",package.seeall)

--[[
数据层次

["EventName1"] =
{
    ["_StaticFunc"] = { Func1, Func2 },

    [Object1] = { Func1, Func2 },
    [Object2] = { Func1, Func2 },
},

["EventName2"] =
{
    ...
}

]]

-- 默认调用函数
local function PreInvoke( EventName, Func, Object, UserData, ... )
	if Object then
		Func( Object, EventName, ... )
	else
		Func( EventName, ... )
	end
end

function New( )
	local NewObj = setmetatable( {}, { __index = package.loaded["BaseEvent"] } )
	-- 对象成员初始化
	NewObj.mPreInvokeFunc = PreInvoke
	NewObj.mEventTable = {}
	return NewObj
end

-- 添加
function Add( Self, EventName, Func, Object, UserData )
	assert(Func,EventName)
	Self.mEventTable[ EventName ] = Self.mEventTable[ EventName ] or {}
	local Event = Self.mEventTable[ EventName ]

	if not Object then
		Object = "_StaticFunc"
	end

	Event[Object] = Event[Object] or {}
	local ObjectEvent = Event[Object]

	ObjectEvent[Func] = UserData or true
end

-- 添加指令
function AddCmd( Self, EventName, Func, Object, UserData )
	Add(Self,MESSAGE_PREFIX_CMD..EventName,Func,Object,UserData)
end

-- 设置调用前回调
function SetDispatchHook( Self, HookFunc )
	Self.mPreInvokeFunc = HookFunc
end

-- 派发
function Dispatch( Self, EventName, ... )
	if (EventName==nil) then
		print("EventName is nil")
		return
	end
	local Event = Self.mEventTable[ EventName ]
	if(Event~=nil)then
		for Object,ObjectFunc in pairs( Event ) do
			if Object == "_StaticFunc" then
				for Func, UserData in pairs( ObjectFunc ) do
					Self.mPreInvokeFunc( EventName, Func, nil, UserData, ... )
				end
			else
				for Func, UserData in pairs( ObjectFunc ) do
					Self.mPreInvokeFunc( EventName, Func, Object, UserData, ... )
				end
			end
		end
	else
		print("EventDispatcher :",EventName,"not handled!")
	end
end

--派发服务器消息
function DispatchCmd( Self, EventName, ... )
	Dispatch(Self,MESSAGE_PREFIX_CMD..EventName,...)
end

-- 回调是否存在
function Exist( Self, EventName )
	assert( EventName )
	local Event = Self.mEventTable[ EventName ]

	if not Event then
		return false
	end

	-- 需要遍历下map, 可能有事件名存在, 但是没有任何回调的
	for Object,ObjectFunc in pairs( Event ) do
		for Func, _ in pairs( ObjectFunc ) do
			-- 居然有一个
			return true
		end
	end

	return false

end

-- 清除
function Remove( Self, EventName, Func, Object )
	assert( Func,string.format("Event remove error with :%s",EventName) )
	local Event = Self.mEventTable[ EventName ]

	if not Event then
		return
	end

	if not Object then
		Object = "_StaticFunc"
	end

	local ObjectEvent = Event[Object]

	if not ObjectEvent then
		return
	end

	ObjectEvent[Func] = nil
end

-- 移除指令
function RemoveCmd( Self, EventName, Func, Object )
	Remove( Self, MESSAGE_PREFIX_CMD..EventName, Func, Object )
end

-- 清除对象的所有回调
function RemoveObjectAllFunc( Self, EventName, Object )
	assert( Object )
	local Event = Self.mEventTable[ EventName ]

	if not Event then
		return
	end

	Event[Object] = nil
end
