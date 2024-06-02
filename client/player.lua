ECM = exports["ContextMenu"]
ESX = exports["es_extended"]:getSharedObject()

local isPlayerAdmin = false

-- CreateThread(function()
--     if not ESX.IsPlayerLoaded() then
--         return
--     end

--     ESX.TriggerServerCallback("dnz_context:getPlayerGroup", function(group)
--         if (group == "superadmin" or group == "admin") then
--             isPlayerAdmin = true
--         end
--     end)

--     Wait(Config.UpdateInterval)
-- end)

ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
    local ped = hitEntity

    if DoesEntityExist(ped) then
        ESX.TriggerServerCallback("dnz_context:getPlayerGroup", function(group)
            if (group == "superadmin" or group == "admin") then
                isPlayerAdmin = true
            end
        end)
    end

    local targetId = NetworkGetPlayerIndexFromPed(ped)
    local xPlayer = GetPlayerServerId(targetId)
    local ply = Player(xPlayer).state

    if not DoesEntityExist(ped) or not IsEntityAPed(ped) or xPlayer == 0 then
        return
    end

    -- check if hit entity is not triggered by player ped (self)
    -- if ped ~= PlayerPedId() then
    --     -- Fouiller un joueur
    --     local itemFouille = ECM:AddItem(0, "Fouiller")
    --     ECM:OnActivate(itemFouille, function()
    --         local player, distance = ESX.Game.GetClosestPlayer()
    --         if (distance ~= -1 and distance <= 3.0) then
    --             TriggerServerEvent("dnz_context:searchPlayer", GetPlayerServerId(player))
    --         else
    --             ESX.ShowNotification("No player nearby", "error", 2000)
    --         end
    --     end)

    --     -- Porter un joueur
    --     local itemPorter = ECM:AddItem(0, "Porter")
    --     ECM:OnActivate(itemPorter, function()
    --         local player, distance = ESX.Game.GetClosestPlayer()
    --         if (distance ~= -1 and distance <= 3.0) then
    --             TriggerServerEvent("dnz_context:carryPlayer", GetPlayerServerId(player))
    --         else
    --             ESX.ShowNotification("No player nearby", "error", 2000)
    --         end
    --     end)
    -- end

    -- Partie admin
    if isPlayerAdmin then
        local submenuInfos = ECM:AddSubmenu(0, "Admin")

        local itemIdentifier = ECM:AddItem(submenuInfos, "ID: " .. xPlayer)
        ECM:OnActivate(itemIdentifier, function()
            SendNUIMessage({
                type = 'playerId',
                playerID = xPlayer
            })
            ESX.ShowNotification("ID copied to clipboard", "success", 2000)
        end)

        ECM:AddItem(submenuInfos, "RP Name : " .. ply.name)

        local itemFed = ECM:AddItem(submenuInfos, "Feed player")
        ECM:OnActivate(itemFed, function()
            TriggerServerEvent('dnz_fed:fed', xPlayer)
            ESX.ShowNotification("Player fed successfully", "success", 2000)
        end)

        local itemHeal = ECM:AddItem(submenuInfos, "Heal player")
        ECM:OnActivate(itemHeal, function()
            TriggerServerEvent('dnz_context:healPlayer', xPlayer)
            ESX.ShowNotification("Player heal successfully", "success", 2000)
        end)

        local itemRevie = ECM:AddItem(submenuInfos, "Revive player")
        ECM:OnActivate(itemRevie, function()
            TriggerServerEvent('dnz_context:revivePlayer', xPlayer)
            ESX.ShowNotification("Player revived successfully", "success", 2000)
        end)

        local itemWashClothes = ECM:AddItem(submenuInfos, "Wash clothes")
        ECM:OnActivate(itemWashClothes, function()
            TriggerServerEvent('dnz_context:washClothes', xPlayer)
            ESX.ShowNotification("Player clothes washed successfully", "success", 2000)
        end)

        if (ped ~= PlayerPedId()) then
            -- Kick player
            local itemKick = ECM:AddItem(submenuInfos, "Kick player")
            ECM:OnActivate(itemKick, function()
                local reason = "Kicked by admin"

                TriggerServerEvent("dnz_debug:kickPlayer", xPlayer, reason)
            end)

            -- Ban player
            local itemBan = ECM:AddItem(submenuInfos, "Ban player")
            ECM:OnActivate(itemBan, function()
                local reason = "Banned by admin"

                TriggerServerEvent("dnz_debug:banPlayer", xPlayer, reason)
            end)
        end
    end
end)

RegisterNetEvent('dnz_context:feedPlayer')
AddEventHandler('dnz_context:feedPlayer', function()
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)

    SetEntityHealth(playerPed, maxHealth)
    ESX.ShowNotification("You have been fed", "success", 2000)
end)

RegisterNetEvent('dnz_context:healPlayer')
AddEventHandler('dnz_context:healPlayer', function()
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)

    SetEntityHealth(playerPed, maxHealth)
    ESX.ShowNotification("You have been healed", "success", 2000)
end)

RegisterNetEvent('dnz_context:revivePlayer')
AddEventHandler('dnz_context:revivePlayer', function()
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)

    if IsEntityDead(playerPed) then
        ClearPedTasksImmediately(playerPed)
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
        ClearPedEnvDirt(playerPed)
        ClearPedWetness(playerPed)
    end

    SetEntityHealth(playerPed, maxHealth)
    ESX.ShowNotification("You have been revived", "success", 2000)
end)

RegisterNetEvent('dnz_context:washClothes')
AddEventHandler('dnz_context:washClothes', function()
    local player = GetPlayerPed(-1)
    if player then
        ClearPedTasksImmediately(player)
        ClearPedBloodDamage(player)
        ResetPedVisibleDamage(player)
        ClearPedLastWeaponDamage(player)
        ClearPedEnvDirt(player)
        ClearPedWetness(player)
        ESX.ShowNotification("Your clothes have been washed", "success", 2000)
    end
end)
