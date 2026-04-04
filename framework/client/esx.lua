local Provider <const>, ESX <const> = {}, exports['es_extended']:getSharedObject()
local PlayerData = ESX.GetPlayerData() or {}

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    if not xPlayer then
        return
    end

    PlayerData = xPlayer
    TriggerEvent('msk_scripts:playerLoaded') 
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    TriggerEvent('msk_scripts:updatedJob') 
end)

AddEventHandler('msk_garages:hideHud', function(toggle) 
    TriggerEvent('radar:setHidden', toggle)
end)

Provider.IsPlayerLoaded = function()
    return ESX.IsPlayerLoaded()
end

Provider.GetPlayerData = function()
    return PlayerData
end

Provider.GetPlayerGroup = function() 
    return PlayerData.group or 'user'
end

Provider.GetCharId = function()
    return PlayerData.identifier or ''
end

Provider.GetJob = function()
    return PlayerData?.job?.name or 'unemployed'
end

Provider.GetExtraJob = function()
    return 'unemployed' -- ESX doesn't support extra jobs
end

Provider.HaveJob = function(jobName) 
    local job <const> = Provider.GetJob()
    if job == jobName then
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

    if PlayerData.inventory then
        for _, data in ipairs(PlayerData.inventory) do
            if data and data.name == itemName then
                return {
                    item = data.name,
                    count = data.count,
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
    if PlayerData.accounts then
        for _, data in ipairs(PlayerData.accounts) do
            if data and data.name == accountName then
                return {
                    name = data.name,
                    money = data.money,
                }
            end
        end
    end

    return {
        name = accountName,
        money = 0,
    }
end

Provider.ShowNotification = function(msg)
    ESX.ShowNotification(msg)
end

Provider.ShowAdvancedNotification = function(title, msg, icon, duration)
    ESX.ShowAdvancedNotification(title, msg, icon, duration or 5000)
end

Provider.ShowHelpNotification = function(name, msg)
    ESX.ShowHelpNotification(msg, true, false, 1)
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
    return 0.0 -- ESX doesn't have a vmax blocker
end

Provider.GetTrunkWeight = function(model)
    return 0.0 -- ESX doesn't have trunk weight by default
end

Provider.DeleteVehicle = function(vehicle)
    ESX.Game.DeleteVehicle(vehicle)
end

Provider.SpawnVehicle = function(modelName, spawnCoords, heading, saveSpawned, cb) 
    ESX.Game.SpawnVehicle(modelName, spawnCoords, heading, cb)
end

Provider.AddKeys = function(plate) 
    -- ESX doesn't have a default key system
end

Provider.ToggleBelt = function(toggle) 
    -- ESX doesn't have a default belt system
end

return Provider