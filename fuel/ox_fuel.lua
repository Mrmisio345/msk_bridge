local fuel <const> = {}

function fuel.SetFuel(vehicle, amount)
    Entity(vehicle).state.fuel = amount
end

function fuel.GetFuel(vehicle)
    return Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
end

return fuel