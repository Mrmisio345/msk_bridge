local exp <const> = exports['rcore_fuel']
local fuel <const> = {}

function fuel.SetFuel(vehicle, amount)
    exp:SetFuel(vehicle, amount)
end

function fuel.GetFuel(vehicle)
    return exp:GetFuel(vehicle)
end

return fuel