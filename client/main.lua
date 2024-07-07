local IsDead = false
local IsAnimated = false

AddEventHandler('joker_bn:resetStatus', function()
	TriggerEvent('joker_sts:set', 'hunger', 500000)
	TriggerEvent('joker_sts:set', 'thirst', 500000)
	TriggerEvent('joker_sts:set', 'stress', 0)
end)

RegisterNetEvent('joker_bn:healPlayer')
AddEventHandler('joker_bn:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('joker_sts:set', 'hunger', 1000000)
	TriggerEvent('joker_sts:set', 'thirst', 1000000)
	TriggerEvent('joker_sts:set', 'stress', 0)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	if IsDead then
		TriggerEvent('joker_bn:resetStatus')
	end

	IsDead = false	
end)

AddEventHandler('joker_sts:loaded', function(status)
	TriggerEvent('joker_sts:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return Config.Visible
	end, function(status)
		status.remove(300)
	end)

	TriggerEvent('joker_sts:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return Config.Visible
	end, function(status)
		status.remove(300)
	end)
end)

TriggerEvent('joker_sts:registerStatus', 'stress', 0, '#cadfff', function(status)
	return false
end, function(status)
	status.add(0)
end)



AddEventHandler('joker_sts:onTick', function(data)
    local playerPed  = PlayerPedId()
    local prevHealth = GetEntityHealth(playerPed)
    local health     = prevHealth
    local stressVal  = 0

    for k, v in pairs(data) do
        if v.name == 'hunger' and v.percent and v.percent == 0 then
            if prevHealth <= 150 then
                health = health - 5
            else
                health = health - 1
            end
        elseif v.name == 'thirst' and v.percent and v.percent == 0 then
            if prevHealth <= 150 then
                health = health - 5
            else
                health = health - 1
            end
        elseif v.name == 'stress' and v.value then
            stressVal = v.percent
        end
    end

    if health ~= prevHealth then
        SetEntityHealth(playerPed, health)
    end
end)




AddEventHandler('joker_bn:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('joker_bn:onUse')
AddEventHandler('joker_bn:onUse', function(type, prop_name)
	if not IsAnimated then
		local anim = {dict = 'mp_player_inteat@burger', name = 'mp_player_int_eat_burger_fp', settings = {8.0, -8, -1, 49, 0, 0, 0, 0}}
		IsAnimated = true
		if type == 'food' then
			prop_name = prop_name or 'prop_cs_burger_01'
			anim = {dict = 'mp_player_inteat@burger', name = 'mp_player_int_eat_burger_fp', settings = {8.0, -8, -1, 49, 0, 0, 0, 0}}
		elseif type == 'drink' then
			prop_name = prop_name or 'prop_ld_flow_bottle'
			anim = {dict = 'mp_player_intdrink', name = 'loop_bottle', settings = {1.0, -1.0, 2000, 0, 1, true, true, true}}
		------------------------EDIT------------------------------------
		
		elseif type == 'stress' then
			prop_name = prop_name or 'prop_ld_flow_bottle'
			anim = {dict = 'mp_player_intdrink', name = 'loop_bottle', settings = {1.0, -1.0, 2000, 0, 1, true, true, true}}
		end

		CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(joaat(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict(anim.dict, function()
				TaskPlayAnim(playerPed, anim.dict, anim.name, anim.settings[1], anim.settings[2], anim.settings[3], anim.settings[4], anim.settings[5], anim.settings[6], anim.settings[7], anim.settings[8])
				RemoveAnimDict(anim.dict)

				Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)
	end
end)

-- Backwards compatibility
RegisterNetEvent('joker_bn:onEat')
AddEventHandler('joker_bn:onEat', function(prop_name)
    local Invoke = GetInvokingResource()

    print(('[^3WARNING^7] ^5%s^7 used ^5joker_bn:onEat^7, this method is deprecated and should not be used! Refer to ^5https://documentation.esx-framework.org/addons/joker_bn/events/oneat^7 for more info!'):format(Invoke))

    if not prop_name then
        prop_name = 'prop_cs_burger_01'
    end
    TriggerEvent('joker_bn:onUse', 'food', prop_name)
end)

RegisterNetEvent('joker_bn:onDrink')
AddEventHandler('joker_bn:onDrink', function(prop_name)
    local Invoke = GetInvokingResource()

    print(('[^3WARNING^7] ^5%s^7 used ^5joker_bn:onDrink^7, this method is deprecated and should not be used! Refer to ^5https://documentation.esx-framework.org/addons/joker_bn/events/ondrink^7 for more info!'):format(Invoke))


    if not prop_name then
        prop_name = 'prop_ld_flow_bottle'
    end
    TriggerEvent('joker_bn:onUse', 'drink', prop_name)
end)
