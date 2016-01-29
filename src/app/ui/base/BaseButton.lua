--创建Button
--目标
--方法
local UIButton = require("framework.cc.ui.UIButton")
local basebutton = class("BaseButton",cc.ui.UIPushButton)

function basebutton:ctor(images, i_Options)
    basebutton.super.ctor(self,images, i_Options)
    --变化大小
    self.scaleFlag = true
    if i_Options and not i_Options.scaleflag then
        self.scaleFlag = false
    end
    if self.scaleFlag then
        self:onButtonPressed(function(event)
            event.target:setScale(1.1)
        end)
    end
    self:onButtonRelease(function(event)
        self:onReleaseCallBack(event)
    end)
end

-- 为按钮添加触摸时间限制
-- @time 限制的时间
function basebutton:addTimeLock(time)
    self:setTouchEnabled(false)
    local function callback(obj)
        if obj and not tolua.isnull(obj) then
            obj:setTouchEnabled(true)
        end
    end
    g_Timer.callAfter(callback,time,self)
end

-- -- 点击事件
-- function basebutton:onButtonClicked(i_CallBack)
--     self.onclickcallback = i_CallBack
--     return self
-- end

--按键抬起时处理
function basebutton:onReleaseCallBack(i_Event)
    if self.scaleFlag then
        i_Event.target:setScale(1.0)
    end
    -- if self.onclickcallback then
    --     pcall(self.onclickcallback,i_Event)
    -- end
end

function basebutton:onTouch_(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
        self.touchBeganX = x
        self.touchBeganY = y
        if not self:checkTouchInSprite_(x, y) then return false end
        self.fsm_:doEvent("press")
        self:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        return true
    end

    -- must the begin point and current point in Button Sprite
    local touchInTarget = self:checkTouchInSprite_(self.touchBeganX, self.touchBeganY)
                        and self:checkTouchInSprite_(x, y)
    if name == "moved" then
        if touchInTarget and self.fsm_:canDoEvent("press") then
            self.fsm_:doEvent("press")
            self:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        elseif not touchInTarget and self.fsm_:canDoEvent("release") then
            self.fsm_:doEvent("release")
            self:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = false})
        end
    else
        if self.fsm_:canDoEvent("release") then
            self.fsm_:doEvent("release")
            self:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = touchInTarget})
        end
        if name == "ended" and touchInTarget then
            if self and not tolua.isnull(self) then
                self:dispatchEvent({name = UIButton.CLICKED_EVENT, x = x, y = y, touchInTarget = true})
            end
        end
    end
end

return basebutton
