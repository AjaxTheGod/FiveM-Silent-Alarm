local cooldown = 900 -- cooldown in seconds
local webhook_addr = "" -- read the readme for details

local locations = {
	{title="Grove Street LTD", colour=2, id=207, x = -42.935, y = -1749.469, z = 29.421, location="Grove Street and Davis Ave [near postal 246]"},
	{title="Vanilla Unicorn", colour=2, id=207, x = 94.065, y = -1292.447, z = 29.269, location="Elgin Ave and Innocence Blvd [Postal 262]"},
	{title="Fleeca Bank on Great Ocean Highway", colour=2, id=207, x = -2957.631, y = 480.586, z = 15.707, location="Great Ocean Highway [Postal 963]"},
	{title="Blaine County Savings Bank", colour=2, id=207, x = -104.930, y = 6476.583, z = 31.627, location="Paleto Blvd and Cascabel Ave [Postal 842]"},
	{title="Pacific Standard Bank", colour=2, id=207, x = 255.714, y = 226.539, z = 101.876, location="Vinewood Blvd and Alta St [Postal 169]"},
	{title="Rob's Liquor", colour=2, id=207, x = -1218.801, y = -915.943, z = 11.326, location="Vinewood Blvd and Alta St [near postal 208-211]"},
	{title="Chumash Suburban", colour=2, id=207, x = -3169.17, y = 1043.81, z = 20.86, location="Great Ocean Highway [near postal 956]"},
	{title="Chumash Ammunition", colour=2, id=207, x = -3172.99, y = 1089.85, z = 20.84, location="Great Ocean Highway [near postal 956]"},
	{title="Barbareno Road 24/7", colour=2, id=207, x = -3249.75, y = 1005.06, z = 12.83, location="Great Ocean Highway [near postal 956]"},
	{title="Sandy Shores 24/7", colour=2, id=207, x = 1959.987, y = 3748.476, z = 32.244, location="Alhambra Dr [near postal 566]"},
	{title="Harmony Fleeca Bank", colour=2, id=207, x = 1177.268, y = 2711.776, z = 38.098, location="Route 68 [near postal 521]"},
	{title="Harmony 24/7", colour=2, id=207, x = 546.282, y = 2663.839, z = 42.157, location="Route 68 [near postal 522]"},
	{title="Banham 24/7", colour=2, id=207, x = -3048.39, y = 587.65, z = 7.91, location="Inesno Road, Banham Canyon [postal 260]"},
	{title="Prosperity St Rob's Liquor", colour=2, id=207, x = -1478.78, y = -375.21, z = 39.16, location="Prosperity St  [near postal 116]"},
	{title="Ginger Street LTD", colour=2, id=207, x = -709.66, y = -903.95, z = 19.22, location="Ginger Street / Lindsay Circus  [near postal 268]"},
	{title="El Rancho Blvd Rob's Liquor", colour=2, id=207, x = 1126.07, y = -980.07, z = 45.42, location="Vespucci Blvd / El Rancho Blvd  [near postal 7539]"},
	{title="West Mirror Drive LTD", colour=2, id=207, x = 1159.56, y = -314.06, z = 69.21, location="West Mirror Drive  [postal 189]"},
}

--Do not touch anything below--
local playercooldown = 0

Citizen.CreateThread(function()
    for _, info in pairs(locations) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

function newNotification(string)
    SetTextComponentFormat("STRING")
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		for _, info2 in pairs(locations) do
			if GetDistanceBetweenCoords(info2.x, info2.y, info2.z, x, y, z) < 5 and playercooldown == 0 then
				newNotification("~b~Active silent alarm at " .. info2.title .. " by pressing ~g~E~b~!")
				if(IsControlPressed(1, 38)) then
					Citizen.Wait(100)
					TriggerServerEvent("salarm:alertDispatch", webhook_addr, info2.title, info2.location)
					TriggerEvent("chatMessage", "", { 0, 0, 0 }, "Silent alarm activated!")
					playercooldown = cooldown
				end
			end
			
			if GetDistanceBetweenCoords(info2.x, info2.y, info2.z, x, y, z) < 5 and playercooldown ~= 0 then
				newNotification("~r~You can not activate another robbery for another ~g~" .. playercooldown .. " seconds~r~!")
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if playercooldown ~= 0 then
			Citizen.Wait(1000)
			playercooldown = playercooldown - 1
		end
	end
end)
