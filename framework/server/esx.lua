local Provider <const>, ESX <const> = {}, exports['es_extended']:getSharedObject()

Provider.GetPlayer = function(playerId)
    local xPlayer <const> = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        return nil
    end

    return {
        source = playerId,
        playerId = playerId,
        identifier = xPlayer.identifier,
        charid = xPlayer.identifier,
        group = xPlayer.group,
        job = xPlayer.job,

        triggerEvent = function(eventName, ...)
            TriggerClientEvent(eventName, playerId, ...)
        end,

        showNotification = function(msg)
            xPlayer.showNotification(msg)
        end,

        getMoney = function(moneyType)
            return xPlayer.getMoney(moneyType)
        end,

        getAccount = function(moneyType)
            return xPlayer.getAccount(moneyType)
        end,

        addAccountMoney = function(moneyType, amount)
            xPlayer.addAccountMoney(moneyType, amount)
        end,

        removeAccountMoney = function(moneyType, amount)
            xPlayer.removeAccountMoney(moneyType, amount)
        end,

        addMoney = function(moneyType, amount)
            xPlayer.addAccountMoney(moneyType, amount)
        end,

        removeMoney = function(moneyType, amount)
            xPlayer.removeAccountMoney(moneyType, amount)
        end,

        getPlayerJobs = function()
            return { xPlayer.job }
        end,

        getInventoryItem = function(item)
            return xPlayer.getInventoryItem(item)
        end,

        removeInventoryItem = function(item, count)
            xPlayer.removeInventoryItem(item, count)
        end,

        addInventoryItem = function(item, count)
            xPlayer.addInventoryItem(item, count)
        end,

        getLevel = function()
            print('[msk_bridge] [esx] getLevel is not implemented')
            return 0
        end,

        addXP = function(amount)
            print('[msk_bridge] [esx] addXP is not implemented')
        end,

        getName = function()
            return xPlayer.getName()
        end,
    }
end

Provider.RegisterUsableItem = function(item, cb)
    ESX.RegisterUsableItem(item, function(playerId)
        cb(playerId)
    end)
end

Provider.UseItem = function(source, item)
    ESX.UseItem(source, item)
end

Provider.GetItemLabel = function(item)
    local items = ESX.GetItems()
    if items and items[item] then
        return items[item].label
    end

    return item
end

Provider.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
    ESX.RegisterCommand(name, group, cb, allowConsole, suggestion)
end

Provider.SendLog = function(...)
    print('[msk_bridge] [esx] SendLog is not implemented')
end

Provider.GetVehicleNumberPlateText = function(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

Provider.GetJobData = function(job)
    local jobs = ESX.GetJobs()
    if jobs and jobs[job] then
        return {
            name = job,
            label = jobs[job].label,
        }
    end

    return nil
end

Provider.GetIdCard = function(charid)
    print('[msk_bridge] [esx] GetIdCard is not implemented')
    return nil
end

Provider.GetPlayers = function()
    return ESX.GetPlayers()
end

Provider.SetPlayerSession = function(playerId, session)
    SetPlayerRoutingBucket(playerId, session)
end

Provider.GetPlayerFromIdentifier = function(identifier)
    local xPlayer <const> = ESX.GetPlayerFromIdentifier(identifier)
    if not xPlayer then
        return nil
    end

    return Provider.GetPlayer(xPlayer.source)
end

Provider.TabletCd = function()
    print('[msk_bridge] [esx] TabletCd is not implemented')
    return nil
end

Provider.GetCounter = function(option)
    if option == 'admin' then
        local counts <const>, total = ESX.GetNumPlayers('group', Config.AdminGroups), 0
        for _, count in pairs(counts) do
            total = total + count
        end
        
        return total
    end

    return ESX.GetNumPlayers('job', option)
end

return Provider