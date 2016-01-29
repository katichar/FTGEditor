--
-- Author: rsma
-- Date: 2015-05-18 15:14:21
--
require("app.objects.BaseRole")
require("app.objects.controller.NPCActionController")
require("app.objects.controller.NPCFightController")

NPCObject = class("NPCObject", BaseRole)
function NPCObject:ctor(i_RoleID)
	NPCObject.super.ctor(self,i_RoleID)
	self.name="NPC"
end
function NPCObject:attack()
	self.fight:cleanBattleTID()
    self.fight:cleanAwaitTID()
	NPCObject.super.attack(self)
end
function NPCObject:skill(i_SkillID)
	self.fight:cleanBattleTID()
    self.fight:cleanAwaitTID()
    return NPCObject.super.skill(self,i_SkillID)
end
function NPCObject:init()
	self.group = g_engine.NPC_GROUP
	NPCObject.super.init(self)
	if g_fight.istory==false then
		if self.isBoss == true then
			self.hpbar = require("app.ui.bar.BossBarUI").new(self.roleinfo)
			g_LayerManager:addMainUI(self.hpbar)
		else
			self.hpbar = require("app.ui.bar.NpcBarUI").new({hp=self.HP})
			self:addChild(self.hpbar)
			self.hpbar:setPosition(0,self.size.h*1.1)
		end
	end
end
function NPCObject:addController()
	self.action = NPCActionController.new(self)
	self.fight  = NPCFightController.new(self)
	self.collider  = ColliderController.new(self,self.group)
end
function NPCObject:addActionHandler()
	NPCObject.super.addActionHandler(self)
	local actions = ACTION_TYPE_CONFIG[self.actiontype]
	local addflag=true
	if actions then
		for _,act in pairs(actions) do
			addflag=true
			act.isRemoteAttack = act.isRemoteAttack or false
			for  _,tat in pairs(self.attackActions) do
				if tat == act.name then
					addflag = false
				end
			end
			if act.name == 'run' or act.name == 'attack' or act.name == 'standup' or act.name == 'dead' then
				addflag = false
			end
			if addflag==true and act.isRemoteAttack==false then
				table.insert(self.attackActions, act.name)
			end
			if act.handler then
				self.actionHandler[act.to]=handler(self.fight,self.fight[act.handler])
			end
			if act.isRemoteAttack then
				self.action.remoteAttackAction=act.name
			end
		end
	end
end
---开始碰撞
function NPCObject:beginCollision(i_myShape,i_targetShape)
	if (self:checkDead()==true and self.inApplyForce==false) or g_fight.istory == true then
		return
	end
	-- print("beginCollision",self.RID,g_engine.getShapeType(i_myShape),g_engine.getShapeType(i_targetShape))
	if g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Attack and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hurt then
		local targetRole = g_engine.getRoleByShape(i_targetShape)
		if targetRole==nil or targetRole:canBeAttacked(self) == false then
			-- print("NPCObject:beginCollision return")
			return
		end
		local myRole = g_engine.getRoleByShape(i_myShape)
		local fightAttr = myRole:getFightAttribute()
        if not fightAttr then
        	-- print("NPCObject->fightAttr is null")
            return
        end
		if self:checkColliderValid(targetRole,fightAttr.attackDist) == false then
			-- print("NPCObject->checkColliderValid == false")
            return
        end
        fightAttr = clone(fightAttr)
        fightAttr.attackAP=self:getAttackPower()
        fightAttr.hurtAP=targetRole:getAttackPower()
        if fightAttr.attackAP < fightAttr.hurtAP and targetRole:isSkillAttack()==true then
        	return --//修改原因背后无法攻击到正在出招的玩家
        end
        self.collider:attackedRole(targetRole.RID)
        local basedamage = myRole:getDemage()*targetRole:getDefence()
        if basedamage < 100 then
            math.newrandomseed()
            fightAttr.damage=math.floor(math.random(basedamage*0.8,basedamage*1.2))
        elseif basedamage < 300 then
            math.newrandomseed()
            fightAttr.damage=math.floor(math.random(basedamage*0.9,basedamage*1.05))
        else
            math.newrandomseed()
            fightAttr.damage=math.floor(math.random(basedamage*0.95,basedamage*1.05))
        end

        if fightAttr.damage<=0 then
            fightAttr.damage=1
        end
        local pauseAction = fightAttr.action
        if fightAttr.action2 and targetRole.currState == fightAttr.action then
            pauseAction = fightAttr.action2
        end
        fightAttr.dirc=self.dirc
        -- print("NPCbeginCollision->pauseAction", pauseAction)
        if fightAttr.attackAP > fightAttr.hurtAP then
        	targetRole:gotoFightState(pauseAction)
        end
        targetRole:playFightEffect(fightAttr.hurtEFName)
        targetRole:hurt(fightAttr)
	elseif  g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Hunt and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hunt then
		self.fight.canAttack = true
	elseif  g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Remote and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hunt then
		self.fight.remoteAttack = true
		-- print("attacking=",self:isAttacking(),"inapplyforce=",self.inApplyForce,"remoteattacking=",self.fight.remoteattacking,"recoverTID=",self.fight.recoverTID,"fleeFlag=",self.fleeFlag)
		-- 碰撞相交部分非常少时，如果攻击对方，如果前后抖动，会再次发生碰撞
		if self:isFighting() or self.inApplyForce or self.fight.remoteattacking or self.fight.recoverTID>0 or self.fleeFlag==true then
			return
		end
		g_fight.beginFight(self,g_engine.getRoleByShape(i_targetShape))
	end
end

--结束碰撞
function NPCObject:endCollision(i_myShape,i_targetShape)
	-- print("endCollision",self.RID,g_engine.getShapeType(i_myShape),g_engine.getShapeType(i_targetShape))
	if g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Hunt and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hunt then
		self.fight.canAttack = false
		-- self.nextState=nil
	end
	if g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Remote and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hunt then
		self.fight.remoteAttack = false
		self.nextState=nil
	end
end
function NPCObject:canBeAttacked(i_tarRole)
	if i_tarRole.collider:checkAttackedRole(self.RID) then
		-- print("checkAttackedRole->true")
		return false
	end
	if i_tarRole and i_tarRole:isSkillAttack() then
		return true
	end
	if self.tweenState==3008 or self.issafe == true or self.stopForce==true or self.isDead==true then
		-- print("NPCObject->tweenState=",self.tweenState, ",issafe=",self.issafe, ",stopForce=",self.stopForce, ",isDead=",self.isDead)
        return false
    end
	return true
end
function NPCObject:canApplyFroce()
	if self.fight.remoteattacking==true and self.HP>0 then
		return false
	end
	return true
end

function NPCObject:cleanSelf(i_isRole)
    if tolua.isnull(self) then
        return
    end
    g_EventManager.dispatch(MESSAGE_EVENT.OBJECT_DEAD,{isRole=false,type=self.roleType})
    --移除Boss血条
    if self.isBoss == true and not tolua.isnull(self.hpbar) then
		self.hpbar:removeSelf()
		self.hpbar=nil
	end
    NPCObject.super.cleanSelf(self,i_isRole)
end
--一招死
function NPCObject:getKilled()
	self:stand()
	self.fight:cleanBattleTID()
    self.fight:cleanAwaitTID()
    g_fight.effect.showHP(self,self.HP*-1)
    if self.hpbar then
        self.hpbar:changeBar({hp=self.HP*-1})
    end
	self.HP=0
	local i_FightAttr = FightAttribute.new({effect="hurtBounceOff", fx=150, fy=120,action="hurtBack2"})
	local effhandler = g_fight.buildEffectHandler(i_FightAttr)
	self.inApplyForce = true
	effhandler(self,function()
			-- self.inApplyForce = false
		end)
end