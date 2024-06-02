ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('dnz_context:getPlayerGroup', function(source, cb)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if not xPlayer then
        return
    end

    local group = xPlayer.getGroup()

    cb(group)
end)
