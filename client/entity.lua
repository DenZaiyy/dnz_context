ECM = exports["ContextMenu"]
ESX = exports["es_extended"]:getSharedObject()

local isPlayerAllowed = false

-- CreateThread(function()
--     while (not isPlayerAllowed) do
--         ESX.TriggerServerCallback("dnz_context:getPlayerGroup", function(group)
--             if (group == "superadmin" or group == "admin") then
--                 isPlayerAllowed = true
--             end
--         end)
--         Wait(1000)
--     end
-- end)

ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
    if (not DoesEntityExist(hitEntity) or not IsEntityAnObject(hitEntity)) then
        return
    end

    local object = hitEntity

    -- Debug submenu
    local submenuDebug = ECM:AddSubmenu(0, "Debug")
    -- Name item with copy name action
    local itemName = ECM:AddItem(submenuDebug, "Model: " .. GetEntityArchetypeName(object))
    ECM:OnActivate(itemName, function()
        SendNUIMessage({
            type = 'itemName',
            name = GetEntityArchetypeName(object)
        })
        ESX.ShowNotification("Model copied to clipboard", "success", 2000)
    end)
    -- Hash item with copy hash action
    local itemHash = ECM:AddItem(submenuDebug, "Hash: " .. GetEntityModel(object))
    ECM:OnActivate(itemHash, function()
        SendNUIMessage({
            type = 'itemHash',
            hash = GetEntityModel(object)
        })
        ESX.ShowNotification("Hash copied to clipboard", "success", 2000)
    end)
    -- Position item with copy position action
    local itemPosition = ECM:AddItem(submenuDebug, "Position of props")
    ECM:OnActivate(itemPosition, function()
        local position = GetEntityCoords(object)
        local heading = GetEntityHeading(object)
        SendNUIMessage({
            type = 'itemPosition',
            x = position.x,
            y = position.y,
            z = position.z,
            heading = heading
        })
        ESX.ShowNotification("Position copied to clipboard", "success", 2000)
    end)

    -- check if player has owner of object



    if isPlayerAllowed then
        -- Repair item with repair action
        local itemRepair = ECM:AddItem(submenuDebug, "Repair object")
        ECM:OnActivate(itemRepair, function()
            SetEntityAsMissionEntity(object, true, true)
            SetEntityAsNoLongerNeeded(object)
            SetEntityAsMissionEntity(object, true, true)
            SetEntityAsNoLongerNeeded(object)
            ESX.ShowNotification("Entity was repaired", "success", 2000)
        end)
    end
    -- gizmo item with gizmo action
    local itemGizmo = ECM:AddItem(submenuDebug, "Moove with gizmo")
    ECM:OnActivate(itemGizmo, function()
        exports.object_gizmo:useGizmo(object)
    end)
    -- Delete item with delete action
    local itemDelete = ECM:AddItem(submenuDebug, "Delete object")
    ECM:OnActivate(itemDelete, function()
        if DoesEntityExist(object) then
            SetEntityAsMissionEntity(object, true, false)
            DeleteEntity(object)
            TriggerServerEvent('dnz_debug:deleteEntity', object)
            ESX.ShowNotification("Entity was deleted", "success", 2000)
        end
    end)
end)
