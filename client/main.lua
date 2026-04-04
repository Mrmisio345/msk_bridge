local Config <const> = require 'data.config'
local Framework <const>, Target <const>, Fuel <const>, ProgressBar <const> in require 'shared.loader'
local ProviderFramework <const> = require(('framework.client.%s'):format(Framework)) or {}

local Utils <const> = require 'shared.utils'
for key, value in pairs(Utils) do
    if not ProviderFramework[key] then
        ProviderFramework[key] = value
    end
end

local Modules <const> = {
    require 'modules.floatingNotification',
    require 'modules.avatar',
}

for _, module in ipairs(Modules) do
    for key, value in pairs(module) do
        if not ProviderFramework[key] then
            ProviderFramework[key] = value
        end
    end
end

local ProviderFuel <const> = require(('fuel.%s'):format(Fuel)) or {}
ProviderFramework.SetFuel = ProviderFuel.SetFuel
ProviderFramework.GetFuel = ProviderFuel.GetFuel

local ProviderProgressBar <const> = require(('progressbar.%s'):format(ProgressBar)) or {}
ProviderFramework.StartProgressBar = ProviderProgressBar.StartProgressBar

if GetResourceState('ox_inventory') == 'started' then
    local trackedItems <const> = {}
    exports('TrackItem', function(itemName)
        if itemName and type(itemName) == 'string' and not trackedItems[itemName] then
            trackedItems[itemName] = exports.ox_inventory:Search('count', itemName) or 0
        end
    end)

    CreateThread(function()
        Wait(5000) 

        while true do
            for itemName, lastCount in pairs(trackedItems) do
                local current <const> = exports.ox_inventory:Search('count', itemName) or 0
                if current ~= lastCount then
                    trackedItems[itemName] = current
                    TriggerEvent('msk_scripts:inventoryUpdated', itemName, current)
                end
            end

            Wait(500)
        end
    end)
end

exports('GetFramework', function()
    return ProviderFramework
end)

local ProviderTarget <const> = require(('target.%s'):format(Target)) or {}
exports('GetTarget', function()
    return ProviderTarget
end)

exports('GetFuel', function()
    return ProviderFuel
end)

exports('GetProgressBar', function()
    return ProviderProgressBar
end)

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

RegisterNetEvent('onPlayerJoining', function(serverId, _, sid)
    if not serverId or not sid then
        return
    end

    local playerPed, timeout = GetPlayerPed(sid), 0
    while playerPed <= 0 and timeout < 20 do
        playerPed, timeout = GetPlayerPed(sid), timeout + 1				
        Wait(100)
    end

    local bag <const> = Player(serverId)
    if not bag then
        return
    end

    TriggerEvent('msk:onPlayerJoining', serverId, playerPed, bag)
end)

RegisterNetEvent('onPlayerDropped', function(serverId)
    TriggerEvent('msk:onPlayerDropped', serverId)
end)

local lines <const> = {
    '^5┌─────────────────────────────────────────────┐^7',
    '^5│^7                 ^3MSK BRIDGE^7                  ^5│^7',
    '^5├─────────────────────────────────────────────┤^7',
    '^5│^7  Framework             ^5→  ^3%-18s^5│^7',
    '^5│^7  Target                ^5→  ^3%-18s^5│^7',
    '^5│^7  Fuel                  ^5→  ^3%-18s^5│^7',
    '^5│^7  ProgressBar           ^5→  ^3%-18s^5│^7',
    '^5│^7  FloatingNotification  ^5→  ^3%-18s^5│^7',
    '^5│^7  Side                  ^5→  ^3%-18s^5│^7',
    '^5│^7  Utils                 ^5→  ^2%-18s^5│^7',
    '^5├─────────────────────────────────────────────┤^7',
    '^5│^7         ^2✓ Bridge loaded successfully^7        ^5│^7',
    '^5└─────────────────────────────────────────────┘^7',
}

print(string.format(
    table.concat(lines, '\n'),
    Framework or 'standalone',
    Target or 'none',
    Fuel or 'none',
    ProgressBar or 'none',
    Config.FloatingNotification or 'none',
    'client',
    'loaded'
))