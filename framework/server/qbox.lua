local Provider <const> = {}
local loadedAt = {}

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
            badge = '',
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

        updateChar = function(key, value)
            if not key then return end
            local charinfoKeys <const> = { firstname = true, lastname = true, dateofbirth = true, sex = true, gender = true, height = true, nationality = true, account = true, phone = true }
            if charinfoKeys[key] then
                pd.charinfo = pd.charinfo or {}
                pd.charinfo[key] = value
                if Player.Functions and Player.Functions.SetPlayerData then
                    Player.Functions.SetPlayerData('charinfo', pd.charinfo)
                end
            else
                pd[key] = value
                if Player.Functions and Player.Functions.SetPlayerData then
                    Player.Functions.SetPlayerData(key, value)
                end
            end
        end,
    }
end

local function triggerPlayerLoaded(playerId)
    playerId = tonumber(playerId)
    if not playerId then
        return
    end

    local now <const> = GetGameTimer()
    if loadedAt[playerId] and now - loadedAt[playerId] < 1000 then
        return
    end

    local Player <const> = Provider.GetPlayer(playerId)
    if not Player then
        return
    end

    loadedAt[playerId] = now
    TriggerEvent('msk_scripts:playerLoaded', playerId, Player)
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    triggerPlayerLoaded(source)
end)

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    local playerData <const> = type(Player) == 'table' and Player.PlayerData or nil
    triggerPlayerLoaded(playerData and playerData.source or source)
end)

RegisterNetEvent('qbx_core:server:playerLoaded', function(Player)
    local playerData <const> = type(Player) == 'table' and Player.PlayerData or nil
    triggerPlayerLoaded(playerData and playerData.source or source)
end)

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

local function hasPermission(source, group)
    if not group or group == 'user' then
        return true
    end

    if type(group) == 'table' then
        for _, permission in ipairs(group) do
            if exports.qbx_core:HasPermission(source, permission) then
                return true
            end
        end

        return false
    end

    return exports.qbx_core:HasPermission(source, group)
end

local function parseCommandArgs(args, suggestion)
    local parsed = {}
    local arguments <const> = suggestion and suggestion.arguments or {}

    for i = 1, #arguments do
        local argument <const> = arguments[i]
        local value = args[i]

        if argument.type == 'player' then
            local playerId <const> = tonumber(value)
            parsed[argument.name] = playerId and { playerId = playerId, source = playerId } or nil
        else
            parsed[argument.name] = value
        end
    end

    return next(parsed) and parsed or args
end

Provider.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
    RegisterCommand(name, function(source, args)
        if source == 0 and not allowConsole then
            return print(('[msk_bridge] Command /%s is player-only'):format(name))
        end

        if source ~= 0 and not hasPermission(source, group) then
            return
        end

        local xPlayer <const> = source ~= 0 and Provider.GetPlayer(source) or false
        local function showError(message)
            if source == 0 then
                print(message)
            elseif xPlayer and xPlayer.showNotification then
                xPlayer.showNotification(message)
            end
        end

        cb(xPlayer, parseCommandArgs(args or {}, suggestion), showError)
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

Provider.GetPlayerFromCharId = function(charid)
    local Player <const> = exports.qbx_core:GetPlayerByCitizenId(charid)
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

Provider.BonusRewards = function(playerId)
    return 1.0
end

return Provider
