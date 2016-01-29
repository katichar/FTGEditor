-- NPC 血条
local node = class("NpcBarUI",g_BaseNode)
local path = "ui/bar/"

function node:ctor(i_Params)
	node.super.ctor(self)
	self.params = i_Params
	self:initBarInfo()
	self:createUI()

	self:addAllListener()
end

function node:addAllListener()
	--g_EventManager.addListener(MESSAGE_EVENT.ROLE_BAR_CHANGE,self.roleBarChange,self)
end

function node:removeAllListener()
	--g_EventManager.removeListener(MESSAGE_EVENT.ROLE_BAR_CHANGE,self.roleBarChange,self)
end

function node:initBarInfo()
	self.hpMax = self.params.hp or 1
	self.hp = self.hpMax
end

function node:createUI()
	self.bg = display.newSprite(path.."ui_bar_npc_bg.png")
		:align(display.CENTER,0,0)
		:addTo(self)
	self.bgW = self.bg:getContentSize().width
	self.bgH = self.bg:getContentSize().height

	local params = {
			image =  path.."ui_bar_npc_hp.png",
			viewRect = cc.rect(0,0,67,5),
			percent = 100,
			direction = 0,
		}
	self.hpBar = require("app.ui.bar.HpBar").new(params,3)
	self.bg:addChild(self.hpBar)
	self.hpBar:setPosition(2,2)
end

function node:changeBar(i_Msg)
	if i_Msg.hp then
		self.hp = self.hp + i_Msg.hp
		local percent = (i_Msg.hp/self.hpMax)*100
		self.hpBar:changeBar(percent)
		if self.hpBar.effectBar:getPercent() <= 0 then
			--self:hide()
		end
	elseif i_Msg.mp then
		local percent = (i_Msg.mp/self.mpMax)*100
		self.mpBar:changeBar(percent)
	end
end

function node:destroy()
	self:removeAllListener()
end

return node