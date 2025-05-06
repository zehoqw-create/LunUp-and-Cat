local m = {}
m.timers = {}

local timer = require('timer')
m.timer = timer
m.start = function (p)
    local listener = function ()
        coroutine.resume(p)
    end
    local t = timer.performWithDelay(1000/60, listener, 0)
    table.insert(m.timers, t)
    return listener, t
end

return m