ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('ownedVeh:exist', function(source, cb, plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @identifier', {
        ['@plate'] = plate,
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local found = false
        if result[1] ~= nil then
            if xPlayer.identifier == result[1].owner then
                found = true
            end
        end
        if found then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('dnz_context:getVehicleOwner')
AddEventHandler('dnz_context:getVehicleOwner', function(plate)
    local _src = source

    MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local ownerIdentifier = result[1].owner
            local xPlayer = ESX.GetPlayerFromIdentifier(ownerIdentifier)
            if xPlayer then
                TriggerClientEvent('dnz_context:receiveVehicleOwner', _src, xPlayer.source)
            else
                TriggerClientEvent('dnz_context:receiveVehicleOwner', _src, nil)
            end
        else
            TriggerClientEvent('dnz_context:receiveVehicleOwner', _src, nil)
        end
    end)
end)
