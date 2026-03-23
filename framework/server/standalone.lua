local Provider <const> = {}

Provider.GetPlayer = function(playerId)
    local identifiers <const>, identifier = GetPlayerIdentifiers(playerId), nil
    for _, id in pairs(identifiers) do
        if string.find(id, 'license:') then
            identifier = id
            break
        end
    end

    local player <const> = {
        source = playerId,
        playerId = playerId,
        identifier = identifier,
        name = GetPlayerName(playerId),
        charid = 0,
        char = {
            firstname = 'firstname',
            lastname = 'lastname',
        }

        triggerEvent = function(eventName, ...)
            TriggerClientEvent(eventName, playerId, ...)
        end,

        getIdentifier = function()
            return identifier
        end,

        getMoney = function(moneyType)
            print('[msk_bridge] [standalone] getMoney is not implemented')
            return 0
        end,

        addMoney = function(moneyType, amount)
            print('[msk_bridge] [standalone] addMoney is not implemented')
        end,

        removeMoney = function(moneyType, amount)
            print('[msk_bridge] [standalone] removeMoney is not implemented')
        end,

        getAccount = function(moneyType)
            print('[msk_bridge] [standalone] getAccount is not implemented for moneyType: ' .. tostring(moneyType))
            return { money = 0 }
        end,

        addAccountMoney = function(moneyType, amount)
            print('[msk_bridge] [standalone] addAccountMoney is not implemented for moneyType: ' .. tostring(moneyType))
        end,

        removeAccountMoney = function(moneyType, amount)
            print('[msk_bridge] [standalone] removeAccountMoney is not implemented for moneyType: ' .. tostring(moneyType))
        end,

        showNotification = function(message)
            print(('[msk_bridge] [standalone] showNotification: %s'):format(message))
        end,

        getPlayerJobs = function()
            print('[msk_bridge] [standalone] getPlayerJobs is not implemented')
            return {}
        end,

        getInventoryItem = function(item)
            print('[msk_bridge] [standalone] getInventoryItem is not implemented for item: ' .. tostring(item))
            return nil
        end,

        removeInventoryItem = function(item, count)
            print('[msk_bridge] [standalone] removeInventoryItem is not implemented for item: ' .. tostring(item))
        end,

        addInventoryItem = function(item, count)
            print('[msk_bridge] [standalone] addInventoryItem is not implemented for item: ' .. tostring(item))
        end,

        addInventoryItemWeapon = function(weaponName, count, ammoCount)
            print('[msk_bridge] [standalone] addInventoryItemWeapon is not implemented for weapon: ' .. tostring(weaponName))
        end,

        getLevel = function()
            print('[msk_bridge] [standalone] getLevel is not implemented')
            return 0
        end,

        addXP = function(amount)
            print('[msk_bridge] [standalone] addXP is not implemented')
        end,

        getName = function()
            return GetPlayerName(playerId)
        end,
    }

    return player
end

Provider.RegisterUsableItem = function(item, cb)
    print('[msk_bridge] [standalone] RegisterUsableItem is not implemented for item: ' .. tostring(item))
end

Provider.UseItem = function(source, item)
    print('[msk_bridge] [standalone] UseItem is not implemented for item: ' .. tostring(item))
end

Provider.GetItemLabel = function(item)
    print('[msk_bridge] [standalone] GetItemLabel is not implemented for item: ' .. tostring(item))
    return item
end

Provider.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
    print(('[msk_bridge] [standalone] RegisterCommand: %s (group: %s, allowConsole: %s)'):format(name, group or 'none', tostring(allowConsole)))
end

Provider.SendLog = function(...)
    print('[msk_bridge] [standalone] SendLog is not implemented')
end

Provider.GetVehicleNumberPlateText = function(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

Provider.GetJobData = function(job)
    print('[msk_bridge] [standalone] GetJobData is not implemented for job: ' .. tostring(job))
    return nil
end

Provider.GetIdCard = function(charid)
    print('[msk_bridge] [standalone] GetIdCard is not implemented')
    return nil
end

Provider.GetPlayers = function()
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        players[#players + 1] = tonumber(playerId)
    end
    return players
end

Provider.GetWeapon = function(...)
    print('[msk_bridge] [standalone] GetWeapon is not implemented')
    return nil
end

Provider.SetPlayerSession = function(playerId, session)
    SetPlayerRoutingBucket(playerId, session)
end

Provider.GetPlayerFromIdentifier = function(identifier)
    for _, playerId in ipairs(GetPlayers()) do
        local ids = GetPlayerIdentifiers(tonumber(playerId))
        for _, id in pairs(ids) do
            if id == identifier then
                return Provider.GetPlayer(tonumber(playerId))
            end
        end
    end
    return nil
end

Provider.TabletCd = function()
    print('[msk_bridge] [standalone] TabletCd is not implemented')
    return nil
end

Provider.GetCounter = function(option)
    print('[msk_bridge] [standalone] GetCounter is not implemented for option: ' .. tostring(option))
    return 0
end

Provider.BanPlayer = function(playerId, reason)
    print('[msk_bridge] [standalone] BanPlayer is not implemented')
end

return Provider