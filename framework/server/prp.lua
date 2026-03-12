local Provider <const> = {}

require '@prp_framework.imports'

Provider.GetPlayer = function(playerId)
    local xPlayer <const> = PRP.GetPlayer(playerId)
    if not xPlayer then
        return nil
    end

    local _triggerEvent <const> = xPlayer.triggerEvent
    rawset(xPlayer, 'triggerEvent', function(...)
        return _triggerEvent(...)
    end)

    local _showNotification <const> = xPlayer.showNotification
    rawset(xPlayer, 'showNotification', function(...)
        return _showNotification(...)
    end)

    local _getMoney <const> = xPlayer.getMoney
    rawset(xPlayer, 'getMoney', function(...)
        return _getMoney(...)
    end)    
	
	local _getAccount <const> = xPlayer.getAccount
    rawset(xPlayer, 'getAccount', function(...)
        return _getAccount(...)
    end)

    local _removeAccountMoney <const> = xPlayer.removeAccountMoney
    rawset(xPlayer, 'removeAccountMoney', function(...)
        return _removeAccountMoney(...)
    end)   

	local _addAccountMoney <const> = xPlayer.addAccountMoney
    rawset(xPlayer, 'addAccountMoney', function(...)
        return _addAccountMoney(...)
    end)	
	
	local _removeMoney <const> = xPlayer.removeMoney
    rawset(xPlayer, 'removeMoney', function(...)
        return _removeMoney(...)
    end)	
	
	local _addMoney <const> = xPlayer.addMoney
    rawset(xPlayer, 'addMoney', function(...)
        return _addMoney(...)
    end)

    rawset(xPlayer, 'getPlayerJobs', function()
        return exports['prp_multijob']:GetPlayerJobs(xPlayer) or {}
    end)

    local _getInventoryItem <const> = xPlayer.getInventoryItem
    rawset(xPlayer, 'getInventoryItem', function(...)
        return _getInventoryItem(...)
    end)

    local _removeInventoryItem <const> = xPlayer.removeInventoryItem
    rawset(xPlayer, 'removeInventoryItem', function(...)
        return _removeInventoryItem(...)
    end)       
	
	local _addInventoryItem <const> = xPlayer.addInventoryItem
    rawset(xPlayer, 'addInventoryItem', function(...)
        return _addInventoryItem(...)
    end)    
	
	local _getLevel <const> = xPlayer.getLevel
    rawset(xPlayer, 'getLevel', function(...)
        return _getLevel(...)
    end)		
	
	local _addXP <const> = xPlayer.addXP
    rawset(xPlayer, 'addXP', function(...)
        return _addXP(...)
    end)		
	
	local _getName <const> = xPlayer.getName
    rawset(xPlayer, 'getName', function(...)
        return _getName(...)
    end)	

    return xPlayer
end

Provider.RegisterUsableItem = function(...)
    PRP.RegisterUsableItem(...)
end

Provider.UseItem = function(...)
    PRP.UseItem(...)
end

Provider.GetItemLabel = function(...)
    return PRP.GetItemLabel(...)
end

Provider.RegisterCommand = function(...)
    PRP.RegisterCommand(...)
end

Provider.SendLog = function(...)
    PRP.SendLog(...)
end

Provider.GetVehicleNumberPlateText = function(...) 
    return PRP.GetVehicleNumberPlateText(...)
end

Provider.GetJobData = function(job)
    local jobData <const> = PRP.GetJobData(job)
    if jobData then
        return {
            name = job,
            label = jobData.label,
        }
    end

    local orgName <const> = exports['prp_jobs']:GetOrgLabel(job)
    if orgName then
        return {
            name = job,
            label = orgName,
        }
    end

    return nil
end

Provider.GetIdCard = function(charid)
    return PRP.GetIdCard(charid)
end

Provider.GetPlayers = function()
    return PRP.GetPlayers()
end

Provider.SetPlayerSession = function(playerId, session) 
    SetPlayerRoutingBucket(playerId, session)
    TriggerClientEvent('prp:setBucket', playerId, session)
end

Provider.GetPlayerFromIdentifier = function(identifier)
    local xIdentifier <const> = PRP.GetPlayerFromIdentifier(identifier)
    if not xIdentifier then
        return nil
    end

    local xPlayer <const> = Provider.GetPlayer(xIdentifier.source)
    if not xPlayer then
        return nil
    end

	return xPlayer
end

Provider.TabletCd = function()
    return PRP.TabletCd()
end

return Provider