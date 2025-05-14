local particleDesigner = {}

particleDesigner.loadParams = function(filename, baseDir, textureSubDir)
	local baseDir = baseDir or system.ResourceDirectory
	local path = system.pathForFile(filename, baseDir)
	local file = io.open(path, 'r')
	local data = file:read('*a') io.close(file)

	local params = plugins.json.decode(data)
	if textureSubDir then
		params.textureFileName = textureSubDir .. params.textureFileName
	end return params
end

particleDesigner.newEmitter = function(filename, baseDir, textureSubDir)
	local emitterParams = particleDesigner.loadParams(filename, baseDir, textureSubDir)
	return display.newEmitter(emitterParams, baseDir)
end

return particleDesigner
