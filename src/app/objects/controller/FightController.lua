--
-- Author: rsma
-- Date: 2015-05-18 10:13:58
-- 战斗控制类
FightController = class("FightController")

function FightController:ctor(PRole)
	self.me = PRole
	self.canAttack=false
	self.remoteAttack=false
	self.remoteattacking=false--正在远程工攻击标识
	self.recoverTID=-1
	self.awaitTID=-1
	self.AttackCDTime=0
	self:initProp()
end

function FightController:initProp()

end
--HP少时，显示闪红效果
function FightController:showHPWarn()
	local actions = {
        cc.TintTo:create(0.25, 255, 0, 0),
        cc.TintTo:create(0.15, 125, 0, 0),
        cc.TintTo:create(0.13, 200, 0, 0),
        cc.TintTo:create(1, 255, 255, 255),
    }
    self.tintseq = transition.sequence(actions)
    self.me.animalObj:runAction(cc.RepeatForever:create(self.tintseq))
end
--普通攻击结束处理函数
function FightController:onFinishedAttack(i_ActionName)
    -- print("FightController:onFinishedAttack",i_ActionName)
    self.me.collider:removeAttackShape()
    self.me.attackCount=self.me.attackCount+1
    if  self.me.currStateCount then
        self.me.currStateCount=self.me.currStateCount-1
        if self.me.currStateCount>0 then
            self.me.animalObj:getAnimation():gotoAndPlay(self.me.actionName)
            return
        end
    end
end
--技能攻击结束处理函数
function FightController:onFinishedSkill(i_ActionName)
    -- print("FightController:onFinishedSkill",i_ActionName,self.me.currStateCount)
    self.me.collider:removeAttackShape()
    if  self.me.currStateCount then
    	self.me.currStateCount=self.me.currStateCount-1
    	if self.me.currStateCount>0 then
	    	self.me.animalObj:getAnimation():gotoAndPlay(self.me.actionName)
	    	return false
	    end
    end
    return true
end
--挨打结束处理函数
function FightController:onFinishedHurt(i_ActionName)
    if self.me:checkDead() == true then
    	self:cleanBattleTID()
		self.me:dead()
		return
	end
	self.me.stopForce=false
end
function FightController:beginBattleCDTime(i_Time)
	self.recoverTID=g_Timer.callAfter(self.onRecover,i_Time,self)
	if g_fight.AI.debugFlag==false then
		return
	end
	if not self.cdblbl then
		self.cdblbl = display.newBMFontLabel({
	    	text = "" .. i_Time,
	    	font = "fonts/f_user_num.fnt",x=-30,y=self.me.size.h})
		self.me:addChild(self.cdblbl)
	end
	self.cdblbl:setString("" .. i_Time)
end
function FightController:cleanBattleTID()
	if self.cdblbl then
		self.cdblbl:setString("" .. 0)
	end
	g_Timer.delTimer(self.recoverTID)
    self.recoverTID=-1
end
function FightController:beginAwaitCDTime(i_Time)
	self.awaitTID=g_Timer.callAfter(self.onAwait,i_Time,self)
	if g_fight.AI.debugFlag==false then
		return
	end
	if not self.cdalbl then
		self.cdalbl = display.newBMFontLabel({
	    	text = "" .. i_Time,
	    	font = "fonts/f_critical_num.fnt",x=30,y=self.me.size.h})
		self.me:addChild(self.cdalbl)
	end
	self.cdalbl:setString("" .. i_Time)
end
function FightController:cleanAwaitTID()
	g_Timer.delTimer(self.awaitTID)
    self.awaitTID=-1
    if self.cdalbl then
    	self.cdalbl:setString("" .. 0)
    end
end
--进入战斗状态
function FightController:readyBattle(i_cTime,i_Req)
	if self.recoverTID>0 then
		g_fight.AI.debug(self.me,"readyBattle.recoverTID>0->return")
		return
	end
	i_Req = i_Req or false
	i_cTime = i_cTime or 0
	g_fight.AI.debug(self.me,"readyBattle->stand")
	self.me:stand()
	self.me.action:faceHuntTarget()
	self:cleanBattleTID()
	if g_fight.istory == false and (self.canAttack == true or i_Req) then
		self.me.nextState = self.me:getAttackName(0)
		g_fight.AI.debug(self.me,"readyBattle->attack-->nextState="..self.me.nextState)
		if self.me.nextState then
			self.me:stand()
			self.me.action:faceHuntTarget()
			self.me:attack()
		else
			self.me.action:huntTarget(self.me.action.huntObj)
		end
	elseif i_cTime==0 then
		self.me.action:huntTarget(self.me.action.huntObj)
	end
	--复活用
	if i_cTime>0 then
		self:beginBattleCDTime(self.AttackCDTime+i_cTime)
		g_fight.AI.debug(self.me,"readyBattle.i_cTime>0.registTID")
	end
end
--待命
function FightController:await()
	if self.awaitTID>0 or g_fight.istory then
		g_fight.AI.debug(self.me,"await->return(awaitTID=" .. self.awaitTID .. ",istory=" .. tostring(g_fight.istory) ..")" )
		return
	end
	g_fight.AI.debug(self.me,"await->stand")
	self.me:stand()
	local random = math.random(1,100)
	if random>=50 or self.me.remoteFlag then
		g_fight.AI.debug(self.me,"await->moveto")
    	self.me.action:moveTo(g_fight.AI.calcPatrolPos(self.me))
	end
	self:cleanAwaitTID()
	self:beginAwaitCDTime(math.random(1,g_fight.getAIProp(AI_ATTR.ACD)))
end
--进入挨打恢复状态
function FightController:onAwait()
	self:cleanAwaitTID()
	if g_fight.battleState == FIGHT_STATUS.VICTORY or g_fight.battleState == FIGHT_STATUS.FAILURE then
		self.me:stand()
		return
	end
	if self == nil or tolua.isnull(self.me) then
		return
	end
	if self.me:checkDead() == true then
		return
	end
	g_fight.AI.debug(self.me,"onAwait->beginFight")
	g_fight.beginFight(self.me,g_RoleManager.player)--self.me.action.huntObj
end
--进入挨打恢复状态
function FightController:onRecover()
	self:cleanBattleTID()
	if g_fight.battleState == FIGHT_STATUS.VICTORY or g_fight.battleState == FIGHT_STATUS.FAILURE then
		self.me:stand()
		return
	end
	if self == nil or tolua.isnull(self.me) then
		return
	end
	if self.me:checkDead() == true then
		return
	end
	g_fight.AI.debug(self.me,"onRecover->beginFight")
	g_fight.beginFight(self.me,g_RoleManager.player)--self.me.action.huntObj
end

function FightController:onFinishedDead(i_ActionName)
	if self.me.name == "NPC" or self.me.name=="Block" then
		local equip = g_Equipment.dropItem(self.me.roleType)
		if equip then
		    local goods = g_RoleManager.buildGoods(equip)
		    goods:setPos(self.me.pos.x,self.me.pos.y)
			goods:setPosition(self.me.pos.x,self.me.pos.y)
			goods:show()
		end
	end
    self.me:cleanSelf()
end
function FightController:destroy()
	g_fight.actionManager:removeAllActionsFromTarget(self.me.animalObj)
    self.me = nil
	self.canAttack=false
	self:cleanBattleTID()
end

function FightController:pauseBattle()
	self:cleanBattleTID()
    self:cleanAwaitTID()
end