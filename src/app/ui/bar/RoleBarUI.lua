-- 信息条UI 生命 魔法 经验条 头像框
local node = class("RoleBarUI",g_BaseNode)
local path = "ui/bar/"

function node:ctor()
	node.super.ctor(self)
	self:initBarInfo()
	self:createUI()

	self:addAllListener()

	g_UI.child.hpbar = self
end

function node:addAllListener()
	g_EventManager.addListener(MESSAGE_EVENT.ROLE_BAR_CHANGE,self.changeBar,self)
	g_EventManager.addListener(MESSAGE_EVENT.ROLE_RESURRECTION,self.resetBar,self)
end

function node:removeAllListener()
	g_EventManager.removeListener(MESSAGE_EVENT.ROLE_BAR_CHANGE,self.changeBar,self)
	g_EventManager.removeListener(MESSAGE_EVENT.ROLE_RESURRECTION,self.resetBar,self)
end

function node:initBarInfo()
	self.hpMax = g_User.roleinfo.hp
	self.hp = self.hpMax
	self.mpMax = g_User.roleinfo.mp
	self.mp = self.mpMax
end

function node:createUI()
	self.bg = display.newSprite(path.."ui_bar_role_bg.png")
		:align(display.LEFT_TOP,0,display.height-50)
		:addTo(self)
	self.bgW = self.bg:getContentSize().width
	self.bgH = self.bg:getContentSize().height

	cc.ui.UILabel.new({
        text = "LV"..g_User.roleinfo.lvl,
        size = 24,
        color = cc.c3b(255, 228, 0),
        })
    :align(display.LEFT_CENTER,133,87)
    :addTo(self.bg)
    :enableOutline(cc.c4b(0,0,0,255),3)

    self.icon = display.newSprite("icons/"..g_RoleConfig[g_User.roleinfo.type].pic)
    	:align(display.LEFT_BOTTOM,160,0)
    	:addTo(self.bg)
    self.icon:setScaleX(-1)

	cc.ui.UILabel.new({
            text = (g_User.name or g_Dict.getInfoByKey("OBJ_TYPE",g_User.roleinfo.type).name),
            size = 26,
            color = cc.c3b(219, 219, 220),
            })
        :align(display.CENTER,self.icon:getContentSize().width/2+10,10)
        :addTo(self.icon)
        :enableOutline(cc.c4b(0,0,0,255),3)
        :setScaleX(-1)

	local params = {
			image =  path.."ui_bar_role_hp.png",
			viewRect = cc.rect(0,0,180,13),
			percent = 100,
			direction = 0,
		}
	self.hpBar = require("app.ui.bar.HpBar").new(params,1)
	self.hpBar:setPosition(133,60)
	self.bg:addChild(self.hpBar)

	params = {
			image =  path.."ui_bar_role_mp.png",
			viewRect = cc.rect(0,0,159,11),
			percent = 100,
			direction = 0,
		}
	self.mpBar = require("app.ui.bar.HpBar").new(params,2)
	self.mpBar:setPosition(133,42)
	self.bg:addChild(self.mpBar)

end

function node:resetBar(eventname)
	self.hp = self.hpMax
	self.hpBar:resetBar()
	self.mp = self.mpMax
	self.mpBar:resetBar()
end

function node:changeBar(i_EventName,i_Msg)
	if i_Msg.hp then
		self.hp = self.hp + i_Msg.hp
		if self.hp >= self.hpMax then
			self.hp = self.hpMax
		end
		if self.hp <= 0 then
			self.hp = 0
		end
		local percent = (self.hp/self.hpMax)*100
		self.hpBar:setBar(percent)
	end
	
	if i_Msg.mp then
		self.mp = self.mp + i_Msg.mp
		if self.mp >= self.mpMax then
			self.mp = self.mpMax
		end
		if self.mp <= 0 then
			self.mp = 0
		end
		local percent = (self.mp/self.mpMax)*100
		self.mpBar:setBar(percent)
	end
end

function node:destroy()
	self:removeAllListener()
end

return node