--创建Image
--目标
--方法
local baseimage = class("BaseImage",cc.ui.UIImage)

-- start --

--------------------------------
-- UIImage构建函数
-- @function [parent=#UIImage] new
-- @param string filename 图片文件名
-- @param table options 参数表

-- end --

function baseimage:ctor(filename, options)
    baseimage.super.ctor(self,filename, options)
end

--------------------------------
-- UIImage设置控件大小
-- @function [parent=#UIImage] setLayoutSize
-- @param number width 宽度
-- @param number height 高度
-- @return UIImage#UIImage  自身

-- end --

function baseimage:setLayoutSize(width, height, i_ScaleX, i_ScaleY)
    i_ScaleX = i_ScaleX or 1
    i_ScaleY = i_ScaleY or 1
    self:getComponent("components.ui.LayoutProtocol"):setLayoutSize(width, height)
    local width, height = self:getLayoutSize()
    local top, right, bottom, left = self:getLayoutPadding()
    width = width - left - right
    height = height - top - bottom

    if self.isScale9_ then
        self:setContentSize(cc.size(width, height))
    else
        local boundingSize = self:getBoundingBox()
        local sx = width / (boundingSize.width / self:getScaleX())
        local sy = height / (boundingSize.height / self:getScaleY())
        if sx > 0 and sy > 0 then
            self:setScaleX(sx*i_ScaleX)
            self:setScaleY(sy*i_ScaleY)
        end
    end

    if self.layout_ then
        self:setLayout(self.layout_)
    end

    return self
end

return baseimage