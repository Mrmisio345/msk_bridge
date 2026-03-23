local exp <const> = exports['esx_progressbar']

local function StartProgressBar(data)
    if not data then return end

    local animation = nil
    if data.anim then
        if data.anim.scenario then
            animation = {
                type = 'Scenario',
                Scenario = data.anim.scenario,
            }
        elseif data.anim.dict then
            animation = {
                type = 'anim',
                dict = data.anim.dict,
                lib = data.anim.clip or data.anim.lib,
            }
        end
    end

    if data.OnStart then
        data.OnStart()
    end

    exp:Progressbar(data.text, data.duration * 1000, {
        FreezePlayer = data.disable and data.disable.move or false,
        animation = animation,
        onFinish = function()
            if data.OnComplete then
                data.OnComplete()
            end
        end,
        onCancel = function()
            if data.OnStop then
                data.OnStop()
            end
        end,
    })
end

return {
    StartProgressBar = StartProgressBar,
}