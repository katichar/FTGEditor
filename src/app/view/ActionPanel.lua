--
-- Author: rsma
-- Date: 2015-12-08 19:18:59
--
local panel = class("ActionPanel", function()
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
    	self.animationInfo = event.item.data
    	if self.changeFunc then
    		self.changeFunc()
    	end
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end
function panel:loadData(PDataInfo)
	self.lv:removeAllItems()
	for _,obj in pairs(PDataInfo.animations) do
		local item = self.lv:newItem()
        local content
        item.data=obj
        content = cc.ui.UILabel.new(
                    {text = obj.name,
                    size = 20,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    color = display.COLOR_BLACK})
        item:addContent(content)
        item:setItemSize(120, 30)
        self.lv:addItem(item)
	end
	self.lv:reload()
end
return panel