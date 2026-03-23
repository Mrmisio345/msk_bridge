local exp <const> = exports['Renewed-Fuel']
local fuel <const> = {}

function fuel.SetFuel(vehicle, amount)
    exp:SetFuel(vehicle, amount)
end

function fuel.GetFuel(vehicle)
    return Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
end

return fuel