---------------
-- Variables --
---------------

-- State variables

local ragdolled = false 

-- Memory load functions

LoadAnim = function(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(0)
	end
end

----------
-- Mapper --
----------

RegisterKeyMapping(config.commandName,config.mapperDesc,config.defaultMapper,config.defaultParameter)
RegisterCommand(config.commandName, function()
	ragdoll()
end)

---------------
-- Functions --
---------------

function ragdoll()
	local ped = PlayerPedId()
	if not CanPedRagdoll(ped) or IsEntityDead(ped) or IsPedInAnyVehicle(ped,false) then 
		ragdoll = false 
		return  
	end 
	Ragdoll = not Ragdoll 

	if Ragdoll then
		ShakeGameplayCam(config.cameraEffect, 1.0)
		for i = 0, 10 do 
			SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			Wait(200)
		end 
		while GetEntitySpeed(ped) > 0.1 do 
			SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			Wait(200)
		end 
		ClearPedTasksImmediately(ped)
		LoadAnim(config.fallAnimDict)
		local coords = GetEntityCoords(ped)
		while not IsEntityPlayingAnim(ped,config.fallAnimDict, config.fallAnim ,1) do 
			Wait(0)
			TaskPlayAnimAdvanced(ped,config.fallAnimDict, config.fallAnim ,coords.x,coords.y,coords.z,0.0,0.0,0.0,1.0,1.0,-1,1,0.9,0,0)
		end 
	else 
		ShakeGameplayCam(config.cameraEffect, 1.0)
		LoadAnim(config.UpAnimDict)
        TaskPlayAnim(ped, config.UpAnimDict ,config.UpAnim, 8.0, -8.0, -1, 0, 0, false, false, false)
        Wait(4500)
		if config.Drunk  then 
			LoadAnim("move_m@drunk@moderatedrunk")
			TaskPlayAnim(ped,"move_m@drunk@moderatedrunk","idle",1.0,1.0,config.DrunkCooldown,1,0,false,false,false)
		end 
	end 
	RemoveAnimDict(config.UpAnimDict)
	RemoveAnimDict(config.fallAnimDict)
end

