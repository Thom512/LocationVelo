ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback(GetCurrentResourceName()..':checkMoney', function(source, cb, prix)
local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= prix then
		xPlayer.removeMoney(prix)
		cb(true)
	else
		cb(false)
	end
end)