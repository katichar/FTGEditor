--
-- Author: rsma
-- Date: 2015-06-19 14:42:47
--
-- t：current time
-- b：beginning value
-- c： change in value
-- d：duration
-- return final value
local tween = {}
function tween.rotateTo(t, b, c, d)
    return t/d*c
end
function tween.fadeTo(t, b, c, d)
    return t/d*c
end
function tween.shake(t, b, c, d) --震动
    return (math.floor(t*100)%2==0 and 1 or -1)*c + b
end
function tween.linear(t, b, c, d) --匀速
    return c*t/d + b
end
function tween.bounceOut(t, b, c, d)
    t = t/d
    if (t < (1/2.75)) then
        return c*(7.5625*t*t) + b,1
    elseif (t < (2/2.75)) then
        t=t-(1.5/2.75)
        return c*(7.5625*t*t + 0.75) + b,2
    elseif (t < (2.5/2.75)) then
        t = t-(2.25/2.75)
        return c*(7.5625*t*t + 0.9375) + b,3
    end
    t = t-(2.625/2.75)
    return c*(7.5625*t*t + 0.984375) + b,4
end
function tween.easeIn(t, b, c, d) --加速曲线
    t = t/d
    return c*(t)*t + b
end
function tween.easeOut(t, b, c, d) --减速曲线
    t = t/d
    return -c*t*(t-2) + b
end

function tween.CallFunc()

end
function tween.DelayTime()

end

return tween