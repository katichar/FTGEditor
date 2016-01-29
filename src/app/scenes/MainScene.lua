local MainScene = class("MainScene", function()
    return display.newPhysicsScene("MainScene")

end)

function MainScene:ctor()
end

function MainScene:onEnter()
	g_engine.init(self)
    -- g_fight.init()
	--背景图片
	local bg = display.newSprite("ui/YellowBlock.png")
	local bgsize = bg:getContentSize()
	bg:setLocalZOrder(-1)
	bg:setScale(display.width/bgsize.width)
	bg:align(display.CENTER, display.cx, display.cy)
	bg:addTo(self)
	--菜单项
	self.menu = require("app.view.MenuPanel").new()
	self:addChild(self.menu)
	self.menu:align(display.LEFT_TOP, 0,display.height)
	--人物及战斗演示场景
	self.fight = require("app.view.FightPanel").new()
	self:addChild(self.fight)
	self.fight:setLocalZOrder(99999)
	self.fight:align(display.BOTTOM_CENTER, display.cx,30)
	self.fight.changeFunc=function()
		self.action:loadData(self.fight.boneInfo)
	end
	--人物动作列表
	self.action = require("app.view.ActionPanel").new()
	self:addChild(self.action)
	self.action:align(display.BOTTOM_LEFT, 10,30)
	self.action.changeFunc=function()
		self.fight:changeAction(self.action.animationInfo)
		self.event:loadData(self.action.animationInfo)
	end
	--人物事件列表
	self.event = require("app.view.EventPanel").new()
	self:addChild(self.event)
	self.event:align(display.BOTTOM_RIGHT, display.width-190,30)
	self.event.changeFunc=function(pos)
		if pos == 1 then
			self.fight:changeAction(self.action.animationInfo)
		end
		self.fight.role:resumeAction()
	end
	
end

function MainScene:onExit()
end

return MainScene
