function collision_trigger(player_entity)
  GamePrintImportant("YOU ARE REVIVED", "God bless you")
  GlobalsSetValue("holy_mountain_revive_point.is_saved", "0")

  -- Delete Area Damage
  while EntityGetWithName("workshop_altar") ~= 0 do
    EntityKill(EntityGetWithName("workshop_altar"))
  end

  -- 無敵時間さん？！(5f * 24 = 120f = 2s)
  EntityAddComponent2(player_entity, "LuaComponent", {
    script_source_file = "mods/holy_mountain_revive_point/files/scripts/player/invincible_action.lua",
    call_init_function = true,
    execute_every_n_frame = 5,
    execute_times = 24,
  })

  local pos_x, pos_y = EntityGetTransform(player_entity)
  local for_stack = 2
  pos_y = pos_y + for_stack
  GamePlaySound("data/audio/Desktop/misc.bank", "misc/teleport_use", pos_x, pos_y)
  EntityLoad("mods/holy_mountain_revive_point/files/entities/revival_point_effect.xml", pos_x, pos_y)
end
