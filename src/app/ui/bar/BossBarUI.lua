-- BOSS血条
local node = class("BossBarUI",g_BaseNode)
local path = "ui/bar/"

function node:ctor(i_Info)
	node.super.ctor(self)
	self.info = i_Info
	self:initBarInfo()
	self:createUI()

	self:addAllListener()
end

function node:addAllListener()
	--g_EventManager.addListener(MESSAGE_EVENT.BOSS_BAR_CHANGE,self.changeBar,self)
end

function node:removeAllListener()
	--g_EventManager.removeListener(MESSAGE_EVENT.BOSS_BAR_CHANGE,self.changeBar,self)
end

function node:initBarInfo()
	-- BOSS血条信息获取
	self.hpIndex = self.info.hpnum
	self.hpMax = self.info.hp/self.info.hpnum
	self.hp = self.hpMax
end

function node:createUI()
	self.bg = display.newSprite(path.."ui_bar_boss_bg.png")
		:align(display.RIGHT_TOP,display.width,display.height-50)
		:addTo(self)
	self.bgW = self.bg:getContentSize().width
	self.bgH = self.bg:getContentSize().height

	self.icon = display.newSprite("icons/"..(self.info.pic or ""))
		:align(display.RIGHT_BOTTOM,self.bgW,0)
		:addTo(self.bg,10)

	cc.ui.UILabel.new({
            text = self.info.name,
            size = 26,
            color = cc.c3b(219, 219, 220),
            })
        :align(display.CENTER,self.icon:getContentSize().width/2,10)
        :addTo(self.icon)
        :enableOutline(cc.c4b(0,0,0,255),3)

    self.hpNum = cc.ui.UILabel.new({
            text = "X"..self.hpIndex-1,
            size = 22,
            color = cc.c3b(255, 255, 255),
            })
        :align(display.CENTER,90,25)
        :addTo(self.bg)
        :enableOutline(cc.c4b(0,0,0,255),3)

    if self.hpIndex <= 1 then
    	self.hpNum:hide()
    end

    self:createBar()
end

function node:createBar()
	self.hpTable = {}
	for i=0,self.info.hpnum-1 do
		local params = {
				image =  path.."ui_bar_boss_hp"..(i%4+1)..".png",
				viewRect = cc.rect(0,0,268,13),
				percent = 100,
				direction = 1,
			}
		local hpBar = require("app.ui.bar.HpBar").new(params,4)
		hpBar:setPosition(62,34)
		self.bg:addChild(hpBar)

		table.insert(self.hpTable,hpBar)
	end
end

function node:changeBar(i_Msg)
	if i_Msg.hp then
		if i_Msg.hp >= 0 then
			-- BOSS加血
		else 
			-- BOSS掉血
			local percent = (i_Msg.hp/self.hpMax)*100
			-- 超过当前血条
			if percent + self.hpTable[self.hpIndex]:getPercent() < 0 then
				self.hpTable[self.hpIndex]:changeBar(-self.hpTable[self.hpIndex]:getPercent())
				if self.hpIndex ~= 1 then
					self.hpTable[self.hpIndex]:hide()
					local more = percent + self.hpTable[self.hpIndex]:getPercent() 
					self:changeHpIndex()
					self.hpTable[self.hpIndex]:changeBar(more)
				end
			else 
				self.hpTable[self.hpIndex]:changeBar(percent)
			end
		end
	end
end

function node:changeHpIndex()
	self.hpIndex = self.hpIndex - 1
	self.hpNum:setString("X"..(self.hpIndex-1))

	if self.hpIndex <= 1 then
    	self.hpNum:hide()
    else 
    	self.hpNum:show()
    end
end

function node:destroy()
	self:removeAllListener()
end

return node