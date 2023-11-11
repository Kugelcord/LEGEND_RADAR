local showingInfo = false
local scannedVehicle = nil  
local maxScanDistance = 50.0  

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)

        local playerPed = GetPlayerPed(-1)
        local playerCar = GetVehiclePedIsIn(playerPed, false)

      
        if DoesEntityExist(playerCar) then
            local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(playerCar))

            if modelName == "POLICE4" then
                showingInfo = true 
            else
                showingInfo = false
            end
        else
            showingInfo = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if showingInfo then
            local playerPed = GetPlayerPed(-1)
            local playerCar = GetVehiclePedIsIn(playerPed, false)

            if DoesEntityExist(playerCar) then
                local playerPos = GetEntityCoords(playerPed)
                local vehiclePos = GetEntityCoords(playerCar)
                local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, vehiclePos.x, vehiclePos.y, vehiclePos.z)
                
                local isPlayerInFrontOfCar = distance < 3.0

                if isPlayerInFrontOfCar then
                    scannedVehicle = nil
                end

                local nearbyVehicles = GetGamePool('CVehicle')
                if scannedVehicle == nil then
                    for _, vehicle in ipairs(nearbyVehicles) do
                        if vehicle ~= playerCar then
                            local vehiclePos = GetEntityCoords(vehicle)
                            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, vehiclePos.x, vehiclePos.y, vehiclePos.z)
                            
                            if distance < maxScanDistance then
                                scannedVehicle = vehicle
                                break
                            end
                        end
                    end
                end

                if scannedVehicle ~= nil then
                    local vehicleSpeed = GetEntitySpeed(scannedVehicle) * 3.6
                    local vehiclePlate = GetVehicleNumberPlateText(scannedVehicle)
                    local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(scannedVehicle)))
                    

                    local displayText = string.format("Kennzeichen: %s\nGeschwindigkeit: %.2f km/h\nAuto Name: %s", vehiclePlate, vehicleSpeed, vehicleName)


                    SetTextScale(0.4, 0.4)
                    SetTextFont(0)
                    SetTextProportional(1)
                    SetTextColour(255, 255, 255, 255)
                    SetTextDropshadow(0, 0, 0, 0, 255)
                    SetTextEdge(1, 0, 0, 0, 255)
                    SetTextOutline()
                    SetTextEntry("STRING")
                    AddTextComponentString(displayText)
                    DrawText(0.2, 0.8)


                    local vehicleCoords = GetEntityCoords(scannedVehicle)
                    DrawMarker(0, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 2.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, false, false, 2, nil, nil, false)
                end
            else
                scannedVehicle = nil
            end
        end
    end
end)
