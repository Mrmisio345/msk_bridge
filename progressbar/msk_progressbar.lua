local exp <const> = exports['msk_progressbar']

return {
    StartProgressBar = function(data)
        if not data then return end
        exp:StartProgressBar(data)
    end,
}