ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("aBoutique:verifcoin", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchScalar('SELECT coin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(coin)
		cb(coin)
	end)
end)

RegisterCommand("givecoin", function(source, args, user)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		local group = xPlayer.getGroup()
		if group == "superadmin" then
			if tonumber(args[1]) and tonumber(args[2]) then
				local xPlayer = ESX.GetPlayerFromId(args[1])
				if xPlayer then
					MySQL.Async.fetchScalar('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
						local finalcoin = result + args[2]
						MySQL.Sync.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
							['@identifier'] = xPlayer.identifier,   
							['@coin'] = finalcoin,   
						})
					end)
					TriggerClientEvent('esx:showNotification', source, "Vous venez de donner ~g~"..ESX.Math.GroupDigits(args[2]).." Coins ~s~à l'id : ~b~"..args[1].."~s~ !")
					TriggerClientEvent('esx:showNotification', args[1], "Vous venez de recevoir ~g~"..ESX.Math.GroupDigits(args[2]).." Coins ~s~d'un staff !")
				else
					TriggerClientEvent('esx:showNotification', source, "~r~Problème~s~ : Le joueur n'est pas en ligne !")
				end
			else
				TriggerClientEvent('esx:showNotification', source, "~r~Problème~s~ : Une erreur dans le commande !")
			end
		else
			TriggerClientEvent('esx:showNotification', source, "~r~Problème~s~ : Permission insuffisantes !")
		end
	else
		local xPlayer = ESX.GetPlayerFromId(args[1])
		if xPlayer then
			MySQL.Async.fetchScalar('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
				local finalcoin = result + args[2]
				MySQL.Sync.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
					['@identifier'] = xPlayer.identifier,   
					['@coin'] = finalcoin,   
				})
				TriggerClientEvent('esx:showNotification', args[1], "Livraison de votre ~g~achat~s~ !")
			end)
		end
	end
end)

RegisterServerEvent('aBoutique:achateffectue')
AddEventHandler('aBoutique:achateffectue', function(vehicleProps, plate, coin, price)
    local xPlayer = ESX.GetPlayerFromId(source)
	coin = coin - price
	if xPlayer ~= nil then
		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
			['@owner']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps)
		}, function(data)
		end)
    end
end)

RegisterNetEvent("aScript:moindecoin")
AddEventHandler("aScript:moindecoin", function(coin, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	coin = coin - price
	MySQL.Async.execute('UPDATE `users` SET `coin`= @coin  WHERE identifier=@identifier', {
		['@identifier']   = xPlayer.identifier,
		['coin'] = coin
	}, function(rowsChange)
	end)
end)

RegisterNetEvent("aScript:arme")
AddEventHandler("aScript:arme", function(raison, weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, 25)
end)

RegisterNetEvent("aScript:achatargent")
AddEventHandler("aScript:achatargent", function(montant)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('bank', montant)
end)
