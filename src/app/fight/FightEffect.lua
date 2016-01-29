--
-- Author: rsma
-- Date: 2015-06-24 16:21:35
--
local effect = {}
effect.resHurt={HEF1={resid=60021,fromId=1,endId=4},
				HEF2={resid=60022,fromId=1,endId=3},
				HEF3={resid=60023,fromId=1,endId=3},
				HEF4={resid=60024,fromId=1,endId=3},
}
effect.resSkill={SEF1={resid="effects/60028.plist",offX=100,offY=230},
}
function effect.skill(i_effectHame,i_dirc)
	local rescfg = effect.resSkill[i_effectHame]
	if rescfg then
		local particle = cc.ParticleSystemQuad:create(rescfg.resid)
        particle:align(display.CENTER, rescfg.offX*i_dirc,rescfg.offY)
        return particle
	end
	return nil
end
function effect.hurt(i_hurtName)
	if display.getAnimationCache(i_hurtName) then
		return display.getAnimationCache(i_hurtName)
	end
	local rescfg = effect.resHurt[i_hurtName]
	if rescfg then
		local frames = display.newFrames(rescfg.resid .. "_%d.png", rescfg.fromId, rescfg.endId)
		if #frames>0 then
			local animation = display.newAnimation(frames, 1/12)
			display.setAnimationCache(i_hurtName, animation)
			return animation
		end
	end
	return nil
end
function effect.showHP(i_Role,i_Num,i_Crit)
	i_Crit = i_Crit or false
	local fntname = 'f_enemy_num.fnt'
	if iskindof(i_Role, "RoleObject") then
		fntname = 'f_user_num.fnt'
	elseif i_Crit == true then
		fntname = 'f_critical_num.fnt'
	end
	local px,py=i_Role:getPosition()
	py = py + i_Role.size.h
	px = px - i_Role.size.w*0.5*i_Role.dirc + g_Map.getMapOffset().x
    local i_lbl_ef = display.newBMFontLabel({
    	text = "" .. i_Num,
    	font = "fonts/"..fntname,x=px,y=py})
	-- i_Role:addChild(i_lbl_ef)
	g_LayerManager:addObjs(i_lbl_ef)
	local sequence = transition.sequence({
				cc.MoveTo:create(0.3, cc.p(px, py+50)),
				transition.newEasing(cc.MoveTo:create(0.2, cc.p(px-30*i_Role.dirc, py+80)), "in"),
                cc.DelayTime:create(0.1),
                cc.CallFunc:create(function()
                    i_lbl_ef:removeFromParent(true)
                    i_lbl_ef=nil
                end),nil
            })
            i_lbl_ef:runAction(sequence)
end
function effect.criticalTip()
	g_Timer.delTimer(effect.ccid)
	effect.critTip:setVisible(true)
	effect.ccid = g_Timer.callLater(function()
				g_Timer.delTimer(effect.ccid)
				effect.critTip:setVisible(false)
			end,1)
	effect.critTip:stopAllActions()
		effect.critTip:setScale(1.3)
		local sequence = transition.sequence({
				cc.Spawn:create({
		            cc.ScaleTo:create(0.1,0.8,0.8),
		        }),
                cc.CallFunc:create(function()
                    effect.critTip:setScale(1)
                end),nil
            })
        effect.critTip:runAction(sequence)
end
function effect.hitTip(i_hitNum,i_finishedHandler)
	g_Timer.delTimer(effect.cid)
	if i_hitNum<=1 then
		effect.hitbgTip:setVisible(false)
		effect.process:setPercent(0)
	else
		effect.hitbgTip:setVisible(true)
		effect.process:setPercent(100)
		effect.cid = g_Timer.addTimer(function()
				local diss=effect.process:getPercent()-3.4
				if diss <=0 then
					diss=0
					g_Timer.delTimer(effect.cid)
					if i_finishedHandler then
						i_finishedHandler()
					end
				end
				effect.process:setPercent(diss)
			end,31,0.1)
		effect.lblTxt:setString("" .. i_hitNum)
		effect.hitbgTip:stopAllActions()
		effect.hitbgTip:setScale(1.3)
		local sequence = transition.sequence({
				cc.Spawn:create({
		            cc.ScaleTo:create(0.1,0.8,0.8),
		        }),
                cc.CallFunc:create(function()
                    effect.hitbgTip:setScale(1)
                end),nil
            })
        effect.hitbgTip:runAction(sequence)
	end
end
function effect.init()
	display.addSpriteFrames("effects/hurt/60021.plist", "effects/hurt/60021.png")
	display.addSpriteFrames("effects/hurt/60022.plist", "effects/hurt/60022.png")
	display.addSpriteFrames("effects/hurt/60023.plist", "effects/hurt/60023.png")
	display.addSpriteFrames("effects/hurt/60024.plist", "effects/hurt/60024.png")
	effect.hitbgTip = display.newSprite("common/c_hit.png")
	g_LayerManager:addEffectUI(effect.hitbgTip)
	effect.hitbgTip:setPosition(display.width-130, display.cy+100)

	effect.lblTxt = display.newBMFontLabel({
	    	text = "0",
	    	font = "fonts/f_critical_num.fnt",x=0,y=0})
	effect.lblTxt:align(display.BOTTOM_RIGHT, 0, 30)
	effect.lblTxt:setScale(1.3)
	effect.hitbgTip:addChild(effect.lblTxt)
	effect.hitbgTip:setVisible(false)

	effect.critTip = display.newSprite("common/c_critical.png")
	g_LayerManager:addEffectUI(effect.critTip)
	effect.critTip:setPosition(display.width-200, display.cy+200)
	effect.critTip:setVisible(false)

	local bgpo = display.newSprite("ui/bar/ui_bar_combo_bg.png")
	bgpo:align(display.BOTTOM_RIGHT, 110,-10 )
    effect.hitbgTip:addChild(bgpo)

    effect.process = cc.ui.UILoadingBar.new({image="ui/bar/ui_bar_combo_po.png",viewRect=cc.rect(0,0,98,7)})
    effect.process:align(display.BOTTOM_RIGHT, 7,-5 )
    effect.hitbgTip:addChild(effect.process)
    effect.process:setPercent(100)
end
function effect.destroy()
	-- effect.hitbgTip=nil
	-- effect.lblTxt=nil
	-- effect.process=nil
end
return effect