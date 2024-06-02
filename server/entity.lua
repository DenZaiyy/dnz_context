RegisterServerEvent('dnz_context:deleteEntity')
AddEventHandler('dnz_context:deleteEntity', function(entity)
    print("Delete entity event received with entity: " .. entity)
    -- check if entity exists
    if DoesEntityExist(entity) then
        print("Entity exists")
        -- set entity as mission entity
        SetEntityAsMissionEntity(entity, true, false)
        -- delete entity
        DeleteEntity(entity)
    end
end)
