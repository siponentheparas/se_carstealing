ESX = nil
local isMissionAcive = false
local isReturing = false
local locIndex = nil
local carIndex = nil
local missionVehHash = nil
local reward = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local markerVisible, waypointInt = false, nil
        local playerPed = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(playerPed))
        local mx, my, mz = table.unpack(Config.GetMission)
        local scale = Config.Markers.scale
        local r, g, b = Config.Markers.color.r, Config.Markers.color.g, Config.Markers.color.b

        if GetDistanceBetweenCoords(px, py, pz, mx, my, mz, false) < 5 then
            DrawMarker(Config.Markers.type, mx, my, mz, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, scale, scale, scale, r, g, b, 50, false, true, 2, false, nil, nil, false)
            if GetDistanceBetweenCoords(px, py, pz, mx, my, mz, true) < 1 then
                ESX.ShowHelpNotification('Paina ~INPUT_CONTEXT~ saadaksesi tehtävän!', true, true)
                if IsControlJustReleased(0, 38) then
                    setMission()
                end
            end
        end
    end
end)

function setMission()
    if not isMissionAcive then
        local playerPed = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(playerPed))
        ESX.ShowAdvancedNotification('Simeon', 'Tuo minulle auto', 'Tuo minulle auto. Lähetän sinulle sijainnin.', 'CHAR_SIMEON', 1)
        locIndex = math.random(1, #Config.Locations)
        mx, my, mz = table.unpack(Config.Locations[locIndex].coords)
        if IsWaypointActive then
            DeleteWaypoint()
        end
        SetNewWaypoint(mx, my)
        isMissionAcive = true
        carIndex = math.random(1, #Config.Vehicles)
        ESX.Game.SpawnVehicle(Config.Vehicles[carIndex].model, Config.Locations[locIndex].coords, Config.Locations[locIndex].heading)
        missionVehHash = GetHashKey(Config.Vehicles[carIndex].model)
    else
        ESX.ShowAdvancedNotification('Simeon', 'IDIOOTTI!!', 'Tuo minulle tämä auto ennenkuin annan sinulle uuden tehtävän.', 'CHAR_SIMEON', 1)
    end
end

Citizen.CreateThread(function()
    local rx, ry, rz = table.unpack(Config.ReturnCar)
    local r, g, b = Config.Markers.color.r, Config.Markers.color.g, Config.Markers.color.b
    local scale = Config.Markers.scale
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(playerPed))
        if isMissionAcive and not isReturing then
            if locIndex == not nil then
                mx, my, mz = table.unpack(Config.Locations[locIndex].coords)
            end
            if GetDistanceBetweenCoords(px, py, pz, mx, my, mz, false) < 3 and GetEntityModel(GetVehiclePedIsIn(playerPed)) == missionVehHash then
                ESX.ShowAdvancedNotification('Simeon', 'Vie auto simeonille.', 'HYVÄ!! Sait auton, tue se minun luokseni. Laitan sinulle sijainnin.', 'CHAR_SIMEON', 1)
                DeleteWaypoint()
                SetNewWaypoint(rx, ry)
                isReturing = true
            end
        end
        if isReturing then
            if GetDistanceBetweenCoords(px, py, pz, rx, ry, rz, false) < 20 and GetEntityModel(GetVehiclePedIsUsing(playerPed)) == missionVehHash then
                DrawMarker(Config.Markers.type, rx, ry, rz, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, scale + 4, scale + 4, scale + 4, r, g, b, 50, false, true, 2, false, nil, nil, false)
                if GetDistanceBetweenCoords(px, py, pz, rx, ry, rz, false) < 5 then
                    ESX.ShowHelpNotification('Paina ~INPUT_CONTEXT~ palauttaaksesi auton!', true, true)
                    if IsControlJustReleased(0, 38) then
                        returnCar()
                    end
                end
            end
        end
    end
end)

function returnCar()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed)
    TaskLeaveVehicle(playerPed, GetVehiclePedIsIn(playerPed), 1)
    Citizen.Wait(1500)
    ESX.Game.DeleteVehicle(vehicle)
    ESX.ShowAdvancedNotification('Simeon', 'Palautit auton.', 'Kiitos kun toit minulle auton. Voit tuoda minulle toisen tai voit tulla hakemaan rahat.', 'CHAR_SIMEON', 1)
    reward = reward + Config.Vehicles[carIndex].reward
    isMissionAcive = false
    isReturing = false
end

Citizen.CreateThread(function()
    scale = Config.Markers.scale
    r, g, b = Config.Markers.color.r, Config.Markers.color.g, Config.Markers.color.b
    while true do
        playerPed = PlayerPedId()
        px, py, pz = table.unpack(GetEntityCoords(playerPed))
        rx, ry, rz = table.unpack(Config.GetReward)
        Citizen.Wait(4)
        if reward > 0 then
            if GetDistanceBetweenCoords(px, py, pz, rx, ry, rz, false) < 5 then
                DrawMarker(Config.Markers.type, rx, ry, rz, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, scale, scale, scale, r, g, b, 50, false, true, 2, false, nil, nil, false)
                if GetDistanceBetweenCoords(px, py, pz, rx, ry, rz, false) < 1 then
                    ESX.ShowHelpNotification('Paina ~INPUT_CONTEXT~ saadaksesi rahat')
                    if IsControlJustReleased(0, 38) then
                        local Currency = Config.Currency
                        TriggerServerEvent('se_carstealing:AddMoney', reward)
                        ESX.ShowAdvancedNotification('Simeon', 'Kiitos työstäsi', 'Kiitos kun autoit minua. Ota nämä rahat ja nauti.  Sinä sait ' .. reward .. Currency, 'CHAR_SIMEON', 1)
                        reward = 0
                    end
                end
            end
        end
    end
end)
