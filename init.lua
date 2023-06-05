dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")
local GLOBALS = dofile_once("mods/holy_mountain_revive_point/files/scripts/global_values.lua")
local revival_alter_actions = dofile_once("mods/holy_mountain_revive_point/files/scripts/player/revival_alter_actions.lua")

print("===========")
print("REVIVE POIT mod init")
print("===========")

ModLuaFileAppend("data/scripts/biomes/temple_altar_left.lua", "mods/holy_mountain_revive_point/files/scripts/biomes/temple_altar_left.lua")
ModLuaFileAppend("data/scripts/biomes/boss_victoryroom.lua", "mods/holy_mountain_revive_point/files/scripts/biomes/boss_victoryroom.lua")
ModLuaFileAppend("data/scripts/biomes/mountain/mountain_floating_island.lua", "mods/holy_mountain_revive_point/files/scripts/biomes/mountain/mountain_floating_island.lua")

function OnPlayerSpawned(player_id)
  EntityAddComponent2(player_id, "LuaComponent", {
    script_damage_received = "mods/holy_mountain_revive_point/files/scripts/player/damage_received.lua",
  })
end

function OnWorldPreUpdate()
  local polymorphed_player_entity_id = FindPolymorphedPlayer()

  if polymorphed_player_entity_id == nil then
    return
  end

  local revive_script = EntityGetFirstComponentIncludingDisabled(polymorphed_player_entity_id, "LuaComponent", "holy_mountain_revive_point.revive_script")
  if revive_script ~= nil then
    return
  end

  EntityAddComponent2(polymorphed_player_entity_id, "LuaComponent", {
    _tags = "holy_mountain_revive_point.revive_script",
    script_damage_received = "mods/holy_mountain_revive_point/files/scripts/player/damage_received.lua",
  })
end

local content = ModTextFileGetContent("data/translations/common.csv")
local translations = ModTextFileGetContent("mods/holy_mountain_revive_point/files/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", content .. translations)

print("===========")
print("REVIVE POIT mod init done")
print("===========")
