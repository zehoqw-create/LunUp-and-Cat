
timer.new = timer.performWithDelay
timer.GameNew = function (time, rep, listener)
    return timer.new(time, listener, rep)
end
local max_fors = 0
local nameBlock
local lua
local add_pcall = function ()
    lua = lua..'\npcall(function()\n'
end
local end_pcall = function ()
    lua = lua..'\nend)\n'
end

local isEvent = {
    start=true, touchObject=true, touchScreen=true, ["function"]=true, collision=true, changeBackground=true, startClone=true,
    endedCollision=true,
}

local function make_block(infoBlock, object, images, sounds, index, blocks, level_blocks, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]--args[i] = make_all_formulas(infoBlock[2][i], object)
    lua = ''
    local waitInsert = function (time)
        lua = lua..'threadFun.wait('..time..'*1000)'
    end
    if nameBlock == 'wait' then
        local time = make_all_formulas(infoBlock[2][1], object)
        waitInsert(time)
    elseif nameBlock == 'setSize' or nameBlock == 'editSize' then
        local formula = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "target.property_size = ("..(nameBlock=='setSize' and '' or 'target.property_size)+(')..formula..")\
        target.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\
        if (target.parent_obj==target) then\
            local objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\
            if (objectsTable[target.infoSaveVisPos][3]==nil) then\
                objectsTable[target.infoSaveVisPos][3] = {}\
            end\
            objectsTable[target.infoSaveVisPos][3].size = target.property_size/100\
            funsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\
        end\
        target:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setPosition' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua..
        "target.x = "..x.."\
        target.y = -"..y
        end_pcall()
    elseif nameBlock == 'setPositionX' then
        add_pcall()
        local x = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'target.x = '..x
        end_pcall()
    elseif nameBlock == 'setPositionY' then
        add_pcall()
        local y = make_all_formulas(infoBlock[2][1], object)
        lua = lua..'target.y = -'..y..''
        end_pcall()
    elseif nameBlock == 'transitionPosition' then
        local time = make_all_formulas(infoBlock[2][1], object)
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)

        add_pcall()
        lua = lua..
        "transition.to(target, {time="..time.."*1000,\
        x="..x..", y= -"..y.."})"
        end_pcall()
        lua = lua.."\n"
        waitInsert(time)
    elseif nameBlock == 'editRotateLeft' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "target:rotate(-"..rotate..")\
        if (target.parent_obj==target) then\
            local objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\
            if (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\
            end\nobjectsTable[target.infoSaveVisPos][3].rotation = target.rotation\
            funsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\
        end"
        end_pcall()
    elseif nameBlock == 'editRotateRight' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "target:rotate("..rotate..")\
        if (target.parent_obj==target) then\
            local objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\
            if (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\
            end\nobjectsTable[target.infoSaveVisPos][3].rotation = target.rotation\
            funsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\
        end"
        end_pcall()
    elseif nameBlock == 'editPositionX'  then
        local x = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."target:translate("..x..", 0)"
        end_pcall()
    elseif nameBlock == 'editPositionY'  then
        local y = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."target:translate(0,-"..y..")"
        end_pcall()
    elseif nameBlock == 'setRotate' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "target.rotation = "..rotate.."\
        if (target.parent_obj==target) then\
            local objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\
            if (objectsTable[target.infoSaveVisPos][3]==nil) then\
                objectsTable[target.infoSaveVisPos][3] = {}\
            end\
            objectsTable[target.infoSaveVisPos][3].rotation = target.rotation\
            funsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\
        end"
        end_pcall()
    elseif nameBlock == 'hide' then
        lua = lua.."target.isVisible = false"
    elseif nameBlock == 'show' then
        lua = lua.."target.isVisible = true"
    elseif nameBlock == 'setAlpha' then
        local alpha = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."target.alpha = math.min(math.max(100-"..alpha..",0),100)/100"
        end_pcall()
    elseif nameBlock == 'commentary' then
        local comment = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."-- "..comment
    elseif nameBlock == 'if' or nameBlock == 'ifElse (2)' then
        local condition = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."if "..condition.." then"
    elseif nameBlock == 'else' then
        lua = lua.."else"
    elseif nameBlock == 'endIf' then
        lua = lua.."end"
    elseif nameBlock == 'repeat' then
        wait_type = 'repeat'
        local rep = make_all_formulas(infoBlock[2][1], object)
        lua = lua..
        "for i=1, type("..rep..") == 'number' and "..rep.." or 0, 1 do\
        "
    elseif nameBlock == 'endRepeat' then
        lua = lua..
        "coroutine.yield()\
        end"
    elseif nameBlock == 'setVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        local var = infoBlock[2][1][2]
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..
            "var_"..var.." = "..value.."\
            if varText_"..var.." then\
                varText_"..var..".text = type(var_"..var..")=='boolean' and (var_"..var.." and app.words[373] or app.words[374]) or type(var_"..var..")=='table' and encodeList(var_"..var..") or var_"..var.."\
            end"
        else
            lua = lua..
            "target.var_"..var.." = "..value.."\
            if target.varText_"..var.." then\
                target.varText_"..var..".text = type(target.var_"..var..")=='boolean' and (target.var_"..var.." and app.words[373] or app.words[374]) or type(target.var_"..var..")=='table' and encodeList(target.var_"..var..") or target.var_"..var.."\
            end"
        end
        end_pcall()
    elseif nameBlock == 'editVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        local var = infoBlock[2][1][2]
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..
            "var_"..var.." = type(var_"..var..")=='boolean' and (var_"..var.." and app.words[373] or app.words[374]) or type(var_"..var..")=='table' and encodeList(var_"..var..") or var_"..var.."+"..value.."\
            if varText_"..var.." then\
                varText_"..var..".text = var_"..var.."\
            end"
        else
            lua = lua..
            "target.var_"..var.." = target.var_"..var.." + "..value.."\
            if target.varText_"..var.." then\
                target.varText_"..var..".text = type(target.var_"..var..")=='boolean' and (target.var_"..var.." and app.words[373] or app.words[374]) or type(target.var_"..var..")=='table' and encodeList(target.var_"..var..") or target.var_"..var.."\
            end"
        end
        end_pcall()
    elseif nameBlock == 'openLink' then
        local link = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."system.openURL("..link..")"
        end_pcall()
    elseif nameBlock == 'cycleForever' then

        lua = lua..
        "while true do"
    elseif nameBlock == 'endCycleForever' then
        lua = lua..
        "coroutine.yield()\
        end"
    elseif nameBlock == 'repeatIsTrue' then
        local condition = make_all_formulas(infoBlock[2][1], object)
        lua = lua..
        "while "..condition.." do"
    elseif nameBlock == 'setImageToId' and #images>0 then
        local image = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/"..#images..")*"..#images.."+1\
        target.numberImage = numberImage\
        target.image_path = '"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[numberImage]..'.png'\
        target.fill = {type = \'image\', filename = '"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[numberImage]..'.png', baseDir = system.DocumentsDirectory}\
        target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\
        target.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\
        local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\
        local g = pocketupFuns.cos(target.property_color+56)/2+0.724\
        local b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\
        target:setFillColor(r,g,b)\
        if (target.property_color~=100) then\
            target.fill.effect = 'filter.brightness'\
            target.fill.effect.intensity = (target.property_brightness)/100-1\
        end\n"
        if (o==1) then
            lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
        end
        lua = lua.."if (target.parent_obj==target) then\
            local objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\
            if (objectsTable[target.infoSaveVisPos][3]==nil) then\
                objectsTable[target.infoSaveVisPos][3] = {}\
            end\
            objectsTable[target.infoSaveVisPos][3].path = target.image_path\
            funsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\
        end"
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == 'clone' then
        add_pcall()
        if (infoBlock[2][1][2]~=nil) then
            lua = lua.."\nlocal target = objects['object_"..infoBlock[2][1][2].."']"
        end
        lua = lua.."\nlocal myClone\nif (target.parent_obj.countImages>0) then"
        lua = lua.."\nmyClone = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)"
        lua = lua.."\nmyClone.image_path = target.image_path\nfor k, v in pairs(target.parent_obj.namesVars) do\nmyClone[v] = 0\nend\nfor k, v in pairs(target.parent_obj.namesLists) do\nmyClone[v] = {}\nend"
        lua = lua.."\nelse"
        lua = lua.."\nmyClone = display.newImage('images/notVisible.png', target.x, target.y)"
        lua = lua.."\nend"
        lua = lua.."\ntarget.group:insert(myClone)\nmyClone.group = target.group"
        lua = lua.."\nmyClone:addEventListener('touch', function(event)\nif (event.phase=='began') then\nlocal newIdTouch=globalConstants.touchId+1\nglobalConstants.touchId = newIdTouch\nglobalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\nglobalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\ndisplay.getCurrentStage():setFocus(event.target, event.id)\nevent.target.isTouch = true\nfor key, value in pairs(objects) do\nfor i=1, #events_touchScreen[key] do\nevents_touchScreen[key][i](value)\nfor i2=1, #value.clones do\nevents_touchScreen[key][i](value.clones[i2])\nend\nend\nend\nfor i=1, #myClone.parent_obj.events_touchObject do\nmyClone.parent_obj.events_touchObject[i](event.target)\nend\nelseif (event.phase=='moved') then\
            globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
            globalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
            -- for key, value in pairs(objects) do\
            --     for i=1, #events_movedScreen[key] do\
            --         events_movedScreen[key][i](value)\
            --         for i2=1, #value.clones do\
            --             events_movedScreen[key][i](value.clones[i2])\
            --         end\
            --     end\
            -- end\
            -- for i=1, #myClone.parent_obj.events_movedObject do\
            --     myClone.parent_obj.events_movedObject[i](event.target)\
            -- end\
        else\ndisplay.getCurrentStage():setFocus(event.target, nil)\nevent.target.isTouch = nil\
            globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\
            if (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then\
                globalConstants.keysTouch = {}\
                globalConstants.isTouch = false\nend\
                -- for key, value in pairs(objects) do\
                --     for i=1, #events_onTouchScreen[key] do\
                --         events_onTouchScreen[key][i](value)\
                --         for i2=1, #value.clones do\
                --             events_onTouchScreen[key][i](value.clones[i2])\
                --         end\
                --     end\
                -- end\
                -- for i=1, #myClone.parent_obj.events_onTouchObject do\
                --     myClone.parent_obj.events_onTouchObject[i](event.target)\
                -- end\
            end\
            return(true)\
        end)"
        lua = lua.."\nmyClone.xScale, myClone.yScale, myClone.alpha, myClone.rotation, myClone.numberImage, myClone.parent_obj = target.xScale, target.yScale, target.alpha, target.rotation, target.numberImage, target.parent_obj"
        lua = lua.."\nmyClone.fill.effect = 'filter.brightness'\nmyClone.property_brightness = target.property_brightness\nmyClone.fill.effect.intensity = (target.property_brightness)/100-1"


        lua = lua.."\nmyClone.parent_obj = target\ntarget.parent_obj.clones[#target.parent_obj.clones+1] = myClone\nmyClone.idClone, myClone.tableVarShow, myClone.origWidth, myClone.origHeight, myClone.width, myClone.height, myClone.property_size = #target.parent_obj, {}, target.origWidth, target.origHeight, target.width, target.height, target.property_size"
        lua = lua.."\nmyClone.isVisible = target.isVisible\nmyClone.physicsReload, myClone.physicsType , myClone.physicsTable = target.physicsReload or function(ob) end, target.physicsType or 'static' , plugins.json.decode(plugins.json.encode(target.physicsTable)) or {}\nmyClone:physicsReload()"
        lua = lua.."\nmyClone.property_color = target.property_color\nlocal r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\nmyClone:setFillColor(r,g,b)\nmyClone.touchesObjects = {}"
        lua = lua.."\ntimer.new(0, function()\nmyClone:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = true\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_collision do\nmyClone.parent_obj.events_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = nil\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_endedCollision do\nmyClone.parent_obj.events_endedCollision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nend\nend)"
        lua = lua.."\nmyClone.gravityScale, myClone.isSensor = target.gravityScale, target.isSensor"
        lua = lua.."\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_startClone do\nmyClone.parent_obj.events_startClone[i](myClone)\nend\n"
        lua = lua.."\nend) end)"
        end_pcall()
--         add_pcall()
--         if (infoBlock[2][1][2]~=nil) then
--             lua = lua.."local target = objects['object_"..infoBlock[2][1][2].."']\n"
--         end
--         lua = lua..
--         "local myClone\
--             if (target.parent_obj.countImages>0) then\
--                 myClone = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)\
--                 myClone.image_path = target.image_path\
--                 for k, v in pairs(target.parent_obj.namesVars) do\
--                     myClone[v] = 0\
--                 end\
--                 for k, v in pairs(target.parent_obj.namesLists) do\
--                     myClone[v] = {}\
--                 end\
--             else\
--                 myClone = display.newImage('images/notVisible.png', target.x, target.y)\
--             end\
--             target.group:insert(myClone)\
--             myClone.group = target.group\
--             myClone:addEventListener('touch', function(event)\
--             if (event.phase=='began') then\
--                 local newIdTouch=globalConstants.touchId+1\
--                 globalConstants.touchId = newIdTouch\
--                 globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\
--                 globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
--                 display.getCurrentStage():setFocus(event.target, event.id)\
--                 event.target.isTouch = true\
--                 for key, value in pairs(objects) do\
--                     for i=1, #events_touchScreen[key] do\
--                         events_touchScreen[key][i](value)\
--                         for i2=1, #value.clones do\
--                             events_touchScreen[key][i](value.clones[i2])\
--                         end\
--                     end\
--                 end\
--                 for i=1, #myClone.parent_obj.events_touchObject do\
--                     myClone.parent_obj.events_touchObject[i](event.target)\
--                 end\
--             elseif (event.phase=='moved') then\
--                 globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
--                 globalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
--                 -- for key, value in pairs(objects) do\
--                 --     for i=1, #events_movedScreen[key] do\
--                 --         events_movedScreen[key][i](value)\
--                 --         for i2=1, #value.clones do\
--                 --             events_movedScreen[key][i](value.clones[i2])\
--                 --         end\
--                 --     end\
--                 -- end\
--                 -- for i=1, #myClone.parent_obj.events_movedObject do\
--                 --     myClone.parent_obj.events_movedObject[i](event.target)\
--                 -- end\
--             else\
--                 display.getCurrentStage():setFocus(event.target, nil)\
--                 event.target.isTouch = nil\
--                 globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\nif (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then\
--                 globalConstants.keysTouch = {}\
--                 globalConstants.isTouch = false\
--                 end\
--                 -- for key, value in pairs(objects) do\
--                 --     for i=1, #events_onTouchScreen[key] do\
--                 --         events_onTouchScreen[key][i](value)\
--                 --         for i2=1, #value.clones do\
--                 --             events_onTouchScreen[key][i](value.clones[i2])\
--                 --         end\
--                 --     end\
--                 -- end\
--                 -- for i=1, #myClone.parent_obj.events_onTouchObject do\
--                 --     myClone.parent_obj.events_onTouchObject[i](event.target)\
--                 -- end\
--             end\
--             return(true)\
--             end)\
--             myClone.xScale, myClone.yScale, myClone.alpha, myClone.rotation, myClone.numberImage, myClone.parent_obj = target.xScale, target.yScale, target.alpha, target.rotation, target.numberImage, target.parent_obj\
--             myClone.fill.effect = 'filter.brightness'\
--             myClone.property_brightness = target.property_brightness\
--             myClone.fill.effect.intensity = (target.property_brightness)/100-1\
--             myClone.parent_obj = target\
--             target.parent_obj.clones[#target.parent_obj.clones+1] = myClone\
--             myClone.idClone, myClone.tableVarShow, myClone.origWidth, myClone.origHeight, myClone.width, myClone.height, myClone.property_size = #target.parent_obj, {}, target.origWidth, target.origHeight, target.width, target.height, target.property_size\
--             myClone.isVisible = target.isVisible\
--             myClone.physicsReload, myClone.physicsType , myClone.physicsTable = target.physicsReload or function(ob) end, target.physicsType or 'static' , plugins.json.decode(plugins.json.encode(target.physicsTable)) or {}\
--             myClone:physicsReload()\
--             myClone.property_color = target.property_color\
--             local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\
--             local g = pocketupFuns.cos(target.property_color+56)/2+0.724\
--             local b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\
--             myClone:setFillColor(r,g,b)\
--             timer.new(0, function()\
--             myClone:addEventListener('collision', function(event)\
--             if (event.phase=='began') then\
--                 event.target.isTouchObject = true\
--                 timer.new(0, function()\
--                     for i=1, #myClone.parent_obj.events_collision do\
--                         myClone.parent_obj.events_collision[i](event.target, event.other.parent_obj.nameObject)\
--                     end\
--                 end)\
--             elseif (event.phase=='ended') then\
--                 event.target.isTouchObject = nil\
--                 timer.new(0, function()\
--                     for i=1, #myClone.parent_obj.events_endedCollision do\
--                         myClone.parent_obj.events_endedCollision[i](event.target, event.other.parent_obj.nameObject)\
--                     end\
--                 end)\
--             end\
--         end)\
--         myClone.gravityScale, myClone.isSensor = target.gravityScale, target.isSensor\
--         timer.new(0, function()\
--             for i=1, #myClone.parent_obj.events_startClone do\
--                 myClone.parent_obj.events_startClone[i](myClone)\
--         end\
--     end)\
-- end)"
--         end_pcall()
    elseif nameBlock == 'deleteClone' then
        add_pcall()
        lua = lua.."if (target) then\
            table.remove(target.parent_obj.clones, target.idClone)\
            for i=1, #target.parent_obj.clones do\
                target.parent_obj.clones[i].idClone = i\
            end\
            display.remove(target)\
        end\n"
        end_pcall()
        add_pcall()
        lua = lua..
        "if true then\
            pcall(function() timer.cancel(_repeat) end)\
            return true\
        end"
        end_pcall()
    elseif (nameBlock == 'broadcastFunction' and infoBlock[2][1][2]~=nil) then
        add_pcall()
        lua = lua..
        "timer.new(0, function()\
            broadcastFunction('fun_"..infoBlock[2][1][2].."')\
        end)"
        end_pcall()
    elseif nameBlock == 'vibration' then
        local time = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "timer.new(100,function()\
            system.vibrate('impact')\
        end , (("..time..")*1000)/100)"
        end_pcall()
    elseif nameBlock == 'goSteps' then
        local steps = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."target:translate(pocketupFuns.sin(target.rotation)*("..steps.."),- (pocketupFuns.cos(target.rotation)*"..steps.."))"
        end_pcall()
    elseif nameBlock == 'speedStepsToSecoond' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua.."target:setLinearVelocity("..x..",-"..y..")"
        end_pcall()
    elseif nameBlock == 'rotateLeftForever' then
        local force = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."target:applyTorque(-"..force.."*100)"
        end_pcall()
    elseif nameBlock == 'rotateRightForever' then
        local force = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."target:applyTorque("..force.."*100)"
        end_pcall()
    elseif nameBlock == 'setBrightness' or nameBlock=='editBrightness' then
        local brig = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "target.fill.effect = 'filter.brightness'\
        target.property_brightness = math.max(math.min(("..(nameBlock=="setBrightness" and '' or 'target.property_brightness)+(')..brig.."), 200),0)\
        target.fill.effect.intensity = target.property_brightness/100-1"
        end_pcall()
    elseif nameBlock == 'playSound' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..
        "if not playSounds["..infoBlock[2][1][2].."] then\
            playSounds["..infoBlock[2][1][2].."] = audio.loadSound('"..obj_path.."/sound_"..infoBlock[2][1][2]..".mp3', system.DocumentsDirectory)\
        end\
        audio.stop(playingSounds["..infoBlock[2][1][2].."])\
        playingSounds["..infoBlock[2][1][2].."] = audio.play(playSounds[".. infoBlock[2][1][2].."])"
        end_pcall()
    elseif nameBlock == 'stopSound' and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..
        "audio.stop(playingSounds["..infoBlock[2][1][2].."])\
        audio.dispose(playSounds[".. infoBlock[2][1][2].."])\
        playSounds[".. infoBlock[2][1][2]..'] = nil'
        end_pcall()
    elseif nameBlock == 'stopAllSounds' then
        add_pcall()
        lua = lua..
        "audio.stop()\
        audio.dispose()\
        playSounds = {}"
        end_pcall()
    elseif nameBlock == 'setVolumeSound' then
        local volume = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."audio.setVolume("..volume.."/100 )"
        end_pcall()
    elseif nameBlock == 'editVolumeSound' then
        local volume = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."audio.setVolume(audio.getVolume() + "..volume.."/100 )"
        end_pcall()
    elseif nameBlock == 'for' then
        local one = make_all_formulas(infoBlock[2][1], object)
        local _end = make_all_formulas(infoBlock[2][2], object)
        max_fors = max_fors+1
        lua = lua.."for i"..max_fors.." = (type("..one..") == 'number' and "..one.." or 0) , type(".._end..") == 'number' and ".._end.." or 0, 1 do\n"
        if (infoBlock[2][3][2]~=nil) then
            if infoBlock[2][3][1] == "globalVariable" then
                lua = lua.."var_"..infoBlock[2][3][2].." = i"..max_fors.."\n"
            else
                lua = lua.."target.var_"..infoBlock[2][3][2].." = i"..max_fors.."\n"
            end
        end
    elseif nameBlock == 'endFor' then
        lua = lua.."end"
    elseif (nameBlock == "addBody") then
        add_pcall()
        if (infoBlock[2][1][2]~="noPhysic") then
            lua = lua..'target.physicsTable = {outline = graphics.newOutline(10, target.image_path, system.DocumentsDirectory), density=3, friction=0.3, bounce=0.3}\ntarget.physicsType = \''..infoBlock[2][1][2]..'\'\n'
            lua = lua..'target.physicsReload = function(target)\nlocal oldTypeRotation = target.isFixedRotation\nplugins.physics.removeBody(target)\n'
            lua = lua.."plugins.physics.addBody(target, target.physicsType , target.physicsTable)\ntarget.isFixedRotation = oldTypeRotation\nend"
            lua = lua..'\ntarget:physicsReload()'
            lua = lua.."\ntarget:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = true\ntimer.new(0, function()\nfor i=1, #events_collision do\nevents_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = nil\ntimer.new(0, function()\nfor i=1, #events_endedCollision do\nevents_endedCollision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nend\nend)"
        else
            lua = lua.."plugins.physics.removeBody(target)\ntarget.physicsReload = nil\ntarget.touchesObjects = {}"
        end
        end_pcall()
        -- add_pcall()
        -- if (infoBlock[2][1][2]~="noPhysic") then
        --     lua = lua..
        --     "target.physicsTable = {outline = graphics.newOutline(10, target.image_path, system.DocumentsDirectory), density=3, friction=0.3, bounce=0.3}\
        --     target.physicsType = '"..infoBlock[2][1][2].."'\
        --     target.physicsReload = function(target)\
        --         local oldTypeRotation = target.isFixedRotation\
        --         plugins.physics.removeBody(target)\
        --         plugins.physics.addBody(target, target.physicsType , target.physicsTable)\
        --         target.isFixedRotation = oldTypeRotation\
        --     end\
        --     target:physicsReload()\
        --     target:addEventListener('collision', function(event)\
        --     if (event.phase=='began') then\
        --         event.target.isTouchObject = true\
        --         timer.new(0, function()\
        --             for i=1, #events_collision do\
        --                 events_collision[i](event.target, event.other.parent_obj.nameObject)\
        --             end\
        --         end)\
        --     elseif (event.phase=='ended') then\
        --         event.target.isTouchObject = nil\
        --         timer.new(0, function()\
        --             for i=1, #events_endedCollision do\
        --                 events_endedCollision[i](event.target, event.other.parent_obj.nameObject)\
        --             end\
        --         end)\
        --     end\
        --     end)"
        -- else
        --     lua = lua..
        --     "plugins.physics.removeBody(target)\
        --     target.physicsReload = nil"
        -- end
        -- end_pcall()
    elseif nameBlock == 'setGravityAllObjects' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        lua = lua.."plugins.physics.setGravity("..x..",-"..y..")"
        end_pcall()
    elseif nameBlock == 'setWeight' then
        local mass = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "target.physicsTable.density = "..mass.."\
        target:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setElasticity' then
        local bounce = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "target.physicsTable.bounce = "..bounce.."/100\
        target:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setFriction' then
        local friction = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua..
        "target.physicsTable.friction = "..friction.."/100\
        target:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setTypeRotate' then
        if infoBlock[2][1][2] == 'true' then
            lua = lua.."target.isFixedRotation = false"
        elseif infoBlock[2][1][2] == 'false' then
            lua = lua.."target.isFixedRotation = true"
        end
    elseif nameBlock == 'goTo' then
        add_pcall()
        if infoBlock[2][1][2] == 'touch' then
            lua = lua.."target.x , target.y = globalConstants.touchX, -globalConstants.touchY"
        elseif infoBlock[2][1][2] == 'random' then
            lua = lua.."target.x, target.y = math.random(-"..(tostring(options.orientation == "vertical" and options.displayWidth/2 or options.displayHeight/2))..",\
            "..(tostring(options.orientation == "vertical" and options.displayWidth/2 or options.displayHeight/2)).."),\
            math.random(-"..tostring(options.orientation == "vertical" and options.displayHeight/2 or options.displayWidth/2)..","..tostring(options.orientation == "vertical" and options.displayHeight/2 or options.displayWidth/2)..")"
        else
            lua = lua.."local object = objects['object_"..infoBlock[2][1][2].."']\
            target.x, target.y = object.x, object.y"
        end
        end_pcall()
    elseif nameBlock == 'setRotateToObject' and infoBlock[2][1][2]~=nil then -- ["setRotateToObject",[["objects",7]],"on"]
        add_pcall()
        lua = lua.."if ( objects['object_"..infoBlock[2][1][2].."']~=nil) then\
            target.rotation = pocketupFuns.atan2(objects['object_"..infoBlock[2][1][2].."'].x - target.x, target.y - objects['object_"..infoBlock[2][1][2].."'].y)\
        end\
        if (target.parent_obj==target) then\
            local objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\
            if (objectsTable[target.infoSaveVisPos][3]==nil) then\
                objectsTable[target.infoSaveVisPos][3] = {}\
            end\
            objectsTable[target.infoSaveVisPos][3].rotation = target.rotation\
            funsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\
        end"
        end_pcall()
    elseif nameBlock == 'toFrontLayer' then
        lua = lua.."target:toFront()"
    elseif nameBlock == 'setImageToName' and #images>0 and infoBlock[2][1][2]~=nil then
        local image = infoBlock[2][1][2]
        
        if (image~=nil) then
            add_pcall()
            lua = lua.."local newIdImage = nil\nfor i=1, #listImages do\nif (listImages[i]=="..image..") then\nnewIdImage=i\nbreak\nend\nend\nif (newIdImage ~= nil) then"
            lua = lua..'\ntarget.numberImage = newIdImage\ntarget.image_path = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\'\n'
            lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\', baseDir = system.DocumentsDirectory}\n'
            lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
            lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
            lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
            if (o==1) then
                lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            lua = lua.."end\n"
            lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
            end_pcall()
        end
    elseif nameBlock == "nextImage" and #images>1 then
        add_pcall()
        lua = lua.."target.numberImage = target.numberImage==#listImages and 1 or target.numberImage+1\ntarget.image_path='"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
        lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == "previousImage" and #images>1 then
        add_pcall()
        lua = lua.."target.numberImage = target.numberImage==1 and #listImages or target.numberImage-1\ntarget.image_path='"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
        lua = lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        lua = lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        lua = lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == "editAlpha" then
        add_pcall()
        lua = lua.."target.alpha = target.alpha - "..make_all_formulas(infoBlock[2][1], object).."/100"
        end_pcall()
    elseif nameBlock=="setColor" or nameBlock=="editColor" then
        add_pcall()
        lua = lua..
        "target.property_color = ("..(nameBlock=="setColor" and '' or "target.property_color)+(")..make_all_formulas(infoBlock[2][1],object)..")\
        local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\
        local g = pocketupFuns.cos(target.property_color+56)/2+0.724\
        local b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\
        target:setFillColor(r,g,b)"
        end_pcall()
    elseif nameBlock == 'setImageBackgroundToName' and #images>0 and infoBlock[2][1][2]~=nil then
        local image = infoBlock[2][1][2]

        if (image~=nil) then
            add_pcall()
            lua = lua.."local newIdImage = nil\nfor i=1, #background.listImagesBack do\nif (background.listImagesBack[i]=="..image..") then\nnewIdImage=i\nbreak\nend\nend\nif (newIdImage ~= nil) then"
            lua = lua..'\nbackground.numberImage = newIdImage\nbackground.image_path = background.obj_pathBack..\'/image_'..image..'.png\'\n'
            lua = lua..'background.fill = {type = \'image\', filename = background.image_path, baseDir = system.DocumentsDirectory}\n'
            lua = lua.."background.origWidth, background.origHeight = getImageProperties(background.image_path, system.DocumentsDirectory)\nbackground.width, background.height = background.origWidth*(background.property_size/100), background.origHeight*(background.property_size/100)\n"
            lua = lua.."local r = pocketupFuns.sin(background.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(background.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(background.property_color+22+56)/2+0.724\nbackground:setFillColor(r,g,b)\n"
            lua = lua.."if (background.property_color~=100) then\nbackground.fill.effect = 'filter.brightness'\nbackground.fill.effect.intensity = (background.property_brightness)/100-1\nend\n"
            if (o==1) then
                lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            lua = lua.."end\n"
            end_pcall()
        end
    elseif nameBlock == 'setImageBackgroundToId' and #images>0 then
        local image = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/#background.listImagesBack)*#background.listImagesBack+1"
        lua = lua..'\nbackground.numberImage = numberImage\nbackground.image_path = background.obj_pathBack..\'/image_\'..background.listImagesBack[numberImage]..\'.png\'\n'
        lua = lua..'background.fill = {type = \'image\', filename = background.image_path, baseDir = system.DocumentsDirectory}\n'
        lua = lua.."background.origWidth, background.origHeight = getImageProperties(background.image_path, system.DocumentsDirectory)\nbackground.width, background.height = background.origWidth*(background.property_size/100), background.origHeight*(background.property_size/100)\n"
        lua = lua.."local r = pocketupFuns.sin(background.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(background.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(background.property_color+22+56)/2+0.724\nbackground:setFillColor(r,g,b)\n"
        lua = lua.."if (background.property_color~=100) then\nbackground.fill.effect = 'filter.brightness'\nbackground.fill.effect.intensity = (background.property_brightness)/100-1\nend\n"
        if (o==1) then
            lua = lua.."broadcastChangeBackground(listImages[numberImage])\n"
        end
        end_pcall()
    elseif nameBlock=='getLinkImage' then
        add_pcall()
        lua = lua.."local function networkListener(event)\
            if (target~=nil and target.x~=nil) then\
                target.image_path = 'objectImage_"..obj_id..".png'\
                target.fill = {type = 'image', filename = target.image_path, baseDir=system.TemporaryDirectory}\
                target.origWidth, target.origHeight = getImageProperties(target.image_path, system.TemporaryDirectory)\
                target.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\
            end\
        end\
        network.download("..make_all_formulas(infoBlock[2][1],object)..",'GET', networkListener, 'objectImage_"..obj_id..".png', system.TemporaryDirectory)"
        end_pcall()
    elseif nameBlock == 'stamp' then
        add_pcall()
        lua = lua..'local obj = #tableFeathers+1\nlocal myObj = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)\ntableFeathers[obj] = myObj\nstampsGroup:insert(myObj)\n'
        lua = lua..'myObj.width, myObj.height, myObj.alpha, myObj.rotation, myObj.xScale, myObj.yScale = target.width, target.height, target.alpha, target.rotation, target.xScale, target.yScale\n'
        lua = lua.."local r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\nmyObj:setFillColor(r,g,b)\n"
        lua = lua.."if (target.property_color~=100) then\nmyObj.fill.effect = 'filter.brightness'\nmyObj.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        end_pcall()
    elseif nameBlock == 'clearPen' then
        add_pcall()
        lua = lua..
        "for i = 1, #tableFeathers, 1 do\
            display.remove(tableFeathers[i])\
        end\
        tableFeathers = {}"
        end_pcall()
    elseif nameBlock == 'setColorPen' then
        local r = make_all_formulas(infoBlock[2][1], object)
        local g = make_all_formulas(infoBlock[2][2], object)
        local b = make_all_formulas(infoBlock[2][3], object)
        add_pcall()
        lua = lua..
        "tableFeathersOptions[2] = "..r.."\
        tableFeathersOptions[3] = "..g.."\
        tableFeathersOptions[4] = "..b
        end_pcall()
    elseif nameBlock == 'setSizePen' then
        local size = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        lua = lua.."tableFeathersOptions[1] = "..size
        end_pcall()
    elseif nameBlock == 'blockTouch' then
        lua = lua..
        "for i=1, #events_touchObject, 1 do\
            events_touchObject[i](target)\
        end"
    elseif nameBlock == 'blockTouchScreen' then
        lua = lua..
            "for key, value in pairs(objects) do\
                for i=1, #events_touchScreen[key] do\
                    events_touchScreen[key][i](value)\
                    for i2=1, #value.clones do\
                        events_touchScreen[key][i](value.clones[i2])\
                    end\
                end\
            end"
    elseif nameBlock == 'showVariable' and infoBlock[2][1][2]~=nil then
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
        local var = infoBlock[2][1][2]
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..
            "if (varText_"..var.."~=nil and varText_"..var..".text~=nil) then\
                display.remove(varText_"..var..")\
            end\
            varText_"..var.." = display.newText(type(var_"..var..")=='boolean' and (var_"..var.." and app.words[373] or app.words[374]) or type(var_"..var..")=='table' and encodeList(var_"..var..") or var_"..var..", "..x..", -"..y..", 'fonts/font_1', 35)\
            varText_"..var..":setFillColor(0, 0, 0)\
            cameraGroup:insert(varText_"..var..")"
            -- lua = lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..')\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText(type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 35)\n'
            -- lua = lua..'varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            -- lua = lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
        else
            lua = lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..')\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText(type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 38)\n'
            lua = lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            lua = lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
        end
        end_pcall()
    elseif nameBlock == 'showVariable2' and infoBlock[2][1][2]~=nil then
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)
        local size = make_all_formulas(infoBlock[2][4], object)
        local hex = make_all_formulas(infoBlock[2][5], object)
        local aligh = infoBlock[2][6][2]
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..')\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText({text = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', align="'..aligh..'", x = '..x..', y = - '..y..', font = nil, fontSize = 30 *('..size..'/100) })\n'
            lua = lua..'local rgb = utils.hexToRgb('..hex..')\n'
            lua = lua..'varText_'..infoBlock[2][1][2]..':setFillColor(rgb[1], rgb[2], rgb[3])'
            lua = lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
        else
            lua = lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..')\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText({text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', align="'..aligh..'", x = '..x..', y = - '..y..', font = nil, fontSize = 30 *('..size..'/100) })\n'
            lua = lua..'local rgb = utils.hexToRgb('..hex..')\n'
            lua = lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(rgb[1], rgb[2], rgb[3])'
            lua = lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
        end
        end_pcall()
    elseif nameBlock == 'hideVariable' and infoBlock[2][1][2]~=nil then
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            lua = lua..'display.remove(varText_'..infoBlock[2][1][2]..')\nvarText_'..infoBlock[2][1][2]..' = nil'
        else
            lua = lua..'display.remove(target.varText_'..infoBlock[2][1][2]..')\ntarget.varText_'..infoBlock[2][1][2]..' = nil'
        end
        end_pcall()
    elseif nameBlock == 'focusCameraToObject' then
        add_pcall()
        lua = lua.."if (focusCameraObject == nil) then\nfocusCameraObject = target\ntarget.timerCamera = timer.new(0, function()\ncameraGroup.x, cameraGroup.y = -focusCameraObject.x + math.max(math.min(focusCameraObject.x+cameraGroup.x,"..tostring(options.displayWidth/2).."/100*"..make_all_formulas(infoBlock[2][1], object).."),-"..tostring(options.displayWidth/2).."/100*"..make_all_formulas(infoBlock[2][1], object).."), -focusCameraObject.y + math.max(math.min(focusCameraObject.y+cameraGroup.y,"..tostring(options.displayHeight/2).."/100*"..make_all_formulas(infoBlock[2][2], object).."),-"..tostring(options.displayHeight/2).."/100*"..make_all_formulas(infoBlock[2][2], object)..") \nend, 0)\nelse\nfocusCameraObject = target\nend"
        end_pcall()
    elseif nameBlock=="removeObjectCamera" then
        add_pcall()
        lua = lua.."notCameraGroup:insert(target)\ntarget.group = notCameraGroup"
        end_pcall()
    elseif nameBlock=="insertObjectCamera" then
        add_pcall()
        lua = lua.."cameraGroup:insert(target)\ntarget.group = cameraGroup"
        end_pcall()
    elseif nameBlock=="removeVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\nnotCameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
        end_pcall()
     elseif nameBlock=="insertVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\ncameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
        end_pcall()
    elseif nameBlock=="removeFocusCameraToObject" then
        add_pcall()
        lua = lua.."if (focusCameraObject~=nil) then\ntimer.cancel(focusCameraObject.timerCamera)\nfocusCameraObject = nil\nend"
        end_pcall()
    elseif nameBlock=="saveVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
        lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\narrayVariables[i][3] = '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables", plugins.json.encode(arrayVariables))\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="readVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
        lua = lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'= arrayVariables[i][3]~=nil and arrayVariables[i][3] or 0\nbreak\nend\nend'
        lua = lua..'\nif '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..' then\n '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="boolean" and ('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="table" and encodeList('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..') or '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nend'
        end_pcall()
    elseif nameBlock=="addElementArray" and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."[#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1] = "..make_all_formulas(infoBlock[2][1], object)
        end_pcall()
    elseif nameBlock=="deleteElementArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."table.remove("..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..", "..make_all_formulas(infoBlock[2][2],object)..")"
        end_pcall()
    elseif nameBlock=="deleteAllElementsArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].." = {}"
        end_pcall()
    elseif nameBlock=="pasteElementArray" and infoBlock[2][2][2]~=nil then
        add_pcall()
         lua = lua.."if ("..make_all_formulas(infoBlock[2][3], object).."<=#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1 and "..make_all_formulas(infoBlock[2][3], object)..">0) then\ntable.insert("..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2]..", "..make_all_formulas(infoBlock[2][3], object)..", "..make_all_formulas(infoBlock[2][1], object)..")\nend"
        end_pcall()
    elseif nameBlock=="replaceElementArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua.."if ("..make_all_formulas(infoBlock[2][2], object).."<=#"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."+1 and "..make_all_formulas(infoBlock[2][2], object)..">0) then\n"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."["..make_all_formulas(infoBlock[2][2],object).."] = "..make_all_formulas(infoBlock[2][3],object).."\nend"
        end_pcall()
    elseif nameBlock=="saveArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
        lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\narrayArrays[i][3] = '..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays", plugins.json.encode(arrayArrays))\nbreak\nend\nend\nprint(plugins.json.encode(list_1))'
        end_pcall()
    elseif nameBlock=="readArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
        lua = lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'= arrayArrays[i][3]~=nil and arrayArrays[i][3] or {}\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="columnStorageToArray" and infoBlock[2][3][2]~=nil then
        add_pcall()
        lua = lua.."local allArraysValues = plugins.json.decode('[\"'.."..make_all_formulas(infoBlock[2][2], object)..":gsub('\"','\\\\\"'):gsub('\\r\\n','\",\"'):gsub('\\n','\",\"')..'\"]')"
        lua = lua.."\nfor i=1, #allArraysValues do\nlocal values = plugins.json.decode('[\"'..allArraysValues[i]:gsub('\\\"','\\\\\"'):gsub(',','\",\"')..'\"]')\nallArraysValues[i] = values["..make_all_formulas(infoBlock[2][1], object).."]==nil and '' or values["..make_all_formulas(infoBlock[2][1], object).."]\nend"
        lua = lua.."\n"..(infoBlock[2][3][1]=="globalArray" and '' or 'target.').."list_"..infoBlock[2][3][2].." = allArraysValues"
        end_pcall()
    elseif nameBlock=="getRequest" and infoBlock[2][2][2]~=nil then
        add_pcall()
        lua = lua..
        "local function networkListener(event)\
            if (mainGroup~=nil and mainGroup.x~=nil) then\
                "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." = event.response\nif ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..") then\n"..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][2][2]..".text = type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and app.words[373] or app.words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].."\
                end\
            end\
        end\
        local header = {headers={[\"User-Agent\"] = \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36\"}}\
        network.request("..make_all_formulas(infoBlock[2][1],object)..",'GET',networkListener, header)"
        end_pcall()
    elseif nameBlock=="exitGame" then
        add_pcall()
        lua = lua..
        "timer.new(0, function()\
            display.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})\
            funBackListener2({keyName='deleteBack', phase='up'})\
        end)"
        end_pcall()
    elseif nameBlock=="runScene" and infoBlock[2][1][2]~=nil then
        add_pcall()
        lua = lua..
        "deleteScene()\
        scene_"..infoBlock[2][1][2].."()"
        end_pcall()
    elseif nameBlock == 'foreach'then
        max_fors = max_fors+1
        if (infoBlock[2][1][2]==nil or infoBlock[2][2][2]==nil ) then
            infoBlock[2][1][2] = "nil"
            infoBlock[2][2][2] = "nil"
        end
        lua = lua..'for key'..max_fors..', value'..max_fors..' in pairs('
        lua = lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..') do\n'
        lua = lua..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' = value'..max_fors..'\n'
        lua = lua..'if '..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and app.words[373] or app.words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..'\nend'
    elseif nameBlock == 'endForeach' then
        lua = lua.."end"
    elseif nameBlock == 'lowerPen' then
        add_pcall()
        lua = lua..
        "if (target.isPen==nil) then\
        target.isPen = true\
        local line = display.newLine(target.x, target.y, target.x, target.y+1)\
        line:setStrokeColor(tableFeathersOptions[2]/255,tableFeathersOptions[3]/255,tableFeathersOptions[4]/255,1)\
        line.strokeWidth = tableFeathersOptions[1]\
        stampsGroup:insert(line)\
        local timerPen\
        timerPen = timer.new(50, function()\
            if (target.isPen and line.x) then\
                if (line.oldX~=target.x or line.oldY~=target.y) then\
                    line:append(target.x, target.y)\
                    line.oldX, line.oldY = target.x, target.y\
                end\
            elseif (line.x == nil) then\
                line = display.newLine(target.x, target.y, target.x, target.y)\
                line:setStrokeColor(tableFeathersOptions[2],tableFeathersOptions[3],tableFeathersOptions[4],1)\
                line.strokeWidth = tableFeathersOptions[1]\
                table.insert(tableFeathers, #tableFeathers+1, line)\
                stampsGroup:insert(line)\
            else\
                timer.cancel(timerPen)\
            end\
        end,0)\
        table.insert(tableFeathers, #tableFeathers+1, line)\
        end"
        end_pcall()
    elseif nameBlock == 'raisePen' then
        lua = lua.."target.isPen=nil"
    elseif nameBlock == 'waitIfTrue2' then
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua..
        "while not "..arg1.." do\
        coroutine.yield()\
        end"
    elseif nameBlock == 'showToast' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        if not utils.isWin then
            lua = lua..
            "if not utils.isSim and not utils.isWin then\
                require 'plugin.toaster'.shortToast("..arg1..")\
            end"
        end
        end_pcall()
    elseif nameBlock == 'showHitboxes' then
        add_pcall()
        lua = lua.."plugins.physics.setDrawMode('hybrid')"
        end_pcall()
    elseif nameBlock == 'hideHitboxes' then
        add_pcall()
        lua = lua.."plugins.physics.setDrawMode('normal')"
        end_pcall()
    -- elseif nameBlock == 'setHorizontalOrientation' then
    --     add_pcall()
    --     lua = lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('landscape')\nmainGroup.xScale, mainGroup.yScale = "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..", "..tostring(xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_Y, CENTER_X\nblackRectTop.width, blackRectTop.height = display.contentHeight, display.contentWidth\nblackRectTop.x, blackRectTop.y = "..("-"..tostring(options.displayHeight/2)..",0" ).."\nblackRectTop.anchorX, blackRectTop.anchorY = 1, 0.5\nblackRectBottom.width, blackRectBottom.height = display.contentHeight, display.contentWidth\nblackRectBottom.x, blackRectBottom.y = "..(tostring(options.displayHeight/2)..",0" ).."\nblackRectBottom.anchorX, blackRectBottom.anchorY = 0, 0.5"
    --     end_pcall()
    -- elseif nameBlock == 'setVerticalOrientation' then
    --     add_pcall()
    --     lua = lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('portrait')\nmainGroup.xScale, mainGroup.yScale = "..tostring(xScaleMainGroup)..", "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_X, CENTER_Y\nblackRectTop.width, blackRectTop.height = display.contentWidth, display.contentHeight\nblackRectTop.x, blackRectTop.y = "..("0,-"..tostring(options.displayHeight/2)).."\nblackRectTop.anchorY, blackRectTop.anchorX = 1, 0.5\nblackRectBottom.x, blackRectBottom.y = "..("0,"..tostring(options.displayHeight/2)).."\nblackRectBottom.anchorY, blackRectBottom.anchorX = 0, 0.5"
    --     end_pcall()
    elseif nameBlock == 'playSoundAndWait' then
        add_pcall()
        lua = lua..
        "if not playSounds["..infoBlock[2][1][2].."] then\
            playSounds["..infoBlock[2][1][2].."] = audio.loadSound('"..obj_path.."/sound_"..infoBlock[2][1][2]..".mp3', system.DocumentsDirectory)\
        end\
        pcall(function()\
            audio.stop(playingSounds["..infoBlock[2][1][2].."])\
        end)\
        playingSounds["..infoBlock[2][1][2].."] = audio.play(playSounds[".. infoBlock[2][1][2].."])"
        end_pcall()
        lua = lua.."\
        local time = audio.getDuration(playSounds["..infoBlock[2][1][2].."])\
        threadFun.wait(time)"
    elseif nameBlock == 'hideHitboxes' then
        lua = lua.."plugins.physics.setDrawMode('normal')"
    elseif nameBlock == 'showHitboxes' then
        lua = lua.."plugins.physics.setDrawMode('hybrid')"
    elseif nameBlock == 'setTextelCoarseness' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."target.physicsTable.outline = graphics.newOutline("..arg1..", target.image_path, system.DocumentsDirectory)\ntarget:physicsReload()\n"
        end_pcall()
    elseif (nameBlock=='isSensor') then
        lua = lua.."target.isSensor = "..(infoBlock[2][1][2]=="on" and "false" or "true")
    elseif nameBlock == 'stopScript' then
        lua = lua..
        "removeTheard()\
        coroutine.yield()"
    end
    return lua
end

return(make_block)