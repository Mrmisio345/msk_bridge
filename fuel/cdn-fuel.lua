local exp <const> = exports['cdn-fuel']
local fuel <const> = {}

function fuel.SetFuel(vehicle, amount)
    exp:SetFuel(vehicle, amount)
end

function fuel.GetFuel(vehicle)
    return exp:GetFuel(vehicle)
end

return fuel