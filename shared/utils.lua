local Utils <const>, IsServerSide <const> = {
    TimeoutCount = 0,
    CancelledTimeouts = {},
}, IsDuplicityVersion()

if not IsServerSide then
    Utils.TriggerServerCallback = function(name, cb, ...)
        lib.callback(name, false, cb, ...)
    end

    Utils.RegisterClientCallback = function(name, cb)
        lib.callback.register(name, function(...)
            local p <const> = promise.new()

            cb(function(...)
                p:resolve({...})
            end, ...)

            local results <const> = Citizen.Await(p)
            return table.unpack(results)
        end)
    end

    Utils.Clipboard = function(text)
        if not text then
            return
        end
        
        SendNUIMessage({
            action = 'saveClipboard',
            text = text
        })
    end
else
    Utils.RegisterServerCallback = function(name, cb)
        lib.callback.register(name, function(source, ...)
            local p <const> = promise.new()

            cb(source, function(...)
                p:resolve({...})
            end, ...)

            local results <const> = Citizen.Await(p)
            return table.unpack(results)
        end)
    end

    Utils.TriggerClientCallback = function(name, playerId, cb, ...)
        lib.callback(name, playerId, cb, ...)
    end
end

Utils.Math = {
    Round = function(value, numDecimalPlaces)
        if numDecimalPlaces then
            local power = 10^numDecimalPlaces
            return math.floor((value * power) + 0.5) / (power)
        else
            return math.floor(value + 0.5)
        end
    end,
    
    GroupDigits = function(value)
        local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

        return left..(num:reverse():gsub('(%d%d%d)','%1' .. ' '):reverse())..right
    end,
    
    Trim = function(value)
        if value then
            return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
        else
            return nil
        end
    end    
}

Utils.UUID = function()
    local template <const> ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

if not IsServerSide then
    Utils.AddKeyBind = function(data)
        local resource = GetInvokingResource()
        if not resource then
            resource = GetCurrentResourceName()
        end
        
        if data and resource then	
            data.id = resource..'_'..data.id
            
            RegisterCommand('+' .. data.id, function()
                if not data.onPressed then
                    return
                end
                
                if data.force then
                    goto continue
                end
                
                if IsPauseMenuActive() then 
                    return 
                end
                
                ::continue::
                
                if data.canInteract then
                    if not data.canInteract() then
                        goto skip
                    end
                end
                
                data:onPressed()
                
                ::skip::
            end)

            RegisterCommand('-' .. data.id, function()
                if not data.onReleased then
                    return
                end
                
                data:onReleased()
            end)
        
            RegisterKeyMapping('+' .. data.id, data.description or 'KeyBinds', data.mapper or 'keyboard', data.key)
        end
    end

    Utils.DrawText3D = function(coords, text, size)
        local onScreen <const>, x <const>, y <const> = World3dToScreen2d(coords.x, coords.y, coords.z)
        if onScreen then
            local camCoords <const> = GetGameplayCamCoords()
            local dist <const> = #(camCoords - coords)
            if not size then
                size = 1
            end

            local scale <const> = (size / dist) * 2
            local fov <const> = (1 / GetGameplayCamFov()) * 100
            local scale <const> = scale * fov
        
            SetTextScale(0.0 * scale, 0.55 * scale)
            SetTextFont(0)
            SetTextProportional(true)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(2, 0, 0, 0, 150)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry('STRING')
            SetTextCentre(true)

            AddTextComponentString(text)
            DrawText(x, y)
        end    
    end

    Utils.GetNuiPosFromCoords = function(coords)
        if not coords then 
            return false, vec2(0.0, 0.0)
        end
        
        local onScreen <const>, x <const>, y <const> = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
        return onScreen, vec2((x * 100), (y * 100))
    end

    Utils.CheckCollisionWall = function(playerPed, coords, coords2)
        if not coords or not coords2 then
            return false
        end
        
        local rayCast <const> = StartExpensiveSynchronousShapeTestLosProbe(coords, coords2, 1, playerPed, 4)
        local _, hit <const>, _, _, _ = GetShapeTestResult(rayCast)
        if hit ~= nil and hit == 0 then
            return true
        end
        
        return false
    end

    Utils.GetPedMugshot = function(ped)
        local mugshot <const> = RegisterPedheadshot(ped)
        while not IsPedheadshotReady(mugshot) do
            Citizen.Wait(100)
        end
        
        return mugshot, GetPedheadshotTxdString(mugshot)
    end

    Utils.GetNetworkIdFromEntity = function(entity, control, force)
        if not entity or not DoesEntityExist(entity) then
            return nil
        end

        if not force and not NetworkGetEntityIsNetworked(entity) then
            return nil
        end

        local timeout = 0
        while not NetworkGetEntityIsNetworked(entity) do
            if timeout >= 20 or not DoesEntityExist(entity) then
                return nil
            end

            timeout = timeout + 1
            Wait(100)
        end

        local networkId <const> = NetworkGetNetworkIdFromEntity(entity)
        if not networkId then
            return nil
        end

        if control then
            local timeout = 0
            while not NetworkHasControlOfNetworkId(networkId) or not NetworkHasControlOfEntity(entity) do
                if timeout >= 20 or not DoesEntityExist(entity) then
                    return nil
                end

                NetworkRequestControlOfNetworkId(networkId)
                NetworkRequestControlOfEntity(entity)

                timeout = timeout + 1
                Wait(100)
            end
        end

        return networkId
    end

    Utils.PlayAnim = function(ped, dict, lib, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ)
        if ped and dict and lib then	
            RequestAnimDict(dict)	
            while not HasAnimDictLoaded(dict) do
                Wait(100)
            end
            
            TaskPlayAnim(ped, dict, lib, blendInSpeed, blendOutSpeed, duration, flag, playbackRate or 0, lockX or 0, lockY or 0, lockZ or 0)
            
            RemoveAnimDict(dict)
        end
    end

    local Marker <const> = {
        ['In'] = {r = 79, g = 70, b = 229, alpha = 50},
        ['Out'] = {r = 255, g = 255, b = 255, alpha = 50},
    }

    Utils.DrawMarker = function(type, coords, size, distance)
        if type and coords then
            local rot = vec3(0.0, 0.0, 0.0)
            
            if type == 6 then
                rot = vec3(270.0, 0.0, 0.0)
                size = vec3(size.x, size.x, size.x)
            end
            
            if not size then
                size = vec3(1.5, 1.5, 1.0)
            end
            
            if distance then
                if distance <= size.x then		
                    DrawMarker(type, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, rot.x, rot.y, rot.z, size.x, size.y, size.z, Marker.In.r, Marker.In.g, Marker.In.b, Marker.In.alpha, false, true, 2)		

                    DrawMarker(type, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, rot.x, rot.y, rot.z, size.x, size.y, size.z, Marker.In.r, Marker.In.g, Marker.In.b, Marker.In.alpha, false, true, 2)
                else				
                    DrawMarker(type, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, rot.x, rot.y, rot.z, size.x, size.y, size.z, Marker.Out.r, Marker.Out.g, Marker.Out.b, Marker.Out.alpha, false, true, 2)
                end
            else
                DrawMarker(type, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, rot.x, rot.y, rot.z, size.x, size.y, size.z, Marker.Out.r, Marker.Out.g, Marker.Out.b, Marker.Out.alpha, false, true, 2)
            end
        end
    end
end

Utils.SetTimeout = function(msec, cb)
	local id <const> = Utils.TimeoutCount + 1

	SetTimeout(msec, function()
		if Utils.CancelledTimeouts[id] then
			Utils.CancelledTimeouts[id] = nil
			return
		end
		
		cb()
	end)

	Utils.TimeoutCount = id

	return id
end

Utils.ClearTimeout = function(id)
	Utils.CancelledTimeouts[id] = true
end

return Utils