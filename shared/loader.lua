local Config <const> = require 'data.config'

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end

    if GetResourceState('prp_framework') == 'started' then
        return 'prp'
    elseif GetResourceState('qbx_core') == 'started' then
        return 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        return 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx'
    end

    return 'standalone'
end

local function DetectTarget()
    if Config.Target ~= 'auto' then
        return Config.Target
    end

    if GetResourceState('prp_target') == 'started' then
        return 'prp_target'
    elseif GetResourceState('ox_target') == 'started' then
        return 'ox_target'
    elseif GetResourceState('qtarget') == 'started' then
        return 'qtarget'
    elseif GetResourceState('bt-target') == 'started' then
        return 'bt-target'
    end

    return 'standalone'
end

local function DetectFuel()
    if Config.Fuel ~= 'auto' then
        return Config.Fuel
    end

    if GetResourceState('ox_fuel') == 'started' then
        return 'ox_fuel'
    elseif GetResourceState('Renewed-Fuel') == 'started' then
        return 'Renewed-Fuel'
    elseif GetResourceState('lc_fuel') == 'started' then
        return 'lc_fuel'
    elseif GetResourceState('cdn-fuel') == 'started' then
        return 'cdn-fuel'
    elseif GetResourceState('x-fuel') == 'started' then
        return 'x-fuel'
    elseif GetResourceState('qs-fuelstations') == 'started' then
        return 'qs-fuelstations'
    elseif GetResourceState('okokGasStation') == 'started' then
        return 'okokGasStation'
    elseif GetResourceState('rcore_fuel') == 'started' then
        return 'rcore_fuel'
    elseif GetResourceState('myFuel') == 'started' then
        return 'myFuel'
    elseif GetResourceState('LegacyFuel') == 'started' then
        return 'LegacyFuel'
    elseif GetResourceState('msk_fuel') == 'started' then
        return 'msk_fuel'
    end

    return 'none'
end

local function DetectProgressBar()
    if Config.ProgressBar ~= 'auto' then
        return Config.ProgressBar
    end

    if GetResourceState('msk_progressbar') == 'started' then
        return 'msk_progressbar'
    elseif GetResourceState('ox_lib') == 'started' then
        return 'ox_lib'
    elseif GetResourceState('esx_progressbar') == 'started' then
        return 'esx'
    elseif GetResourceState('progressbar') == 'started' then
        return 'qb'
    elseif GetResourceState('qs-interface') == 'started' then
        return 'qs-interface'
    end

    return 'none'
end

return {
    Framework = DetectFramework(),
    Target = DetectTarget(),
    Fuel = DetectFuel(),
    ProgressBar = DetectProgressBar(),
}