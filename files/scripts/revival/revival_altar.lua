dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")

local function register_revive_point(entity_item, pos_x, pos_y)
  local unsaved = tonumber(GlobalsGetValue("holy_mountain_revive_point.is_saved", "0")) == 0

  if unsaved then
    GlobalsSetValue("holy_mountain_revive_point.is_saved", "1")

    local player_entity = get_player_entity()
    local revive_action_component_id = EntityAddComponent2(player_entity, "LuaComponent", {
      script_damage_received = "mods/holy_mountain_revive_point/files/scripts/player/revive_action.lua",
    })
    GlobalsSetValue("holy_mountain_revive_point.revive_action_id", tostring(revive_action_component_id))
  end

  GlobalsSetValue("holy_mountain_revive_point.newest_revive_pos_x", tostring(pos_x))
  GlobalsSetValue("holy_mountain_revive_point.newest_revive_pos_y", tostring(pos_y - 1))
end

function item_pickup(entity_item, entity_who_picked, item_name)
  local pos_x, pos_y = EntityGetTransform(entity_item)

  -- revive counting
  local revive_count = tonumber(GlobalsGetValue("holy_mountain_revive_point.revive_count", "0"))
  GlobalsSetValue("holy_mountain_revive_point.revive_count", tostring(revive_count + 1))

  GamePrintImportant("You swore to God")

  register_revive_point(entity_item, pos_x, pos_y)

  -- spawn a new one
  EntityKill(entity_item)
  EntityLoad("data/entities/particles/perk_reroll.xml", pos_x, pos_y)
  EntityLoad("mods/holy_mountain_revive_point/files/entities/revival_altar.xml", pos_x, pos_y)
end

