dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
  local entity = GetUpdatedEntityID()
  for _, damage_model in ipairs(EntityGetComponent(entity, "DamageModelComponent") or {}) do
    if is_fatal then
      -- プレイヤー無敵化、REVIVE呼び出し用のフラグをON
      GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_REVIVED", "1")
      ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", true)

      -- revive pointをロードする
      local pos_x = GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__NEWEST_REVIVE_POSITION_X", "")
      local pos_y = GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__NEWEST_REVIVE_POSITION_Y", "")
      if pos_x == "" or pos_y == "" then
        -- 蘇生ポイントが上手くロードできなかった場合は無敵を解除する
        -- 諦めて死んでくれ
        ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
      else
        EntityLoad("mods/holy_mountain_revive_point/files/entities/revive_point.xml", pos_x, pos_y - 1)
      end

      -- 蘇生用スクリプトをPlayerから解除
      local player_entity = get_player_entity()
      local revive_action_model = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__REVIVE_ACTION_ID"))

      EntityRemoveComponent(player_entity, revive_action_model)
    end
  end
end

-- function damage_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
--   print("====damage_about_to_be_received====")
--   print(tostring(damage))
--   print(tostring(x))
--   print(tostring(y))
--   print(tostring(entity_thats_responsible))
--   print(tostring(critical_hit_chance))

--   local entity = GetUpdatedEntityID()
--   for _, damage_model in ipairs(EntityGetComponent(entity, "DamageModelComponent") or {}) do
--     local this_hp = ComponentGetValue2( damage_model, "hp" )
--     print("this hp: ".. tostring(this_hp))
--     print("damage: ".. tostring(damage))
--     print("judge: ".. tostring(this_hp <damage))
--     -- 有効化の判定を追加する
--     if this_hp < damage then
--       local max_hp = ComponentGetValue2(damage_model, "max_hp")
--       ComponentSetValue2(damage_model, "hp", max_hp)
--       damage = 0
--       local pos_x, pos_y = EntityGetTransform( entity )
--       revived_pos_x = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__REVIVE_POINT_X", pos_x))
--       revived_pos_y = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__REVIVE_POINT_Y", pos_y))
--       GameSetCameraPos(revived_pos_x, revived_pos_y)
--       EntityApplyTransform(entity, revived_pos_x, revived_pos_y)
--       GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__REVIVE_POINT_X", "")
--       GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__REVIVE_POINT_Y", "")
--     end
--   end
--   return damage, critical_hit_chance
-- end
