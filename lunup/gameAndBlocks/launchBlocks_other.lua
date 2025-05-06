
timer.new = timer.performWithDelay
timer.GameNew = function (time, rep, listener)
    return timer.new(time, listener, rep)
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

local isEvent = {
    start=true, touchObject=true, touchScreen=true, ["function"]=true, collision=true, changeBackground=true, startClone=true,
    endedCollision=true,
}

local function make_block(infoBlock, object, images, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options)
    if infoBlock[3] == 'off' then
        return ''
    end
    nameBlock = infoBlock[1]--args[i] = make_all_formulas(infoBlock[2][i], object)
    Lua = ''
    local waitInsert = function (time)
        Lua = Lua..'threadFun.wait('..time..'*1000)'
    end
    if nameBlock == 'wait' then
        local time = make_all_formulas(infoBlock[2][1], object)
        waitInsert(time)
    elseif nameBlock == 'setSize' or nameBlock == 'editSize' then
        local formula = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
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
        Lua = Lua..
        "target.x = "..x.."\
        target.y = -"..y
        end_pcall()
    elseif nameBlock == 'setPositionX' then
        add_pcall()
        local x = make_all_formulas(infoBlock[2][1], object)
        Lua = Lua..'target.x = '..x
        end_pcall()
    elseif nameBlock == 'setPositionY' then
        add_pcall()
        local y = make_all_formulas(infoBlock[2][1], object)
        Lua = Lua..'target.y = -'..y..''
        end_pcall()
    elseif nameBlock == 'transitionPosition' then
        local time = make_all_formulas(infoBlock[2][1], object)
        local x = make_all_formulas(infoBlock[2][2], object)
        local y = make_all_formulas(infoBlock[2][3], object)

        add_pcall()
        Lua = Lua..
        "transition.to(target, {time="..time.."*1000,\
        x="..x..", y= -"..y.."})"
        end_pcall()
        Lua = Lua.."\n"
        waitInsert(time)
    elseif nameBlock == 'editRotateLeft' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
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
        Lua = Lua..
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
        Lua = Lua.."target:translate("..x..", 0)"
        end_pcall()
    elseif nameBlock == 'editPositionY'  then
        local y = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."target:translate(0,-"..y..")"
        end_pcall()
    elseif nameBlock == 'setRotate' then
        local rotate = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
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
        Lua = Lua.."target.isVisible = false"
    elseif nameBlock == 'show' then
        Lua = Lua.."target.isVisible = true"
    elseif nameBlock == 'setAlpha' then
        local alpha = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."target.alpha = math.min(math.max(100-"..alpha..",0),100)/100"
        end_pcall()
    elseif nameBlock == 'commentary' then
        local comment = make_all_formulas(infoBlock[2][1], object)
        Lua = Lua.."-- "..comment
    elseif nameBlock == 'if' or nameBlock == 'ifElse (2)' then
        local condition = make_all_formulas(infoBlock[2][1], object)
        Lua = Lua.."if "..condition.." then"
    elseif nameBlock == 'else' then
        Lua = Lua.."else"
    elseif nameBlock == 'endIf' then
        Lua = Lua.."end"
    elseif nameBlock == 'repeat' then
        local rep = make_all_formulas(infoBlock[2][1], object)
        Lua = Lua..
        "for i=1, type("..rep..") == 'number' and "..rep.." or 0, 1 do\
        "
    elseif nameBlock == 'endRepeat' then
        Lua = Lua..
        "coroutine.yield()\
        end"
    elseif nameBlock == 'setVariable' and infoBlock[2][1][2]~=nil then
        local value = make_all_formulas(infoBlock[2][2], object)
        local var = infoBlock[2][1][2]
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            Lua = Lua..
            "var_"..var.." = "..value.."\
            if varText_"..var.." then\
                varText_"..var..".text = type(var_"..var..")=='boolean' and (var_"..var.." and app.words[373] or app.words[374]) or type(var_"..var..")=='table' and encodeList(var_"..var..") or var_"..var.."\
            end"
        else
            Lua = Lua..
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
            Lua = Lua..
            "var_"..var.." = type(var_"..var..")=='boolean' and (var_"..var.." and app.words[373] or app.words[374]) or type(var_"..var..")=='table' and encodeList(var_"..var..") or var_"..var.."+"..value.."\
            if varText_"..var.." then\
                varText_"..var..".text = var_"..var.."\
            end"
        else
            Lua = Lua..
            "target.var_"..var.." = target.var_"..var.." + "..value.."\
            if target.varText_"..var.." then\
                target.varText_"..var..".text = type(target.var_"..var..")=='boolean' and (target.var_"..var.." and app.words[373] or app.words[374]) or type(target.var_"..var..")=='table' and encodeList(target.var_"..var..") or target.var_"..var.."\
            end"
        end
        end_pcall()
    elseif nameBlock == 'openLink' then
        local link = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."system.openURL("..link..")"
        end_pcall()
    elseif nameBlock == 'cycleForever' then

        Lua = Lua..
        "while true do"
    elseif nameBlock == 'endCycleForever' then
        Lua = Lua..
        "coroutine.yield()\
        end"
    elseif nameBlock == 'repeatIsTrue' then
        local condition = make_all_formulas(infoBlock[2][1], object)
        Lua = Lua..
        "while "..condition.." do"
    elseif nameBlock == 'setImageToId' and #images>0 then
        local image = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
        "local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/"..#images..")*"..#images.."+1\
        target.numberImage = numberImage\
        target.image_path = '"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[numberImage]..'.png'\
        target.fill = {type = \'image\', filename = '"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[numberImage]..'.png', baseDir = system.DocumentsDirectory}\
        target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\
        target.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\
        local r = lunupFuns.sin(target.property_color-22+56)/2+0.724\
        local g = lunupFuns.cos(target.property_color+56)/2+0.724\
        local b = lunupFuns.sin(target.property_color+22+56)/2+0.724\
        target:setFillColor(r,g,b)\
        if (target.property_color~=100) then\
            target.fill.effect = 'filter.brightness'\
            target.fill.effect.intensity = (target.property_brightness)/100-1\
        end\n"
        if (o==1) then
            Lua = Lua.."broadcastChangeBackground(listImages[numberImage])\n"
        end
        Lua = Lua.."if (target.parent_obj==target) then\
            local objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\
            if (objectsTable[target.infoSaveVisPos][3]==nil) then\
                objectsTable[target.infoSaveVisPos][3] = {}\
            end\
            objectsTable[target.infoSaveVisPos][3].path = target.image_path\
            funsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\
        end"
        Lua = Lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == 'clone' then
        add_pcall()
        if (infoBlock[2][1][2]~=nil) then
            Lua = Lua.."\nlocal target = objects['object_"..infoBlock[2][1][2].."']"
        end
        Lua = Lua.."\nlocal myClone\
        if (target.parent_obj.countImages>0) then"
        Lua = Lua.."\nmyClone = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)"
        Lua = Lua.."\nmyClone.image_path = target.image_path\
        for k, v in pairs(target.parent_obj.namesVars) do\
            myClone[v] = 0\
        end\
        for k, v in pairs(target.parent_obj.namesLists) do\
            myClone[v] = {}\
        end"
        Lua = Lua.."\nelse"
        Lua = Lua.."\nmyClone = display.newImage('images/notVisible.png', target.x, target.y)"
        Lua = Lua.."\nend"
        Lua = Lua.."\ntarget.group:insert(myClone)\
        myClone.group = target.group"
        Lua = Lua.."\
        myClone.events_whenTheTruth = target.events_whenTheTruth\
        for i=1, #myClone.events_whenTheTruth do\
            myClone.events_whenTheTruth[i](myClone)\
        end\n"
        Lua = Lua.."\nmyClone:addEventListener('touch', function(event)\
        if (event.phase=='began') then\
            local newIdTouch=globalConstants.touchId+1\
            globalConstants.touchId = newIdTouch\
            globalConstants.keysTouch['touch_'..newIdTouch], globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = event.id, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale, true\
            globalConstants.isTouch, globalConstants.touchX, globalConstants.touchY = true, (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
            display.getCurrentStage():setFocus(event.target, event.id)\
            event.target.isTouch = true\
            for key, value in pairs(objects) do\
                for i=1, #events_touchScreen[key] do\
                    events_touchScreen[key][i](value)\
                    for i2=1, #value.clones do\
                        events_touchScreen[key][i](value.clones[i2])\
                    end\
                end\
            end\
            for i=1, #myClone.parent_obj.events_touchObject do\
                myClone.parent_obj.events_touchObject[i](event.target)\
            end\
        elseif (event.phase=='moved') then\
            globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id] = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\nglobalConstants.touchX, globalConstants.touchY = (event.x-mainGroup.x)/mainGroup.xScale, -(event.y-mainGroup.y)/mainGroup.yScale\
            for key, value in pairs(objects) do\
                for i=1, #events_movedScreen[key] do\
                    events_movedScreen[key][i](value)\
                    for i2=1, #value.clones do\
                        events_movedScreen[key][i](value.clones[i2])\
                    end\
                end\
            end\
            for i=1, #myClone.parent_obj.events_movedObject do\
                myClone.parent_obj.events_movedObject[i](event.target)\
            end\
        else\
            display.getCurrentStage():setFocus(event.target, nil)\
            event.target.isTouch = nil\
            globalConstants.touchsXId[event.id], globalConstants.touchsYId[event.id], globalConstants.isTouchsId[event.id] = nil, nil, nil\
            if (pocketupFuns.getCountTouch(globalConstants.isTouchsId)==0) then\
                globalConstants.keysTouch = {}\
                globalConstants.isTouch = false\
            end\
            for key, value in pairs(objects) do\
                for i=1, #events_onTouchScreen[key] do\
                    events_onTouchScreen[key][i](value)\
                    for i2=1, #value.clones do\
                        events_onTouchScreen[key][i](value.clones[i2])\
                    end\
                end\
            end\
            for i=1, #myClone.parent_obj.events_onTouchObject do\
                myClone.parent_obj.events_onTouchObject[i](event.target)\
            end\
        end\
        return(true)\
        end)"
        Lua = Lua.."\nmyClone.xScale, myClone.yScale, myClone.alpha, myClone.rotation, myClone.numberImage, myClone.parent_obj = target.xScale, target.yScale, target.alpha, target.rotation, target.numberImage, target.parent_obj"
        Lua = Lua.."\nmyClone.fill.effect = 'filter.brightness'\
        myClone.property_brightness = target.property_brightness\
        myClone.fill.effect.intensity = (target.property_brightness)/100-1"


        Lua = Lua.."\nmyClone.parent_obj = target.parent_obj or target"

        Lua = Lua.."\ntarget.parent_obj.clones[#target.parent_obj.clones+1] = myClone\nmyClone.idClone, myClone.tableVarShow, myClone.origWidth, myClone.origHeight, myClone.width, myClone.height, myClone.property_size = #target.parent_obj, {}, target.origWidth, target.origHeight, target.width, target.height, target.property_size"
        Lua = Lua.."\nmyClone.isVisible = target.isVisible\nmyClone.physicsReload, myClone.physicsType , myClone.physicsTable = target.physicsReload or function(ob) end, target.physicsType or 'static' , plugins.json.decode(plugins.json.encode(target.physicsTable)) or {}\nmyClone:physicsReload()"
        Lua = Lua.."\nmyClone.property_color = target.property_color\nlocal r = pocketupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = pocketupFuns.cos(target.property_color+56)/2+0.724\nlocal b = pocketupFuns.sin(target.property_color+22+56)/2+0.724\nmyClone:setFillColor(r,g,b)\nmyClone.touchesObjects = {}"
        Lua = Lua.."\ntimer.new(0, function()\nmyClone:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = true\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_collision do\nmyClone.parent_obj.events_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = nil\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_endedCollision do\nmyClone.parent_obj.events_endedCollision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nend\nend)"
        Lua = Lua.."\nmyClone.gravityScale, myClone.isSensor = target.gravityScale, target.isSensor\n myClone.parent_obj.events_startClone = myClone.parent_obj.events_startClone or (events_startClone or {})"
        Lua = Lua.."\ntimer.new(0, function()\nfor i=1, #myClone.parent_obj.events_startClone do\nmyClone.parent_obj.events_startClone[i](myClone)\nend\n"
        Lua = Lua.."\nend) end)"
        end_pcall()
    elseif nameBlock == 'deleteClone' then
        add_pcall()
        Lua = Lua.."if (target) then\
            table.remove(target.parent_obj.clones, target.idClone)\
            for i=1, #target.parent_obj.clones do\
                target.parent_obj.clones[i].idClone = i\
            end\
            display.remove(target)\
        end\n"
        end_pcall()
        add_pcall()
        Lua = Lua..
        "if true then\
            pcall(function() timer.cancel(_repeat) end)\
            return true\
        end"
        end_pcall()
    elseif (nameBlock == 'broadcastFunction' and infoBlock[2][1][2]~=nil) then
        add_pcall()
        Lua = Lua..
        "timer.new(0, function()\
            broadcastFunction('fun_"..infoBlock[2][1][2].."')\
        end)"
        end_pcall()
    elseif nameBlock == 'vibration' then
        local time = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
        "timer.new(100,function()\
            system.vibrate('impact')\
        end , (("..time..")*1000)/100)"
        end_pcall()
    elseif nameBlock == 'goSteps' then
        local steps = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."target:translate(lunupFuns.sin(target.rotation)*("..steps.."),- (lunupFuns.cos(target.rotation)*"..steps.."))"
        end_pcall()
    elseif nameBlock == 'speedStepsToSecoond' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        Lua = Lua.."target:setLinearVelocity("..x..",-"..y..")"
        end_pcall()
    elseif nameBlock == 'rotateLeftForever' then
        local force = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."target:applyTorque(-"..force.."*100)"
        end_pcall()
    elseif nameBlock == 'rotateRightForever' then
        local force = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."target:applyTorque("..force.."*100)"
        end_pcall()
    elseif nameBlock == 'setBrightness' or nameBlock=='editBrightness' then
        local brig = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
        "target.fill.effect = 'filter.brightness'\
        target.property_brightness = math.max(math.min(("..(nameBlock=="setBrightness" and '' or 'target.property_brightness)+(')..brig.."), 200),0)\
        target.fill.effect.intensity = target.property_brightness/100-1"
        end_pcall()
    elseif nameBlock == 'playSound' and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua..
        "if not playSounds["..infoBlock[2][1][2].."] then\
            playSounds["..infoBlock[2][1][2].."] = audio.loadSound('"..obj_path.."/sound_"..infoBlock[2][1][2]..".mp3', system.DocumentsDirectory)\
        end\
        audio.stop(playingSounds["..infoBlock[2][1][2].."])\
        playingSounds["..infoBlock[2][1][2].."] = audio.play(playSounds[".. infoBlock[2][1][2].."])"
        end_pcall()
    elseif nameBlock == 'stopSound' and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua..
        "audio.stop(playingSounds["..infoBlock[2][1][2].."])\
        audio.dispose(playSounds[".. infoBlock[2][1][2].."])\
        playSounds[".. infoBlock[2][1][2]..'] = nil'
        end_pcall()
    elseif nameBlock == 'stopAllSounds' then
        add_pcall()
        Lua = Lua..
        "audio.stop()\
        audio.dispose()\
        playSounds = {}"
        end_pcall()
    elseif nameBlock == 'setVolumeSound' then
        local volume = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."audio.setVolume("..volume.."/100 )"
        end_pcall()
    elseif nameBlock == 'editVolumeSound' then
        local volume = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."audio.setVolume(audio.getVolume() + "..volume.."/100 )"
        end_pcall()
    elseif nameBlock == 'for' then
        local one = make_all_formulas(infoBlock[2][1], object)
        local _end = make_all_formulas(infoBlock[2][2], object)
        max_fors = max_fors+1
        Lua = Lua.."for i"..max_fors.." = (type("..one..") == 'number' and "..one.." or 0) , type(".._end..") == 'number' and ".._end.." or 0, 1 do\n"
        if (infoBlock[2][3][2]~=nil) then
            if infoBlock[2][3][1] == "globalVariable" then
                Lua = Lua.."var_"..infoBlock[2][3][2].." = i"..max_fors.."\n"
            else
                Lua = Lua.."target.var_"..infoBlock[2][3][2].." = i"..max_fors.."\n"
            end
        end
    elseif nameBlock == 'endFor' then
        Lua = Lua.."end"
    elseif (nameBlock == "addBody") then
        add_pcall()
        if (infoBlock[2][1][2]~="noPhysic") then
            Lua = Lua..'target.physicsTable = {outline = graphics.newOutline(10, target.image_path, system.DocumentsDirectory), density=3, friction=0.3, bounce=0.3}\ntarget.physicsType = \''..infoBlock[2][1][2]..'\'\n'
            Lua = Lua..'target.physicsReload = function(target)\nlocal oldTypeRotation = target.isFixedRotation\nplugins.physics.removeBody(target)\n'
            Lua = Lua.."plugins.physics.addBody(target, target.physicsType , target.physicsTable)\ntarget.isFixedRotation = oldTypeRotation\nend"
            Lua = Lua..'\ntarget:physicsReload()'
            Lua = Lua.."\ntarget:addEventListener('collision', function(event)\nif (event.phase=='began') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = true\ntimer.new(0, function()\nfor i=1, #events_collision do\nevents_collision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nelseif (event.phase=='ended') then\nevent.target.touchesObjects['obj_'..event.other.parent_obj.idObject] = nil\ntimer.new(0, function()\nfor i=1, #events_endedCollision do\nevents_endedCollision[i](event.target, event.other.parent_obj.nameObject)\nend\nend)\nend\nend)"
        else
            Lua = Lua.."plugins.physics.removeBody(target)\ntarget.physicsReload = nil\ntarget.touchesObjects = {}"
        end
        end_pcall()
    elseif nameBlock == 'setGravityAllObjects' then
        local x = make_all_formulas(infoBlock[2][1], object)
        local y = make_all_formulas(infoBlock[2][2], object)
        add_pcall()
        Lua = Lua.."plugins.physics.setGravity("..x..",-"..y..")"
        end_pcall()
    elseif nameBlock == 'setWeight' then
        local mass = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
        "target.physicsTable.density = "..mass.."\
        target:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setElasticity' then
        local bounce = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
        "target.physicsTable.bounce = "..bounce.."/100\
        target:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setFriction' then
        local friction = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua..
        "target.physicsTable.friction = "..friction.."/100\
        target:physicsReload()"
        end_pcall()
    elseif nameBlock == 'setTypeRotate' then
        if infoBlock[2][1][2] == 'true' then
            Lua = Lua.."target.isFixedRotation = false"
        elseif infoBlock[2][1][2] == 'false' then
            Lua = Lua.."target.isFixedRotation = true"
        end
    elseif nameBlock == 'goTo' then
        add_pcall()
        if infoBlock[2][1][2] == 'touch' then
            Lua = Lua.."target.x , target.y = globalConstants.touchX, -globalConstants.touchY"
        elseif infoBlock[2][1][2] == 'random' then
            Lua = Lua.."target.x, target.y = math.random(-"..(tostring(options.orientation == "vertical" and options.displayWidth/2 or options.displayHeight/2))..",\
            "..(tostring(options.orientation == "vertical" and options.displayWidth/2 or options.displayHeight/2)).."),\
            math.random(-"..tostring(options.orientation == "vertical" and options.displayHeight/2 or options.displayWidth/2)..","..tostring(options.orientation == "vertical" and options.displayHeight/2 or options.displayWidth/2)..")"
        else
            Lua = Lua.."local object = objects['object_"..infoBlock[2][1][2].."']\
            target.x, target.y = object.x, object.y"
        end
        end_pcall()
    elseif nameBlock == 'setRotateToObject' and infoBlock[2][1][2]~=nil then -- ["setRotateToObject",[["objects",7]],"on"]
        add_pcall()
        Lua = Lua.."if ( objects['object_"..infoBlock[2][1][2].."']~=nil) then\
            target.rotation = lunupFuns.atan2(objects['object_"..infoBlock[2][1][2].."'].x - target.x, target.y - objects['object_"..infoBlock[2][1][2].."'].y)\
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
        Lua = Lua.."target:toFront()"
    elseif nameBlock == 'setImageToName' and #images>0 and infoBlock[2][1][2]~=nil then
        local image = infoBlock[2][1][2]
        
        if (image~=nil) then
            add_pcall()
            Lua = Lua.."local newIdImage = nil\nfor i=1, #listImages do\nif (listImages[i]=="..image..") then\nnewIdImage=i\nbreak\nend\nend\nif (newIdImage ~= nil) then"
            Lua = Lua..'\ntarget.numberImage = newIdImage\ntarget.image_path = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\'\n'
            Lua = Lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_'..image..'.png\', baseDir = system.DocumentsDirectory}\n'
            Lua = Lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
            Lua = Lua.."local r = lunupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = lunupFuns.cos(target.property_color+56)/2+0.724\nlocal b = lunupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
            Lua = Lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
            if (o==1) then
                Lua = Lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            Lua = Lua.."end\n"
            Lua = Lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
            end_pcall()
        end
    elseif nameBlock == "nextImage" and #images>1 then
        add_pcall()
        Lua = Lua.."target.numberImage = target.numberImage==#listImages and 1 or target.numberImage+1\ntarget.image_path='"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
        Lua = Lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        Lua = Lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        Lua = Lua.."local r = lunupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = lunupFuns.cos(target.property_color+56)/2+0.724\nlocal b = lunupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
        Lua = Lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        Lua = Lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == "previousImage" and #images>1 then
        add_pcall()
        Lua = Lua.."target.numberImage = target.numberImage==1 and #listImages or target.numberImage-1\ntarget.image_path='"..app.idProject.."/scene_"..scene_id.."/object_"..obj_id.."/image_'..listImages[target.numberImage]..'.png'\n"
        Lua = Lua..'target.fill = {type = \'image\', filename = \''..app.idProject..'/scene_'..scene_id..'/object_'..obj_id..'/image_\'..listImages[target.numberImage]..\'.png\', baseDir = system.DocumentsDirectory}\n'
        Lua = Lua.."target.origWidth, target.origHeight = getImageProperties(target.image_path, system.DocumentsDirectory)\ntarget.width, target.height = target.origWidth*(target.property_size/100), target.origHeight*(target.property_size/100)\n"
        Lua = Lua.."local r = lunupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = lunupFuns.cos(target.property_color+56)/2+0.724\nlocal b = lunupFuns.sin(target.property_color+22+56)/2+0.724\ntarget:setFillColor(r,g,b)\n"
        Lua = Lua.."if (target.property_color~=100) then\ntarget.fill.effect = 'filter.brightness'\ntarget.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        Lua = Lua.."\nif (target.parent_obj==target) then\nlocal objectsTable = plugins.json.decode(funsP['получить сохранение']('"..scene_path.."/objects'))\nif (objectsTable[target.infoSaveVisPos][3]==nil) then\nobjectsTable[target.infoSaveVisPos][3] = {}\nend\nobjectsTable[target.infoSaveVisPos][3].path = target.image_path\nfunsP['записать сохранение']('"..scene_path.."/objects', plugins.json.encode(objectsTable))\nend"
        end_pcall()
    elseif nameBlock == "editAlpha" then
        add_pcall()
        Lua = Lua.."target.alpha = target.alpha - "..make_all_formulas(infoBlock[2][1], object).."/100"
        end_pcall()
    elseif nameBlock=="setColor" or nameBlock=="editColor" then
        add_pcall()
        Lua = Lua..
        "target.property_color = ("..(nameBlock=="setColor" and '' or "target.property_color)+(")..make_all_formulas(infoBlock[2][1],object)..")\
        local r = lunupFuns.sin(target.property_color-22+56)/2+0.724\
        local g = lunupFuns.cos(target.property_color+56)/2+0.724\
        local b = lunupFuns.sin(target.property_color+22+56)/2+0.724\
        target:setFillColor(r,g,b)"
        end_pcall()
    elseif nameBlock == 'setImageBackgroundToName' and #images>0 and infoBlock[2][1][2]~=nil then
        local image = infoBlock[2][1][2]

        if (image~=nil) then
            add_pcall()
            Lua = Lua.."local newIdImage = nil\nfor i=1, #background.listImagesBack do\nif (background.listImagesBack[i]=="..image..") then\nnewIdImage=i\nbreak\nend\nend\nif (newIdImage ~= nil) then"
            Lua = Lua..'\nbackground.numberImage = newIdImage\nbackground.image_path = background.obj_pathBack..\'/image_'..image..'.png\'\n'
            Lua = Lua..'background.fill = {type = \'image\', filename = background.image_path, baseDir = system.DocumentsDirectory}\n'
            Lua = Lua.."background.origWidth, background.origHeight = getImageProperties(background.image_path, system.DocumentsDirectory)\nbackground.width, background.height = background.origWidth*(background.property_size/100), background.origHeight*(background.property_size/100)\n"
            Lua = Lua.."local r = lunupFuns.sin(background.property_color-22+56)/2+0.724\nlocal g = lunupFuns.cos(background.property_color+56)/2+0.724\nlocal b = lunupFuns.sin(background.property_color+22+56)/2+0.724\nbackground:setFillColor(r,g,b)\n"
            Lua = Lua.."if (background.property_color~=100) then\nbackground.fill.effect = 'filter.brightness'\nbackground.fill.effect.intensity = (background.property_brightness)/100-1\nend\n"
            if (o==1) then
                Lua = Lua.."broadcastChangeBackground(listImages[numberImage])\n"
            end
            Lua = Lua.."end\n"
            end_pcall()
        end
    elseif nameBlock == 'setImageBackgroundToId' and #images>0 then
        local image = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."local numberImage = ("..image.."-1)-math.floor((".. image.."-1)/#background.listImagesBack)*#background.listImagesBack+1"
        Lua = Lua..'\nbackground.numberImage = numberImage\nbackground.image_path = background.obj_pathBack..\'/image_\'..background.listImagesBack[numberImage]..\'.png\'\n'
        Lua = Lua..'background.fill = {type = \'image\', filename = background.image_path, baseDir = system.DocumentsDirectory}\n'
        Lua = Lua.."background.origWidth, background.origHeight = getImageProperties(background.image_path, system.DocumentsDirectory)\nbackground.width, background.height = background.origWidth*(background.property_size/100), background.origHeight*(background.property_size/100)\n"
        Lua = Lua.."local r = lunupFuns.sin(background.property_color-22+56)/2+0.724\nlocal g = lunupFuns.cos(background.property_color+56)/2+0.724\nlocal b = lunupFuns.sin(background.property_color+22+56)/2+0.724\nbackground:setFillColor(r,g,b)\n"
        Lua = Lua.."if (background.property_color~=100) then\nbackground.fill.effect = 'filter.brightness'\nbackground.fill.effect.intensity = (background.property_brightness)/100-1\nend\n"
        if (o==1) then
            Lua = Lua.."broadcastChangeBackground(listImages[numberImage])\n"
        end
        end_pcall()
    elseif nameBlock=='getLinkImage' then
        add_pcall()
        Lua = Lua.."local function networkListener(event)\
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
        Lua = Lua..'local obj = #tableFeathers+1\nlocal myObj = display.newImage(target.image_path, system.DocumentsDirectory, target.x, target.y)\ntableFeathers[obj] = myObj\nstampsGroup:insert(myObj)\n'
        Lua = Lua..'myObj.width, myObj.height, myObj.alpha, myObj.rotation, myObj.xScale, myObj.yScale = target.width, target.height, target.alpha, target.rotation, target.xScale, target.yScale\n'
        Lua = Lua.."local r = lunupFuns.sin(target.property_color-22+56)/2+0.724\nlocal g = lunupFuns.cos(target.property_color+56)/2+0.724\nlocal b = lunupFuns.sin(target.property_color+22+56)/2+0.724\nmyObj:setFillColor(r,g,b)\n"
        Lua = Lua.."if (target.property_color~=100) then\nmyObj.fill.effect = 'filter.brightness'\nmyObj.fill.effect.intensity = (target.property_brightness)/100-1\nend\n"
        end_pcall()
    elseif nameBlock == 'clearPen' then
        add_pcall()
        Lua = Lua..
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
        Lua = Lua..
        "tableFeathersOptions[2] = "..r.."\
        tableFeathersOptions[3] = "..g.."\
        tableFeathersOptions[4] = "..b
        end_pcall()
    elseif nameBlock == 'setSizePen' then
        local size = make_all_formulas(infoBlock[2][1], object)
        add_pcall()
        Lua = Lua.."tableFeathersOptions[1] = "..size
        end_pcall()
    elseif nameBlock == 'blockTouch' then
        Lua = Lua..
        "for i=1, #events_touchObject, 1 do\
            events_touchObject[i](target)\
        end"
    elseif nameBlock == 'blockTouchScreen' then
        Lua = Lua..
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
            Lua = Lua..
            "if (varText_"..var.."~=nil and varText_"..var..".text~=nil) then\
                display.remove(varText_"..var..")\
            end\
            varText_"..var.." = display.newText(type(var_"..var..")=='boolean' and (var_"..var.." and app.words[373] or app.words[374]) or type(var_"..var..")=='table' and encodeList(var_"..var..") or var_"..var..", "..x..", -"..y..", 'fonts/font_1', 35)\
            varText_"..var..":setFillColor(0, 0, 0)\
            cameraGroup:insert(varText_"..var..")"
        else
            Lua = Lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..')\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText(type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', '..x..', -'..y..', "fonts/font_1", 38)\n'
            Lua = Lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(0, 0, 0)'
            Lua = Lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
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
            Lua = Lua..'if (varText_'..infoBlock[2][1][2]..'~=nil and varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(varText_'..infoBlock[2][1][2]..')\nend\nvarText_'..infoBlock[2][1][2]..' = display.newText({text = type(var_'..infoBlock[2][1][2]..')=="boolean" and (var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(var_'..infoBlock[2][1][2]..')=="table" and encodeList(var_'..infoBlock[2][1][2]..') or var_'..infoBlock[2][1][2]..', align="'..aligh..'", x = '..x..', y = - '..y..', font = nil, fontSize = 30 *('..size..'/100) })\n'
            Lua = Lua..'local rgb = utils.hexToRgb('..hex..')\n'
            Lua = Lua..'varText_'..infoBlock[2][1][2]..':setFillColor(rgb[1], rgb[2], rgb[3])'
            Lua = Lua.."\ncameraGroup:insert(varText_"..infoBlock[2][1][2]..")"
        else
            Lua = Lua..'if (target.varText_'..infoBlock[2][1][2]..'~=nil and target.varText_'..infoBlock[2][1][2]..'.text~=nil) then\ndisplay.remove(target.varText_'..infoBlock[2][1][2]..')\nend\ntarget.varText_'..infoBlock[2][1][2]..' = display.newText({text = type(target.var_'..infoBlock[2][1][2]..')=="boolean" and (target.var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type(target.var_'..infoBlock[2][1][2]..')=="table" and encodeList(target.var_'..infoBlock[2][1][2]..') or target.var_'..infoBlock[2][1][2]..', align="'..aligh..'", x = '..x..', y = - '..y..', font = nil, fontSize = 30 *('..size..'/100) })\n'
            Lua = Lua..'local rgb = utils.hexToRgb('..hex..')\n'
            Lua = Lua..'target.varText_'..infoBlock[2][1][2]..':setFillColor(rgb[1], rgb[2], rgb[3])'
            Lua = Lua.."\ncameraGroup:insert(target.varText_"..infoBlock[2][1][2]..")"
        end
        end_pcall()
    elseif nameBlock == 'hideVariable' and infoBlock[2][1][2]~=nil then
        add_pcall()
        if infoBlock[2][1][1] == 'globalVariable' then
            Lua = Lua..'display.remove(varText_'..infoBlock[2][1][2]..')\nvarText_'..infoBlock[2][1][2]..' = nil'
        else
            Lua = Lua..'display.remove(target.varText_'..infoBlock[2][1][2]..')\ntarget.varText_'..infoBlock[2][1][2]..' = nil'
        end
        end_pcall()
    elseif nameBlock == 'focusCameraToObject' then
        add_pcall()
        Lua = Lua.."if (focusCameraObject == nil) then\nfocusCameraObject = target\ntarget.timerCamera = timer.new(0, function()\ncameraGroup.x, cameraGroup.y = -focusCameraObject.x + math.max(math.min(focusCameraObject.x+cameraGroup.x,"..tostring(options.displayWidth/2).."/100*"..make_all_formulas(infoBlock[2][1], object).."),-"..tostring(options.displayWidth/2).."/100*"..make_all_formulas(infoBlock[2][1], object).."), -focusCameraObject.y + math.max(math.min(focusCameraObject.y+cameraGroup.y,"..tostring(options.displayHeight/2).."/100*"..make_all_formulas(infoBlock[2][2], object).."),-"..tostring(options.displayHeight/2).."/100*"..make_all_formulas(infoBlock[2][2], object)..") \nend, 0)\nelse\nfocusCameraObject = target\nend"
        end_pcall()
    elseif nameBlock=="removeObjectCamera" then
        add_pcall()
        Lua = Lua.."notCameraGroup:insert(target)\ntarget.group = notCameraGroup"
        end_pcall()
    elseif nameBlock=="insertObjectCamera" then
        add_pcall()
        Lua = Lua.."cameraGroup:insert(target)\ntarget.group = cameraGroup"
        end_pcall()
    elseif nameBlock=="removeVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\nnotCameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
        end_pcall()
     elseif nameBlock=="insertVariableCamera" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua.."if ("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2].."~=nil and "..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..".text ~= nil) then\ncameraGroup:insert("..(infoBlock[2][1][1]=="globalVariable" and "" or "target.").."varText_"..infoBlock[2][1][2]..")\nend"
        end_pcall()
    elseif nameBlock=="removeFocusCameraToObject" then
        add_pcall()
        Lua = Lua.."if (focusCameraObject~=nil) then\ntimer.cancel(focusCameraObject.timerCamera)\nfocusCameraObject = nil\nend"
        end_pcall()
    elseif nameBlock=="saveVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
        Lua = Lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\narrayVariables[i][3] = '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables", plugins.json.encode(arrayVariables))\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="readVariable" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua..'local arrayVariables = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalVariable" and app.idProject or obj_path)..'/variables"))'
        Lua = Lua..'\nfor i=1, #arrayVariables do\nif (arrayVariables[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'= arrayVariables[i][3]~=nil and arrayVariables[i][3] or 0\nbreak\nend\nend'
        Lua = Lua..'\nif '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..' then\n '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="boolean" and ('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..' and app.words[373] or app.words[374]) or type('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..')=="table" and encodeList('..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..') or '..(infoBlock[2][1][1]=="globalVariable" and '' or 'target.')..'var_'..infoBlock[2][1][2]..'\nend'
        end_pcall()
    elseif nameBlock=="addElementArray" and infoBlock[2][2][2]~=nil then
        add_pcall()
        Lua = Lua..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."[#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1] = "..make_all_formulas(infoBlock[2][1], object)
        end_pcall()
    elseif nameBlock=="deleteElementArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua.."table.remove("..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..", "..make_all_formulas(infoBlock[2][2],object)..")"
        end_pcall()
    elseif nameBlock=="deleteAllElementsArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].." = {}"
        end_pcall()
    elseif nameBlock=="pasteElementArray" and infoBlock[2][2][2]~=nil then
        add_pcall()
         Lua = Lua.."if ("..make_all_formulas(infoBlock[2][3], object).."<=#"..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2].."+1 and "..make_all_formulas(infoBlock[2][3], object)..">0) then\ntable.insert("..(infoBlock[2][2][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][2][2]..", "..make_all_formulas(infoBlock[2][3], object)..", "..make_all_formulas(infoBlock[2][1], object)..")\nend"
        end_pcall()
    elseif nameBlock=="replaceElementArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua.."if ("..make_all_formulas(infoBlock[2][2], object).."<=#"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."+1 and "..make_all_formulas(infoBlock[2][2], object)..">0) then\n"..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2].."["..make_all_formulas(infoBlock[2][2],object).."] = "..make_all_formulas(infoBlock[2][3],object).."\nend"
        end_pcall()
    elseif nameBlock=="saveArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
        Lua = Lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\narrayArrays[i][3] = '..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'\nfunsP["записать сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays", plugins.json.encode(arrayArrays))\nbreak\nend\nend\nprint(plugins.json.encode(list_1))'
        end_pcall()
    elseif nameBlock=="readArray" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua..'local arrayArrays = plugins.json.decode(funsP["получить сохранение"]("'..(infoBlock[2][1][1]=="globalArray" and app.idProject or obj_path)..'/arrays"))'
        Lua = Lua..'\nfor i=1, #arrayArrays do\nif (arrayArrays[i][1]=='..infoBlock[2][1][2]..') then\n'..(infoBlock[2][1][1]=="globalArray" and '' or 'target.')..'list_'..infoBlock[2][1][2]..'= arrayArrays[i][3]~=nil and arrayArrays[i][3] or {}\nbreak\nend\nend'
        end_pcall()
    elseif nameBlock=="columnStorageToArray" and infoBlock[2][3][2]~=nil then
        add_pcall()
        Lua = Lua.."local allArraysValues = plugins.json.decode('[\"'.."..make_all_formulas(infoBlock[2][2], object)..":gsub('\"','\\\\\"'):gsub('\\r\\n','\",\"'):gsub('\\n','\",\"')..'\"]')"
        Lua = Lua.."\nfor i=1, #allArraysValues do\nlocal values = plugins.json.decode('[\"'..allArraysValues[i]:gsub('\\\"','\\\\\"'):gsub(',','\",\"')..'\"]')\nallArraysValues[i] = values["..make_all_formulas(infoBlock[2][1], object).."]==nil and '' or values["..make_all_formulas(infoBlock[2][1], object).."]\nend"
        Lua = Lua.."\n"..(infoBlock[2][3][1]=="globalArray" and '' or 'target.').."list_"..infoBlock[2][3][2].." = allArraysValues"
        end_pcall()
    elseif nameBlock=="getRequest" and infoBlock[2][2][2]~=nil then
        add_pcall()
        Lua = Lua..
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
        Lua = Lua..
        "timer.new(0, function()\
            display.save(mainGroup,{ filename=myScene..'/icon.png', baseDir=system.DocumentsDirectory, backgroundColor={1,1,1,1}})\
            funBackListener2({keyName='deleteBack', phase='up'})\
        end)"
        end_pcall()
    elseif nameBlock == "continueScene" then
        if infoBlock[2][1][2]==nil then
            return ''
        end
        local id = infoBlock[2][1][2]

        Lua = Lua.. "pcall(function()\n"
        Lua = Lua..
        "moveScene()\
        if not Scenes["..id.."] then\
            scene_"..infoBlock[2][1][2].."()\
            return true\
        end\
        \
        local scene = Scenes["..id.."]\
        Scenes.select = scene\
        \
        globalConstants.touchX = scene.globalConstants.touchX\
        globalConstants.touchY = scene.globalConstants.touchY\
        globalConstants.isTouch = false\
        \
        thread.timers = scene.threads\
        for i = 1 , #thread.timers do\
            timer.resume(thread.timers[i])\
        end\
        mainGroup = scene.mainGroup\
        mainGroup.isVisible = true\
        \
        \
        WebViews = scene.WebViews\
        textFields = scene.textFields\
        objects = scene.objects\
        \
        -- events_touchBack = scene.events_touchBack\
        -- events_keypressed = scene.events_keypressed\
        -- events_endKeypressed = scene.events_endKeypressed\
        events_touchScreen = scene.events_touchScreen\
        --events_movedScreen = scene.events_movedScreen\
        events_onTouchScreen = scene.events_onTouchScreen\
        -- events_whenTheTruth = scene.events_whenTheTruth\
        playSounds = scene.playSounds\
        playingSounds = scene.playingSounds\
        \
        joysticks = scene.joysticks\
        Timers = {}\
        Timers_max = 0\
        \
        \
        for key, value in pairs(objects) do\
            pcall(function()\
                transition.resume(value)\
            end)\
            pcall(function()\
                if value.physicsReload then\
                    value:physicsReload()\
                end\
            end)\
        end\
        for key, value in pairs(playingSounds) do\
            audio.resume(playingSounds[key])\
        end\
        "
        Lua = Lua.."\nend)\
        removeTheard()\ncoroutine.yield()"
    elseif nameBlock=="runScene" and infoBlock[2][1][2]~=nil then
        add_pcall()
        Lua = Lua..
        "moveScene()\
        if Scenes["..infoBlock[2][1][2].."] then\
            deleteScene("..infoBlock[2][1][2]..")\
        end\
        scene_"..infoBlock[2][1][2].."()"
        end_pcall()
        Lua = Lua .. "removeTheard()\ncoroutine.yield()"
    elseif nameBlock == 'foreach'then
        max_fors = max_fors+1
        if (infoBlock[2][1][2]==nil or infoBlock[2][2][2]==nil ) then
            infoBlock[2][1][2] = "nil"
            infoBlock[2][2][2] = "nil"
        end
        Lua = Lua..'for key'..max_fors..', value'..max_fors..' in pairs('
        Lua = Lua..(infoBlock[2][1][1]=="globalArray" and "" or "target.").."list_"..infoBlock[2][1][2]..') do\n'
        Lua = Lua..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' = value'..max_fors..'\n'
        Lua = Lua..'if '..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..' then\n target.varText_'..infoBlock[2][1][2]..'.text = type('..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='boolean' and ("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2].." and app.words[373] or app.words[374]) or type("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..")=='table' and encodeList("..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..") or "..(infoBlock[2][2][1]=="globalVariable" and "" or "target.").."var_"..infoBlock[2][2][2]..'\nend'
    elseif nameBlock == 'endForeach' then
        Lua = Lua.."end"
    elseif nameBlock == 'lowerPen' then
        add_pcall()
        Lua = Lua..
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
        Lua = Lua.."target.isPen=nil"
    elseif nameBlock == 'waitIfTrue2' then
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        Lua = Lua..
        "while not "..arg1.." do\
        coroutine.yield()\
        end"
    elseif nameBlock == 'showToast' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        if not utils.isWin then
            Lua = Lua..
            "if not utils.isSim and not utils.isWin then\
                require 'plugin.toaster'.shortToast("..arg1..")\
            end"
        end
        end_pcall()
    elseif nameBlock == 'showHitboxes' then
        add_pcall()
        Lua = Lua.."plugins.physics.setDrawMode('hybrid')"
        end_pcall()
    elseif nameBlock == 'hideHitboxes' then
        add_pcall()
        Lua = Lua.."plugins.physics.setDrawMode('normal')"
        end_pcall()
    -- elseif nameBlock == 'setHorizontalOrientation' then
    --     add_pcall()
    --     Lua = Lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('landscape')\nmainGroup.xScale, mainGroup.yScale = "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup)..", "..tostring(xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_Y, CENTER_X\nblackRectTop.width, blackRectTop.height = display.contentHeight, display.contentWidth\nblackRectTop.x, blackRectTop.y = "..("-"..tostring(options.displayHeight/2)..",0" ).."\nblackRectTop.anchorX, blackRectTop.anchorY = 1, 0.5\nblackRectBottom.width, blackRectBottom.height = display.contentHeight, display.contentWidth\nblackRectBottom.x, blackRectBottom.y = "..(tostring(options.displayHeight/2)..",0" ).."\nblackRectBottom.anchorX, blackRectBottom.anchorY = 0, 0.5"
    --     end_pcall()
    -- elseif nameBlock == 'setVerticalOrientation' then
    --     add_pcall()
    --     Lua = Lua.."CENTER_X = display.contentCenterX\nCENTER_Y = display.screenOriginY+display.contentHeight/2\nplugins.orientation.lock('portrait')\nmainGroup.xScale, mainGroup.yScale = "..tostring(xScaleMainGroup)..", "..tostring(not options.aspectRatio and yScaleMainGroup or xScaleMainGroup).."\nmainGroup.x, mainGroup.y = CENTER_X, CENTER_Y\nblackRectTop.width, blackRectTop.height = display.contentWidth, display.contentHeight\nblackRectTop.x, blackRectTop.y = "..("0,-"..tostring(options.displayHeight/2)).."\nblackRectTop.anchorY, blackRectTop.anchorX = 1, 0.5\nblackRectBottom.x, blackRectBottom.y = "..("0,"..tostring(options.displayHeight/2)).."\nblackRectBottom.anchorY, blackRectBottom.anchorX = 0, 0.5"
    --     end_pcall()
    elseif nameBlock == 'playSoundAndWait' then
        add_pcall()
        Lua = Lua..
        "if not playSounds["..infoBlock[2][1][2].."] then\
            playSounds["..infoBlock[2][1][2].."] = audio.loadSound('"..obj_path.."/sound_"..infoBlock[2][1][2]..".mp3', system.DocumentsDirectory)\
        end\
        pcall(function()\
            audio.stop(playingSounds["..infoBlock[2][1][2].."])\
        end)\
        playingSounds["..infoBlock[2][1][2].."] = audio.play(playSounds[".. infoBlock[2][1][2].."])"
        end_pcall()
        Lua = Lua.."\
        local time = audio.getDuration(playSounds["..infoBlock[2][1][2].."])\
        threadFun.wait(time)"
    elseif nameBlock == 'hideHitboxes' then
        Lua = Lua.."plugins.physics.setDrawMode('normal')"
    elseif nameBlock == 'showHitboxes' then
        Lua = Lua.."plugins.physics.setDrawMode('hybrid')"
    elseif nameBlock == 'setTextelCoarseness' then
        add_pcall()
        local arg1 = make_all_formulas(infoBlock[2][1], object)
        Lua = Lua.."target.physicsTable.outline = graphics.newOutline("..arg1..", target.image_path, system.DocumentsDirectory)\ntarget:physicsReload()\n"
        end_pcall()
    elseif (nameBlock=='isSensor') then
        Lua = Lua.."target.isSensor = "..(infoBlock[2][1][2]=="on" and "false" or "true")
    elseif nameBlock == 'stopScript' then
        Lua = Lua..
        "removeTheard()\
        coroutine.yield()"
    elseif nameBlock == "setGravityScale" then
        add_pcall()
        Lua = Lua.."target.gravityScale = tonumber("..make_all_formulas(infoBlock[2][1], object)..", 0)"
        end_pcall()
    elseif nameBlock == "setQuareHitbox" then
        add_pcall()
        Lua = Lua.."target.physicsTable.outline, target.physicsTable.shape, target.physicsTable.radius = nil, nil, nil\ntarget:physicsReload()"
        end_pcall()
    elseif nameBlock == "setQuareWHHitbox" then
        add_pcall()
        Lua = Lua.."local w = "..make_all_formulas(infoBlock[2][1], object).."/2\nlocal h = "..make_all_formulas(infoBlock[2][2], object).."/2\ntarget.physicsTable.outline, target.physicsTable.radius, target.physicsTable.shape = nil, nil, {-w, -h, -w, h, w, h, w, -h}\ntarget:physicsReload()"
        end_pcall()
    elseif nameBlock == "setCircleHitbox" then
        add_pcall()
        Lua = Lua.."target.physicsTable.radius, target.physicsTable.outline, target.physicsTable.shape = "..make_all_formulas(infoBlock[2][1], object)..", nil, nil\ntarget:physicsReload()"
        end_pcall()
    end
    return Lua
end

return(make_block)