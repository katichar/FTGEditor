--
-- Author: rsma
-- Date: 2015-12-08 17:01:23
--
FrameEvent = class("FrameEvent")

function FrameEvent:ctor()
	self.name=""
	self.IgFH=0
end

function FrameEvent:parser(prop)
	if prop then
		self.IgFH=prop.hurtProp.IgFH or 0
	end
end