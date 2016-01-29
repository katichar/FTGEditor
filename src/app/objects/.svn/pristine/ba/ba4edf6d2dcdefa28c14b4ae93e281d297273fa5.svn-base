--
-- Author: rsma
-- Date: 2015-08-06 15:01:15
--
require("app.objects.BaseRole")
require("app.objects.controller.NPCActionController")
require("app.objects.controller.NPCFightController")
BlockObject = class("BlockObject", BaseRole)
function BlockObject:ctor(i_RoleID)
	BlockObject.super.ctor(self,i_RoleID)
	self.name="Block"
	g_fight.aliveman=g_fight.aliveman-1
end
function BlockObject:buildAnimal(i_info)
	self.roleinfo = i_info
    self.roleid=i_info.roleid
    self.roleType=i_info.type
    self.actiontype=i_info.actiontype or ACTION_TYPE.GONGJIA
    self.offSpeed=i_info.speed or 0
    self.isBoss = self.roleType==OBJ_TYPE.BOSS
    self.HP=i_info.hp or 0
    self.MaxHP=self.HP
    self.MP=i_info.mp or 0
    self.def=i_info.def or 0
    self.avoidinjury=i_info.avoidinjury or USER_DEFAULT.AVOIDINJURY
    self.atk=i_info.atk or 0
    i_info.size.raw = i_info.size.raw or 0
    self.size = i_info.size
    self.size.R=0
    self.size.RW=0
    self.size.S = 0
	self.animalObj = display.newSprite(i_info.img)
    self.animalObj:setPosition(0,self.size.h*0.5)
	self:addChild(self.animalObj)
	self.hpbar = require("app.ui.bar.NpcBarUI").new({hp=self.HP})
	self:addChild(self.hpbar)
	self.hpbar:setPosition(0,self.size.h*1.1)
end
function BlockObject:addController()
	self.action = NPCActionController.new(self)
	self.fight  = NPCFightController.new(self)
	self.collider  = ColliderController.new(self,self.group)
end
function BlockObject:setShadow() end
function BlockObject:gotoFightState(i_State)end
function BlockObject:addListener()end
function BlockObject:removeListener()end
function BlockObject:changeAction(PActionName)end
function BlockObject:canBeAttacked(i_tarRole)
	if i_tarRole.collider:checkAttackedRole(self.RID) then
		return false
	end
	if self.tweenState==3008 or self.issafe == true or self.stopForce==true or self.isDead==true then
        return false
    end
	return true
end
function BlockObject:canApplyFroce()
	return true
end
--检查是否浮空受创
function BlockObject:isFlight()
    return false
end
function BlockObject:isAttacking()
    return false
end
function BlockObject:isSkillAttack()
    return false
end
function BlockObject:playslow(i_flag)end
function BlockObject:pauseAction()
    self.isPause=true
end

function BlockObject:resumeAction()
    self.isPause=false
end

function BlockObject:changeDirc(PDirc)
    if self.dirc == PDirc then
        return
    end
    self.dirc = PDirc
end

function BlockObject:dead()
	BlockObject.super.dead(self)
	g_Timer.callAfter(function()
			self.fight:onFinishedDead()
		end,0.1)
end

function BlockObject:cleanSelf(i_DispatchFlag)
	if tolua.isnull(self) then
        return
    end
	BlockObject.super.cleanSelf(self)
end