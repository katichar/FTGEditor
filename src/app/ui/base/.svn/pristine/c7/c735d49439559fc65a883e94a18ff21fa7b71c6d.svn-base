--此类为所有界面的基类
local basenode=class("BaseNode",function ()
    return display.newNode()
end)

function basenode:ctor()
    --响应加入舞台和退出舞台事件
    self:setNodeEventEnabled(true)
end

--显示错误信息
--ErrorString 错误提示
--Func 调用方法
function basenode:showError(i_ErrorString,i_Func,...)
    if g_CommonUtil.isEmpty(i_ErrorString) then
        return
    end
    local info = {func=i_Func,descr=i_ErrorString,tag=1}
    self:addChild(g_TipUI.new(info,self,...))
end

--销毁
function basenode:destroy()
    -- body
end

function basenode:onExit()
    self:destroy()
    self:removeNodeEventListener(cc.NODE_TOUCH_EVENT)
    self:setTouchEnabled(false)
    self:removeAllNodeEventListeners()
    self:removeTouchEvent()
    self:unregisterScriptHandler()
    self:setNodeEventEnabled(false)
    -- g_CommonUtil.releaseUnusedTextures()
end

return basenode