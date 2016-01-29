--
-- Author: rsma
-- Date: 2015-06-09 14:33:24
--
FightAttribute = class("FightAttribute")

function FightAttribute:ctor(i_Data)
	self.damage=0
	self.sound = i_Data.sound
	self.effect = i_Data.effect
	self.action = i_Data.action
	self.action2 = i_Data.action2
	self.attackDist= i_Data.atkDist
	self.pause = (i_Data.pause==nil and 0 or 1)
	self.pauseFrame = (i_Data.pauseFrame==nil and 1 or i_Data.pauseFrame)
	self.target=nil
	self.fx=(i_Data.fx==nil and 0 or i_Data.fx)
	self.fy=(i_Data.fy==nil and 0 or i_Data.fy)
	-- self.moveBy=(i_Data.moveBy==nil and 0 or i_Data.moveBy)
	self.frames=(i_Data.frames==nil and 0 or i_Data.frames)
	self.hurtEFName=i_Data.effectName
	if i_Data.target then
		if i_Data.target == "ALL" and not tolua.isnull(g_LayerManager) and not tolua.isnull(g_LayerManager.mapinfo) then
			self.target = g_LayerManager.mapinfo
		end
	end
end

function FightAttribute:checkActionPause()
	return self.pause == 1
end