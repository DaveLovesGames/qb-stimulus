local QBCore = exports['qb-core']:GetCoreObject()

-- Check if user has permission to use the command
local function hasPermission(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local playerGroup = Player.PlayerData.group
    
    for _, allowedGroup in pairs(Config.AllowedGroups) do
        if playerGroup == allowedGroup then
            return true
        end
    end
    return false
end

-- Process stimulus for all players
local function stimulusPlayers(amount)
    MySQL.query('SELECT citizenid, money FROM players', {}, function(result)
        if result then
            local updates = 0
            local errors = 0
            
            for _, player in ipairs(result) do
                local moneyTable = json.decode(player.money)
                if moneyTable then
                    moneyTable.bank = moneyTable.bank + amount
                    
                    MySQL.update('UPDATE players SET money = ? WHERE citizenid = ?', {
                        json.encode(moneyTable),
                        player.citizenid
                    }, function(affectedRows)
                        if affectedRows > 0 then
                            updates = updates + 1
                        else
                            errors = errors + 1
                        end
                    end)
                end
            end
            
            -- Notify online players about the stimulus
            local Players = QBCore.Functions.GetPlayers()
            for _, v in pairs(Players) do
                local Player = QBCore.Functions.GetPlayer(v)
                if Player then
                    Player.Functions.AddMoney('bank', amount, "government-stimulus")
                    TriggerClientEvent('QBCore:Notify', v, "You received a government stimulus of $" .. amount, "success")
                end
            end
            
            print("Stimulus complete: Updated " .. updates .. " players, " .. errors .. " errors")
        end
    end)
    
    return true
end

-- Process stimulus for all businesses
local function stimulusBusinesses(amount)
    MySQL.update('UPDATE management_funds SET amount = amount + ?', {
        amount
    }, function(affectedRows)
        -- Only log to server console, no client notification
        print("Stimulus complete: Updated " .. affectedRows .. " businesses")
    end)
    
    return true
end

-- Register the command - using the same approach as in qb-gift
QBCore.Commands.Add(Config.Command, 'Distribute stimulus payments', {
    {name='type', help='player/business'},
    {name='amount', help='Amount to distribute'}
}, false, function(source, args)
    local citizenType = args[1]
    local amount = tonumber(args[2])
    
    if not citizenType or not amount then
        TriggerClientEvent('QBCore:Notify', source, string.format(Config.Messages.InvalidArgs, Config.Command), 'error')
        return
    end
    
    local stimulusType = citizenType:lower()
    
    if stimulusType ~= "player" and stimulusType ~= "business" then
        TriggerClientEvent('QBCore:Notify', source, Config.Messages.InvalidType, "error")
        return
    end
    
    if not amount or amount <= 0 then
        TriggerClientEvent('QBCore:Notify', source, Config.Messages.InvalidAmount, "error")
        return
    end
    
    local success = false
    
    if stimulusType == "player" then
        success = stimulusPlayers(amount)
    else
        success = stimulusBusinesses(amount)
    end
    
    if success then
        -- Only notify the admin who ran the command
        TriggerClientEvent('QBCore:Notify', source, string.format(Config.Messages.Success, amount, stimulusType), "success")
    else
        TriggerClientEvent('QBCore:Notify', source, Config.Messages.Error, "error")
    end
end, 'admin') -- Simply use 'admin' here like in your qb-gift resource 