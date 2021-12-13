dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
  local entity = GetUpdatedEntityID()
  for _, damage_model in ipairs(EntityGetComponent(entity, "DamageModelComponent") or {}) do
    if is_fatal then
      -- プレイヤー無敵化、REVIVE呼び出し用のフラグをON
      GlobalsSetValue("holy_mountain_revive_point.is_revived", "1")
      ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", true)

      -- revive pointをロードする
      local pos_x = GlobalsGetValue("holy_mountain_revive_point.newest_revive_pos_x", "")
      local pos_y = GlobalsGetValue("holy_mountain_revive_point.newest_revive_pos_y", "")
      if pos_x == "" or pos_y == "" then
        -- 蘇生ポイントが上手くロードできなかった場合は無敵を解除する
        -- 諦めて死んでくれ
        ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
      else
        EntityLoad("mods/holy_mountain_revive_point/files/entities/revive_point.xml", pos_x, pos_y - 1)
      end

      GamePrintImportant("YOU ARE REVIVED", "God bless you")

      -- 蘇生用スクリプトをPlayerから解除
      local player_entity = get_player_entity()
      local revive_action_model = tonumber(GlobalsGetValue("holy_mountain_revive_point.revive_action_id"))
      EntityRemoveComponent(player_entity, revive_action_model)
    end
  end
end
