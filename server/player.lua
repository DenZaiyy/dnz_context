ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('dnz_context:feedPlayer')
AddEventHandler('dnz_context:feedPlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if not xPlayer or not xTarget then
        return
    end

    if xPlayer.group == "admin" then
        TriggerClientEvent('dnz_context:feedPlayer', target)
    end
end)

RegisterNetEvent('dnz_context:healPlayer')
AddEventHandler('dnz_context:healPlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    if xPlayer.group == "admin" then
        TriggerClientEvent('dnz_context:healPlayer', target)
    end
end)

RegisterNetEvent('dnz_context:revivePlayer')
AddEventHandler('dnz_context:revivePlayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    if xPlayer.group == "admin" then
        TriggerClientEvent('dnz_context:revivePlayer', target)
    end
end)

RegisterNetEvent('dnz_context:washClothes')
AddEventHandler('dnz_context:washClothes', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    if xPlayer.group == "admin" then
        TriggerClientEvent('dnz_context:washClothes', target)
    end
end)

RegisterServerEvent('dnz_context:searchPlayer')
AddEventHandler('dnz_context:searchPlayer', function(target)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(target)
    local identifier = xPlayer.getIdentifier()
    local rpName = xPlayer.getName()

    ExecuteCommand('steal')

    print("Player " .. target .. " (" .. rpName .. ")" .. " searched by " .. _src)
    print("Player " .. target .. " identifier: " .. identifier)
end)

RegisterServerEvent('dnz_context:carryPlayer')
AddEventHandler('dnz_context:carryPlayer', function(target)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(target)
    local xPlayerSrc = ESX.GetPlayerFromId(_src)

    if not xPlayer then
        return
    end

    if xPlayerSrc.group == "admin" then
        TriggerClientEvent('dnz_context:carryPlayer', target)
    end
end)

RegisterServerEvent('dnz_context:kickPlayer')
AddEventHandler('dnz_context:kickPlayer', function(target, reason)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(target)
    local xPlayerSrc = ESX.GetPlayerFromId(_src)

    --check if player is valid and if player trigger himself
    if target == xPlayerSrc then
        ESX.ShowNotification("You can't kick yourself", "error", 2000)
        return
    end

    --check if player is valid
    if not xPlayer then
        ESX.ShowNotification("Player not found or not online", "error", 2000)
        return
    end

    --check if player is allowed to kick
    if xPlayerSrc.getGroup() ~= "superadmin" and xPlayerSrc.getGroup() ~= "admin" then
        ESX.ShowNotification("You don't have permission to kick", "error", 2000)
        return
    end

    --kick player
    DropPlayer(target, reason)
end)
