--
-- Author: rsma
-- Date: 2015-05-22 14:51:51
--
require("app.objects.BaseRole")
require("app.objects.controller.RoleActionController")
require("app.objects.controller.RoleFightController")
RoleObject = class("RoleObject", BaseRole)
function RoleObject:ctor(i_RoleID)
	RoleObject.super.ctor(self,i_RoleID)
	self.name="Role"
    self.pauseRoles={}
end
function RoleObject:init()
	self.group = g_engine.ROLE_GROUP
	RoleObject.super.init(self)
end
---开始碰撞
function RoleObject:beginCollision(i_myShape,i_targetShape)
    if self.actionName==ROLE_ACTION.xianjie and g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Hurt and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hurt then
        local targetRole = g_engine.getRoleByShape(i_targetShape)
        -- local self = g_engine.getRoleByShape(i_myShape)
        if self:checkColliderValid(targetRole) == false then
            return
        end
        table.removebyvalue(self.action.tweens,self.temptweens)
        self.temptweens=nil
        self:pauseAction()
        targetRole:pauseAction()
        targetRole.action.targetPos=nil
        targetRole.action:updateSpeed(0,0)
        targetRole:changeAction("A_attack_back2")
        table.insert(self.pauseRoles, targetRole)
        if self.skillTweenObj then
            return
        end
        self.skillTweenObj = transition.sequence({
            cc.DelayTime:create(GAME_FPS*10),
            cc.CallFunc:create(function()
                self:resumeAction()
                for _,robj in pairs(self.pauseRoles) do
                    robj:resumeAction()
                    robj:stand()
                end
                self.pauseRoles={}
                self:gotoFightState(self.currState)
                self.skillTweenObj=nil
            end),nil
        })
        self:runAction(self.skillTweenObj)
        return
    end
    if  g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Hunt and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hunt then
    -- self.action:huntTarget(g_engine.getRoleByShape(i_targetShape))
        self.fight.canAttack = true
    elseif g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Attack and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hurt then
        local targetRole = g_engine.getRoleByShape(i_targetShape)
        if targetRole==nil or targetRole:canBeAttacked(self)==false then
            -- print("RoleObject:beginCollision return 111")
            return
        end
        local fightAttr = self:getFightAttribute()
        if not fightAttr then
            -- print("RoleObject fightAttr is null")
            return
        end
        if self:checkColliderValid(targetRole,fightAttr.attackDist) == false then
            -- print("RoleObject checkColliderValid is false")
            return
        end
        fightAttr = clone(fightAttr)
        fightAttr.attackAP=self:getAttackPower()
        fightAttr.hurtAP=targetRole:getAttackPower()
        self.collider:attackedRole(targetRole.RID)

        ------------------- 计算伤害---开始-----------------------------
        local basedamage = self:getDemage()*targetRole:getDefence()
        if basedamage < 100 then
            math.newrandomseed()
            fightAttr.damage=math.random(basedamage*0.8,basedamage*1.2)
        elseif basedamage < 300 then
            math.newrandomseed()
            fightAttr.damage=math.random(basedamage*0.9,basedamage*1.05)
        else
            math.newrandomseed()
            fightAttr.damage=math.random(basedamage*0.95,basedamage*1.05)
        end
        --如果是暴击
        if self:isCrit() then
            fightAttr.damage=fightAttr.damage*(self.roleinfo.critdamage*0.01)
            fightAttr.critFlag=true
            g_fight.effect.criticalTip()
        end
        -- 伤害取整
        fightAttr.damage=math.floor(fightAttr.damage)
        if fightAttr.damage<=0 then
            fightAttr.damage=1
        end
        ------------------- 计算伤害---结束-----------------------------

        if self:isFighting() then
            if self.ishit==false then
                self.ishit=true
            end
            self.hitCount = self.hitCount + 1
            if g_fight.maxCombo<self.hitCount then
                g_fight.maxCombo = self.hitCount
            end
            g_fight.effect.hitTip(self.hitCount,function()
                    if self.hitCount>10 then
                        g_fight.comboScore=g_fight.comboScore+(self.hitCount-10)
                    end
                    self.hitCount=0
                    g_fight.effect.hitTip(self.hitCount)
                end)
            if fightAttr.sound then
                audio.playSound("sounds/"..fightAttr.sound,false)
            else
                self:playActionSound("hit")
            end
        end
        if fightAttr and fightAttr:checkActionPause() == true then
            local pauseAction = fightAttr.action
            if fightAttr.action2 and targetRole.currState == fightAttr.action then
                pauseAction = fightAttr.action2
            end
            if fightAttr.attackAP > fightAttr.hurtAP then
                --受创前如果有其它攻击前动作则先停止
                if targetRole.temptweens then
                    -- print("role attack remove npc tweens")
                    targetRole:stand()
                    table.removebyvalue(targetRole.action.tweens,targetRole.temptweens)
                    targetRole.temptweens=nil
                end
                if targetRole.fight.remoteattacking==true then
                    targetRole.fight.remoteattacking=false
                end
            end
            -- print("RolebeginCollision->pauseAction", pauseAction,"attackAP=",fightAttr.attackAP,"hurtAP=", fightAttr.hurtAP)
            if fightAttr.attackAP > fightAttr.hurtAP then
                self:pauseAction()
                targetRole:gotoFightState(pauseAction)
                targetRole:playFightEffect(fightAttr.hurtEFName)
                targetRole:pauseAction()
                local sequence = transition.sequence({
                    cc.DelayTime:create(GAME_FPS*fightAttr.pauseFrame),
                    cc.CallFunc:create(function()
                        targetRole:hurt(fightAttr)
                        self:resumeAction()
                        targetRole:resumeAction()
                    end),nil
                })
                self:runAction(sequence)
            elseif fightAttr.attackAP == fightAttr.hurtAP then
                -- print("RolebeginCollision-->return")
                targetRole:playFightEffect(fightAttr.hurtEFName)
                targetRole:hurt(fightAttr)
            end
            -- targetRole:gotoFightState(pauseAction)
        else
            -- print("RolebeginCollision->no-pauseAction")
            if fightAttr.attackAP >= fightAttr.hurtAP then
                targetRole:playFightEffect(fightAttr.hurtEFName)
                targetRole:hurt(fightAttr)
            end
        end
    end
end
--结束碰撞
function RoleObject:endCollision(i_myShape,i_targetShape)
    -- print("endCollision",self.RID,g_engine.getShapeType(i_myShape),g_engine.getShapeType(i_targetShape))
    if g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Hunt and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hunt then
        self.fight.canAttack = false
    end
end
function RoleObject:addController()
	self.action = RoleActionController.new(self)
	self.fight  = RoleFightController.new(self)
	self.collider  = ColliderController.new(self,self.group)
end
function RoleObject:run()
	local res = RoleObject.super.run(self)
	if res then
		self.action:resetSpeed()
	end
    return res
end
function RoleObject:addActionHandler()
	RoleObject.super.addActionHandler(self)
	self.actionHandler[ROLE_ACTION.attack1]=handler(self.fight,self.fight.onFinishedAttack)
	self.actionHandler[ROLE_ACTION.attack2]=handler(self.fight,self.fight.onFinishedAttack)
	self.actionHandler[ROLE_ACTION.attack3]=handler(self.fight,self.fight.onFinishedAttack)
	self.actionHandler[ROLE_ACTION.attack4]=handler(self.fight,self.fight.onFinishedAttack)
	self.actionHandler[ROLE_ACTION.standup]=handler(self,self.onStandup)
	if self.skills then
        for _,sobj in pairs(self.skills) do
            self:addSkill(sobj.skillid)
        end
    end
end
function RoleObject:onStandup()
	self:gotoFightState(FIGHT_STATE.stand)
end
--检查能否被攻击
function RoleObject:canBeAttacked(i_tarRole)
    if self.tweenState==3008 or self.issafe == true or self.isDead==true or i_tarRole.collider:checkAttackedRole(self.RID) then
        -- print("RoleObject->tweenState=",self.tweenState,",issafe=",self.issafe,",isDead=",self.isDead,",checkAttackedRole=",i_tarRole.collider:checkAttackedRole(self.RID))
        return false
    end
    if i_tarRole.fight.remoteattacking == true and self:isFlight()==true then
        -- print("RoleObject->remoteattacking=",i_tarRole.fight.remoteattacking,"isFlight,=",self:isFlight())
        return false
    end
    -- print("starSkill=",self.starSkill,"currState=",self.currState,"RoleObject:canBeAttacked()",true)
    return true
end
--检查能否受力影响
function RoleObject:canApplyFroce()
	-- if self:isFighting() and self.HP>0 then
	-- 	return false
	-- end
	return true
end

-- 渲染人物坐标
function RoleObject:renderPos()
   	if self.inApplyForce==false then
        self.standLine = self:getPosY()
        self:checkStandLine()
    end
    self:setLocalZOrder(g_Map.getMapZorderY()-self.pos.y)

    self:setPositionX(self.pos.x+self.action.speedX)
    self:setPositionY(self.pos.y+self.action.speedY)
end

function RoleObject:cleanSelf(i_flag)
	-- print("RoleObject:cleanSelf()",i_flag)
	if not i_flag then
		g_EventManager.dispatch(MESSAGE_EVENT.OBJECT_DEAD,{isRole=true,type=self.roleType})
        return
	end
    RoleObject.super.cleanSelf(self)
end

--是否暴击
function RoleObject:isCrit()
    math.newrandomseed()
    local crit = math.random(0,100)
    if crit <= self.roleinfo.critchance then
        return true 
    else 
        return false
    end
end

-- 仅仅移除自己，不发现死亡通知
function RoleObject:deleteSelf()
    RoleObject.super.cleanSelf(self,false)
end