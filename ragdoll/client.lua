---------------
-- Variables --
---------------

-- World related variables

local ped

-- State variables

local onGround

-- Memory load functions

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(1)
	end
end

----------
-- Code --
----------

Citizen.CreateThread(function()
	while true do
		ped = PlayerPedId()

		if IsControlJustPressed(0, cfg.key) then
			ragdoll()
		end
		Citizen.Wait(3)
	end
end)

---------------
-- Functions --
---------------

function ragdoll()
	if not onGround then
		SetPedToRagdoll(ped, 300000, 300000, 0, 0, 0, 0)
		onGround = not onGround
	else 
		ClearPedTasksImmediately(ped)
		SetEntityHeading(ped, GetEntityHeading(ped) + 180.0)
		LoadAnim("missheist_agency3astumble_getup")
        TaskPlayAnim(ped, "missheist_agency3astumble_getup" ,"stumble_getup", 8.0, -8.0, -1, 0, 0, false, false, false)
        Wait(4500)
		onGround = not onGround
	end
end
