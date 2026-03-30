local Provider <const> = {}

Provider.GetPlayer = function(playerId)
    local Player <const> = exports.qbx_core:GetPlayer(playerId)
    if not Player then
        return nil
    end

    local pd <const> = Player.PlayerData

    return {
        source = playerId,
        playerId = playerId,
        identifier = pd.citizenid,
        charid = pd.citizenid,
        group = exports.qbx_core:HasPermission(playerId, 'admin') and 'admin' or 'user',
        job = pd.job,
        char = {
            firstname = pd.charinfo and pd.charinfo.firstname or 'firstname',
            lastname = pd.charinfo and pd.charinfo.lastname or 'lastname',
        },

        triggerEvent = function(eventName, ...)
            TriggerClientEvent(eventName, playerId, ...)
        end,

        showNotification = function(msg)
            exports.qbx_core:Notify(playerId, msg, 'inform', 5000)
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
            if GetResourceState('ox_inventory') == 'started' then
                local count = exports.ox_inventory:Search(playerId, 'count', item)
                return { name = item, amount = count or 0 }
            end
            return nil
        end,

        removeInventoryItem = function(item, count)
            if GetResourceState('ox_inventory') == 'started' then
                exports.ox_inventory:RemoveItem(playerId, item, count)
            end
        end,

        addInventoryItem = function(item, count)
            if GetResourceState('ox_inventory') == 'started' then
                exports.ox_inventory:AddItem(playerId, item, count)
            end
        end,

        addInventoryItemWeapon = function(weaponName, count, ammoCount)
            if GetResourceState('ox_inventory') == 'started' then
                for i = 1, count do
                    exports.ox_inventory:AddItem(playerId, weaponName, 1, { ammo = ammoCount })
                end
            end
        end,

        getLevel = function()
            print('[msk_bridge] [qbox] getLevel is not implemented')
            return 0
        end,

        addXP = function(amount)
            print('[msk_bridge] [qbox] addXP is not implemented')
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
    exports.qbx_core:CreateUseableItem(item, function(source)
        cb(source)
    end)
end

Provider.UseItem = function(source, item)
    print('[msk_bridge] [qbox] UseItem - use ox_inventory for item usage')
end

Provider.GetItemLabel = function(item)
    if GetResourceState('ox_inventory') == 'started' then
        local itemData = exports.ox_inventory:Items(item)
        if itemData then
            return itemData.label
        end
    end
    return item
end

Provider.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
    RegisterCommand(name, function(source, args)
        if group and group ~= 'user' and not exports.qbx_core:HasPermission(source, group) then
            return
        end
        cb(source, args)
    end, false)
end

Provider.SendLog = function(...)
    print('[msk_bridge] [qbox] SendLog is not implemented')
end

Provider.GetVehicleNumberPlateText = function(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

Provider.GetJobData = function(job)
    -- QBOX stores jobs internally, try QB bridge compatibility
    local QBCore = exports['qb-core']
    local success, result = pcall(function()
        return QBCore:GetJob(job)
    end)

    if success and result then
        return {
            name = job,
            label = result.label,
        }
    end

    return nil
end

Provider.GetIdCard = function(charid)
    print('[msk_bridge] [qbox] GetIdCard is not implemented')
    return nil
end

Provider.GetPlayers = function()
    local sources = {}
    local players = exports.qbx_core:GetQBPlayers()
    for k in pairs(players) do
        sources[#sources + 1] = k
    end
    return sources
end

Provider.GetWeapon = function(...)
    print('[msk_bridge] [qbox] GetWeapon is not implemented')
    return nil
end

Provider.SetPlayerSession = function(playerId, session)
    exports.qbx_core:SetPlayerBucket(playerId, session)
end

Provider.GetPlayerFromIdentifier = function(identifier)
    local Player <const> = exports.qbx_core:GetPlayerByCitizenId(identifier)
    if not Player then
        return nil
    end
    return Provider.GetPlayer(Player.PlayerData.source)
end

Provider.TabletCd = function()
    print('[msk_bridge] [qbox] TabletCd is not implemented')
    return nil
end

Provider.GetCounter = function(option)
    if option == 'admin' then
        local count = 0
        local players = exports.qbx_core:GetQBPlayers()
        for src in pairs(players) do
            if exports.qbx_core:HasPermission(src, 'admin') then
                count = count + 1
            end
        end
        return count
    end

    local dutyCount = exports.qbx_core:GetDutyCountJob(option)
    return dutyCount or 0
end

Provider.BanPlayer = function(playerId, reason)
    DropPlayer(playerId, reason or 'Banned')
end

return Provider