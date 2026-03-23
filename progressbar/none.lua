local function StartProgressBar(data)
    if not data then return end

    if data.OnStart then
        data.OnStart()
    end

    Wait(data.duration * 1000)

    if data.OnComplete then
        data.OnComplete()
    end
end

return {
    StartProgressBar = StartProgressBar,
}