-- 游戏中血条基类

-- direction 
-- 0 →→→→→→
-- 1 ←←←←←←
-- 从 0 到 100 的进度方向
local bar = class("BaseBar", function (params)
	if params then
		if params.scale9 then
			params.capInsets = params.capInsets or cc.rect(0,0,0,0)
		end
		params.percent = params.percent or 100
		params.direction = params.direction or UILoadingBar.DIRECTION_LEFT_TO_RIGHT
	end 
	local tempbar = cc.ui.UILoadingBar.new(params)
	tempbar._params = params
	return tempbar
end)

-- 获取当前血条的长度
function bar:getLength()
	if self._params.viewRect then
		return self._params.viewRect.width
	else 
		return 0
	end
end

-- 通过百分比获得长度
function bar:getLengthByPercent(i_Percent)
	return math.ceil(self:getLength()*i_Percent/100) 
	--return self:getLength()*i_Percent/100
end

return bar
