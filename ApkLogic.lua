local zipAndroid = require 'plugin.zipAndroid'

if utils.isSim or utils.isWin then
    return true
end

local function removeAllObjects()
    local stage = display.getCurrentStage()

    for i = stage.numChildren, 1, -1 do
        local child = stage[i]
        if child then
            child:removeSelf()
            child = nil
        end
    end
end

local launch = function ()
    app.idProject = "project_"..2
    removeAllObjects()
    scene_run_game('scripts', {nil, nil,nil})
end

if funsP["прочитать сс сохранение"]('counter_projects') >= 2 then
    launch()
    return true
end

local counterProjects = 2
funsP["записать сс сохранение"]('counter_projects', counterProjects)

local pathFolderProject = "project_"..counterProjects

plugins.lfs.mkdir(system.pathForFile(pathFolderProject, system.DocumentsDirectory))
zipAndroid.uncompress {
    path=system.pathForFile("importFile", system.ResourceDirectory),
    folder=system.pathForFile(pathFolderProject, system.DocumentsDirectory),
    listener=function(event)
        launch()
    end
}