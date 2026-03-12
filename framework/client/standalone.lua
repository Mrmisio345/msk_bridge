local Provider <const> = {}

-- Handlers

AddEventHandler('msk_garages:hideHud', function(toggle)
    TriggerEvent('radar:setHidden', toggle) 
end)

Provider.IsPlayerLoaded = function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
end

Provider.GetPlayerData = function()
    return {
        charid = 1,
        accounts = {},
        job = {},
        group = 'user',
        routingBucket = 0,
    }
end

Provider.GetPlayerGroup = function()
    return 'user'
end

Provider.GetCharId = function()
    return 1
end

Provider.GetJob = function()
    return 'unemployed'
end

Provider.GetExtraJob = function() 
    return 'unemployed'
end

Provider.HaveJob = function(jobName)
    return false
end

Provider.GetItem = function(itemName) 
    return {
        item = itemName,
        count = 0,
    }
end

Provider.GetAccount = function(accountName) 
    return {
        name = accountName,
        money = 0,
    }
end

Provider.ShowNotification = function(msg)
    assert(type(msg) == 'string', 'ShowNotification: msg must be a string')

    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false)
end

Provider.ShowAdvancedNotification = function(title, msg, icon, duration)
    assert(type(title) == 'string', 'ShowAdvancedNotification: title must be a string')
    assert(type(msg) == 'string', 'ShowAdvancedNotification: msg must be a string')

    local txd <const> = icon or 'CHAR_DEFAULT'
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentString(msg)
    EndTextCommandThefeedPostMessagetext(txd, txd, false, 0, title, '~s~')
end

Provider.ShowHelpNotification = function(name, msg)
    assert(type(name) == 'string', 'ShowHelpNotification: name must be a string')
    assert(type(msg) == 'string', 'ShowHelpNotification: msg must be a string')

    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentString(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local GetVehicleLabel <const>, SetVehicleProperties <const>, GetVehicleProperties <const> in require 'modules.vehicle'
Provider.GetVehicleLabel = GetVehicleLabel
Provider.SetVehicleProperties = SetVehicleProperties
Provider.GetVehicleProperties = GetVehicleProperties

Provider.GetVehicleCategory = function(model)
    return GetVehicleClassFromName(model)
end

Provider.GetVehicleSeats = function(model) 
    return GetVehicleModelNumberOfSeats(model)
end

Provider.GetVehicleVMax = function(model) 
    return 0.0
end

Provider.GetTrunkWeight = function(model)
    return 0.0
end

Provider.DeleteVehicle = function(vehicle) 
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end

Provider.SpawnVehicle = function(modelName, spawnCoords, heading, saveSpawned, cb) 
    local model <const> = type(modelName) == 'number' and modelName or GetHashKey(modelName)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    local vehicle <const> = CreateVehicle(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
    SetModelAsNoLongerNeeded(model)

    if cb then
        cb(vehicle)
    end
end

Provider.AddKeys = function(plate) 
    -- No key system in standalone
end

Provider.ToggleBelt = function(toggle) 
    -- No belt system in standalone
end

return Provider