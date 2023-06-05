local GLOBALS = dofile_once("mods/holy_mountain_revive_point/files/scripts/global_values.lua")
local revival_alter_actions = dofile_once("mods/holy_mountain_revive_point/files/scripts/player/revival_alter_actions.lua")

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
  local player_entity_id = GetUpdatedEntityID()

  local saved = (GlobalsGetValue(GLOBALS.KEYS.ENCODED_POSITION, "") ~= "")

  if is_fatal and saved then
    revival_alter_actions.revive(player_entity_id)
  end
end
