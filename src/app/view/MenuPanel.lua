--
-- Author: rsma
-- Date: 2015-12-08 17:46:18
--
local button = require("app.view.MenuButton")
local panel = class("MenuPanel", function()
		return cc.Node:create()
	end)

function panel:ctor()
	local cfgBtn = button.create({normal="Config",pressed="Config",disabled="Config"},{width=120},self.onConfig)
	self:addChild(cfgBtn)
	cfgBtn:align(display.LEFT_TOP, 0, 0)
end
function panel:onConfig()
	print("panel:onConfig()")
end
return panel