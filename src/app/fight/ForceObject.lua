--
-- Author: rsma
-- Date: 2015-06-08 15:02:14
-- 施力及受力类
ForceObject = class("ForceObject")
--i_Role:施力者或受力者
--i_ForceTarget:
function ForceObject:ctor(i_Role,i_FightAttribute)
	self.forcedObj=i_Role
	self.fightAttr=i_FightAttribute
	self.rotate = i_Role.dirc==DIRC.LEFT and 1 or -1
	self.finishedHandler = nil
	self.valid=true
end
function ForceObject:reset()
	if i_Role and not tolua.isnull(i_Role) then
		i_Role:setPos(g_LayerManager.mapinfo:getWorldPosition(i_Role:getPosition()))
	end
end
function ForceObject:setFinishedHandler(i_Handler)
	self.finishedHandler = i_Handler
end