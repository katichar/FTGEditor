--
-- Author: rsma
-- Date: 2015-12-10 21:47:58
--
local panel = class("EventPanel", function()
		return cc.Node:create()
	end)
function panel:ctor()
	local shape4 = display.newRect(cc.rect(0, 0, 180, display.height-160-30-5),
        {fillColor = cc.c4f(1,0,0,0), borderColor = cc.c4f(1,0,0,1), borderWidth = 1})
    self:addChild(shape4, -1)
    self.lv = cc.ui.UIListView.new {
        bgColor = cc.c4b(200, 200, 200, 255),
        bgScale9 = true,
        viewRect = cc.rect(0, 0, 180, display.height-160-30-10),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = "ui/bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self)
end
function panel:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
    	self.frameEventInfo = event.item.data
    	g_VPauseAction=self.frameEventInfo.name
    	if self.changeFunc then
    		self.changeFunc(event.itemPos)
    	end
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end
function panel:loadData(PAnimationInfo)
	self.lv:removeAllItems()
	if not PAnimationInfo.events then
		return
	end
	for _,obj in pairs(PAnimationInfo.events) do
		local item = self.lv:newItem()
        local content
        item.data=obj
        content = cc.ui.UILabel.new(
                    {text = obj.name,
                    size = 20,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    color = obj.IgFH==1 and display.COLOR_RED or display.COLOR_BLACK})
        item:addContent(content)
        item:setItemSize(120, 30)
        self.lv:addItem(item)
	end
	self.lv:reload()
end
return panel