local GLOBALS = dofile_once("mods/holy_mountain_revive_point/files/scripts/global_values.lua")
local Json = dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/jsonlua/json.lua")
local revival_icon = dofile_once("mods/holy_mountain_revive_point/files/scripts/revival/revival_icon.lua")

function item_pickup(entity_item, entity_who_picked, item_name)
  local pos_x, pos_y = EntityGetTransform(entity_item)
  GlobalsSetValue(GLOBALS.KEYS.ENCODED_POSITION, Json.encode({
    x = pos_x,
    y = pos_y - 1,
  }))

  GamePrintImportant("$holy_mountain_end_point_swore_to_god")
  revival_icon.add_ui_icon(entity_who_picked)

  -- revive counting
  local revive_count = tonumber(GlobalsGetValue("holy_mountain_revive_point.revive_count", "0"))
  GlobalsSetValue("holy_mountain_revive_point.revive_count", tostring(revive_count + 1))

  -- spawn a new one
  EntityKill(entity_item)
  EntityLoad("data/entities/particles/perk_reroll.xml", pos_x, pos_y)
  EntityLoad("mods/holy_mountain_revive_point/files/entities/revival_altar.xml", pos_x, pos_y)
end

