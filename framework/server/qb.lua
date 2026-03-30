local Provider <const> = {}
local QBCore <const> = exports['qb-core']:GetCoreObject()

Provider.GetPlayer = function(playerId)
    local Player <const> = QBCore.Functions.GetPlayer(playerId)
    if not Player then
        return nil
    end

    local pd <const> = Player.PlayerData

    return {
        source = playerId,
        playerId = playerId,
        identifier = pd.citizenid,
        charid = pd.citizenid,
        group = QBCore.Functions.HasPermission(playerId, 'admin') and 'admin' or 'user',
        job = pd.job,
        char = {
            firstname = pd.charinfo and pd.charinfo.firstname or 'firstname',
            lastname = pd.charinfo and pd.charinfo.lastname or 'lastname',
        },

        triggerEvent = function(eventName, ...)
            TriggerClientEvent(eventName, playerId, ...)
        end,

        showNotification = function(msg)
            TriggerClientEvent('QBCore:Notify', playerId, msg, 'primary', 5000)
        end,

        getMoney = function(moneyType)
            return Player.Functions.GetMoney(moneyType) or 0
        end,

        getAccount = function(moneyType)
            return { money = Player.Functions.GetMoney(moneyType) or 0 }
        end,

        addAccountMoney = function(moneyType, amount)
            Player.Functions.AddMoney(moneyType, amount, 'msk_bridge')
        end,

        removeAccountMoney = function(moneyType, amount)
            Player.Functions.RemoveMoney(moneyType, amount, 'msk_bridge')
        end,

        addMoney = function(moneyType, amount)
            Player.Functions.AddMoney(moneyType, amount, 'msk_bridge')
        end,

        removeMoney = function(moneyType, amount)
            Player.Functions.RemoveMoney(moneyType, amount, 'msk_bridge')
        end,

        getPlayerJobs = function()
            local jobs = {}
            if pd.job then jobs[#jobs + 1] = pd.job end
            if pd.gang then jobs[#jobs + 1] = pd.gang end
            return jobs
        end,

        getInventoryItem = function(item)
            if pd.items then
                for _, data in pairs(pd.items) do
                    if data and data.name == item then
                        return data
                    end
                end
            end
            return nil
        end,

        removeInventoryItem = function(item, count)
            if GetResourceState('qb-inventory') ~= 'missing' then
                exports['qb-inventory']:RemoveItem(playerId, item, count)
            end
        end,

        addInventoryItem = function(item, count)
            if GetResourceState('qb-inventory') ~= 'missing' then
                exports['qb-inventory']:AddItem(playerId, item, count)
            end
        end,

        addInventoryItemWeapon = function(weaponName, count, ammoCount)
            if GetResourceState('qb-inventory') ~= 'missing' then
                for i = 1, count do
                    exports['qb-inventory']:AddItem(playerId, weaponName, 1, { ammo = ammoCount })
                end
            end
        end,

        getLevel = function()
            print('[msk_bridge] [qb] getLevel is not implemented')
            return 0
        end,

        addXP = function(amount)
            print('[msk_bridge] [qb] addXP is not implemented')
        end,

        getName = function()
            if pd.charinfo then
                return pd.charinfo.firstname .. ' ' .. pd.charinfo.lastname
            end
            return GetPlayerName(playerId)
        end,
    }
end

Provider.RegisterUsableItem = function(item, cb)
    QBCore.Functions.CreateUseableItem(item, function(source)
        cb(source)
    end)
end

Provider.UseItem = function(source, item)
    QBCore.Functions.UseItem(source, item)
end

Provider.GetItemLabel = function(item)
    local items = QBCore.Shared.Items
    if items and items[item] then
        return items[item].label
    end
    return item
end

Provider.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
    RegisterCommand(name, function(source, args)
        if group and group ~= 'user' and not QBCore.Functions.HasPermission(source, group) then
            return
        end
        cb(source, args)
    end, false)
end

Provider.SendLog = function(...)
    print('[msk_bridge] [qb] SendLog is not implemented')
end

Provider.GetVehicleNumberPlateText = function(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

Provider.GetJobData = function(job)
    local jobs = QBCore.Shared.Jobs
    if jobs and jobs[job] then
        return {
            name = job,
            label = jobs[job].label,
        }
    end
    return nil
end

Provider.GetIdCard = function(charid)
    print('[msk_bridge] [qb] GetIdCard is not implemented')
    return nil
end

Provider.GetPlayers = function()
    return QBCore.Functions.GetPlayers()
end

Provider.GetWeapon = function(weaponName)
    if QBCore.Shared.Weapons and QBCore.Shared.Weapons[weaponName] then
        return QBCore.Shared.Weapons[weaponName]
    end
    return nil
end

Provider.SetPlayerSession = function(playerId, session)
    QBCore.Functions.SetPlayerBucket(playerId, session)
end

Provider.GetPlayerFromIdentifier = function(identifier)
    local Player <const> = QBCore.Functions.GetPlayerByCitizenId(identifier)
    if not Player then
        return nil
    end
    return Provider.GetPlayer(Player.PlayerData.source)
end

Provider.TabletCd = function()
    print('[msk_bridge] [qb] TabletCd is not implemented')
    return nil
end

Provider.GetCounter = function(option)
    if option == 'admin' then
        local count = 0
        for _, src in pairs(QBCore.Functions.GetPlayers()) do
            if QBCore.Functions.HasPermission(src, 'admin') then
                count = count + 1
            end
        end
        return count
    end

    return QBCore.Functions.GetDutyCount(option) or 0
end

Provider.BanPlayer = function(playerId, reason)
    QBCore.Functions.Kick(playerId, reason or 'Banned')
end

return Provider