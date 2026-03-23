local fuel <const> = {}

function fuel.SetFuel(vehicle, amount)
    SetVehicleFuelLevel(vehicle, amount + 0.0)
    DecorSetFloat(vehicle, '_FUEL_LEVEL', amount + 0.0)
end

function fuel.GetFuel(vehicle)
    return GetVehicleFuelLevel(vehicle)
end

return fuel