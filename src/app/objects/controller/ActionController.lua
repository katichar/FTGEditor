--
-- Author: rsma
-- Date: 2015-05-16 18:22:58
--
require("app.fight.TweenObject")
ActionController = class("ActionController")

function ActionController:ctor(PRole)
    self.renderFlag=false
    self.me=PRole
    self.currTime=0 --currTime current move render time
    self.lastTime=0 --lastTime current move render time
    self.speedX=0
    self.speedY=0
    self.lastSpeedX=0
    self.lastSpeedY=0
    self.targetPos=nil
    self.sound={}
    self:initStateMachine()
    self.FX=0
    self.FY=0
    self.tweens={}
    self.rd=0
    self.attackSites={
        -- [1]={id=1,dirc=-1,offX=-10,offY=-30,rid=0}, [2]={id=2,dirc=-1,offX=-10,offY=-30,rid=0},
        -- [3]={id=3,dirc=-1,offX=-10,offY=-30,rid=0}, [4]={id=5,dirc=-1,offX=-10,offY=-30,rid=0},
        -- [5]={id=4,dirc=-1,offX=-10,offY=-30,rid=0}, [6]={id=6,dirc=-1,offX=-10,offY=-30,rid=0},

        [1]={id=1,dirc=1,offX=  5,offY=  0,rid=0}, [2]={id=2,dirc=-1,offX=  0,offY=  5,rid=0},
        [3]={id=3,dirc=1,offX=-10,offY=-30,rid=0}, [4]={id=5,dirc=-1,offX=-10,offY= 30,rid=0},
        [5]={id=4,dirc=1,offX=-10,offY= 30,rid=0}, [6]={id=6,dirc=-1,offX=-10,offY=-30,rid=0},
    }
    self.remoteAttackAction=nil
end
--开始执行Tweens
function ActionController:runTweens(i_Tweens)
    for _,tobj in pairs(i_Tweens) do
        if tobj == nil then
            table.removebyvalue(i_Tweens,tobj)
        else
             tobj.target=self.me
        end
    end
    table.insert(self.tweens, i_Tweens)
end
--检查正在执行的特效
function ActionController:checkApplyTween(dt)
    self.FX=0
    self.FY=0
    for _,tobj in pairs(self.tweens) do
        local tweenObj = tobj[1]
        if tweenObj.isvalid == true then
            tweenObj:update(dt)
        end
        if tweenObj.isvalid == false then
            table.removebyvalue(tobj,tweenObj)
        end
        if #tobj == 0 then
            table.removebyvalue(self.tweens,tobj)
        end
    end
    if #self.tweens == 0 and self.me.inApplyForce==true then
        -- print("----All Tween finished")
        self.me.inApplyForce = false
        self.me.fight:onFinishedHurt("")
    end
end
-- the event transitioned successfully from one state to another
-- StateMachine.SUCCEEDED = 1
-- the event was successfull but no state transition was necessary
-- StateMachine.NOTRANSITION = 2
-- the event was cancelled by the caller in a beforeEvent callback
-- StateMachine.CANCELLED = 3
-- the event is asynchronous and the caller is in control of when the transition occurs
-- StateMachine.PENDING = 4
-- the event was failure
-- StateMachine.FAILURE = 5
function ActionController:doEvent(event)
    if self.fsm_:canDoEvent(event) then
        local codeid = self.fsm_:doEvent(event)
        -- if codeid == 2 then
            -- printLog("doEvent","resule " .. event .. " no transition")
        -- end
        -- if codeid~=1 then
        --     printLog("doEvent","resule " .. event .. " no transition")
        -- end
        return codeid
    else
        -- print("can not do event ",event)
        return -1
    end
end

--当操作对象进入舞台
function ActionController:onEnter()
end

--初始化状态机机制
function ActionController:initStateMachine()
    self.fsm_ = {}
    cc.GameObject.extend(self.fsm_)
        :addComponent("components.behavior.StateMachine")
        :exportMethods()

    self.callbacks = {
        onidle        = handler(self,self.stateHandler),
        onrun         = handler(self,self.stateHandler),
        onstand       = handler(self,self.stateHandler),
        onstandup     = handler(self,self.stateHandler),
        onattack      = handler(self,self.stateHandler),
        onattack1     = handler(self,self.stateHandler),
        onattack2     = handler(self,self.stateHandler),
        onattack3     = handler(self,self.stateHandler),
        onattack4     = handler(self,self.stateHandler),
        onattack5     = handler(self,self.stateHandler),
        onhurtBack1   = handler(self,self.stateHandler),
        onhurtBack2   = handler(self,self.stateHandler),
        onskill1      = handler(self,self.stateHandler),
        onskill2      = handler(self,self.stateHandler),
        onskill3      = handler(self,self.stateHandler),
        onskill4      = handler(self,self.stateHandler),
        onskill5      = handler(self,self.stateHandler),
        onskill6      = handler(self,self.stateHandler),
        onskill7      = handler(self,self.stateHandler),
        onskill8      = handler(self,self.stateHandler),
        onskill9      = handler(self,self.stateHandler),
        onskill10     = handler(self,self.stateHandler),
        onskill11     = handler(self,self.stateHandler),
        onskill12     = handler(self,self.stateHandler),
        ondead        = handler(self,self.stateHandler),
        onhurtBounceUp1   = handler(self,self.stateHandler),
        onhurtBounceUp2   = handler(self,self.stateHandler),
        onhurtBounceUp3   = handler(self,self.stateHandler),
        onhurtBounceUp4   = handler(self,self.stateHandler),
        onhurtFallDown   = handler(self,self.stateHandler),
        onhurtVFly1   = handler(self,self.stateHandler),
    --onchangestate = function(event) print("[FSM] CHANGED STATE: " .. event.from .. " to " .. event.to) end,
    }
    self:updateStateMachine()
end
function ActionController:updateStateMachine()
    self.events ={
        {name = "idle",   from = "none",    to = ROLE_ACTION.stand},
        {name = "stand",   from = "*",       to = ROLE_ACTION.stand  },
        {name = "hurtBack1",   from = {ROLE_ACTION.stand,ROLE_ACTION.run,ROLE_ACTION.walk,ROLE_ACTION.hurtBack2,ROLE_ACTION.attack,ROLE_ACTION.attack1,ROLE_ACTION.attack2,ROLE_ACTION.attack3,ROLE_ACTION.attack4}, to = ROLE_ACTION.hurtBack1 },
        {name = "hurtBack2",   from = {ROLE_ACTION.stand,ROLE_ACTION.run,ROLE_ACTION.walk,ROLE_ACTION.hurtBack1,ROLE_ACTION.attack,ROLE_ACTION.attack1,ROLE_ACTION.attack2,ROLE_ACTION.attack3,ROLE_ACTION.attack4}, to = ROLE_ACTION.hurtBack2 },
        {name = "hurtBounceUp1",   from = "*", to = ROLE_ACTION.hurtBounceUp1 },
        {name = "hurtBounceUp2",   from = "*", to = ROLE_ACTION.hurtBounceUp2 },
        {name = "hurtBounceUp3",   from = "*", to = ROLE_ACTION.hurtBounceUp3 },
        {name = "hurtBounceUp4",   from = "*", to = ROLE_ACTION.hurtBounceUp4 },
        {name = "hurtFallDown",   from = "*", to = ROLE_ACTION.hurtFallDown },
        {name = "hurtVFly1",   from = "*", to = ROLE_ACTION.hurtVFly1 },
        -- {name = "dead",   from = "*", to = ROLE_ACTION.dead },
    }
    self:updateSkillConfig()
end
function ActionController:loadBattleState()
    local attacks = ACTION_TYPE_CONFIG[self.me.actiontype]
    if attacks then
        for _,atk in pairs(attacks) do
            table.insert(self.events, atk)
            self.sound[atk.to]=atk.sound
             if atk.sound then
                if atk.sound.attack then
                    audio.preloadSound("sounds/" .. atk.sound.attack)
                end
                if atk.sound.hit then
                    audio.preloadSound("sounds/" .. atk.sound.hit)
                end
            end
            self.me.demage[atk.to] = atk.demage
            if atk.remPos or atk.remPosName or atk.IgCollde then
                if self.me.actionProp[atk.to] == nil then
                    self.me.actionProp[atk.to]={}
                end
                self.me.actionProp[atk.to].remPos = atk.remPos
                self.me.actionProp[atk.to].remPosName = atk.remPosName
                self.me.actionProp[atk.to].IgCollde = atk.IgCollde
            end
            if not self.me.attackPower[atk.to] or self.me.attackPower[atk.to]==-1 then
                self.me.attackPower[atk.to] = atk.ap or 0
            end
        end
    end
    if self.me.skills then
        for _,sobj in pairs(self.me.skills) do
            self:addSkill(sobj.skillid)
        end
    end
end
function ActionController:addSkill(i_SkillID)
    local skillStates = SKILL_ACTION_CONFIG[i_SkillID]
    if skillStates then
        for _,state in pairs(skillStates) do
            table.insert(self.events, state)
            self.sound[state.to]=state.sound
            if state.sound then
                if state.sound.attack then
                    audio.preloadSound("sounds/" .. state.sound.attack)
                end
                if state.sound.hit then
                    audio.preloadSound("sounds/" .. state.sound.hit)
                end
            end
            if state.remPos or state.remPosName or state.IgCollde then
                if self.me.actionProp[state.to] == nil then
                    self.me.actionProp[state.to]={}
                end
                self.me.actionProp[state.to].remPos = state.remPos
                self.me.actionProp[state.to].remPosName = state.remPosName
                self.me.actionProp[state.to].IgCollde = state.IgCollde
            end
            if not self.me.attackPower[state.to] or self.me.attackPower[state.to]==-1 then
                self.me.attackPower[state.to] = state.ap or 0
            end
        end
    end
end
function ActionController:updateSkillConfig()
    self:loadBattleState()
    self.fsm_:setupState({events=self.events,callbacks=self.callbacks})
end
function ActionController:getSoundName(i_ActName,i_type)
    if self.sound[i_ActName] == nil then
        return nil
    end
    if type(self.sound[i_ActName]) == "table" then
        return self.sound[i_ActName][i_type]
    end
    return self.sound[i_ActName]
end
function ActionController:stateHandler(event)
    -- if iskindof(self.me, "RoleObject") then
    --     print(self.me.name,"stateHandler",",to=",event.to,",move=",event.move,",gotoState=",event.gotoState)
    -- end
    self.me.move=event.move or 0
    self.me.currStateCount = event.count or -1
    self.me.gotoState = event.gotoState
    self.me:changeAction(event.to)
end

function ActionController:huntTarget(i_Role,i_Req)
    if self.me:checkDead() == true then
        return
    end
    if tolua.isnull(i_Role) then
        self.huntObj=nil
        return
    end
    self.huntObj = i_Role
    self.attackSite = self.huntObj.action:getAttackSite(self.me,i_Req)
    if not self.attackSite then
        self.me.fight:await()
        return
    end
    self:moveTo(g_fight.AI.calcHuntPos(self.me))
    if self.me.remoteFlag==false then
        self.attackSite.rid=self.me.RID
    else
        self.attackSite=nil
    end
end
function ActionController:resetAttackSite()
    self:huntTarget(self.huntObj)
end
function ActionController:isInAttackSite()
    if not self.attackSite then
        return false
    end
    if tolua.isnull(self.huntObj) then
        return false
    end
    local tPosX,tPosY = g_fight.AI.calcHuntPos(self.me)
    if self.me.pos.x == tPosX and self.me.pos.y == tPosY then
        return true
    end
    return false
end
--周围可站立区
function ActionController:getAttackSite(i_Role,i_Req)
    local site=nil
    i_Req = i_Req or false
    --如果远程攻击类，则自由攻击
    if i_Role.remoteFlag and i_Req==false then
        return nil
    end
    for i=1,6 do
        local obj = self.attackSites[i]
        if obj.rid == i_Role.RID then
            site = obj
        end
    end
    if site then
        site.rid=0
    end
    local firIdxs=nil
    if self.me.pos.x < i_Role.pos.x then
        firIdxs = {1,3,5}
    else
        firIdxs = {2,4,6}
    end
    for _,idobj in pairs(firIdxs) do
        local obj = self.attackSites[idobj]
        if obj.rid==0 and self:checkSiteValid(obj,i_Role)==true then
            return obj
        end
    end
    if i_Role.remoteFlag and i_Req==true then
        return self.attackSites[firIdxs[math.random(1,3)]]
    end
    site = nil
    for i=1,6 do
        local obj = self.attackSites[i]
        if obj.rid==0 and self:checkSiteValid(obj,i_Role)==true then
            return obj
        end
    end
    return nil
end
function ActionController:checkSiteValid(i_Site,i_TRole)
    local tPosX,tPosY = self.me:getPos()
    tPosX = tPosX+(i_TRole.size.hw*0.5+self.me.size.hw*0.4+i_Site.offX)*i_Site.dirc
    tPosY=tPosY+i_Site.offY
    if tPosX > g_LayerManager.mapinfo.roleright or tPosX < g_LayerManager.mapinfo.roleleft then
        -- print(i_Site.id,"is invalid!!!")
        return false
    end
    if tPosY < g_LayerManager.mapinfo.rolebottom  or tPosY > g_LayerManager.mapinfo.roletop then
        -- print(i_Site.id,"is invalid!!!")
        return false
    end
    return true
end
function ActionController:faceHuntTarget()
    local dissX=nil
    if self.huntObj and not tolua.isnull(self.huntObj) then
        dissX = self.me.pos.x - self.huntObj.pos.x
        if math.abs(dissX) <=30 then
            return
        end
    elseif self.targetPos then
        dissX = self.me.pos.x - self.targetPos.x
    elseif g_RoleManager.player and not tolua.isnull(g_RoleManager.player) then
        dissX = self.me.pos.x - g_RoleManager.player.pos.x
    end
    self:updateFace(dissX)
end
function ActionController:updateFace(dissX)
    if dissX then
        if dissX>=0 then
            self.me:changeDirc(DIRC.LEFT)
        else
            self.me:changeDirc(DIRC.RIGHT)
        end
    end
end
function ActionController:moveTo(i_x,i_y)
    self.targetPos=nil
    if self.me.pos.y>=i_y then
        self.rd=-1
    else
        self.rd=1
    end
    self.targetPos = LPoint(i_x,i_y)
    self.me:run()
end

function ActionController:checkTargetPos()

end

function ActionController:moveRrender(dt)
    self:checkApplyTween(dt)
end
function ActionController:onMoveStep()
    local spx = self.speedX
    local spy = self.speedY
    if self.me:isFighting() == true then
        spx=0
        spy=0
    end
    local run_x = self.me.pos.x + spx + self.FX
    local run_y = self.me.pos.y + spy + self.FY

    if self.me.inApplyForce == false then
        if run_y < 0  or run_y > g_Map.getMapTop() then
            run_y = self.me.pos.y
        end
    else
        if run_x>g_Map.getMapRight() and self.me.dirc == DIRC.LEFT then
            run_x = g_Map.getMapRight()
        elseif run_x<g_Map.getMapLeft() and self.me.dirc == DIRC.RIGHT then
            run_x = g_Map.getMapLeft()
        end
    end
    self.me:setPos(run_x,run_y)
end

function ActionController:updateSpeed(SX,SY)
    self.speedX=SX
    self.speedY=SY
    if SX ~= 0 then
        self.me:changeDirc(SX<0 and DIRC.LEFT or DIRC.RIGHT )
    end
end

function ActionController:setSpeed(SX,SY)
    self.lastSpeedX=SX
    self.lastSpeedY=SY
    if self.me:isFighting()==false then
        self:updateSpeed(SX,SY)
    end
end
function ActionController:resetSpeed()
    self:updateSpeed(self.lastSpeedX,self.lastSpeedY)
end
function ActionController:render(dt)
    self:moveRrender(dt)
end

function ActionController:destroy()
    self:pauseAction()
    self.fsm_=nil
    if self.attackSite then
        self.attackSite.rid=0
    end
end

function ActionController:pauseAction()
    if self.me:checkDead()==true then
        self.targetPos=nil
        self:updateSpeed(0,0)
        return
    end
    self.me:stand()
end