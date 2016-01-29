--
-- Author: rsma
-- Date: 2015-06-19 15:14:47
--
-- local cri = display.newCircle(5, {x=i_ForceObj.forcedObj.pos.x,y=i_ForceObj.forcedObj.pos.y,color=cc.c4f(1, 0, 0, 1)})
-- g_LayerManager:addObjs(cri)
TweenObject = class("TweenObject")
TweenObject.PropValue={
		['x']='FX',
		['y']='FY',
	}
function TweenObject.Spawn(i_Tweens,i_updateHandler)
	local tween = TweenObject.new("Spawn",nil,nil,nil,nil,i_updateHandler)
	tween.spawn = i_Tweens
	return tween
end
function TweenObject.MoveTo(i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
	return TweenObject.new("linear",i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
end
function TweenObject.EaseIn(i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
	return TweenObject.new("easeIn",i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
end
function TweenObject.EaseOut(i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
	return TweenObject.new("easeOut",i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
end
function TweenObject.BounceOut(i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
	return TweenObject.new("bounceOut",i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
end
function TweenObject.Shake(i_Prop,i_Time,i_Diss,i_updateHandler)
	return TweenObject.new("shake",i_Prop,i_Time,i_Diss,nil,i_updateHandler)
end
function TweenObject.CallFunc(i_updateHandler)
	return TweenObject.new("CallFunc",nil,1,nil,nil,i_updateHandler)
end
function TweenObject.DelayTime(i_Time,i_updateHandler)
	return TweenObject.new("DelayTime",nil,i_Time,nil,nil,i_updateHandler)
end
function TweenObject.RotateTo(i_Time,i_Value,i_updateHandler)
	return TweenObject.new("rotateTo",nil,i_Time,i_Value,nil,i_updateHandler)
end
function TweenObject.FadeTo(i_Time,i_Value,i_updateHandler)
	return TweenObject.new("fadeTo",nil,i_Time,nil,i_Value,i_updateHandler)
end
function TweenObject:ctor(i_TweenName,i_Prop,i_Time,i_Diss,i_EndValue,i_updateHandler)
	i_Time = i_Time==nil and 0 or i_Time
	-- i_Time = i_Time * 30
	self.target = nil
	self.tweenName = i_TweenName
	self.prop = i_Prop
	self.time = i_Time--g_fight.tweenFPS--GAME_FPS
	self.frames=i_Time
	self.diss = i_Diss
	self.endValue=i_EndValue
	self.handler = nil
	self.isvalid=true
	self.updateHandler=i_updateHandler
	self.initParams=false
	self.spawn=nil
	self.currFrame=0
end

function TweenObject:init()
	if self.tweenName == "Spawn" then
		for _,tobj in pairs(self.spawn) do
			tobj.target = self.target
			tobj:init()
		end
		self.initParams=true
		return
	end

	self.startPos=0
	self.currTime=0
	self.currFrame=0
	if self.tweenName == "Spawn" or self.tweenName == "CallFunc" or self.tweenName == "DelayTime" then
		self.handler = nil
	else
		local funcname = "return require('app.fight.TweenFunction').".. self.tweenName
		self.handler = loadstring(funcname)()
	end
	if self.prop then
		self.startPos = self.target.pos[self.prop]
		if self.endValue and type(self.endValue) == "function" then
			self.diss = self.endValue(self.target)
		elseif self.endValue and type(self.endValue) == "number" then
			self.diss = self.endValue - self.startPos
		end
	elseif self.tweenName == "fadeTo" then
		self.orgOpacity = self.target:getOpacity()
		self.diss = self.endValue - self.target:getOpacity()
	end
	self.initParams=true
	-- if iskindof(self.target, "NPCObject") then
	-- 	print(self.target.RID,"TweenObject",self.tweenName,self.prop,"startPos=",self.startPos,"endValue=",self.endValue,"diss=",self.diss)
	-- end
end
function TweenObject:doslow(i_slowFlag)
	if self.target==nil then
		return
	end
	if self.tweenName == "Spawn" then
		for _,tobj in pairs(self.spawn) do
			tobj:doslow()
		end
		return
	end
	-- print(self.target.RID,self.target.name,self.tweenName,"TweenObject:doslow(),currFrame=",self.currFrame,"frames=",self.frames,"time=",self.time)
	if self.currFrame>0 then
		if i_slowFlag == true then
			self.currFrame = self.currFrame * g_fight.tweenSlow
		else
			self.currFrame = math.ceil((self.currFrame/(self.frames* g_fight.tweenSlow))*self.frames)
		end
	end
end
function TweenObject:update(dt)
	if self.initParams==false then
		self:init()
	end
	if self.tweenName == "Spawn" then
		for _,tobj in pairs(self.spawn) do
			tobj:update(dt)
			if tobj.isvalid == false then
				table.removebyvalue(self.spawn, tobj)
			end
		end
		if self.updateHandler then
			self.updateHandler(self.currFrame,self.frames)
		end
		if #self.spawn == 0 then
			self.isvalid=false
		end
		return
	end
	self.currFrame = self.currFrame + 1
	if self.handler then
		self.currTime = self.currFrame * g_fight.tweenFPS--GAME_FPS
		-- if self.currTime>self.time*g_fight.tweenSlow*g_fight.tweenFPS then
		-- 	print("+++++",self.target.RID,self.target.name,"currTime=",self.currTime,"tweenName=",self.tweenName,"tweenFPS=",g_fight.tweenFPS,"currFrame=",self.currFrame,"frames=",self.frames,"time=",self.time)
		-- end
		local delta,args = self.handler(self.currTime,self.startPos,self.diss,self.time*g_fight.tweenSlow*g_fight.tweenFPS)
		if self.tweenName == "rotateTo" then
			self.target.animalObj:setRotation(delta)
		elseif self.tweenName == "fadeTo" then
			self.target.animalObj:setOpacity(self.orgOpacity+delta)
		else
			self.target.action[TweenObject.PropValue[self.prop]] = delta-self.target.pos[self.prop]
			if self.updateHandler then
				self.updateHandler(self.target.action[TweenObject.PropValue[self.prop]],args,self.currFrame)
			end
			-- if g_fight.gameOver == true and iskindof(self.target, "NPCObject") then
			-- 	print(self.tweenName,"time=",self.currTime,"delta=",delta,TweenObject.PropValue[self.prop],self.target.action[TweenObject.PropValue[self.prop]])
			-- end
		end
	end
	if self.currFrame>=self.frames*g_fight.tweenSlow then
		if self.tweenName == "CallFunc" or self.tweenName == "DelayTime" then
			if self.updateHandler then
				self.updateHandler()
			end
		end
		-- print("finished tween=",self.tweenName,self.time,self.currTime,self.prop,self.target.pos[self.prop])
		self.isvalid=false
	end
end