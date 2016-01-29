--此类为所有弹出界面的基类

local basepop=class("BasePopUI",g_BaseNode)

function basepop:ctor(Params)
    basepop.super.ctor(self)
    
	self.isbusy=false
	local alpha,scapx,scapy=128,0,0
	if (Params) then
		alpha= Params.Alpha or alpha
		scapx= Params.ScapX or scapx
		scapy=Params.ScapY or scapy
	end
	self:setTouchEnabled(true)
	--	阻止鼠标事件传递
	self:setTouchSwallowEnabled(true)
	--记录打开页面
	self:record()

	if (Params and Params.showBG~=nil and Params.showBG==false) then
		self:setContentSize(cc.size(display.width, display.height))
		return
	end

	self.cover = display.newScale9Sprite("ui/common/ui_common_cover.png")
        :align(display.CENTER,display.cx,display.cy)
        :addTo(self)
    self.cover:setContentSize(cc.size(display.width,display.height))
end

--记录打开UI
function basepop:record()
	pcall(g_UA.openUI,self.uicode)
end

return basepop
