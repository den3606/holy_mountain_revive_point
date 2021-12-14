dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
  local entity = GetUpdatedEntityID()
  local player_entity = get_player_entity()

  for _, damage_model in ipairs(EntityGetComponent(entity, "DamageModelComponent") or {}) do
    local is_saved = tonumber(GlobalsGetValue("holy_mountain_revive_point.is_saved", "0")) == 1
    if is_fatal and is_saved then
      -- プレイヤー無敵化
      ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", true)

      -- revive pointをロードする
      local pos_x = GlobalsGetValue("holy_mountain_revive_point.newest_revive_pos_x", "")
      local pos_y = GlobalsGetValue("holy_mountain_revive_point.newest_revive_pos_y", "")

      if pos_x == "" or pos_y == "" then
        -- 蘇生ポイントが上手くロードできなかった場合は無敵を解除する
        -- 諦めて死んでくれ
        ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
      else
        local FOR_UNSTACK = 1
        pos_x = tonumber(pos_x)
        pos_y = tonumber(pos_y) - FOR_UNSTACK

        -- 復活ポイントをロード
        EntityLoad("mods/holy_mountain_revive_point/files/entities/revive_point.xml", pos_x, pos_y)

        -- 復活ポイントに移動
        EntityApplyTransform(player_entity, pos_x, pos_y)
        GameSetCameraPos(pos_x, pos_y)
      end

      -- 蘇生用スクリプトをPlayerから解除
      local revive_action_component_id = tonumber(GlobalsGetValue("holy_mountain_revive_point.revive_action_id"))
      EntityRemoveComponent(player_entity, revive_action_component_id)
    end
  end
end
