local exp <const> = exports['progressbar']

local function StartProgressBar(data)
    if not data then return end

    local animation = nil
    if data.anim then
        animation = {
            animDict = data.anim.dict,
            anim = data.anim.clip,
            flags = data.anim.flags or 49,
        }
    end

    local controlDisables = {
        disableMovement = data.disable and data.disable.move or false,
        disableCarMovement = data.disable and data.disable.car or false,
        disableMouse = data.disable and data.disable.mouse or false,
        disableCombat = data.disable and data.disable.combat or true,
    }

    if data.OnStart then
        data.OnStart()
    end

    exp:Progress({
        name = data.name or 'msk_bridge_progress',
        duration = data.duration * 1000,
        label = data.text,
        useWhileDead = data.useWhileDead or false,
        canCancel = data.canCancel ~= false,
        controlDisables = controlDisables,
        animation = animation,
        prop = data.prop or {},
    }, function(cancelled)
        if not cancelled then
            if data.OnComplete then
                data.OnComplete()
            end
        else
            if data.OnStop then
                data.OnStop()
            end
        end
    end)
end

return {
    StartProgressBar = StartProgressBar,
}