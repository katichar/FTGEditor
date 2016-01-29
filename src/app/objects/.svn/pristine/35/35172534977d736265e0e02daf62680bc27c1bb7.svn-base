--
-- Author: rsma
-- Date: 2015-05-20 15:11:26
--
require("app.objects.controller.ActionController")
NPCActionController = class("NPCActionController", ActionController)

function NPCActionController:checkTargetPos()
	if not self.targetPos then
		--移动固定点时，会自动计算方向
		if self.me.inApplyForce == false and self.me.fight.remoteattacking==false and self.me:isFighting()==false and self.me.fleeFlag==false then
			self:faceHuntTarget()
		end
		return
	end
	if fleeFlag==false then
		if self.me.fight.canAttack then
			if self.me.remoteFlag or self:isInAttackSite()==true or self.me.isElite then
				self.me:stand()
				g_fight.AI.debug(self.me,"checkTargetPos.canAttack.remoteFlag.isInAttackSite->readyBattle")
				self.me.fight:readyBattle()
				return
			end
		end
		if self.huntObj and self.huntObj.pos:getDistance(self.targetPos)>=g_fight.getAIProp(AI_ATTR.HUNTDIST) then
			g_fight.AI.debug(self.me,"checkTargetPos.huntObj_Distance>", g_fight.getAIProp(AI_ATTR.HUNTDIST),"->huntTarget")
		    self:huntTarget(self.huntObj,self.me.remoteFlag)
		    return
		end
	else
		if self.me.fight.canAttack then
			if math.random(1,100) <=g_fight.getAIProp(AI_ATTR.IMMATKPRO) then
				self.me:stand()
				self.me.fight:readyBattle()
				return
			end
		end
	end
	local sx,sy = self:calcMoveSpeed()
	self:updateSpeed(sx,sy)
	if sx==0 and sy==0 then
		self.me:setPos(self.targetPos.x,self.targetPos.y)
		self.me:stand()
		if g_fight.istory== true then
			return
		end
		if self.me.remoteFlag==false and (self.me.fight.canAttack or self:isInAttackSite()==true) then
			g_fight.AI.debug(self.me,"checkTargetPos.SXSY==0.canAttack.isInAttackSite->readyBattle,canAttack=",self.me.fight.canAttack,self:isInAttackSite())
			self.me.fight:readyBattle(-1,true)
			return
		end
		if self.me.remoteFlag==true and self.me.fight.canAttack then
			g_fight.AI.debug(self.me,"checkTargetPos.SXSY==0.remoteFlag.canAttack->readyBattle")
			self.me.fight:readyBattle()
			return
		end
		if self.huntObj and (self:isInAttackSite()==false or self.me.fight.canAttack==false ) and self.me.fleeFlag==false then
			g_fight.AI.debug(self.me,"checkTargetPos.isInAttackSite=false->huntTarget,insite=",self:isInAttackSite(),"canattack=",self.me.fight.canAttack)
			self:huntTarget(self.huntObj,self.me.remoteFlag)
			return
		end
		if self.me.fleeFlag==true then
			self.me.fleeFlag=false
			g_fight.AI.debug(self.me,"checkTargetPos.fleeFlag=true->beginFight->fleeFlag=",self.me.fleeFlag)
			self:faceHuntTarget()
			g_fight.beginFight(self.me,self.huntObj)
		end
	end
end
--计算下一步的移动速度
function NPCActionController:calcMoveSpeed()
	if not self.targetPos then
		return 0,0
	end
	local speedup=0
	if g_fight.getAIProp(AI_ATTR.SPR)>=200 and self.huntObj.pos:getDistance(self.me.pos)<=g_fight.getAIProp(AI_ATTR.SPR) then
		if self.me.offSpeed>=0 then
			speedup = 2-self.me.offSpeed
		else
			speedup=2
		end
	end
	local speed = MOVE_SPEED.NEAR_SPEED*0.5+self.me.offSpeed+speedup
	local locX,locY = self.me:getPos()
	local sx=0
	local sy=0
	if math.abs(locX - self.targetPos.x) >  math.abs(speed) then
		if locX > self.targetPos.x then
			sx = -speed
		else
			sx = speed
		end
	end
	if math.abs(locY - self.targetPos.y) > math.abs(speed) then
		if locY > self.targetPos.y then
			sy = -speed
		else
			sy = speed
		end
	end
	if self.huntObj and self:calcAround(self.huntObj.pos.x,self.me.pos.x,self.targetPos.x) and self.rd~=0 then
		if self.rd==1 then
			sy=-speed
		elseif self.rd==-1 then
			sy=speed
		end
		if math.ceil(math.abs(self.me.pos.y-self.huntObj.pos.y))  >= 80 then
			sy=0
		end
	end
	return sx,sy
end
---计算绕行路线
-- i_AX-player.posX
-- i_NX-NPC.posX
-- i_TX-targetPos.x
function NPCActionController:calcAround(i_AX,i_NX,i_TX)
	-- if self.me.remoteFlag then
	-- 	return false
	-- end
	if math.ceil(math.abs(i_TX-i_NX))  >= math.ceil(math.abs(i_AX-i_NX)) then
		if i_NX-i_AX>-1300 and i_NX-i_AX<0 then--左边
			return true
		end
		if i_NX-i_AX>0 and i_NX-i_AX<1300 then--右边
			return true
		end
	end
	return false
end
function NPCActionController:huntTarget(i_Role,i_Req)
	if self.me:checkDead() == true or iskindof(self.me, "BlockObject") then
		return
	end
	NPCActionController.super.huntTarget(self,i_Role,i_Req)
end
function NPCActionController:moveRrender(dt)
	NPCActionController.super.moveRrender(self,dt)
	if self.me.name=="NPC" then
		self:checkTargetPos()
	end
    if self.speedX + self.FX==0 and self.speedY + self.FY==0 then
        return
    end
	self:onMoveStep()
end