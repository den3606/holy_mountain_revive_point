dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")
dofile_once("mods/holy_mountain_revive_point/files/scripts/player/revive_action.lua")

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
  local player_entity_id = GetUpdatedEntityID()

  local is_saved = tonumber(GlobalsGetValue("holy_mountain_revive_point.is_saved", "0")) == 1
  if is_fatal and is_saved then
    reviveAction(player_entity_id)
  end
end
