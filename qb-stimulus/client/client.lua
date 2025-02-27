local QBCore = exports['qb-core']:GetCoreObject()

-- This file is mostly empty as the stimulus functionality is handled server-side
-- You can add client-side notifications or effects here if needed

RegisterNetEvent('qb-stimulus:client:notifyStimulus', function(amount)
    QBCore.Functions.Notify('You received a government stimulus of $' .. amount, 'success')
end) 