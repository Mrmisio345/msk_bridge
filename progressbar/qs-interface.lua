local exp <const> = exports['qs-interface']

local function StartProgressBar(data)
    if not data then return end

    if data.OnStart then
        data.OnStart()
    end

    local success <const> = exp:ProgressBar({
        duration = data.duration * 1000,
        label = data.text,
        position = 'bottom',
        canCancel = data.canCancel ~= false,
    })

    if success then
        if data.OnComplete then
            data.OnComplete()
        end
    else
        if data.OnStop then
            data.OnStop()
        end
    end
end

return {
    StartProgressBar = StartProgressBar,
}