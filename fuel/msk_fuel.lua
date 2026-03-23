local fuel <const> = {}

function fuel.SetFuel(vehicle, amount)
    SetVehicleFuelLevel(vehicle, amount + 0.0)
    local bag <const> = Entity(vehicle)
    if bag then
        bag.state:set('fuel', amount, true)
    end
end

function fuel.GetFuel(vehicle)
    local bag <const> = Entity(vehicle)
    if bag and bag.state.fuel ~= nil then
        return bag.state.fuel
    end
    
    return GetVehicleFuelLevel(vehicle)
end

return fuel