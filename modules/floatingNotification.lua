local FloatingNotification <const> in require 'shared.loader'
if FloatingNotification == 'msk_interactions' then
    return {
        ShowFloatingHelpNotification = function(data, fncData)
            if not data or not data.name then 
                return 
            end

            exports['msk_interactions']:ShowFloatingHelpNotification(data, fncData)
        end,
    }
end

local Floating <const> = {}

local function ShowFloatingHelpNotification(data, fncData)
    if not data or not data.name then
        return
    end

    if not Floating[data.name] then
        Floating[data.name] = {
            LastMessages = GetGameTimer() + 200,
            Text = data.text or '',
            Coords = data.coords or vec3(0.0, 0.0, 0.0),
            Distance = data.distance or 5.0,
            Interact = data.interact or 2.0,
            FncData = fncData or nil,
        }
    else
        local currentData <const> = Floating[data.name]
        if not currentData then
            return
        end

        currentData.LastMessages = GetGameTimer() + 200

        if data.text ~= nil then 
            currentData.Text = data.text 
        end

        if data.coords and #(currentData.Coords - data.coords) > 0.1 then
            currentData.Coords = data.coords
        end

        if data.distance and math.abs(currentData.Distance - data.distance) > 0.1 then
            currentData.Distance = data.distance
        end

        currentData.FncData = fncData or currentData.FncData
    end
end

CreateThread(function()
    while true do
        local sleep = 500
        if next(Floating) ~= nil then
            sleep = 0
            local timer <const> = GetGameTimer()
            local playerCoords <const> = GetEntityCoords(cache.ped)
            local closestName, closestData, closestDist = nil, nil, math.huge

            for name, data in pairs(Floating) do
                if data.LastMessages <= timer then
                    Floating[name] = nil
                else
                    local distance <const> = #(playerCoords - data.Coords)
                    if distance <= data.Distance and distance < closestDist then
                        closestName, closestData, closestDist = name, data, distance
                    end
                end
            end

            if closestName and closestData then
                AddTextEntry('msk_floating', closestData.Text)
                SetFloatingHelpTextWorldPosition(1, closestData.Coords.x, closestData.Coords.y, closestData.Coords.z)
                SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
                BeginTextCommandDisplayHelp('msk_floating')
                EndTextCommandDisplayHelp(2, false, false, -1)

                if closestDist <= closestData.Interact and closestData.FncData then
                    xpcall(closestData.FncData, function() end)
                end
            end
        end

        Wait(sleep)
    end
end)

return {
    ShowFloatingHelpNotification = ShowFloatingHelpNotification,
}