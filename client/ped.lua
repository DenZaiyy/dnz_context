ECM = exports["ContextMenu"]
ESX = exports["es_extended"]:getSharedObject()

ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
    local ped = hitEntity

    if (not DoesEntityExist(ped) or not IsEntityAPed(ped)) then
        return
    end
end)
