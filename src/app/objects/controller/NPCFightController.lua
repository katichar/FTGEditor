--
-- Author: rsma
-- Date: 2015-05-22 16:23:36
--
require("app.objects.controller.FightController")
NPCFightController = class("NPCFightController", FightController)

function NPCFightController:initProp()
    NPCFightController.super.initProp(self)
    self.AttackCDTime=5
    if self.me.isBoss then
    	self.AttackCDTime=10
    end
end

function NPCFightController:onFinishedAttack(i_ActionName)
    NPCFightController.super.onFinishedAttack(self,i_ActionName)
    -- print("NPCFightController:onFinishedAttack",self.me.BeginAttack,self.me.currState)
    if self.me.currStateCount>0 then
        return
    end
    if self.me.gotoState then
        self.me:gotoFightState(self.me.gotoState)
        return
    end
    -- print("NPCFightController:onFinishedAttack",self.me.currState,"fleeFlag=",self.me.fleeFlag)
    if self.me:checkDead() == false then
        if self.me.fleeProbability>0 then
            if math.random(0,100) <= self.me.fleeProbability*100 then
                self.me.fleeFlag=true
                self.me.action:moveTo(g_fight.AI.calcFleePos(self.me))
                g_fight.AI.debug(self.me,">>onFinishedAttack->fleeProbability-",self.me.fleeFlag)
                if self.me.action.targetPos then
                    self.me.action:updateFace(self.me.pos.x - self.me.action.targetPos.x)
                end
                return
            end
        end
        --取当前攻击的恢复时间
        if self.me.AttackCDTime[self.me.currState] then
            self.AttackCDTime = self.me.AttackCDTime[self.me.currState]
        end
        self.me:stand()
        math.newrandomseed()
        self:beginBattleCDTime(self.AttackCDTime+(math.random(-5,5)/10))
	else
		printLog("INFO","Fight Logic Error!!",self.me.RID)
        self.me:dead()
    end
end

function NPCFightController:onFinishedHurt(i_ActionName)
    if self.me.name == "Goods" then
        return
    end
    NPCFightController.super.onFinishedHurt(self,i_ActionName)
    if self.me:checkDead() == true then
        return
    end
    if self.me.HP/self.me.MaxHP <=30 then
        self.AttackCDTime=2
        if  self.me.isBoss then
            self:showHPWarn()
        end
    end
    self.me:stand()
    local prob=0
    if self.me.roleType == OBJ_TYPE.NORMAL then
        prob=g_fight.getAIProp(AI_ATTR.NHATKPRO)
    elseif self.me.roleType == OBJ_TYPE.ELITE then
        prob=g_fight.getAIProp(AI_ATTR.EHATKPRO)
    elseif self.me.roleType == OBJ_TYPE.BOSS then
        prob=g_fight.getAIProp(AI_ATTR.BHATKPRO)
    end
    --远程和精英怪有起身攻击
    -- if self.me.remoteFlag or self.me.isElite or self.me.isBoss then
    if math.random(1,100)<=prob*100 then
        if self.me.roleType == OBJ_TYPE.BOSS then
            self.me.standUpAttack=true
        end
        self:onRecover()
        return
    end
    --取当前攻击的恢复时间
    if self.me.AttackCDTime[self.me.currState] then
        self.AttackCDTime = self.me.AttackCDTime[self.me.currState]
    end
    self:beginBattleCDTime(self.AttackCDTime*0.5+(math.random(-5,5)/10))
end