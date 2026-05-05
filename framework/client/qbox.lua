local Provider <const> = {}
local Events <const> = require 'framework.client.events'
local PlayerData = exports.qbx_core:GetPlayerData() or {}

AddEventHandler('playerSpawned', function(...)
    Events.TriggerPlayerSpawn(...)
end)

RegisterNetEvent('qb-license:client:onUpdate', function(license)
    Events.TriggerLicensesUpdated(license)
end)

RegisterNetEvent('qbx_license:client:onUpdate', function(license)
    Events.TriggerLicensesUpdated(license)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = exports.qbx_core:GetPlayerData() or {}
    Events.TriggerPlayerLoaded(PlayerData)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    TriggerEvent('msk_scripts:updatedJob')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val

    local licenses <const> = Events.GetPlayerLicenses(PlayerData)
    if licenses then
        Events.TriggerLicensesUpdated(licenses)
    end
end)

AddEventHandler('msk_garages:hideHud', function(toggle)
    TriggerEvent('radar:setHidden', toggle)
end)

Provider.IsPlayerLoaded = function()
    return LocalPlayer.state.isLoggedIn or false
end

Provider.GetPlayerData = function()
    return PlayerData
end

Provider.GetPlayerGroup = function()
    return 'user' -- QBOX uses ACE permissions
end

Provider.GetCharId = function()
    return PlayerData.citizenid or ''
end

Provider.GetJob = function()
    return PlayerData?.job?.name or 'unemployed'
end

Provider.GetExtraJob = function()
    return PlayerData?.gang?.name or 'unemployed'
end

Provider.HaveJob = function(jobName)
    local job <const> = Provider.GetJob()
    if job == jobName then
        return true
    end

    local extra <const> = Provider.GetExtraJob()
    if extra == jobName then
        return true
    end

    return false
end

Provider.GetItem = function(itemName)
    if GetResourceState('ox_inventory') == 'started' then
        local count = exports.ox_inventory:Search('count', itemName)
        local itemData <const> = exports.ox_inventory:Items(itemName)
        return {
            item = itemName,
            count = count or 0,
            label = itemData and itemData.label or itemName,
        }
    end

    return {
        item = itemName,
        count = 0,
        label = itemName,
    }
end

Provider.GetAccount = function(accountName)
    local money = PlayerData.money and PlayerData.money[accountName] or 0
    return {
        name = accountName,
        money = money,
    }
end

Provider.ShowNotification = function(msg)
    exports.qbx_core:Notify(msg, 'inform', 5000)
end

Provider.ShowAdvancedNotification = function(title, msg, icon, duration)
    exports.qbx_core:Notify(msg, 'inform', duration or 5000)
end

Provider.ShowHelpNotification = function(name, msg)
    exports.qbx_core:Notify(msg, 'inform', 5000)
end

local GetVehicleLabel <const>, SetVehicleProperties <const>, GetVehicleProperties <const> in require 'modules.vehicle'
Provider.GetVehicleLabel = GetVehicleLabel
Provider.SetVehicleProperties = SetVehicleProperties
Provider.GetVehicleProperties = GetVehicleProperties

Provider.GetVehicleCategory = function(model, vehicle)
    return GetVehicleClassFromName(model)
end

Provider.GetVehicleSeats = function(model)
    return GetVehicleModelNumberOfSeats(model)
end

Provider.GetVehicleVMax = function(model, vehicle)
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
    -- QBOX doesn't have a default key system
end

Provider.ToggleBelt = function(toggle)
    -- QBOX doesn't have a default belt system
end

return Provider
