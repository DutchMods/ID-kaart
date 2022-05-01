local open = false
local ESX	 = nil

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

-- Key events
Citizen.CreateThread(function()
    while true do
        Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 166) then
            openMenu()
        end
	end
end)


RegisterCommand("id", function()
	if open then
		SendNUIMessage({
			action = "close"
		})
		open = false
	else
		openMenu()
		open = true
	end
end, false)

RegisterCommand("KijkID", function()
	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
end, false)

RegisterCommand("KijkRijbewijs", function()
	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
end, false)

RegisterCommand("GeefID", function()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 1.5 then
	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
	end
end, false)

RegisterCommand("GeefRijbewijs", function()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 1.5 then
	TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
	end
end, false)
