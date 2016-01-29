--
-- Author: rsma
-- Date: 2015-07-13 14:15:24
--
require("app.objects.controller.FightController")
RoleFightController = class("RoleFightController", FightController)
function RoleFightController:initProp()
    RoleFightController.super.initProp(self)
end
function RoleFightController:updateAttackIndex()
	self.me.attackIndex=self.me.attackIndex+1
	if self.me.attackIndex>=4 then
        self.me.attackIndex=0
    end
end
function RoleFightController:onFinishedAttack(i_ActionName)
	RoleFightController.super.onFinishedAttack(self,i_ActionName)
    if self.me.currStateCount>0 then
        return
    end
    -- print("RoleFightController:onFinishedHurt",self.RID,i_ActionName,self.me.HP,self.me.RID,self.canAttack)
	if self.me.currState and self.me.stopAttack==false and g_fight.gameOver==false then
		if self.me.attackIndex==0 then
			self.me.action:resetSpeed()
		end
		self.me:gotoFightState(self.me.currState)
		self:updateAttackIndex()
	else
		if self.me.ismoving==true then
			self.me:run()
		else
			self.me:stand()
		end
	end
	if self.me.hitCount < self.me.attackCount or self.me:isAttacking()==false then
		self.me.attackCount=0
	end
end

function RoleFightController:onFinishedSkill(i_ActionName)
	RoleFightController.super.onFinishedSkill(self,i_ActionName)
	-- print("RoleFightController:onFinishedSkill",i_ActionName,"currStateCount=",self.me.currStateCount,self.me.gotoState)
	if self.me.currStateCount>0 then
        return
    end
    if self.me.gotoState then
    	self.me:gotoFightState(self.me.gotoState)
    	return
    end
    self.me.starSkill=false

    if self.me.ismoving==true then
		self.me:run()
	else
		self.me:stand()
	end
    if g_fight.onAttackFunc then
    	g_fight.onAttackFunc()
    end
end
function RoleFightController:onFinishedHurt(i_ActionName)
    RoleFightController.super.onFinishedHurt(self,i_ActionName)
    if self.me:checkDead() == true then
    	return
    end
    if g_fight.onAttackFunc then
    	g_fight.onAttackFunc()
    end
	if self.me.ismoving==true then
		self.me:run()
	else
		self.me:stand()
	end
	if g_fight.onAttackFunc then
    	g_fight.onAttackFunc()
    end
end