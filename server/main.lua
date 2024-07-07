--[[
──────────────────────────────────────────────────────────────────────────────────
─────────██████─██████████████─██████──████████─██████████████─████████████████───
─────────██░░██─██░░░░░░░░░░██─██░░██──██░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░██───
─────────██░░██─██░░██████░░██─██░░██──██░░████─██░░██████████─██░░████████░░██───
─────────██░░██─██░░██──██░░██─██░░██──██░░██───██░░██─────────██░░██────██░░██───
─────────██░░██─██░░██──██░░██─██░░██████░░██───██░░██████████─██░░████████░░██───
─────────██░░██─██░░██──██░░██─██░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░░░██───
─██████──██░░██─██░░██──██░░██─██░░██████░░██───██░░██████████─██░░██████░░████───
─██░░██──██░░██─██░░██──██░░██─██░░██──██░░██───██░░██─────────██░░██──██░░██─────
─██░░██████░░██─██░░██████░░██─██░░██──██░░████─██░░██████████─██░░██──██░░██████─
─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██──██░░░░██─██░░░░░░░░░░██─██░░██──██░░░░░░██─
─██████████████─██████████████─██████──████████─██████████████─██████──██████████─
──────────────────────────────────────────────────────────────────────────────────
]]--
CreateThread(function()
	for k,v in pairs(Config.Items) do
		ESX.RegisterUsableItem(k, function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			if v.remove then
				xPlayer.removeInventoryItem(k,1)
			end
			if v.type == "food" then
				TriggerClientEvent("joker_sts:add", source, "hunger", v.status)
				TriggerClientEvent('joker_bn:onUse', source, v.type, v.prop, v.anim)
				xPlayer.showNotification(TranslateCap('used_food', ESX.GetItemLabel(k)))
			elseif v.type == "drink" then
				TriggerClientEvent("joker_sts:add", source, "thirst", v.status)
				TriggerClientEvent('joker_bn:onUse', source, v.type, v.prop, v.anim)
				xPlayer.showNotification(TranslateCap('used_drink', ESX.GetItemLabel(k)))
		-----------EDIT--------------
		elseif v.type == "stress" then
				TriggerClientEvent("joker_sts:remove", source, "stress", v.status)
--				TriggerClientEvent("joker_sts:remove", source, "hunger", v.status)
				TriggerClientEvent('joker_bn:onUse', source, v.type, v.prop, v.anim)
				xPlayer.showNotification(TranslateCap('used_drink', ESX.GetItemLabel(k)))
			else
				print(string.format('^1[ERROR]^0 %s has no correct type defined.', k))
			end
		end)
	end 
end)

ESX.RegisterCommand('heal', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('joker_bn:healPlayer')
	args.playerId.showNotification(TranslateCap('got_healed'))
end, true, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', validate = true, arguments = {
	{name = 'playerId', help = 'the player id', type = 'player'}
}})

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
		return
	end

	TriggerClientEvent('joker_bn:healPlayer', eventData.id)
end)
