--管理所有层的类
local layermanager=class("LayerManager")
--将UI中一些公共部分作为公共变量，方便多次调用
layermanager.RoleUI=nil
layermanager.MenuUI=nil

function layermanager:ctor(i_Parent)
	--保存的child列表
	self.childs={}
	--层容器
	self.container=i_Parent
end

--地图层
function layermanager:initMapLayer()
	self.childs.maplayer = display.newNode():addTo(self.container)
    self.childs.objslayer = display.newNode():addTo(self.container)
    self.childs.maplayer:setTouchEnabled(false)
    self.childs.objslayer:setTouchEnabled(false)
end

-- UI层
function layermanager:initUILayer()
    self.childs.uilayer=display.newNode():addTo(self.container)
    self.childs.uimain=display.newNode():addTo(self.childs.uilayer)
    self.childs.uifunction=display.newNode():addTo(self.childs.uilayer)
    self.childs.uipop=display.newNode():addTo(self.childs.uilayer)
    self.childs.uieffect=display.newNode():addTo(self.childs.uilayer)
    self.childs.uimask=display.newNode():addTo(self.childs.uilayer)
end

--初始化层
function layermanager:initLayer(i_MapFlag)
    --初始化地图层
	if i_MapFlag then
		self:initMapLayer()
	end
	--初始化UI层
	self:initUILayer()
end

--添加到主UI层上（所有UI都不能使用）
function layermanager:addMainUI(i_MainUI)
	self.childs.uimain:addChild(i_MainUI)
end

--添加功能的UI，例如（商城、仓库、好友、任务等）
--现在用到uifunction的有:
--1商城；
function layermanager:addFunctionUI(i_Function)
    self.childs.uifunction:addChild(i_Function)
end

--添加到PopUI层上(POP层为最上层，不会被覆盖)
--现在用到PopUI的有:
--1登陆奖励；2升级；3购买，出售
function layermanager:addPopUI(i_PopUI)
	self.childs.uipop:addChild(i_PopUI)
end

--添加到EffectUI层上(效果层)
function layermanager:addEffectUI(i_EffectUI)
	self.childs.uieffect:addChild(i_EffectUI)
end

-- 添加到指引层上
function layermanager:addMaskUI(i_MaskUI)
	self.childs.uimask:addChild(i_MaskUI)
end

--添加对象
function layermanager:addObjs(i_Child)
    i_Child:addTo(self.childs.objslayer)
    if i_Child == g_RoleManager.player then
        self.mapinfo:setFocusObj(i_Child)
    end
end

--设置地图等级
function layermanager:setMapLevel(i_Level,i_SubLevel,i_MapGap)
	-- i_Level = checknumber(i_Level or 1)
	-- i_SubLevel = checknumber(i_SubLevel or 1)
	-- if self.lvl == i_Level then
	-- 	return
	-- end

	-- if self.mapinfo and not tolua.isnull(self.mapinfo) then
	-- 	self.mapinfo:removeSelf()
	-- end
    self.mapinfo = require("app.ui.layer.NewBackGround").new(i_Level,i_SubLevel,i_MapGap):addTo(self.childs.maplayer)
    return self.mapinfo
end

--根据文件名返回相应的层
function layermanager:getLayerByName(i_Name)
	if string.upper(i_Name) == "UILAYER" then
		return self.childs.uilayer
	elseif string.upper(i_Name) == "UIMAIN" then
		return self.childs.uimain
	elseif string.upper(i_Name) == "UIFUNCTION" then
		return self.childs.uifunction
	elseif string.upper(i_Name) == "UIPOP" then
		return self.childs.uipop
	elseif string.upper(i_Name) == "UIMASK" then
		return self.childs.uimask
	elseif string.upper(i_Name) == "UIEFFECT" then
		return self.childs.uieffect
	elseif string.upper(i_Name) == "MAPLAYER" then
		return self.childs.maplayer
	else
		return self.childs.objslayer
	end
end

--关闭POP层所有UI
function layermanager:closePopUI()
	g_CommonUtil.closeNode(self.childs.uipop)
end

--根据名称删除层
function layermanager:removeLayerByName(i_Name)
	g_CommonUtil.closeNode(self.getLayerByName(i_Name))
end

--销毁
function layermanager:destroy()
	for k,v in pairs(self.childs) do
		g_CommonUtil.closeNode(v)
	end
	self.childs=nil
	self.container=nil
end

return layermanager
