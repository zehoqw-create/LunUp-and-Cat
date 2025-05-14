return {
    ["createParticle"] = function (infoBlock, object, images, sounds, make_all_formulas)
        if infoBlock[2][2][2] ~= nil then
            local lua = "pcall(function()\n"
            lua = lua.."local name = "..make_all_formulas(infoBlock[2][1], object).."\
particles[name] = plugins.particle.newEmitter('Emitter/' .. '"..infoBlock[2][2][2].."', nil, 'Emitter/')\n"
            lua = lua.."mainGroup:insert(particles[name])\
particles[name].group = mainGroup"
            return lua.."\nend)"
        end
    end,

    setPositionParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.x, particle.y = "..make_all_formulas(infoBlock[2][2], object)..", -"..make_all_formulas(infoBlock[2][3], object).."\nend"
        return lua.."\nend)"
    end,

    setRotateParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.rotation = "..make_all_formulas(infoBlock[2][2], object).."\nend"
        return lua.."\nend)"
    end,

    setSpeedParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.speed = "..make_all_formulas(infoBlock[2][2], object).."\nend"
        return lua.."\nend)"
    end,

    setSizeParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle.xScale = "..make_all_formulas(infoBlock[2][2], object).."/100\nparticle.yScale = "..make_all_formulas(infoBlock[2][2], object).."/100\nend"
        return lua.."\nend)"
    end,

    setLayerParticle = function (infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."] particle.group:insert("..make_all_formulas(infoBlock[2][1], object).."+3, particle)"
        return lua .. "\nend)"
    end,

    toFrontLayerParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle:toFront()\nend"
        return lua.."\nend)"
    end,

    deleteParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\ndisplay.remove(particle)\nparticles["..make_all_formulas(infoBlock[2][1], object).."]=nil\nend"
        return lua.."\nend)"
    end,

    stopParticle = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\nif (particle~=nil) then\nparticle:stop()\nend"
        return lua.."\nend)"
    end,

    deleteAllParticles = function ()
        local lua = "pcall(function()\n"
        lua = lua.."for key, value in pairs(particles) do\ndisplay.remove(value)\nend\nparticles = {}"
        return lua.."\nend)"
    end,

    startStopParticle = function(infoBlock, object, images, sounds, make_all_formulas)
        local lua = "pcall(function()\n"
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\n"
        lua = lua.."if particle ~= nil then\n"
        print(plugins.json.encode(infoBlock))
        lua = lua.."if "..(infoBlock[2][2][2] == "on" and "false" or "true").." then\n"
        lua = lua.."particle:start()\nelse\nparticle:pause()\nend\nend"
        return lua.."\nend)"
    end,

    particleSceneInsertCamera = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\n"
        lua = lua.."cameraGroup:insert(particle)"
        return lua.."\nend)"
    end,

    particleSceneRemoveCamera = function (infoBlock, object, images, sounds, make_all_formulas, obj_id, obj_path, scene_id, scene_path, options, o)
        local lua = "pcall(function()\n"
        local name = make_all_formulas(infoBlock[2][1], object)
        lua = lua.."local particle = particles["..make_all_formulas(infoBlock[2][1], object).."]\n"
        lua = lua.."notCameraGroup:insert(particle)"
        return lua.."\nend)"
    end,
}