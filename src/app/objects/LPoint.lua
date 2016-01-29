--
-- Author: rsma
-- Date: 2015-06-27 19:09:55
--
local point=class("LPoint")
function LPoint(PX,PY)
	return point.new(PX,PY)
end
function point:ctor(x,y)
	self.x=x
	self.y=y
end
function point:getDistance(i_LPoint)
	local tx = math.pow(self.x - i_LPoint.x,2)
	local ty = math.pow(self.y - i_LPoint.y,2)
	return math.sqrt(tx + ty)
end
return point