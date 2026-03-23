local Config <const> = require 'data.config'
local Framework <const>, Target <const> in require 'shared.loader'
local Provider <const>, Utils <const> = require(('framework.server.%s'):format(Framework)) or {}, require 'shared.utils'

for key, value in pairs(Utils) do
    if not Provider[key] then
        Provider[key] = value
    end
end

if not Provider['SendLog'] then
    local SendLog <const>, ClearIdentifierCache <const> in require 'server.logs'
    Provider.SendLog = SendLog

    AddEventHandler('playerDropped', function()
        local _source <const> = source
        ClearIdentifierCache(_source)        
    end)
end

Provider.CheckVersion = function()
    local resourceName <const> = GetInvokingResource() or GetCurrentResourceName()
    if not resourceName then 
        return print(("^1[%s] ^7Failed to determine resource name for version check^0"):format(GetCurrentResourceName()))
    end

    local currentVersion <const> = GetResourceMetadata(resourceName, "version", 0)
    if not currentVersion then
        return print(("^1[%s] ^7Missing version in fxmanifest.lua^0"):format(resourceName))
    end

    local url <const> = ("https://raw.githubusercontent.com/Mrmisio345/mskscripts-version/main/%s.json"):format(resourceName)
    PerformHttpRequest(url, function(status, response)
        if status == 404 then
            return print(("^3[%s] ^7No version info found (404)^0"):format(resourceName))
        end

        if status ~= 200 or not response then
            return print(("^1[%s] ^7Failed to check version (HTTP %s)^0"):format(resourceName, tostring(status)))
        end

        local data <const> = json.decode(response)
        if not data or not data.version then 
            return print(("^1[%s] ^7Invalid version data received^0"):format(resourceName))
        end

        local function versionToNumber(v)
            local n = 0
            local mult = 1000000
            for part in v:gmatch("(%d+)") do
                n = n + tonumber(part) * mult
                mult = mult / 1000
            end
            return n
        end

        local remote <const> = versionToNumber(data.version)
        local local_ <const> = versionToNumber(currentVersion)
        if local_ >= remote then
            print(("^5[%s] ^2✓ Up to date (%s)^0"):format(resourceName, currentVersion))
        else
            local lines <const> = {
                "^5┌──────────────────────────────────────────┐^0",
                ("^5│^0 ^3%-40s ^5│^0"):format(resourceName),
                "^5├──────────────────────────────────────────┤^0",
                ("^5│^0 ^1Current: ^7%-32s ^5│^0"):format(currentVersion),
                ("^5│^0 ^2Latest:  ^7%-32s ^5│^0"):format(data.version),
            }

            if data.descriptions and #data.descriptions > 0 then
                lines[#lines + 1] = "^5├──────────────────────────────────────────┤^0"
                for _, desc in ipairs(data.descriptions) do
                    lines[#lines + 1] = ("^5│^0 ^3• ^7%-38s ^5│^0"):format(desc:sub(1, 38))
                end
            end

            lines[#lines + 1] = "^5├──────────────────────────────────────────┤^0"
            lines[#lines + 1] = "^5│^0 ^1Download the latest version from^0        ^5│^0"
            lines[#lines + 1] = "^5│^0 ^3https://portal.cfx.re^0                   ^5│^0"
            lines[#lines + 1] = "^5└──────────────────────────────────────────┘^0"

            print(table.concat(lines, '\n'))
        end
    end, "GET")
end

exports('GetFramework', function()
    return Provider
end)

-- On Stop
AddEventHandler('onResourceStop', function(resourceName)
    local invokedResource <const> = GetInvokingResource()
    if invokedResource == GetCurrentResourceName() then
        return
    end

    if not string.find(resourceName, 'msk_') then
        return
    end

    TriggerEvent('onResourceStop', resourceName)
end)

MySQL.ready(function()
    local resourceName <const> = GetCurrentResourceName()
    local currentVersion <const> = GetResourceMetadata(resourceName, "version", 0) or 'unknown'
    local url <const> = ("https://raw.githubusercontent.com/Mrmisio345/mskscripts-version/main/%s.json"):format(resourceName)

    PerformHttpRequest(url, function(status, response)
        local latestVersion, isOutdated = nil, false

        if status == 200 and response then
            local data <const> = json.decode(response)
            if data and data.version then
                local function versionToNumber(v)
                    local n, mult = 0, 1000000
                    for part in v:gmatch("(%d+)") do
                        n = n + tonumber(part) * mult
                        mult = mult / 1000
                    end
                    return n
                end
                latestVersion = data.version
                isOutdated = versionToNumber(currentVersion) < versionToNumber(latestVersion)
            end
        end

        local lines = {
            '^5┌─────────────────────────────────────────────┐^7',
            '^5│^7                 ^3MSK BRIDGE^7                  ^5│^7',
            '^5├─────────────────────────────────────────────┤^7',
            ('^5│^7  Framework             ^5→  ^3%-18s^5│^7'):format(Framework or 'standalone'),
            ('^5│^7  Target                ^5→  ^3%-18s^5│^7'):format(Target or 'none'),
            ('^5│^7  FloatingNotification  ^5→  ^3%-18s^5│^7'):format(Config.FloatingNotification or 'none'),
            ('^5│^7  ProgressBar           ^5→  ^3%-18s^5│^7'):format(Config.ProgressBar or 'none'),
            ('^5│^7  Side                  ^5→  ^3%-18s^5│^7'):format('server'),
            ('^5│^7  Utils                 ^5→  ^2%-18s^5│^7'):format('loaded'),
            '^5├─────────────────────────────────────────────┤^7',
        }

        if isOutdated then
            lines[#lines + 1] = ('^5│^7  Version               ^5→  ^1%-18s^5│^7'):format(currentVersion)
            lines[#lines + 1] = ('^5│^7  Latest                ^5→  ^3%-18s^5│^7'):format(latestVersion)
            lines[#lines + 1] = '^5├─────────────────────────────────────────────┤^7'
            lines[#lines + 1] = '^5│^7             ^1⚠ Update available              ^5│^7'
            lines[#lines + 1] = '^5│  ^1 https://github.com/Mrmisio345/msk_bridge  ^5│^7'
        else
            lines[#lines + 1] = ('^5│^7  Version               ^5→  ^2%-18s^5│^7'):format(currentVersion)
            lines[#lines + 1] = '^5├─────────────────────────────────────────────┤^7'
            lines[#lines + 1] = '^5│^7         ^2✓ Bridge loaded successfully^7        ^5│^7'
        end

        lines[#lines + 1] = '^5└─────────────────────────────────────────────┘^7'

        print(table.concat(lines, '\n'))
    end, "GET")
end)