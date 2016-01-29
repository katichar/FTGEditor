--
-- Author: rsma
-- Date: 2015-06-09 10:52:35
--
local actions = {}
local downFrames=9
local stopForceH=100
actions.fps=1/24
--打击时推进
function actions.forward(i_ForceObj)
    local sequence={
        TweenObject.MoveTo("x",i_ForceObj.fightAttr.frames,-i_ForceObj.fightAttr.fx*i_ForceObj.rotate),
        TweenObject.CallFunc(function()
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end)
    }
    return sequence
end
function actions.moveToPlayer(i_ForceObj)
    local frames = i_ForceObj.fightAttr.frames
    local tarPos = cc.p(0,0)--g_RoleManager.player.pos
    if i_ForceObj.fightAttr.remPos then
        tarPos = i_ForceObj.fightAttr.remPos
    end
    local mypos = i_ForceObj.forcedObj.pos
    i_ForceObj.forcedObj.abc=1
    i_ForceObj.forcedObj.action:updateFace(mypos.x-tarPos.x)
    local sequence={
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj.fight.remoteattacking=true
        end),
        TweenObject.Spawn({
                TweenObject.MoveTo("x",frames,tarPos.x-mypos.x+60*i_ForceObj.rotate),
                TweenObject.MoveTo("y",frames,tarPos.y-mypos.y),
            }),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj.fight.remoteattacking=false
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end)
    }
    return sequence
end
--震地效果
function actions.groundShake(i_ForceObj)
    if tolua.isnull(i_ForceObj.fightAttr.target)  then
        return {}
    end
    local posX,posY = i_ForceObj.fightAttr.target:getPosition()
    local actInt1 = transition.newEasing(cc.MoveTo:create(actions.fps*2, cc.p(posX, posY-15)), "OUT",3,1)
    local actInt2 = transition.newEasing(cc.MoveTo:create(actions.fps*2, cc.p(posX, posY)), "OUT",3,1)
    local actInt3 = cc.CallFunc:create(function()
            i_ForceObj.fightAttr.target:setPosition(posX,posY)
        end)
    local sequence={actInt1,actInt2,actInt3}
    return sequence
end
function actions.hurtFallDown(i_ForceObj)
    local dissX=i_ForceObj.fightAttr.fx
    local dissY=i_ForceObj.fightAttr.fy
    -- print("hurtFallDown->tweenState",i_ForceObj.forcedObj.tweenState)
    local sequence={
        TweenObject.Spawn({
                TweenObject.CallFunc(function()
                    local sequence = transition.sequence({
                            cc.CallFunc:create(function()
                                    i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp3)
                                    i_ForceObj.forcedObj.tweenState=3001
                                end),
                            cc.DelayTime:create(0.03*4),
                            cc.CallFunc:create(function()
                                    i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp4)
                                    i_ForceObj.forcedObj.tweenState=3002
                                end),
                            cc.DelayTime:create(0.03*2),
                        })
                    i_ForceObj.forcedObj:runAction(sequence)
                end),
                TweenObject.MoveTo("x",downFrames,(dissX*0.5)*i_ForceObj.rotate),
                -- TweenObject.EaseIn("y",15,-dissY-50),
                TweenObject.EaseIn("y",downFrames,nil,i_ForceObj.forcedObj.standLine,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            }),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtFallDown)
            i_ForceObj.forcedObj.tweenState=3005
            if g_fight.isplayslow==true then
                g_fight.undoPlaySlow()
            end
        end),
        TweenObject.DelayTime(3),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtVFly1)
            i_ForceObj.forcedObj.tweenState=3006
        end),
        TweenObject.Spawn({
                TweenObject.EaseOut("x",5,dissX*0.25*i_ForceObj.rotate),
                TweenObject.EaseOut("y",5,nil,g_fight.bd.bounceHeight(0.375)),
            }),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtFallDown)
            i_ForceObj.forcedObj.tweenState=3007
        end),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj.tweenState=3008
        end),
        TweenObject.Spawn({
            TweenObject.EaseOut("x",4,dissX*0.25*i_ForceObj.rotate),
            TweenObject.BounceOut("y",4,nil,i_ForceObj.forcedObj.standLine,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
        }),
        TweenObject.DelayTime(18),
        TweenObject.CallFunc(function()
            if i_ForceObj.forcedObj:checkDead() == false then
                i_ForceObj.forcedObj.standupFlag=true
                i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.standup)
            end
        end),
        TweenObject.CallFunc(function()
            -- print("hurtFallDown finished")
            i_ForceObj.forcedObj.tweenState=0
            i_ForceObj.forcedObj:setRotation(0)
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end),
    }
    return sequence
end
--被打时向外弹开
function actions.hurtBounceOff(i_ForceObj)
    local dissX=i_ForceObj.fightAttr.fx
    local dissY=i_ForceObj.fightAttr.fy
    local dissf=0
    if COMBO_ENABLE==true and i_ForceObj.forcedObj.bounceHeight>=stopForceH then
        --逼到墙角时弹开
        local run_x=i_ForceObj.forcedObj:getPosX()+dissX*i_ForceObj.rotate
        if run_x>g_Map.getMapRight() or run_x<g_Map.getMapLeft() then
            dissX=dissX*-1
        end
    end
    -- print("hurtBounceOff-->tweenState",i_ForceObj.forcedObj.tweenState)
    local actInt0 =TweenObject.DelayTime(1)
    local actInt1 = TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp1)
            i_ForceObj.forcedObj.tweenState=2001
        end)
    local actInt2 = TweenObject.Spawn({
                -- TweenObject.RotateTo(6,20),
                TweenObject.MoveTo("x",6,dissX*i_ForceObj.rotate),
                TweenObject.EaseOut("y",6,dissY,nil,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.tweenState=2002
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            })
    local actInt3 = TweenObject.CallFunc(function()
            -- i_ForceObj.forcedObj.pos.x = i_ForceObj.forcedObj.pos.x + i_ForceObj.forcedObj.size.ActOffX*i_ForceObj.rotate
            -- i_ForceObj.forcedObj.pos.y = i_ForceObj.forcedObj.pos.y + i_ForceObj.forcedObj.size.ActOffY
            i_ForceObj.forcedObj:setRotation(0)
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp2)
            i_ForceObj.forcedObj.tweenState=2003
        end)
    if i_ForceObj.forcedObj.tweenState>1001 then
        actInt0 =TweenObject.DelayTime(3)
        actInt1 = TweenObject.CallFunc(function()
            -- i_ForceObj.forcedObj.pos.x = i_ForceObj.forcedObj.pos.x + i_ForceObj.forcedObj.size.ActOffX*i_ForceObj.rotate
            -- i_ForceObj.forcedObj.pos.y = i_ForceObj.forcedObj.pos.y + i_ForceObj.forcedObj.size.ActOffY
            i_ForceObj.forcedObj:setRotation(0)
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp3)
            i_ForceObj.forcedObj.tweenState=2101
        end)
        actInt2 = TweenObject.Spawn({
                -- TweenObject.Shake("x",12,20*i_ForceObj.rotate),
                TweenObject.MoveTo("x",6,dissX*i_ForceObj.rotate),--6
                TweenObject.EaseIn("y",5,dissY,nil,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.tweenState=2102
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            })
        actInt3=TweenObject.CallFunc(function()
            i_ForceObj.forcedObj.tweenState=2103
        end)
    end
    local sequence={
        actInt0,
        actInt1,
        actInt2,
        actInt3,
        TweenObject.Spawn({
                TweenObject.CallFunc(function()
                    local sequence = transition.sequence({
                            cc.CallFunc:create(function()
                                    i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp3)
                                end),
                            cc.DelayTime:create(0.03*4),
                            cc.CallFunc:create(function()
                                    i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp4)
                                end),
                            cc.DelayTime:create(0.03*2),
                        })
                    i_ForceObj.forcedObj:runAction(sequence)
                end),
                TweenObject.MoveTo("x",downFrames,(dissX*0.5)*i_ForceObj.rotate),
                -- TweenObject.EaseIn("y",15,-dissY-50),
                TweenObject.EaseIn("y",downFrames,nil,i_ForceObj.forcedObj.standLine,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            }),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtFallDown)
            i_ForceObj.forcedObj.tweenState=2004
            if g_fight.isplayslow==true then
                g_fight.undoPlaySlow()
            end
        end),
        TweenObject.DelayTime(3),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtVFly1)
            i_ForceObj.forcedObj.tweenState=2005
        end),
        TweenObject.Spawn({
                TweenObject.EaseOut("x",4,dissX*0.25*i_ForceObj.rotate),
                TweenObject.EaseOut("y",4,nil,g_fight.bd.bounceHeight(0.375),function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            }),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtFallDown)
            i_ForceObj.forcedObj.tweenState=2006
        end),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj.tweenState=3008
        end),
        TweenObject.Spawn({
            TweenObject.EaseOut("x",9,dissX*0.25*i_ForceObj.rotate),
            TweenObject.BounceOut("y",9,nil,i_ForceObj.forcedObj.standLine,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
        }),
        TweenObject.DelayTime(17),
        TweenObject.CallFunc(function()
            if i_ForceObj.forcedObj:checkDead() == false then
                i_ForceObj.forcedObj.standupFlag=true
                i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.standup)
            end
        end),
        TweenObject.CallFunc(function()
            -- print("hurtBounceOff finished")
            i_ForceObj.forcedObj.tweenState=0
            i_ForceObj.forcedObj:setRotation(0)
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end),
    }
    return sequence
end
--重击打倒在地
function actions.hartDown(i_ForceObj)
    local dissX=i_ForceObj.fightAttr.fx
    local dissY=i_ForceObj.fightAttr.fy
    local frames = i_ForceObj.fightAttr.frames
    local sequence={
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtFallDown)
        end),
        TweenObject.Shake("x",4,3*i_ForceObj.rotate),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtVFly1)
        end),
        TweenObject.Spawn({
                TweenObject.EaseOut("x",8,dissX*i_ForceObj.rotate),
                TweenObject.EaseOut("y",5,dissY,nil,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            }),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtFallDown)
        end),
        TweenObject.Spawn({
            TweenObject.BounceOut("y",4,nil,i_ForceObj.forcedObj.standLine,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
        }),
        TweenObject.DelayTime(30),
        TweenObject.CallFunc(function()
            if i_ForceObj.forcedObj:checkDead() == false then
                i_ForceObj.forcedObj.standupFlag=true
                i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.standup)
            end
        end),
        TweenObject.CallFunc(function()
            -- print("hartDown finished")
            i_ForceObj.forcedObj.tweenState=0
            i_ForceObj.forcedObj:setRotation(0)
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end),
    }
    return sequence
end
--被打弹起效果
function actions.hurtBounceUp(i_ForceObj)
    local dissX=i_ForceObj.fightAttr.fx
    local dissY=i_ForceObj.fightAttr.fy
    local frames = i_ForceObj.fightAttr.frames
    -- print("hurtBounceUp->tweenState",i_ForceObj.forcedObj.tweenState)
    local actInt1 = TweenObject.CallFunc(function()
            -- i_ForceObj.forcedObj.pos.x = i_ForceObj.forcedObj.pos.x + i_ForceObj.forcedObj.size.ActOffX*i_ForceObj.rotate
            -- i_ForceObj.forcedObj.pos.y = i_ForceObj.forcedObj.pos.y + i_ForceObj.forcedObj.size.ActOffY
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp2)
            i_ForceObj.forcedObj.tweenState=2001
        end)
    local actInt2 = TweenObject.Spawn({
                -- TweenObject.RotateTo(12,20),
                TweenObject.MoveTo("x",frames,dissX*i_ForceObj.rotate),
                TweenObject.EaseOut("y",frames,dissY,nil,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.tweenState=2002
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            })
    local actInt3 = TweenObject.CallFunc(function()
            -- i_ForceObj.forcedObj.pos.x = i_ForceObj.forcedObj.pos.x + i_ForceObj.forcedObj.size.ActOffX*i_ForceObj.rotate
            -- i_ForceObj.forcedObj.pos.y = i_ForceObj.forcedObj.pos.y + i_ForceObj.forcedObj.size.ActOffY
            i_ForceObj.forcedObj:setRotation(0)
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp2)
            i_ForceObj.forcedObj.tweenState=2003
        end)
    if i_ForceObj.forcedObj.tweenState>1001 then
        actInt1 = TweenObject.CallFunc(function()
            -- i_ForceObj.forcedObj.pos.x = i_ForceObj.forcedObj.pos.x + i_ForceObj.forcedObj.size.ActOffX*i_ForceObj.rotate
            -- i_ForceObj.forcedObj.pos.y = i_ForceObj.forcedObj.pos.y + i_ForceObj.forcedObj.size.ActOffY
            i_ForceObj.forcedObj:setRotation(0)
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp2)
            i_ForceObj.forcedObj.tweenState=2101
        end)
        actInt2 = TweenObject.Spawn({
                -- TweenObject.Shake("x",12,20*i_ForceObj.rotate),
                TweenObject.MoveTo("x",frames,dissX*i_ForceObj.rotate),
                TweenObject.EaseIn("y",frames,dissY,nil,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.tweenState=2102
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            })
        actInt3=TweenObject.CallFunc(function()
            i_ForceObj.forcedObj.tweenState=2103
        end)
    end
    local sequence={
        actInt1,
        actInt2,
        actInt3,
        TweenObject.DelayTime(5),
        TweenObject.Spawn({
                TweenObject.CallFunc(function()
                    local sequence = transition.sequence({
                            cc.CallFunc:create(function()
                                    i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp3)
                                    i_ForceObj.forcedObj.tweenState=3001
                                end),
                            cc.DelayTime:create(0.03*5),
                            cc.CallFunc:create(function()
                                    i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtBounceUp4)
                                    i_ForceObj.forcedObj.tweenState=3002
                                end),
                            cc.DelayTime:create(0.03*2),
                        })
                    i_ForceObj.forcedObj:runAction(sequence)
                end),
                TweenObject.MoveTo("x",downFrames,(dissX*0.5)*i_ForceObj.rotate),
                -- TweenObject.EaseIn("y",15,-dissY-50),
                TweenObject.EaseIn("y",downFrames,nil,i_ForceObj.forcedObj.standLine,function()
                        i_ForceObj.forcedObj.bounceHeight= i_ForceObj.forcedObj:getPosY() - i_ForceObj.forcedObj.standLine
                        i_ForceObj.forcedObj.stopForce=false
                        if i_ForceObj.forcedObj.bounceHeight<stopForceH then
                            i_ForceObj.forcedObj.stopForce=true
                        end
                    end),
            }),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtFallDown)
            i_ForceObj.forcedObj.tweenState=2004
            if g_fight.isplayslow==true then
                g_fight.undoPlaySlow()
            end
        end),
        TweenObject.DelayTime(3),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtVFly1)
            i_ForceObj.forcedObj.tweenState=2005
        end),
        TweenObject.Spawn({
                TweenObject.EaseOut("x",5,dissX*0.25*i_ForceObj.rotate),
                TweenObject.EaseOut("y",5,nil,g_fight.bd.bounceHeight(0.375)),
            }),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.hurtFallDown)
            i_ForceObj.forcedObj.tweenState=2006
        end),
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj.tweenState=3008
        end),
        TweenObject.Spawn({
            TweenObject.EaseOut("x",4,dissX*0.25*i_ForceObj.rotate),
            TweenObject.BounceOut("y",4,nil,i_ForceObj.forcedObj.standLine),
        }),
        TweenObject.DelayTime(18),
        TweenObject.CallFunc(function()
            if i_ForceObj.forcedObj:checkDead() == false then
                i_ForceObj.forcedObj.standupFlag=true
                i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.standup)
            end
        end),
        TweenObject.CallFunc(function()
            -- print("hurtBounceUp finished")
            i_ForceObj.forcedObj.tweenState=0
            i_ForceObj.forcedObj:setRotation(0)
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end),
    }
    return sequence
end

--被血雾击中效果
function actions.hurtBlood(i_ForceObj)
    local sequence = {
        cc.TintTo:create(0.25, 255, 0, 0),
        cc.TintTo:create(0.15, 125, 0, 0),
        cc.TintTo:create(0.13, 200, 0, 0),
        cc.TintTo:create(0.1, 255, 255, 255),
        cc.CallFunc:create(function()
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end)
    }
    return sequence
end
--被打击时后退
function actions.hurtBack(i_ForceObj)
    -- print("hurtBack-->tweenState",i_ForceObj.forcedObj.tweenState)
    -- print("hurtBack->",i_ForceObj.forcedObj:getPosY()-i_ForceObj.forcedObj.standLine,i_ForceObj.forcedObj.bounceHeight)
    if COMBO_ENABLE==true and i_ForceObj.forcedObj:getPosY()-i_ForceObj.forcedObj.standLine>=stopForceH then
        i_ForceObj.fightAttr.fy=(i_ForceObj.forcedObj:getPosY()-i_ForceObj.forcedObj.standLine)*0.2
        -- print(i_ForceObj.forcedObj:getPosY()-i_ForceObj.forcedObj.standLine,i_ForceObj.fightAttr.fy)
        return actions.hurtBounceUp(i_ForceObj)
    end
    local sequence={
        TweenObject.Shake("x",6,2*i_ForceObj.rotate),
        TweenObject.MoveTo("x",i_ForceObj.fightAttr.frames,i_ForceObj.fightAttr.fx*i_ForceObj.rotate,nil,function()
                i_ForceObj.forcedObj.tweenState=1001
            end),
        TweenObject.CallFunc(function()
            if i_ForceObj.forcedObj:checkDead() == false then
                i_ForceObj.forcedObj:gotoFightState(FIGHT_STATE.standup)
            end
        end),
        TweenObject.DelayTime(6),
        TweenObject.CallFunc(function()
            -- print("hurtBack finished",i_ForceObj.forcedObj.tweenState)
            i_ForceObj.forcedObj.tweenState=0
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end)
    }
    return sequence
end
--block消失
function actions.blockDieOut(i_ForceObj)
    local opacity = i_ForceObj.forcedObj.isDead == true and 100 or 255
    local sequence={
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj.tweenState=3008
        end),
        TweenObject.Spawn({
                TweenObject.RotateTo(3,20*i_ForceObj.rotate),
                TweenObject.MoveTo("x",12,i_ForceObj.fightAttr.fx*i_ForceObj.rotate),
                TweenObject.FadeTo(12,opacity),
            }),
        TweenObject.CallFunc(function()
            -- print("hurtBounceOff finished")
            i_ForceObj.forcedObj.tweenState=0
            i_ForceObj.forcedObj.animalObj:setRotation(0)
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end),
    }
    return sequence
end
function actions.dropGoods(i_ForceObj)
    local sequence={
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:setVisible(true)
        end),
        TweenObject.Spawn({
                TweenObject.MoveTo("x",6,i_ForceObj.fightAttr.fx),
                TweenObject.EaseOut("y",6,i_ForceObj.fightAttr.fy),
            }),
        TweenObject.Spawn({
            TweenObject.EaseOut("x",12,i_ForceObj.fightAttr.fx*0.25),
            TweenObject.BounceOut("y",12,nil,i_ForceObj.forcedObj.standLine),
        }),
        TweenObject.DelayTime(20),
        TweenObject.CallFunc(function()
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end),
    }
    return sequence
end
function actions.pickupGoods(i_ForceObj)
    local sequence={
        TweenObject.CallFunc(function()
            i_ForceObj.forcedObj:setVisible(true)
        end),
        TweenObject.Spawn({
                TweenObject.MoveTo("x",3,i_ForceObj.fightAttr.fx),
                TweenObject.EaseOut("y",3,i_ForceObj.fightAttr.fy),
            }),
        TweenObject.CallFunc(function()
            if i_ForceObj.finishedHandler then
                i_ForceObj.finishedHandler()
            end
        end),
    }
    return sequence
end
return actions