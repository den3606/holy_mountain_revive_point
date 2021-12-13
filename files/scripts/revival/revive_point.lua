function collision_trigger(player_entity)
  GamePrintImportant("YOU ARE REVIVED", "God bless you")
  GlobalsSetValue("holy_mountain_revive_point.is_saved", "0")

  for _, damage_model in ipairs(EntityGetComponent(player_entity, "DamageModelComponent") or {}) do
    -- HPをフルヘルスにする
    local max_hp = ComponentGetValue2(damage_model, "max_hp")
    ComponentSetValue2(damage_model, "hp", max_hp)

    -- 無敵解除
    ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
  end
end
