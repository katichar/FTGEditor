--
-- Author: rsma
-- Date: 2014-11-02 21:59:56
--
local rect = class("LRect")
function LRect(x,y,width,height)
	return rect.new(x,y,width,height)
end
function rect:ctor(x,y,width,height)
	self.x=x
	self.y=y
	self.width=width
	self.height=height
end
function rect:containsPoint(LPos)
	return LPos.x >= self.x and LPos.x <= (self.x + self.width) and LPos.y>=self.y and LPos.y <= (self.y + self.height)
end
function rect:intersectsRect(SelectRect)
    local RectMinX = SelectRect.x
    local RectMinY = SelectRect.y
    local RectMaxX = RectMinX + SelectRect.width
    local RectMaxY = RectMinY + SelectRect.height

    local SelfMinX = self.x--self.left
    local SelfMinY = self.y--self.top
    local SelfMaxX = SelfMinX + self.width
    local SelfMaxY = SelfMinY + self.height

    local bool = SelfMaxX < RectMinX or
                 RectMaxX <      SelfMinX or
                 SelfMaxY < RectMinY or
                 RectMaxY <      SelfMinY

    return bool==false
end
return rect