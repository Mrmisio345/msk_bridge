local Avatar <const> = {
    Id = 0,
    Data = {},
}

local function GetMugShotBase64(txd, cb)
    if not txd then
        if cb then cb(false) end
        return
    end

    Avatar.Id = Avatar.Id + 1
    local currentId <const> = Avatar.Id

    SendNUIMessage({
        action = 'convert',
        pMugShotTxd = txd,
        id = currentId,
    })

    while not Avatar.Data[currentId] do
        Wait(10)
    end

    local result <const> = Avatar.Data[currentId]
    Avatar.Data[currentId] = nil

    if cb then 
        cb(result) 
    end
end

local function GetPedMugshot(ped)
    local mugshot <const> = RegisterPedheadshot(ped)
    while not IsPedheadshotReady(mugshot) do
        Citizen.Wait(100)
    end

    return mugshot, GetPedheadshotTxdString(mugshot)
end

local function GetAvatarURL()
    local handle <const>, headshot <const> = GetPedMugshot(cache.ped)
    if handle then
        UnregisterPedheadshot(handle)
    end

    local done <const> = promise.new()
    local avatar = nil
    GetMugShotBase64(headshot, function(_avatar)
        avatar = _avatar
        done:resolve()
    end)

    Citizen.Await(done)

    return avatar
end

RegisterNUICallback('Convert', function(data, cb)
    if not data.url or not data.id then
        return cb(false)
    end

    Avatar.Data[data.id] = data.url
    cb(true)
end)

return {
    GetAvatarURL = GetAvatarURL,
    GetMugShotBase64 = GetMugShotBase64,
}