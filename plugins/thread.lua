local m = {}
m.timers = {}

local timer = require('timer')
m.timer = timer
m.start = function (p, object)
    local listener = function ()
        print(object.x)
        coroutine.resume(p)
    end
    local t = timer.performWithDelay(1000/60, listener, 0)
    table.insert(m.timers, t)
    return listener, t
end

return m