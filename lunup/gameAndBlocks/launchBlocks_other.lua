
timer.new = timer.performWithDelay
timer.GameNew = function (time, rep, listener)
    return timer.new(time, listener, rep)
end
timer.GameNew2 = function (time, rep, onComplete, listener)
    local i = 0
    return timer.new(time, function()
        listener()
        i = i+1
        if (i==rep) then
            onComplete()
        end
    end, rep)
end
local max_fors = 0
local nameBlock
local Lua
local add_pcall = function ()
    Lua = Lua..'\npcall(function()\n'
end
local end_pcall = function ()
    Lua = Lua..'\nend)\n'
end

local function make_block(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]
    Lua = ''
    if BlocksAllHandlers[nameBlock] then
        Lua = Lua..(BlocksAllHandlers[nameBlock](infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o, mainGroup) or '')
    end
    return Lua

end

return(make_block)