ECM                  = exports["ContextMenu"]
ESX                  = exports["es_extended"]:getSharedObject()

local isPlayerAdmin  = false
local isVehicleOwner = false

-- CreateThread(function()
--     while true do
--         if not ESX.IsPlayerLoaded() then
--             return
--         end

--         ESX.TriggerServerCallback("dnz_context:getPlayerGroup", function(group)
--             if (group == "superadmin" or group == "admin") then
--                 isPlayerAdmin = true
--             end
--         end)

--         Wait(Config.UpdateInterval)
--     end
-- end)

function OpenCloseVehicle()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed, true)

    local vehicle   = nil

    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        RequestAnimDict("anim@mp_player_intmenu@key_fob@")
        TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false,
            false)
    end

    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
    end

    ESX.TriggerServerCallback('ownedVeh:exist', function(gotkey)
        if gotkey then
            local locked = GetVehicleDoorLockStatus(vehicle)
            if locked == 1 or locked == 0 then -- if unlocked
                SetVehicleDoorsLocked(vehicle, 2)
                SetVehicleLights(vehicle, 2)
                Wait(200)
                SetVehicleLights(vehicle, 0)
                StartVehicleHorn(vehicle, 100, 1, false)
                Wait(200)
                SetVehicleLights(vehicle, 2)
                Wait(400)
                SetVehicleLights(vehicle, 0)
                -- PlayVehicleDoorCloseSound(vehicle, 1)
                ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
            elseif locked == 2 then -- if locked
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleLights(vehicle, 2)
                Wait(200)
                SetVehicleLights(vehicle, 0)
                StartVehicleHorn(vehicle, 100, 1, false)
                Wait(200)
                SetVehicleLights(vehicle, 2)
                Wait(400)
                SetVehicleLights(vehicle, 0)
                ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
            end
        else
            ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
        end
    end, GetVehicleNumberPlateText(vehicle))
end

RegisterNetEvent('dnz_context:receiveVehicleOwner')
AddEventHandler('dnz_context:receiveVehicleOwner', function(ownerID)
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(playerPed))

    if ownerID == playerId then
        isVehicleOwner = true
    end
end)

-- this function gets called when clicking on anything
ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
    if (not DoesEntityExist(hitEntity) or not IsEntityAVehicle(hitEntity)) then
        return
    end

    -- ESX.TriggerServerCallback("dnz_context:getVehicleOwner", function(cbOwner, cbPlayer)
    --     if cbOwner == cbPlayer then
    --         vehicleOwner = true
    --     end
    -- end)

    local vehicle = hitEntity
    if DoesEntityExist(vehicle) then
        ESX.TriggerServerCallback("dnz_context:getPlayerGroup", function(group)
            if (group == "superadmin" or group == "admin") then
                isPlayerAdmin = true
            end
        end)
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('dnz_context:getVehicleOwner', plate)
    end

    -- check if vehicle have doors before adding submenu
    if (GetNumberOfVehicleDoors(vehicle) > 0) then
        local submenuDoor, submenuDoorItem = ECM:AddSubmenu(0, "Open door")
        for i = 1, GetNumberOfVehicleDoors(vehicle), 1 do
            local itemDoor = ECM:AddItem(submenuDoor, "Door " .. i)
            ECM:OnActivate(itemDoor, function()
                local door = i - 1
                if (GetVehicleDoorAngleRatio(vehicle, door) < 0.1) then
                    SetVehicleDoorOpen(vehicle, door, false, false)
                else
                    SetVehicleDoorShut(vehicle, door, false)
                end
            end)
        end
    end

    --GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()

    -- check if player has owner of vehicle
    if isVehicleOwner then
        local submenuVehicle = ECM:AddSubmenu(0, "Vehicle")

        local itemLock = ECM:AddItem(submenuVehicle, "Lock/Unlock vehicle")
        ECM:OnActivate(itemLock, function()
            OpenCloseVehicle()
        end)

        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
            local itemEngine = ECM:AddItem(submenuVehicle, "Toggle engine")
            ECM:OnActivate(itemEngine, function()
                if (GetIsVehicleEngineRunning(vehicle)) then
                    SetVehicleEngineOn(vehicle, false, true, true)
                    ESX.ShowNotification("Engine off", "success", 2000)
                else
                    SetVehicleEngineOn(vehicle, true, true, true)
                    ESX.ShowNotification("Engine on", "success", 2000)
                end
            end)
        end
    end

    -- check if player have admin permission
    if isPlayerAdmin then
        local submenuAdmin = ECM:AddSubmenu(0, "Admin")

        local itemRepair = ECM:AddItem(submenuAdmin, "Repair vehicle")
        ECM:OnActivate(itemRepair, function()
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            -- SetVehicleEngineHealth(vehicle, 1000)
        end)

        local itemDelete = ECM:AddItem(submenuAdmin, "Delete vehicle")
        ECM:OnActivate(itemDelete, function()
            if (DoesEntityExist(vehicle)) then
                SetEntityAsMissionEntity(vehicle, true, false)
                ESX.Game.DeleteVehicle(vehicle)
            end
        end)
    end
end)
