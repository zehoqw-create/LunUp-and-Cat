return {
    openLink = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local link = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."system.openURL("..link..")"
        return lua.."\nend)"
    end,

    blockTouch = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = ""
        lua = lua..
        'for i=1, #events_touchObject, 1 do\
        events_touchObject[i](target)\
        end'
        return lua
    end,

    blockTouchScreen = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = ""
        lua = lua..
        'for key, value in pairs(objects) do\
        for i=1, #events_touchScreen[key] do\
        events_touchScreen[key][i](value)\
        for i2=1, #value.clones do\
        events_touchScreen[key][i](value.clones[i2])\
        end\
        end\
        end'
        return lua
    end,

    showToast = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."if not utils.isSim and not utils.isWin then\
            require('plugin.toaster').shortToast("..arg1..")\
        end\n"
        return lua.."\nend)"
    end,

    sleepScreenMode =  function(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua .. "system.setIdleTimer("..(infoBlock[2][1][2]=="on" and "true" or "false")..")"
        return lua.."\nend)"
    end,

    setTapDelay = function(infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua .. "system.setTapDelay("..make_all_formulas(infoBlock[2][1], object)..")"
        return lua.."\nend)"
    end
}