local m = {}
m.timers = {}

local timer = require('timer')
m.timer = timer
m.start = function (p, object)
    local t
    local listener = function ()
        if object and object.x then
            coroutine.resume(p)
            print(os.time())
        else
            timer.cancel(t)
        end
    end
    t = timer.performWithDelay(1000/60, listener, 0)
    table.insert(m.timers, t)
    return listener, t
end

return m