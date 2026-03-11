local Config <const> = require 'data.config'

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end

    if GetResourceState('prp_framework') == 'started' then
        return 'prp'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx'
    elseif GetResourceState('qb-core') == 'started' then
        return 'qbcore'
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

local function DetectFloatingNotification()
    if Config.FloatingNotification ~= 'auto' then
        return Config.FloatingNotification
    end

    if GetResourceState('msk_interactions') == 'started' then
        return 'msk_interactions'
    end

    return 'standalone'
end

local function DetectProgressBar()
    if Config.ProgressBar ~= 'auto' then
        return Config.ProgressBar
    end

    if GetResourceState('msk_progressbar') == 'started' then
        return 'msk_progressbar'
    end

    return 'ox_lib'
end

return {
    Framework = DetectFramework(),
    Target = DetectTarget(),
    FloatingNotification = DetectFloatingNotification(),
    ProgressBar = DetectProgressBar(),
}