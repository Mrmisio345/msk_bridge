local Events <const> = {}
local lastPlayerSpawn = -1000

local function addLicense(list, license)
    if type(license) == 'string' then
        list[#list + 1] = { type = license }
    elseif type(license) == 'table' then
        list[#list + 1] = license.type and license or { type = license.name }
    end
end

Events.NormalizeLicenses = function(licenses)
    if type(licenses) ~= 'table' then
        return {}
    end

    local list = {}
    for key, value in pairs(licenses) do
        if type(key) == 'number' then
            addLicense(list, value)
        elseif value then
            addLicense(list, key)
        end
    end

    return list
end

Events.GetPlayerLicenses = function(playerData)
    if type(playerData) ~= 'table' then
        return nil
    end

    if playerData.licenses or playerData.licences then
        return playerData.licenses or playerData.licences
    end

    local metadata <const> = playerData.metadata
    if type(metadata) == 'table' then
        return metadata.licenses or metadata.licences
    end

    return nil
end

Events.TriggerLicensesUpdated = function(licenses)
    TriggerEvent('msk_scripts:licensesUpdated', Events.NormalizeLicenses(licenses))
end

Events.TriggerPlayerLoaded = function(playerData)
    TriggerEvent('msk_scripts:playerLoaded', playerData)

    local licenses <const> = Events.GetPlayerLicenses(playerData)
    if licenses then
        Events.TriggerLicensesUpdated(licenses)
    end
end

Events.TriggerPlayerSpawn = function(...)
    local now <const> = GetGameTimer()
    if now - lastPlayerSpawn < 1000 then
        return
    end

    lastPlayerSpawn = now
    TriggerEvent('msk_scripts:onPlayerSpawn', ...)
end

return Events
