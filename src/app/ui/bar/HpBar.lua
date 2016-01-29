-- 有基础特效功能的血条
local node = class("HpBar",g_BaseNode)
local path = "ui/bar/"
local EFFECT_IMAGE_TYPE = {
	ROLE_HP = 1,
	ROLE_MP = 2,
	NPC_NORMAL = 3,
	BOSS_NORMAL = 4,
}

function node:ctor(i_Params,i_EffectType)
	node.super.ctor(self)
	self.params = i_Params
	self.effectType = i_EffectType
	--[*]
	self:createMainBar()

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,handler(self,self.upDateEffect))
    self:scheduleUpdate()
end

function node:createMainBar()

	local params = {
			direction = self.params.direction,
		    image = self:getImageByType(self.effectType),
		    viewRect = self.params.viewRect,
		}
	self.effectBar = require("app.ui.bar.BaseBar").new(params)
	self:addChild(self.effectBar)

	self.mainBar = require("app.ui.bar.BaseBar").new(self.params)
	self:addChild(self.mainBar)
end

function node:changeBar(i_Percent)
	local currPercent = self.mainBar:getPercent() + i_Percent
	if currPercent <= 0 then
		self.mainBar:setPercent(0)
		return
	elseif currPercent >= 100 then
		self.mainBar:setPercent(100)
		return 
	end
	self.mainBar:setPercent(currPercent)
end

function node:setBar(i_Percent)
	if i_Percent <= 0 then
		i_Percent = 0
	elseif i_Percent >= 100 then
		i_Percent = 100
	end
	self.mainBar:setPercent(i_Percent)
end

function node:resetBar()
	self.mainBar:setPercent(100)
	self.effectBar:setPercent(100)
end

function node:upDateEffect()
	if self.effectBar:getPercent() >= self.mainBar:getPercent() then
		local gap = 0.5
		if self.effectBar:getPercent() - self.mainBar:getPercent() >= 20 then
			gap = 1
		end

		if self.effectBar:getPercent()-gap <= 0 then
			self.effectBar:setPercent(0)
		else 
			self.effectBar:setPercent(self.effectBar:getPercent()-gap)
		end
	else 
		self.effectBar:setPercent(self.mainBar:getPercent())
	end
end

function node:removeEffect()
	if self.effectBar then
		self.effectBar:removeSelf(true)
		self.effectBar=nil
	end
end

function node:getImageByType(i_Type)
	if i_Type == EFFECT_IMAGE_TYPE.ROLE_HP then
		return path .. "ui_bar_role_hpeffect.png"
	elseif i_Type == EFFECT_IMAGE_TYPE.ROLE_MP then
		return path .. "ui_bar_role_mpeffect.png"
	elseif i_Type == EFFECT_IMAGE_TYPE.NPC_NORMAL then
		return path .. "ui_bar_npc_hpeffect.png"
	elseif i_Type == EFFECT_IMAGE_TYPE.BOSS_NORMAL then
		return path .. "ui_bar_boss_hpeffect.png"
	end
end

function node:getPercent()
	return self.mainBar:getPercent()
end

function node:destroy()
end

return node

