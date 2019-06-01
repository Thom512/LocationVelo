ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    for i=1, #Config.Locs, 1 do
		local currLoc = Config.Locs[i]
        blip = AddBlipForCoord(currLoc.PNJ.x, currLoc.PNJ.y, currLoc.PNJ.z)
        SetBlipSprite(blip, 280)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Location vélos")
        EndTextCommandSetBlipName(blip)
		
		RequestModel(GetHashKey("a_m_y_beachvesp_02"))
		while not HasModelLoaded(GetHashKey("a_m_y_beachvesp_02")) do
			Citizen.Wait(10)
		end
		npc = CreatePed(5, "a_m_y_beachvesp_02", currLoc.PNJ.x, currLoc.PNJ.y, currLoc.PNJ.z, currLoc.PNJ.h, false, false)
		SetPedFleeAttributes(npc, 0, 0)
		SetPedComponentVariation(npc, 11, 1, 1, 2)
		SetPedDropsWeaponsWhenDead(npc, false)
		SetPedDiesWhenInjured(npc, false)
		--Citizen.Wait(1500)
		SetEntityInvincible(npc , true)
		FreezeEntityPosition(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
    end
end)

function ChooseBike(currLoc)
		local currSpawn = Config.Locs[currLoc].Spawn
		local elements = {}

		for i=1, #Config.Velos, 1 do
			table.insert(elements, {label =  GetLabelText(GetDisplayNameFromVehicleModel(Config.Velos[i].model)) .. '<span style="color: limegreen;">'.. Config.Velos[i].prix.. '$</span>', value = Config.Velos[i].model, prix = Config.Velos[i].prix})
		end
    
        ESX.UI.Menu.CloseAll()
    
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuPerso',{
            title = 'Location de vélos',
            align = 'top-left',
            elements = elements
        },
        function(data, menu)
			menu.close()
            ESX.TriggerServerCallback(GetCurrentResourceName()..':checkMoney', function(hasMoney)
				if hasMoney then
					RequestStreamedTextureDict("DIA_BIKERENTAL", true)
					while not HasStreamedTextureDictLoaded("DIA_BIKERENTAL") do Wait(1) end
					ESX.ShowAdvancedNotification("Location de vélos", "Je te cherche ton ~g~".. GetLabelText(GetDisplayNameFromVehicleModel(data.current.value)), "", "DIA_BIKERENTAL", 1)
					Wait(5000)
					ESX.Game.SpawnVehicle(data.current.value, currSpawn, currSpawn.h, function(vehicle)
						TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
						SetVehicleNumberPlateText(vehicle, "LOC"..math.random(10000,99999))
					end)
					ESX.ShowAdvancedNotification("Location de vélos", "Bonne route!", "", "DIA_BIKERENTAL", 1)
				else
					RequestStreamedTextureDict("DIA_BIKERENTAL", true)
					while not HasStreamedTextureDictLoaded("DIA_BIKERENTAL") do Wait(1) end
					ESX.ShowAdvancedNotification("Location de vélos", "Tu n'as pas assez de liquide", "", "DIA_BIKERENTAL", 1)
				end
			end, data.current.prix)
    end,
    function(data, menu)
        menu.close()
    end)
end 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for i=1, #Config.Locs, 1 do
		local currLoc = Config.Locs[i]
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, currLoc.PNJ.x, currLoc.PNJ.y, currLoc.PNJ.z)
            if dist <= 2.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ pour louer un ~b~vélo")
				if IsControlJustPressed(1,51) then 
					ChooseBike(i)
				end
            end
        end
    end
end)