function get_player_entity()
	local players = EntityGetWithTag("player_unit")
	if #players == 0 then return end

	return players[1]
end

function get_basic_damage_multiplier(entity_id, multiplier_name)
	local dmc_id = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	local multiplier = ComponentObjectGetValue2( dmc_id, "damage_multipliers", multiplier_name )
	return multiplier
end