--
-- Author: rsma
-- Date: 2015-05-15 16:29:45
--
require("app.objects.controller.ActionController")
require("app.objects.controller.FightController")
require("app.objects.controller.ColliderController")
BaseRole = class("BaseRole",g_BaseNode)
BaseRole.RID=1
function BaseRole:ctor(i_RoleID)
    BaseRole.super.ctor(self)
    self.RID=-1
    --初始位置
    self.id=i_RoleID
    self.pos=LPoint(-1, -1)
    self.skills={}
    self.HP=0
    self.MP=0
    self.def=0
    self.atk=0
    self.avoidinjury=USER_DEFAULT.AVOIDINJURY
    self.animalObj=nil
    self.actionName=nil
    self.dirc=DIRC.RIGHT
    self.group = -1
    self.auto=false
    self.size={w=100,h=260,offX=0,offY=120}
    self.ismoving=false  ---是否正在移动
    self.standLine=0     ---玩家站立的地平线值
    self.currState=nil
    self.currStateCount=-1
    self.gotoState=nil
    self.stopAttack=false  --普通 攻击标识
    self.isDead=false
    self.inApplyForce=false--是否正在受力
    self.fightAttr=nil --战斗属性
    self.attackAttr=nil --攻击属性
    self.effects={} --正在执行的特效
    self.currTime = 0
    self.lastTime = 0
    self.attackCount=0--攻击数
    self.hitCount=0--连击次数
    self.tweenState=0
    self.actionHandler={}
    self.attackActions={}
    self.ishit=false--是否命中
    self.isBoss=false
    self.isElite=false
    self.bounceHeight=0
    self.shadow=nil
    self.offSpeed=0
    self.safeTime=10--复活后受保护时间
    self.issafe=false
    self.attackIndex=0
    self.attackShapeIndex=0--攻击核
    self.demage={}
    self.attackPower={} --攻击动作权值
    self.attackHandler={} --动作判断方法
    self.actionProp={} --攻击动作属性
    self.starSkill=false
    self.istoryman=g_fight.istory
    self.stopForce=false
    self.deadFlag=false
    self.skillEF={}--所有技能特效
    self.remoteFlag=false --远程类标识
    self.nextState=nil--下一个战斗
    self.AttackCDTime={}
    self.fleeFlag=false --逃离标识
    self.fleeOffset=0 --逃离偏移量
    self.fleeProbability=0 --逃离机率
    self.skinScale=1
    self.pickupequips={}--捡起的装备
    self.standupFlag=false
    self.standUpAttack=false--起身攻击中
end
function BaseRole:init()
    self.RID = BaseRole.RID
    BaseRole.RID = BaseRole.RID + 1
    self.speffect=display.newSprite()
    self.speffect:align(display.CENTER, 0, 120)
    self:addChild(self.speffect,1000)
    self.isPause=false
    self:addController()
    self:addActionHandler()
    self:gotoFightState(FIGHT_STATE.idle)
    self:addListener()
    self:setShadow()
end
function BaseRole:setShadow()
  if not self.shadow then
    self.shadow = display.newSprite("roles/shadow.png")
    self:addChild(self.shadow,-1)
  end
end
function BaseRole:addController()
    self.action = ActionController.new(self)
    self.fight  = FightController.new(self)
    self.collider   = ColliderController.new(self,self.group)
end

function BaseRole:addActionHandler()
    -- self.actionHandler[ROLE_ACTION.hurt]=handler(self.fight,self.fight.onFinishedHurt)
    self.actionHandler[ROLE_ACTION.dead]=handler(self.fight,self.fight.onFinishedDead)
    self.actionHandler["fengyi"]=function()
        g_EventManager.dispatch(MESSAGE_EVENT.ROLE_THROW_CLOTHES)
    end
end

function BaseRole:onActionHandler(i_ActionName,event)
    if self.actionHandler[i_ActionName] then
        self.actionHandler[i_ActionName](i_ActionName)
    end
end
--获得伤害特效位置
function BaseRole:getHurtPos(i_name)
    local cfg = HURT_POS[i_name]
    local tx=0
    local ty=0
    if cfg then
        tx = cfg.x or (self.size.w*cfg.offX)
        ty = cfg.y or (self.size.h*cfg.offY)
    end
    return tx,ty
end
---设置技能信息
function BaseRole:setSkillInfo(i_SkillInfo)
    self.skills={}
    if i_SkillInfo then
        for _,sobj in pairs(i_SkillInfo) do
            if sobj.sn>0 then
                self.skills['skill' .. sobj.skillid]=sobj
            end
        end
    end
end
function BaseRole:addListener()
    self.animalObj:registerAnimationEventHandler(handler(self,self.onMovementEvent))
    self.animalObj:registerFrameEventHandler(handler(self,self.onFrameEvent))
end
function BaseRole:removeListener()
    self.animalObj:unregisterAnimationEventHandler()
    self.animalObj:unregisterFrameEventHandler()
end
--换肤
function BaseRole:updateSkin(i_skinId,i_armature,i_scale)
    if i_skinId and i_skinId>0 and g_Skin[i_armature] then
        display.addSpriteFrames("roles/skins/"..i_armature.."_" ..i_skinId..".plist","roles/skins/"..i_armature.."_" ..i_skinId..".png")
        local boneObj;
        for _,boneName in pairs(g_Skin[i_armature]) do
            boneObj = self.animalObj:getArmature():getSlot(boneName)
            -- print(boneName,"roles/skins/"..i_armature.."_" ..i_skinId..".plist")
            if boneObj then
                -- local img = cc.SpriteWithHue:create("#"..boneName .."_".. i_skinId ..".png")
                local img = display.newSprite("#"..boneName .."_".. i_skinId ..".png")
                if img then
                    local cds = boneObj:getCCDisplay()
                    -- print(boneName,"#"..boneName .."_".. i_skinId ..".png")
                    img:retain()
                    img:setAnchorPoint(cds:getAnchorPoint())
                    boneObj:setDisplayImage(img,true)
                end
                -- local img = display.newSprite("roles/skin/"..i_armature.."/".. boneName .."_".. i_skinId ..".png")
            end
        end
    end
    self.animalObj:setScale(i_scale or 1)
end
function BaseRole:buildAnimal(i_info)
    self.roleinfo = i_info
    self.roleid=i_info.roleid
    self.roleType=i_info.type or OBJ_TYPE.NORMAL
    self.actiontype=i_info.actiontype or ACTION_TYPE.GONGJIA
    self.offSpeed=i_info.speed or 0
    self.isBoss = self.roleType==OBJ_TYPE.BOSS
    self.isElite = self.roleType==OBJ_TYPE.ELITE
    self.HP=i_info.hp or 0
    self.MaxHP=self.HP
    self.MP=i_info.mp or 0
    self.def=i_info.def or 0
    self.avoidinjury=i_info.avoidinjury or USER_DEFAULT.AVOIDINJURY
    self.atk=i_info.atk or 0
    local bonePath = i_info.animalData.bone
    local texturePath = i_info.animalData.texture
    local armature = i_info.animalData.armature
    local factory = db.DBCCFactory:getInstance()
    self.size = i_info.size
    self.size.R=0 --圆形攻击范围
    self.size.S=0 --扇形攻击范围
    self.size.RW=0 --直线攻击范围
    self.remote=nil
    self.fleeProbability = i_info.PFlee or 0
    if i_info.remote then
        self.remote={}
        self.size.R = i_info.remote.r or 0
        if self.size.R>0 and self.size.R<1 then
            self.size.R = self.size.R * display.width
        end
        self.size.S = i_info.remote.s or 0
        if self.size.S>0 and self.size.S<1 then
            self.size.S = self.size.S * display.width
        end
        self.size.RW = i_info.remote.w or 0
        if self.size.RW>0 and self.size.RW<1 then
            self.size.RW = self.size.RW * display.width
        end
        local num=0
        if i_info.remote.atk1 then
            self.attackHandler[FIGHT_STATE.attack1]=i_info.remote.atk1.handler
            self.attackPower[ROLE_ACTION.attack1]=i_info.remote.atk1.AP or -1
            self.AttackCDTime[FIGHT_STATE.attack1]=i_info.remote.atk1.CD or 0
            self.remote[FIGHT_STATE.attack1]={1,i_info.remote.atk1.P*100,i_info.remote.atk1.T}
            num=i_info.remote.atk1.P*100
        end
        if i_info.remote.atk2 then
            self.attackHandler[i_info.remote.atk2.Alias or FIGHT_STATE.attack2]=i_info.remote.atk2.handler
            self.attackPower[ROLE_ACTION.attack2]=i_info.remote.atk2.AP or -1
            self.AttackCDTime[i_info.remote.atk2.Alias or FIGHT_STATE.attack2]=i_info.remote.atk2.CD or 0
            self.remote[i_info.remote.atk2.Alias or FIGHT_STATE.attack2]={num+1,num+i_info.remote.atk2.P*100,i_info.remote.atk2.T,}
            num=num+i_info.remote.atk2.P*100
        end
        if i_info.remote.atk3 then
            self.attackHandler[i_info.remote.atk3.Alias or FIGHT_STATE.attack3]=i_info.remote.atk3.handler
            self.attackPower[ROLE_ACTION.attack3]=i_info.remote.atk3.AP or -1
            self.AttackCDTime[i_info.remote.atk3.Alias or FIGHT_STATE.attack3]=i_info.remote.atk3.CD or 0
            self.remote[i_info.remote.atk3.Alias or FIGHT_STATE.attack3]={num+1,num+i_info.remote.atk3.P*100,i_info.remote.atk3.T,}
            num=num+i_info.remote.atk3.P*100
        end
        if i_info.remote.atk4 then
            self.attackHandler[i_info.remote.atk4.Alias or FIGHT_STATE.attack4]=i_info.remote.atk4.handler
            self.attackPower[ROLE_ACTION.attack4]=i_info.remote.atk4.AP or -1
            self.AttackCDTime[i_info.remote.atk4.Alias or FIGHT_STATE.attack4]=i_info.remote.atk4.CD or 0
            self.remote[i_info.remote.atk4.Alias or FIGHT_STATE.attack4]={num+1,num+i_info.remote.atk4.P*100,i_info.remote.atk4.T,}
            num=num+i_info.remote.atk4.P*100
        end
        if i_info.remote.atk5 then
            self.attackHandler[i_info.remote.atk5.Alias or FIGHT_STATE.attack5]=i_info.remote.atk5.handler
            self.attackPower[ROLE_ACTION.attack5]=i_info.remote.atk5.AP or -1
            self.AttackCDTime[i_info.remote.atk5.Alias or FIGHT_STATE.attack5]=i_info.remote.atk5.CD or 0
            self.remote[i_info.remote.atk5.Alias or FIGHT_STATE.attack5]={num+1,num+i_info.remote.atk5.P*100,i_info.remote.atk5.T,}
            num=num+i_info.remote.atk5.P*100
        end
        if i_info.remote.atk then
            self.attackHandler[FIGHT_STATE.attack]=i_info.remote.atk.handler
            self.attackPower[ROLE_ACTION.attack]=i_info.remote.atk.AP or -1
            self.AttackCDTime[FIGHT_STATE.attack]=i_info.remote.atk.CD or 0
            self.remote[FIGHT_STATE.attack]={0,i_info.remote.atk.P*100,i_info.remote.atk.T}
        end
    else
        self.attackPower[ROLE_ACTION.attack]=i_info.AP or -1
        self.AttackCDTime[FIGHT_STATE.attack]=i_info.CD or 0
    end
    self.remoteFlag = (self.size.R>0 or self.size.RW>0 or self.size.S>0)
    if i_info.scale then
        self.size.w = self.size.w * i_info.scale
        self.size.h = self.size.h * i_info.scale
        self.size.offX = self.size.offX * i_info.scale
        self.size.offY = self.size.offY * i_info.scale
        self.size.hw = self.size.hw * i_info.scale
    end
    self.skinScale=i_info.scale or 1
    factory:loadDragonBonesData(bonePath, armature);
    factory:loadTextureAtlas(texturePath, armature);
    self.animalObj = factory:buildArmatureNode(armature) --DBCCArmatureNode
    self:addChild(self.animalObj)
    self:updateSkin(i_info.animalData.skinId,armature,i_info.scale)
end

--添加生命及精神
function BaseRole:addHealth(i_HP,i_MP)
    if self.HP then
        self.HP = self.HP + checknumber(i_HP)
    end
    if self.MP then
        self.MP = self.MP + checknumber(i_MP)
    end
end

--根据类型随机获得攻击动作名称
function BaseRole:getAttackName(i_ByType)
    if self.remoteFlag then
        local temp={}
        for rname,robj in pairs(self.remote) do
            if i_ByType == robj[3] then
                table.insert(temp, rname)
            end
        end
        return temp[math.random(1,#temp)]
    elseif #self.attackActions>0 then
        if self.remote then
            local radom = math.random(1,100)
            for rname,robj in pairs(self.remote) do
                if radom>=robj[1] and radom <= robj[2] then
                    return rname
                end
            end
        end
        return self.attackActions[math.random(1,#self.attackActions)]
    end
    return FIGHT_STATE.attack
end

function BaseRole:cleanSelf()
    -- print("BaseRole:cleanSelf",self.RID,self.name,"State=",self.currState,"Action=",self.actionName)
    if tolua.isnull(self) then
        return
    end
    -- if g_fight.battleState == FIGHT_STATUS.VICTORY and self.name=="NPC" and (self.currState ~= "dead" or self.actionName ~= "siwang") then
    --     print("clean self logic error->BaseRole:cleanSelf",self.RID,self.name,"State=",self.currState,"Action=",self.actionName)
    -- end
    self:removeListener()
    self.fight:destroy()
    self.collider:destroy()
    self.action:destroy()
    -- table.remove(g_RoleManager.allRole,table.indexof(g_RoleManager.allRole, self, 1))
    table.removebyvalue(g_RoleManager.allRole, self)
    self.action=nil
    self.fight=nil
    self.collider= nil
    self.shadow=nil
    self:removeSelf()
    self=nil
end

function BaseRole:onMovementEvent(event)
    self:onActionHandler(event.animationName,event)
end
function BaseRole:onFrameEvent( event)
    local actionName = event.animationName
    local frameEvent = event.frameLabel
    self.collider:removeAttackShape()
    local prop=nil
    -- if iskindof(self, "NPCObject") then
    --     print("actionName=",actionName,"frameEvent=",frameEvent,"self.currState=",self.currState,"self.actiontype=",self.actiontype)
    -- end
    if ACTION_SHAPE[self.currState] and ACTION_SHAPE[self.currState][actionName] and ACTION_SHAPE[self.currState][actionName][frameEvent] then
        prop = ACTION_SHAPE[self.currState][actionName][frameEvent]
    elseif ACTION_SHAPE[actionName] and ACTION_SHAPE[actionName][self.actiontype] and ACTION_SHAPE[actionName][self.actiontype][frameEvent] then
        prop = ACTION_SHAPE[actionName][self.actiontype][frameEvent]
    elseif ACTION_SHAPE[actionName] and ACTION_SHAPE[actionName][frameEvent] then
        prop = ACTION_SHAPE[actionName][frameEvent]
    end
    if prop then
        self.attackShapeIndex=self.attackShapeIndex+1
        -- print(actionName,frameEvent)
        if prop.shape.delEF and not tolua.isnull(self.skillEF[prop.shape.delEF]) then
            self:removeChild(self.skillEF[prop.shape.delEF], true)
            self.skillEF[prop.shape.delEF]=nil
        end
        if prop.shape.addEF and self.skillEF[prop.shape.addEF]==nil then
            self.skillEF[prop.shape.addEF] = g_fight.effect.skill(prop.shape.addEF,self.dirc)
            if self.skillEF[prop.shape.addEF] then
                self:addChild(self.skillEF[prop.shape.addEF])
            end
        end
        self.collider:updateAttackShape(prop.shape)
        g_fight.bindFightAttribute(self,prop)
        local attHandler = g_fight.buildEffectHandler(self:getAttackAttribute())
        if attHandler then
            attHandler(self)
        end
        if prop.sound and prop.sound.attack then
            if prop.sound.attack then
                audio.playSound("sounds/"..prop.sound.attack,false)
            end
        end
    else
        -- print("No configuration shape","onFrameEvent::","ActionName=",actionName,"EventName=",frameEvent)
    end
    if frameEvent == g_VPauseAction then
        self:pauseAction()
    end
end
--获取当前动作权重值
function BaseRole:getAttackPower()
    if (CURR_GAME_MODE == GAME_MODE.NORMAL or self.standUpAttack==true) and self.name=="NPC" and self:isFighting() and self.standupFlag==true then
        self.standupFlag=false
        self.standUpAttack=false
        local ap = self.attackPower[self.actionName]
        if ap and ap<=5 then
            return 6
        end
    end
    -- print(self.name,self.RID,self.actionName,"getAttackPower",self.attackPower[self.actionName])
    return self.attackPower[self.actionName] or -1
end
function BaseRole:changeAction(PActionName)
    if self.actionName == PActionName then
        return
    end
    -- if iskindof(self, "NPCObject") then
    --     print(self.actionName,">>>>>",PActionName,"dirc=",self.dirc)
    -- end
    self.actionName = PActionName
    if self:isFighting() then
        self:playActionSound("attack")
    elseif self.actionName == ROLE_ACTION.dead then
        self:playActionSound()
    end
    if self.actionProp[self.actionName] and self.actionProp[self.actionName].remPos then
        self.actionProp[self.actionName].remPos = clone(g_RoleManager.player.pos)
    end
    self.attackShapeIndex=0
    self.animalObj:getAnimation():gotoAndPlay(self.actionName)
    if not self.shadow then
        return
    end
    if self.actionName==ROLE_ACTION.hurtVFly1 or
       self.actionName==ROLE_ACTION.hurtBounceUp1 or
       self.actionName==ROLE_ACTION.hurtBounceUp2 or
       self.actionName==ROLE_ACTION.hurtBounceUp3 or
       self.actionName==ROLE_ACTION.hurtBounceUp4 then
        self.shadow:setVisible(false)
    else
        self.shadow:setVisible(true)
    end
end
function BaseRole:playslow(i_flag)
    i_flag = i_flag or false
    self.animalObj:getAnimation():setTimeScale( i_flag==true and 0.1 or 1)
    for _,tobj in pairs(self.action.tweens) do
        local tweenObj = tobj[1]
        if tweenObj.isvalid == true then
            tweenObj:doslow(i_flag)
        end
    end
end
function BaseRole:pauseAction()
    self.isPause=true
    self.animalObj:getAnimation():stop()
end

function BaseRole:resumeAction()
    self.isPause=false
    self.animalObj:getAnimation():play()
end

function BaseRole:changeDirc(PDirc)
    if self.dirc == PDirc then
        return
    end
    self.dirc = PDirc
    self.animalObj:setScaleX(self.dirc)
end
function BaseRole:checkColliderValid(i_TargetRole,i_Dist)
    if i_TargetRole and i_Dist then
        return math.abs(self.standLine - i_TargetRole.standLine) <= i_Dist
    end
    if i_TargetRole then
        return math.abs(self.standLine - i_TargetRole.standLine) <= MAX_VALID_ATTACK_DIST
    end
    return false
end

--计算伤害值(公式)
--self.attackShapeIndex 攻击资数
--local obj = self.demage[self.currState]
function BaseRole:getDemage()
    if g_fight.istory == true then
        return 1000000
    end
    local dobj = self.demage[self.actionName]--攻击配置信息
    local per=nil--当前攻击核所占有总伤害百分比
    if dobj and dobj[self.attackShapeIndex] then
        per=dobj[self.attackShapeIndex]
    end
    --per = per or 1
    if self.currState == FIGHT_STATE.attack or self.currState == FIGHT_STATE.attack1 or self.currState == FIGHT_STATE.attack2 then
        return self.atk*(per or 1)
    end
    if self.name == "NPC" then
        return self.atk*(per or 1)
    end
    local skill = self.skills[self.currState]
    if skill then
        return skill.atk*(per or 0.05)
    end
    return 0
end

function BaseRole:getDefence()
    return self.avoidinjury
end
---开始碰撞
function BaseRole:beginCollision(i_myShape,i_targetShape)
end
function BaseRole:playActionSound(i_type)
    local soundname = self.action:getSoundName(self.actionName,i_type)
    if soundname then
        return audio.playSound("sounds/"..soundname,false)
    end
    return nil
end
--结束碰撞
function BaseRole:endCollision(i_myShape,i_targetShape)

end

function BaseRole:removeShape()
    self.collider:removeAttackShape()
end
--检查是否浮空受创
function BaseRole:isFlight()
    return self.actionName==ROLE_ACTION.hurtVFly1 or
        self.actionName==ROLE_ACTION.hurtBounceUp1 or
        self.actionName==ROLE_ACTION.hurtBounceUp2 or
        self.actionName==ROLE_ACTION.hurtBounceUp3 or
        self.actionName==ROLE_ACTION.hurtBounceUp4 or
        self.actionName==ROLE_ACTION.hurtFallDown
end
function BaseRole:isAttacking()
    return string.match(self.actionName, "gongji")~=nil
end
function BaseRole:isSkillAttack()
    return self.currState == FIGHT_STATE.skill1 or
        self.currState == FIGHT_STATE.skill2 or
        self.currState == FIGHT_STATE.skill3 or
        self.currState == FIGHT_STATE.skill4 or
        self.currState == FIGHT_STATE.skill5 or
        self.currState == FIGHT_STATE.skill6 or
        self.currState == FIGHT_STATE.skill7 or
        self.currState == FIGHT_STATE.skill8 or
        self.currState == FIGHT_STATE.skill9 or
        self.currState == FIGHT_STATE.skill10 or
        self.currState == FIGHT_STATE.skill11 or
        self.currState == FIGHT_STATE.skill12
end
function BaseRole:isFighting()
    return self:isAttacking() or self:isSkillAttack()
end
--------fight action----------
function BaseRole:gotoFightState(i_State)
    local codeid = self.action:doEvent(i_State)
    if codeid == 1 then
        self.currState = i_State
        -- if self.name == "Role" then
        --     print("gotoFightState->",i_State,",move=",self.move,self.fight.remoteAttack)
        -- end
        if self.move~=0 then
            -- if self.fight.remoteAttack == true then
            if self.move == -999 then
                self.fight.remoteattacking=true
                local dissNum=0
                local worldPos = g_Map.getScreenPos(self.pos.x,self.pos.y)
                local myPos = self.pos
                local tarPos = g_RoleManager.player.pos
                local angle = math.atan2(myPos.y-tarPos.y, myPos.x-tarPos.x)
                local maxMY=0
                local disMax=self.dirc==DIRC.LEFT and worldPos.x or display.width-worldPos.x
                local maxMX=disMax
                local dirY=1
                if math.abs(myPos.y-tarPos.y)<=30 then
                    maxMY=0
                elseif myPos.y>=tarPos.y then
                    maxMY=myPos.y
                    dirY=-1
                    maxMX = maxMY/math.tan(angle)
                else
                     maxMY=g_Map.getMapTop()-myPos.y
                     maxMX = maxMY/math.tan(angle)
                end
                maxMX = math.abs(maxMX)
                if maxMX> disMax then
                    maxMX=math.abs(disMax)
                end
                if maxMY==0 then
                    dissNum = maxMX
                else
                    dissNum=math.abs(maxMY/math.sin(angle))
                end
                local delayTime = math.abs(maxMX)/(MOVE_SPEED.NEAR_SPEED*3)
                -- print("maxMX=",maxMX,"maxMY=",maxMY,"dissNum=",dissNum,math.sqrt(maxMX*maxMX+maxMY*maxMY),delayTime)
                self.temptweens ={
                        TweenObject.Spawn({
                                TweenObject.MoveTo("x",delayTime,maxMX*self.dirc),
                                TweenObject.MoveTo("y",delayTime,maxMY*dirY),
                            }),
                        TweenObject.CallFunc(function()
                            self.fight.remoteattacking=false
                            self.fight:onFinishedAttack("")
                        end)
                    }
                self.action:runTweens(self.temptweens)
                return
            end
            -----
            local move=self.move
            local igColldeFlag = 0 --缺省不忽略撞击
            if self.actionProp[self.actionName] then
                igColldeFlag = checknumber(self.actionProp[self.actionName].IgCollde)
            end
            -- print("actionName=",self.actionName,"igColldeFlag=",igColldeFlag)
            local delayTime = self.move==1 and 5 or 10
            if move == -1 then
                move=0
                delayTime=0.01
            elseif self.fight.canAttack and igColldeFlag==0 then
                move=1
                delayTime=0.1
            end
            -- print(">>>temptweens",move,delayTime)
            self.temptweens ={
                    TweenObject.MoveTo("x",delayTime,move*self.dirc),
                    TweenObject.CallFunc(function()
                        -- print("<<<temptweens",move,delayTime)
                        if self.gotoState then
                            self:gotoFightState(self.gotoState)
                        end
                    end)
                }
            self.action:runTweens(self.temptweens)
        end
    end
    return codeid==1
end
function BaseRole:stand()
    self.action.targetPos=nil
    self.action:updateSpeed(0,0)
    self:gotoFightState(FIGHT_STATE.stand)
end
function BaseRole:throwClothes()
    self.action:updateSpeed(0,0)
    self:changeAction("fengyi")
end
function BaseRole:run()
    return self:gotoFightState(FIGHT_STATE.run)
end
function BaseRole:attack()
    if self.nextState then
        self:gotoFightState(self.nextState)
        return
    end
    if #self.attackActions>0 then
        self:gotoFightState(self.attackActions[math.random(1,#self.attackActions)])
        return
    end
    self:gotoFightState(FIGHT_STATE.attack)
end

function BaseRole:skill(i_SkillID)
    if iskindof(self, "RoleObject") and self:checkDead()==false and (self.tweenState==1001 or self.tweenState==0) then
        self:stand()
    end
    if self.action.fsm_:canDoEvent("skill" .. i_SkillID) then
        g_fight.cleanTargetAllEffects(self)
    end
    local res = self:gotoFightState("skill" .. i_SkillID)
    if res==true then
        self.starSkill = true
        self.attackIndex=0
    end
    return res
end
function BaseRole:canApplyFroce()
    return true
end
function BaseRole:hurt(i_FightAttr)
    -- i_FightAttr = clone(i_FightAttr)
    if self:checkDead() == true and self.inApplyForce==false then
        print("BaseRole->hurt logic error!!!")
        self:dead()
        return
    end
    g_fight.effect.showHP(self,i_FightAttr.damage,i_FightAttr.critFlag)
    if self.name=="Role" then
        g_EventManager.dispatch(MESSAGE_EVENT.ROLE_BAR_CHANGE,{hp=i_FightAttr.damage*-1})
    else
        if self.hpbar then
            self.hpbar:changeBar({hp=i_FightAttr.damage*-1})
        end
    end
    if self.istoryman==false and self.HP>0 and self.HP - i_FightAttr.damage<=0 and iskindof(self, "NPCObject") then
        g_fight.aliveman=g_fight.aliveman-1
    end
    self.HP = self.HP - i_FightAttr.damage
    if self.name=="Role" then
        g_EventManager.dispatch(MESSAGE_EVENT.FIGHT_SCORE,GAME_SCORE.ATTACK)
    end
    if i_FightAttr.attackAP <=i_FightAttr.hurtAP and self.HP>0 then
        -- print(self.name,"111attackAP=",i_FightAttr.attackAP,"hurtAP=",i_FightAttr.hurtAP)
         self:playFightEffect(i_FightAttr.hurtEFName)
        return
    end
    if self:canApplyFroce()==false and self.HP>0 then
        self:playFightEffect(i_FightAttr.hurtEFName)
        return
    end
    if self.name=="Block" then
        if i_FightAttr.effect ~="hurtBack" then
            i_FightAttr.effect="blockDieOut"
            i_FightAttr.fx=200
            self.isDead=(self.HP<=0)
        else
            i_FightAttr.fx=10
            i_FightAttr.fy=0
        end
    elseif self.HP<=0 and g_fight.checkGameOver(self) then
        g_fight.gameOver=true
        g_fight.doPlaySlow()
        -- print(self.RID,"-->PlaySlow-->",i_FightAttr.effect)
        -- if i_FightAttr.effect == "hurtBack" or i_FightAttr.effect == "hurtBounceUp" then
        if self.pos.y-self.standLine <=100  then
            i_FightAttr.effect="hurtBounceOff"
            i_FightAttr.fx=150
            i_FightAttr.fy=120
            i_FightAttr.action="hurtBack2"
        end
    elseif self.HP<=0 and self.name=="Role" then
        g_fight.gameOver=true
        if i_FightAttr.effect == "hurtBack" or i_FightAttr.effect == "hurtBounceUp" then
            self:changeDirc(i_FightAttr.dirc == DIRC.LEFT and DIRC.RIGHT or DIRC.LEFT)
            i_FightAttr.effect="hurtBounceOff"
            i_FightAttr.fx=100
            i_FightAttr.fy=60
            i_FightAttr.action="hurtBack2"
        end
    elseif self.name=="Role" and i_FightAttr.effect == "hurtBounceOff" then
        self:changeDirc(i_FightAttr.dirc == DIRC.LEFT and DIRC.RIGHT or DIRC.LEFT)
    end
    self.fight:cleanBattleTID()
    self.fight:cleanAwaitTID()
    local effhandler = g_fight.buildEffectHandler(i_FightAttr)
    if effhandler then
        if self.name=="NPC" or self.name=="Block" then
            self.action:faceHuntTarget()
        end
        self.attackIndex=0
        self.inApplyForce = true
        self.action.targetPos=nil
        self.action:updateSpeed(0,0)
        if i_FightAttr.action and i_FightAttr:checkActionPause() == false then
            if self.tweenState==1001 then
                self:gotoFightState(i_FightAttr.action)
            end
            self:playFightEffect(i_FightAttr.hurtEFName)
        end
        effhandler(self)
    end
end

function BaseRole:dead()
    self.animalObj:setColor(cc.c3b(255, 255, 255))
    transition.stopTarget(self.animalObj)
    g_fight.actionManager:removeAllActionsFromTarget(self.animalObj)
    self.isDead=true
    self.fight.canAttack=false
    self.deadFlag=true
    self:gotoFightState(FIGHT_STATE.dead)
end

function BaseRole:relive()
    self.isDead=false
    self.inApplyForce=false
    self.HP=self.MaxHP
    self.fight.canAttack=false
    self:gotoFightState(FIGHT_STATE.standup)
    self.issafe=true
    local actions = {
        cc.FadeTo:create(0.3, 150),
        cc.FadeTo:create(0.3, 255),
        cc.FadeTo:create(0.3, 150),
        cc.FadeTo:create(0.3, 255),
        cc.FadeTo:create(0.3, 150),
        cc.FadeTo:create(0.3, 255),
        cc.FadeTo:create(0.3, 150),
        cc.FadeTo:create(0.3, 255),
        cc.CallFunc:create(function()
                if not tolua.isnull(self) then
                    self.issafe=false
                end
            end)
    }
    self.animalObj:runAction(transition.sequence(actions))
end

function BaseRole:pushEffect(i_EFName,i_forceObj,i_tweens)
    local effect = {name=i_EFName,forceObj=i_forceObj,tweens=i_tweens}
    table.insert(self.effects, effect)
    return effect
end

function BaseRole:checkDead()
    return (self.isDead==true or self.HP<=0)
end

function BaseRole:getFightAttribute()
    return self.fightAttr
end
function BaseRole:getAttackAttribute()
    if self.attackAttr then
        local remPosName=nil
        if self.actionProp[self.actionName] then
            remPosName = self.actionProp[self.actionName].remPosName
        end
        if remPosName and self.actionProp[remPosName] and self.actionProp[remPosName].remPos then
            self.attackAttr.remPos = self.actionProp[remPosName].remPos
        end
    end
    return self.attackAttr
end
function BaseRole:setFightAttribute(i_fightAttr)
    self.fightAttr = i_fightAttr
end

function BaseRole:setAttackAttribute(i_fightAttr)
    self.attackAttr = i_fightAttr
end
function BaseRole:playFightEffect(i_effectName)
    if not i_effectName then
        return
    end
    local i_PosX,i_PosY = self:getHurtPos(self.currState)
    local animation = g_fight.effect.hurt(i_effectName)
    if animation and not tolua.isnull(animation) then
        self.speffect:setVisible(true)
        self.speffect:align(display.CENTER, i_PosX*self.dirc,i_PosY)
        self.speffect:playAnimationOnce(animation,false,function()
            self.speffect:setVisible(false)
        end)
    end
    -- local particle = cc.ParticleSystemQuad:create("effects/effects_hurt.plist")
    -- particle:align(display.CENTER, i_PosX*self.dirc,i_PosY)
    -- self:addChild(particle)
end

function BaseRole:render(dt)
    dt = dt or 0
    if dt == 0 then return end
    self.currTime = self.currTime + dt
    if self.currTime - self.lastTime < g_fight.FPS then
        return
    end
    self.lastTime =self.currTime

    if self.isPause == true then
        return
    end
    self.action:render(dt)
    self:renderPos()
end

--当对象被加入舞台
function BaseRole:onEnter()
    if self.action then
        self.action:onEnter()
    end
end

--设置对象世界坐标
function BaseRole:setPos(i_x,i_y)
    self.pos.x=i_x
    self.pos.y=i_y
end

--返回对象世界坐标
function BaseRole:getPos()
    return self.pos.x, self.pos.y
end

function BaseRole:getPosX()
    return self.pos.x
end

function BaseRole:getPosY()
    return self.pos.y
end

-- 渲染人物坐标
function BaseRole:renderPos()
    if self.inApplyForce==false then
        self.standLine = self.pos.y
        self:checkStandLine()
    end
    self:setPosition(self:getPos())
    self:setLocalZOrder(g_Map.getMapZorderY()-self.pos.y)
end
function BaseRole:checkStandLine()
    if self.standLine < 0 then
        -- print(self.name,"checkStandLine->standLine<0",self.standLine)
        self.standLine=5
        self.pos.y=self.standLine
    elseif self.standLine > g_Map.getMapTop() then
        -- print(self.name,"checkStandLine->standLine>Top",self.standLine)
        self.standLine = g_Map.getMapTop()-5
        self.pos.y=self.standLine
    end
end
function BaseRole:addSkill(i_SkillID)
    local skillStates = SKILL_ACTION_CONFIG[i_SkillID]
    if skillStates then
        for _,state in pairs(skillStates) do
            self.demage[state.to] = state.demage
            if state.handler then
                self.actionHandler[state.to]=handler(self.fight,self.fight[state.handler])
            end
        end
    end
    self.action:addSkill(i_SkillID)
end
function BaseRole:updateSkillConfig()
    self.action:updateSkillConfig()
end

function BaseRole:showEquip(i_Equip)
    i_Equip:setVisible(true)
    i_Equip:setOpacity(0)
    local size = i_Equip:getContentSize()
    table.insert(self.pickupequips, i_Equip)
    i_Equip:align(display.BOTTOM_CENTER, 0, self.size.h+20+size.height*(#self.pickupequips-2))
    i_Equip:addTo(self,1000)
    local pos=cc.p(0,self.size.h+20+size.height*(#self.pickupequips-1))
    local showSeq=transition.sequence({
            cc.Spawn:create({
                    cc.MoveTo:create(0.6,pos),
                    cc.FadeTo:create(0.4,255),
                }),
            cc.CallFunc:create(function()
                i_Equip.status=1
                self:checkEquips(i_Equip)
                end),
            cc.DelayTime:create(5),
            cc.FadeTo:create(0.6,0),
            cc.CallFunc:create(function()
                    table.removebyvalue(self.pickupequips, i_Equip)
                    i_Equip:removeSelf()
                    self:checkEquips()
                end),
        })
    i_Equip:runAction(showSeq)
end

function BaseRole:checkEquips(i_Equip)
    if not tolua.isnull(i_Equip) then
        local i = table.indexof(self.pickupequips, i_Equip, 1)
        local size = i_Equip:getContentSize()
        local pos=cc.p(0,self.size.h+20+size.height*(i-1))
        local seq = transition.sequence({
                cc.MoveTo:create(0.3,pos),
            })
        i_Equip:runAction(seq)
        return
    end
    local size=self.size
        for i=1,#self.pickupequips,1 do
            local item = self.pickupequips[i]
            if item.status and item.status==1 then
                local size = item:getContentSize()
                local pos=cc.p(0,self.size.h+20+size.height*(i-1))
                local seq = transition.sequence({
                        cc.MoveTo:create(0.3,pos),
                    })
                item:runAction(seq)
            end
        end
end