local function ClampVectorAlongAxis(v, axis)
    local axisNorm <const> = norm(axis)
    return dot(v, axisNorm) * axisNorm
end

local function IsPointTooFarFromVehicle(point, vehicle)
    local vehPos <const> = GetEntityCoords(vehicle)
    local pointInWorld <const> = GetOffsetFromEntityInWorldCoords(vehicle, point.x, point.y, point.z)
    local _, hit <const>, position <const>, normal <const>, hitEntity <const> = GetShapeTestResult(StartExpensiveSynchronousShapeTestLosProbe(pointInWorld.x, pointInWorld.y, pointInWorld.z, vehPos.x, vehPos.y, vehPos.z, 2, 0, 0))
    if not hit or hitEntity ~= vehicle then
        return true
    end

    return 1.0 - dot(norm(pointInWorld - position), norm(normal)) > 0.5
end

local function GetVehicleOffsetsForDeformation(vehicle)
    local model <const> = GetEntityModel(vehicle)
    local pos <const> = GetEntityCoords(cache.ped) + vec3(0, 0, -50)
    local newVehicle <const> = CreateVehicle(model, pos.x, pos.y, pos.z, 0.0, false, false)
    local count, defPoints, min, max = 0, {}, GetModelDimensions(model)

    if not min or not max then
        return defPoints
    end
    
    FreezeEntityPosition(newVehicle, true)
    SetEntityAlpha(newVehicle, 0)

    for x = -1, 1, 0.25 do
        for y = 1, -1, -0.25 do
            for z = -1, 1, 0.5 do
                if ((y < -0.55 or y > 0.55) and z > -0.6) then
                    count += 1
                    defPoints[count] = vec3((max.x - min.x) * x * 0.5 + (max.x + min.x) * 0.5, (max.y - min.y) * y * 0.5 + (max.y + min.y) * 0.5, (max.z - min.z) * z * 0.5 + (max.z + min.z) * 0.5)
                end
            end
        end
    end

    for i = #defPoints, 1, -1 do
        if IsPointTooFarFromVehicle(defPoints[i], newVehicle) then
            table.remove(defPoints, i)
        end
    end

    DeleteEntity(newVehicle)

    return defPoints
end

local function GetVehicleDeformation(vehicle)
    local offsets <const>, deformationPoints <const> = GetVehicleOffsetsForDeformation(vehicle), {}
    for i = 1, #offsets do
        local projectedDamageVector <const> = ClampVectorAlongAxis(GetVehicleDeformationAtPos(vehicle, offsets[i].x, offsets[i].y, offsets[i].z), -offsets[i])
        if #(projectedDamageVector) > 0.05 then
            deformationPoints[#deformationPoints + 1] = { offsets[i], projectedDamageVector }
        end
    end

    return deformationPoints
end

local function SetVehicleDeformation(vehicle, deformationPoints)
    if deformationPoints[1] and type(deformationPoints[1][2]) == "number" then
        return
    end

    CreateThread(function()
        local deform, iterations = true, 0
        while (deform and iterations < 50) do
            if not DoesEntityExist(vehicle) then
                return
            end

            deform = false

            for i, def in ipairs(deformationPoints) do
                local currDef <const> = GetVehicleDeformationAtPos(vehicle, def[1].x, def[1].y, def[1].z)
                local clampedDef <const> = ClampVectorAlongAxis(currDef, -vector3(def[1].x, def[1].y, def[1].z))
                if #clampedDef < #vector(def[2].x, def[2].y, def[2].z) then
                    if def[3] == nil then
                        def[3] = 50.0
                    else
                        def[3] = def[3] + 5.0
                    end
                    
                    SetVehicleDamage(vehicle, def[1].x, def[1].y, def[1].z, def[3], def[3], true)

                    deform = true

                    Citizen.Wait(0)
                end
            end

            iterations = iterations + 1

            Citizen.Wait(0)
        end
    end)
end

local function GetVehicleProperties(vehicle) 
    if DoesEntityExist(vehicle) then
        local extras <const>, tyreBurst <const> = {}, {}
        local numWheels <const> = tostring(GetVehicleNumberOfWheels(vehicle))
        local TyresIndex <const> = {           
            ['2'] = { 0, 4 },         
            ['3'] = { 0, 1, 4, 5 },  
            ['4'] = { 0, 1, 4, 5 },   
            ['6'] = { 0, 1, 2, 3, 4, 5 } 
        }
        
        if TyresIndex[numWheels] then
            for _, idx in pairs(TyresIndex[numWheels]) do
                tyreBurst[tostring(idx)] = IsVehicleTyreBurst(vehicle, idx, false)
            end
        end
        
        for extraId = 0, 20 do
            if DoesExtraExist(vehicle, extraId) then
                extras[tostring(extraId)] = IsVehicleExtraTurnedOn(vehicle, extraId)
            end
        end
    
        local model <const> = GetEntityModel(vehicle)				
        local colorPrimary <const>, colorSecondary <const> = GetVehicleColours(vehicle)
        local pearlescentColor <const>, wheelColor <const> = GetVehicleExtraColours(vehicle)		
        local bag <const> = Entity(vehicle)	
        local fuelLevel = GetVehicleFuelLevel(vehicle)
        local parts = {}
        
        if bag then
            if bag.state.parts then
                parts = bag.state.parts
            end		

            if bag.state.fuel then
                fuelLevel = bag.state.fuel		
            end								
        end	
        
        local deformations <const> = GetVehicleDeformation(vehicle)
        local fitment = nil
        if GetResourceState('msk_mechanic') == 'started' then
            fitment = exports['msk_mechanic']:GetVehicleFitment(vehicle)
        end
        
        return {
            model = model,
            name = GetDisplayNameFromVehicleModel(model),
            plate = GetVehicleNumberPlateText(vehicle):gsub("%s$", ""),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

            tyres = tyreBurst,

            health = GetEntityHealth(vehicle),
            engineHealth = GetVehicleEngineHealth(vehicle),
            bodyHealth = GetVehicleBodyHealth(vehicle),
            tankHealth = GetVehiclePetrolTankHealth(vehicle),
            dirtLevel = GetVehicleDirtLevel(vehicle),
            fuelLevel = fuelLevel,
            parts = parts,
            deformations = deformations,

            color1 = colorPrimary,
            color2 = colorSecondary,
        
            pearlescentColor = pearlescentColor,
            wheelColor = wheelColor,
            
            interiorColor = GetVehicleInteriorColour(vehicle),
            dashboardColor = GetVehicleDashboardColour(vehicle),

            wheels = GetVehicleWheelType(vehicle),
            windowTint = GetVehicleWindowTint(vehicle),
            bulletProofTyre = not GetVehicleTyresCanBurst(vehicle),
            
            driftTyres = GetDriftTyresEnabled(vehicle),

            neonEnabled = {
              IsVehicleNeonLightEnabled(vehicle, 0),
              IsVehicleNeonLightEnabled(vehicle, 1),
              IsVehicleNeonLightEnabled(vehicle, 2),
              IsVehicleNeonLightEnabled(vehicle, 3),
            },
            
            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),

            extras = extras,

            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),

            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modTurbo = IsToggleModOn(vehicle, 18),
            
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modXenon = IsToggleModOn(vehicle, 22),
            modXenonColor = GetVehicleHeadlightsColour(vehicle),

            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),

            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modLivery = GetVehicleMod(vehicle, 48),
            modLiveryVariant = GetVehicleLivery(vehicle),
            fitment = fitment,
        }
    else
        return
    end
end

local function SetVehicleProperties(vehicle, props, loadDeformation) 
    if DoesEntityExist(vehicle) then
        SetVehicleModKit(vehicle, 0)

        if props.plate ~= nil then
            SetVehicleNumberPlateText(vehicle, props.plate:gsub("%s$", ""))
        end

        if props.plateIndex ~= nil then
            SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
        end

        if props.health ~= nil then			
            SetEntityHealth(vehicle, props.health)
        end

        if props.engineHealth ~= nil then	
            props.engineHealth = props.engineHealth + 0.0
            SetVehicleEngineHealth(vehicle, props.engineHealth)
        end

        if props.bodyHealth ~= nil then	
            props.bodyHealth = props.bodyHealth + 0.0			
            SetVehicleBodyHealth(vehicle, props.bodyHealth)
        end

        if props.tankHealth ~= nil then
            SetVehiclePetrolTankHealth(vehicle, props.tankHealth)
        end

        if props.dirtLevel ~= nil then		
            SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
        end
      
        if props.fuelLevel ~= nil then
            SetVehicleFuelLevel(vehicle, props.fuelLevel)
        end
        
        local bag <const> = Entity(vehicle)	
        if bag then						
            if props.fitment then
                bag.state:set('fitment', props.fitment, true)
            end
            
            if props.parts then
                bag.state:set('parts', props.parts, true)
            end
        end
        
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        if props.pearlescentColor ~= nil then
            pearlescentColor = props.pearlescentColor
        end

        if props.wheelColor ~= nil then
            wheelColor = props.wheelColor
        end
        
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        if props.color1 ~= nil then
            colorPrimary = props.color1
        end
        
        if props.color2 ~= nil then
            colorSecondary = props.color2
        end
        
        if colorPrimary ~= nil and colorSecondary ~= nil then
            SetVehicleColours(vehicle, colorPrimary, colorSecondary)	
        end
      
        if props.interiorColor ~= nil then
            SetVehicleInteriorColour(vehicle, props.interiorColor)
        end

        if pearlescentColor ~= nil and wheelColor ~= nil then
            SetVehicleExtraColours(vehicle, pearlescentColor, wheelColor)
        end
        
        if props.dashboardColor ~= nil then
            SetVehicleDashboardColour(vehicle, props.dashboardColor)
        end

        if props.wheels ~= nil then
            SetVehicleWheelType(vehicle, props.wheels)
        end

        if props.windowTint ~= nil then
            SetVehicleWindowTint(vehicle, props.windowTint)
        end

        if props.bulletProofTyre ~= nil then
            SetVehicleTyresCanBurst(vehicle, not props.bulletProofTyre)
        end
      
        if props.driftTyres ~= nil then
            SetDriftTyresEnabled(vehicle, props.driftTyres)
        end

        if props.neonEnabled ~= nil then
            for i = 1, 4, 1 do
                SetVehicleNeonLightEnabled(vehicle, i - 1, props.neonEnabled[i])
            end
        end

        if props.extras ~= nil then
            for extraId, enabled in pairs(props.extras) do	
                if extraId ~= nil and enabled ~= nil then
                    local extraIdVal = tonumber(extraId)
                    if extraIdVal ~= nil then
                        SetVehicleExtra(vehicle, extraIdVal, enabled and 0 or 1)
                    end
                end
            end
        end

        if props.neonColor ~= nil then
            SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
        end

        if props.modSmokeEnabled ~= nil then
            ToggleVehicleMod(vehicle, 20, true)
        end

        if props.tyreSmokeColor ~= nil then
            SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
        end

        if props.modSpoilers ~= nil then
            SetVehicleMod(vehicle, 0, props.modSpoilers, false)
        end

        if props.modFrontBumper ~= nil then
            SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
        end

        if props.modRearBumper ~= nil then
            SetVehicleMod(vehicle, 2, props.modRearBumper, false)
        end

        if props.modSideSkirt ~= nil then
            SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
        end

        if props.modExhaust ~= nil then
            SetVehicleMod(vehicle, 4, props.modExhaust, false)
        end

        if props.modFrame ~= nil then
            SetVehicleMod(vehicle, 5, props.modFrame, false)
        end

        if props.modGrille ~= nil then
            SetVehicleMod(vehicle, 6, props.modGrille, false)
        end

        if props.modHood ~= nil then
            SetVehicleMod(vehicle, 7, props.modHood, false)
        end

        if props.modFender ~= nil then
            SetVehicleMod(vehicle, 8, props.modFender, false)
        end

        if props.modRightFender ~= nil then
            SetVehicleMod(vehicle, 9, props.modRightFender, false)
        end

        if props.modRoof ~= nil then
            SetVehicleMod(vehicle, 10, props.modRoof, false)
        end

        if props.modEngine ~= nil then
            SetVehicleMod(vehicle, 11, props.modEngine, false)
        end

        if props.modBrakes ~= nil then
            SetVehicleMod(vehicle, 12, props.modBrakes, false)
        end

        if props.modTransmission ~= nil then
            SetVehicleMod(vehicle, 13, props.modTransmission, false)
        end

        if props.modHorns ~= nil then
            SetVehicleMod(vehicle, 14, props.modHorns, false)
        end

        if props.modSuspension ~= nil then
            SetVehicleMod(vehicle, 15, props.modSuspension, false)
        end

        if props.modArmor ~= nil then
            SetVehicleMod(vehicle, 16, props.modArmor, false)
        end

        if props.modTurbo ~= nil then
            ToggleVehicleMod(vehicle, 18, props.modTurbo)
        end

        if props.modXenon ~= nil then
            ToggleVehicleMod(vehicle, 22, props.modXenon)
        end

        if props.modXenonColor ~= nil then
            SetVehicleHeadlightsColour(vehicle, props.modXenonColor)
        end
    
        if props.modBackWheels ~= nil then			
            SetVehicleMod(vehicle, 24, props.modBackWheels, false)
        end

        if props.modFrontWheels ~= nil then
            SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
        end

        if props.modPlateHolder ~= nil then
            SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
        end

        if props.modVanityPlate ~= nil then
            SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
        end

        if props.modTrimA ~= nil then
            SetVehicleMod(vehicle, 27, props.modTrimA, false)
        end

        if props.modOrnaments ~= nil then
            SetVehicleMod(vehicle, 28, props.modOrnaments, false)
        end

        if props.modDashboard ~= nil then
            SetVehicleMod(vehicle, 29, props.modDashboard, false)
        end

        if props.modDial ~= nil then
            SetVehicleMod(vehicle, 30, props.modDial, false)
        end

        if props.modDoorSpeaker ~= nil then
            SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
        end

        if props.modSeats ~= nil then
            SetVehicleMod(vehicle, 32, props.modSeats, false)
        end

        if props.modSteeringWheel ~= nil then
            SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
        end

        if props.modShifterLeavers ~= nil then
            SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
        end

        if props.modAPlate ~= nil then
            SetVehicleMod(vehicle, 35, props.modAPlate, false)
        end

        if props.modSpeakers ~= nil then
            SetVehicleMod(vehicle, 36, props.modSpeakers, false)
        end

        if props.modTrunk ~= nil then
            SetVehicleMod(vehicle, 37, props.modTrunk, false)
        end

        if props.modHydrolic ~= nil then
            SetVehicleMod(vehicle, 38, props.modHydrolic, false)
        end

        if props.modEngineBlock ~= nil then
            SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
        end

        if props.modAirFilter ~= nil then
            SetVehicleMod(vehicle, 40, props.modAirFilter, false)
        end

        if props.modStruts ~= nil then
            SetVehicleMod(vehicle, 41, props.modStruts, false)
        end

        if props.modArchCover ~= nil then
            SetVehicleMod(vehicle, 42, props.modArchCover, false)
        end

        if props.modAerials ~= nil then
            SetVehicleMod(vehicle, 43, props.modAerials, false)
        end

        if props.modTrimB ~= nil then
            SetVehicleMod(vehicle, 44, props.modTrimB, false)
        end

        if props.modTank ~= nil then
            SetVehicleMod(vehicle, 45, props.modTank, false)
        end

        if props.modWindows ~= nil then
            SetVehicleMod(vehicle, 46, props.modWindows, false)
        end

        if props.modLivery ~= nil then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
        end

        if props.modLiveryVariant ~= nil then
            SetVehicleLivery(vehicle, props.modLiveryVariant)
        end
        
        if props.tyres ~= nil then
            for k, v in pairs(props.tyres) do
                if v then
                    local indexVal <const> = tonumber(k)
                    SetVehicleTyreBurst(vehicle, indexVal or 0, true, 1148846080)
                end
            end
        end
        
        if props.deformations ~= nil and loadDeformation then			
            SetVehicleDeformation(vehicle, props.deformations)
        end
    end
end

return {
    GetVehicleProperties = GetVehicleProperties,
    SetVehicleProperties = SetVehicleProperties,
}