local exp <const>, target <const> = exports['prp_target'], {}

target.disableTargeting = function(state)
    exp:disableTargeting(state)
end

target.isActive = function()
    return exp:isActive()
end

target.addGlobalOption = function(data)
    exp:addGlobalOption(data)
end

target.removeGlobalOption = function(name)
    exp:removeGlobalOption(name)
end

target.addGlobalObject = function(options)
    exp:addGlobalObject(options)
end

target.removeGlobalObject = function(optionNames)
    exp:removeGlobalObject(optionNames)
end

target.addGlobalModel = function(options)
    exp:addGlobalModel(options)
end

target.removeGlobalModel = function(optionNames)
    exp:removeGlobalModel(optionNames)
end

target.addGlobalPed = function(options)
    exp:addGlobalPed(options)
end

target.removeGlobalPed = function(optionNames)
    exp:removeGlobalPed(optionNames)
end

target.addGlobalVehicle = function(options)
    exp:addGlobalVehicle(options)
end

target.removeGlobalVehicle = function(optionNames)
    exp:removeGlobalVehicle(optionNames)
end

target.addGlobalPlayer = function(options)
    exp:addGlobalPlayer(options)
end

target.removeGlobalPlayer = function(optionNames)
    exp:removeGlobalPlayer(optionNames)
end

target.addModel = function(models, options)
    exp:addModel(models, options)
end

target.removeModel = function(models, optionNames)
    exp:removeModel(models, optionNames)
end

target.addEntity = function(netIds, options)
    exp:addEntity(netIds, options)
end

target.removeEntity = function(netIds, optionNames)
    exp:removeEntity(netIds, optionNames)
end

target.addLocalEntity = function(entities, options)
    exp:addLocalEntity(entities, options)
end

target.removeLocalEntity = function(entities, optionNames)
    exp:removeLocalEntity(entities, optionNames)
end

target.addSphereZone = function(parameters)
    exp:addSphereZone(parameters)
end

target.addBoxZone = function(parameters)
    exp:addBoxZone(parameters)
end

target.addPolyZone = function(parameters)
    exp:addPolyZone(parameters)
end

target.removeZone = function(id)
    exp:removeZone(id)
end

target.zoneExists = function(id)
    return exp:zoneExists(id)
end

target.getTargetOptions = function(entity, _type, model)
    return exp:getTargetOptions(entity, _type, model)
end

return target