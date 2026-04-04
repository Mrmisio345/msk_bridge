local Provider <const> = {}
local QBCore <const> = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData() or {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    TriggerEvent('msk_scripts:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    TriggerEvent('msk_scripts:updatedJob')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
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
    return 'user' -- QB uses ACE permissions, no group field
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
        return {
            item = itemName,
            count = count or 0,
        }
    end

    if PlayerData.items then
        for _, data in pairs(PlayerData.items) do
            if data and data.name == itemName then
                return {
                    item = data.name,
                    count = data.amount or data.count or 0,
                }
            end
        end
    end

    return {
        item = itemName,
        count = 0,
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
    QBCore.Functions.Notify(msg, 'primary', 5000)
end

Provider.ShowAdvancedNotification = function(title, msg, icon, duration)
    QBCore.Functions.Notify(msg, 'primary', duration or 5000)
end

Provider.ShowHelpNotification = function(name, msg)
    QBCore.Functions.Notify(msg, 'primary', 5000)
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
    TriggerEvent('vehiclekeys:client:SetOwner', plate)
end

Provider.ToggleBelt = function(toggle)
    -- QB doesn't have a default belt system
end

return Provide