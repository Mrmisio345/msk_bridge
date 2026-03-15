local ProgressBar <const> in require 'data.config'
if ProgressBar == 'msk_progressbar' then
    return {
        StartProgressBar = function(data)
            if not data then 
                return 
            end

            exports['msk_progressbar']:StartProgressBar(data)
        end,
    }
end

local function StartProgressBar(data)
    if not data then
        return
    end

    if data.OnStart then
        data.OnStart()
    end

    local success <const> = lib.progressBar({
        duration = data.duration * 1000,
        label = data.text,
        useWhileDead = data.useWhileDead or false,
        canCancel = data.canCancel ~= false,
        disable = data.disable or {},
        anim = data.anim or nil,
        prop = data.prop or nil,
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