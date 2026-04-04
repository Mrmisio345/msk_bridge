local Provider <const>, Core <const> = {}, exports['prp_framework']:GetSharedObject()
local PlayerData = Core.PlayerData or {}

RegisterNetEvent('prp:playerLoaded', function(xPlayer)
    if not xPlayer then 
        return 
    end

    PlayerData = xPlayer
    TriggerEvent('msk_scripts:playerLoaded')
end)

RegisterNetEvent('prp:setJob', function(job)
	PlayerData.job = job
    TriggerEvent('msk_scripts:updatedJob') 
end)

RegisterNetEvent('prp:onUpdateOrg', function(data) 
	while Core == nil or PlayerData.job == nil do 
		Wait(500)
	end
	
	if data then
		PlayerData.extra = data		
	end

    TriggerEvent('msk_scripts:updatedJob')
end)

RegisterNetEvent('prp:setAccountMoney', function(account)
	for key, data in ipairs(PlayerData.accounts) do
		if data and data.name == account.name then
			PlayerData.accounts[key] = account
			break
		end
	end
end)

RegisterNetEvent('prp:addInventoryItem', function(item)
    if PlayerData.inventory then		
        for key, data in ipairs(PlayerData.inventory) do
            if data and data.name == item.name then			
                PlayerData.inventory[key] = item			
                TriggerEvent('msk_scripts:inventoryUpdated', item.name, item.count)
                return
            end
        end

        table.insert(PlayerData.inventory, item)
        TriggerEvent('msk_scripts:inventoryUpdated', item.name, item.count)
    end
end)

RegisterNetEvent('prp:removeInventoryItem', function(item)
    if PlayerData.inventory then		
        for key, data in ipairs(PlayerData.inventory) do
            if data and data.name == item.name then						
                PlayerData.inventory[key] = item	
                TriggerEvent('msk_scripts:inventoryUpdated', item.name, item.count)
                return
            end
        end
        
        table.insert(PlayerData.inventory, item)
        TriggerEvent('msk_scripts:inventoryUpdated', item.name, item.count)
    end
end)

RegisterNetEvent('prp:updateItem', function(item)	
    if PlayerData.inventory then
        for key, data in ipairs(PlayerData.inventory) do
            if data and data.name == item.name then
                PlayerData.inventory[key] = item
                TriggerEvent('msk_scripts:inventoryUpdated', item.name, item.count)
                break
            end
        end
    end
end)

AddEventHandler('msk_garages:hideHud', function(toggle)
    TriggerEvent('radar:setHidden', toggle)
end)

Provider.IsPlayerLoaded = function()
	return LocalPlayer.state.Connected
end

Provider.GetPlayerData = function()
    return PlayerData
end

Provider.GetPlayerGroup = function()
    return PlayerData.group or 'user'
end

Provider.GetCharId = function()
    return PlayerData.charid or 0
end

Provider.GetJob = function() 
    return PlayerData?.job?.name or 'unemployed'
end

Provider.GetExtraJob = function() 
    return PlayerData?.extra?.name or 'unemployed'
end

Provider.HaveJob = function(jobName)
    local job <const> = Provider.GetJob()
    if job == jobName then
        return true
    end

    local job <const> = Provider.GetExtraJob()
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
    Core.ShowNotification(msg)
end

Provider.ShowAdvancedNotification = function(title, msg, icon, duration)
    Core.ShowAdvancedNotification(title, msg, icon, duration)
end

Provider.ShowHelpNotification = function(name, msg)
    Core.ShowHelpNotification(name, msg)
end

Provider.GetVehicleLabel = function(model) 
    local customName <const> = exports['prp_vmaxblocker']:getVehicleLabel(model)
    local name = 'Brak danych'
    if customName then
        name = customName
    else
        name = GetDisplayNameFromVehicleModel(model)
        local label <const> = GetLabelText(name)
        if label ~= "NULL" then												
            name = label
        end					
    end

    return name
end

Provider.GetVehicleCategory = function(model)
    return exports['prp_vmaxblocker']:getVehicleClass(model)
end

Provider.GetVehicleSeats = function(model)
    return GetVehicleModelNumberOfSeats(model)
end

Provider.GetVehicleVMax = function(model) 
    return exports['prp_vmaxblocker']:getVehicleVMax(model)
end

Provider.GetTrunkWeight = function(model) 
    return exports['prp_inventory']:getModelTrunkWeight(model) / 1000
end

Provider.GetVehicleProperties = function(vehicle) 
    return Core.Game.GetVehicleProperties(vehicle)
end

Provider.DeleteVehicle = function(vehicle) 
    Core.Game.DeleteVehicle(vehicle)
end

Provider.SpawnVehicle = function(modelName, spawnCoords, heading, saveSpawned, cb) 
    Core.Game.SpawnVehicle(modelName, spawnCoords, heading, saveSpawned, cb)
end

Provider.SetVehicleProperties = function(vehicle, props, loadDeformation) 
    Core.Game.SetVehicleProperties(vehicle, props, loadDeformation)
end

Provider.AddKeys = function(plate) 
    TriggerEvent('prp_kluczyki:dodajklucze', plate, true)	
end

Provider.ToggleBelt = function(toggle) 
    TriggerEvent('prp_dzwon:belt', toggle)
end

return Provider