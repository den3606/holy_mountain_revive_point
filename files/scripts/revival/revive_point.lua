function collision_trigger(player_entity)
  GamePrintImportant("YOU ARE REVIVED", "God bless you")
  GlobalsSetValue("holy_mountain_revive_point.is_saved", "0")

  -- Delete Area Damage
  while EntityGetWithName("workshop_altar") ~= 0 do
    EntityKill(EntityGetWithName("workshop_altar"))
  end

  for _, damage_model in ipairs(EntityGetComponent(player_entity, "DamageModelComponent") or {}) do
    -- HPをフルヘルスにする
    local max_hp = ComponentGetValue2(damage_model, "max_hp")
    ComponentSetValue2(damage_model, "hp", max_hp)

    -- 無敵解除
    ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
  end

  local pos_x, pos_y = EntityGetTransform(player_entity)
  local for_stack = 2
  pos_y = pos_y + for_stack
  GamePlaySound("data/audio/Desktop/misc.bank", "misc/teleport_use", pos_x, pos_y)
  EntityLoad("mods/holy_mountain_revive_point/files/entities/revival_point_effect.xml", pos_x, pos_y)
end
