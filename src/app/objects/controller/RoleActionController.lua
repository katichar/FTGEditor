--
-- Author: rsma
-- Date: 2015-05-22 14:53:12
--
require("app.objects.controller.ActionController")
RoleActionController = class("RoleActionController", ActionController)

function RoleActionController:checkTargetPos()

end
function RoleActionController:huntTarget(i_Role)

end
function RoleActionController:moveRrender(dt)
    RoleActionController.super.moveRrender(self,dt)
    if self.me.inApplyForce == true then
        self:updateSpeed(0,0)
    end
    if self.speedX + self.FX==0 and self.speedY + self.FY==0 then
        return
    end
    self:onMoveStep()
end

function RoleActionController:onMoveStep()
    local spx = self.speedX
    local spy = self.speedY
    if self.me:isFighting() == true then
        spx=0
        spy=0
    end
    local run_x = self.me.pos.x + spx + self.FX
    local run_y = self.me.pos.y + spy + self.FY
    if run_x > g_Map.getMapRight() or run_x < g_Map.getMapLeft() then
        run_x = self.me.pos.x
    end
    if self.me.inApplyForce == false then
        if run_y < g_LayerManager.mapinfo.rolebottom  or run_y > g_LayerManager.mapinfo.roletop then
            run_y = self.me.pos.y
        end
    else
        if run_x>g_Map.getMapRight() and self.me.dirc == DIRC.LEFT then
            run_x = g_Map.getMapRight()
        elseif run_x<g_Map.getMapLeft() and self.me.dirc == DIRC.RIGHT then
            run_x = g_Map.getMapLeft()
        end
    end
    self.me:setPos(run_x,run_y)
end