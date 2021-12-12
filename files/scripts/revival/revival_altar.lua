dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")

function item_pickup(entity_item, entity_who_picked, item_name)
  local pos_x, pos_y = EntityGetTransform(entity_item)

  -- 復活のカウント
  local revive_count = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__REVIVE_COUNT", "0"))
  GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__REVIVE_COUNT", tostring(revive_count + 1))

  register_revive_point(entity_item, pos_x, pos_y)

  -- spawn a new one
  EntityKill(entity_item)
  EntityLoad("data/entities/particles/perk_reroll.xml", pos_x, pos_y)
  EntityLoad("mods/holy_mountain_revive_point/files/entities/revival_altar.xml", pos_x, pos_y)
end

function register_revive_point(entity_item, pos_x, pos_y)
  -- 登録する
  local is_saved = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_SAVED", "0")) == 1
  print(tostring(is_saved))
  if is_saved then
    -- 蘇生ポイントを上書きする
    if newest_revive_point ~= "" then
      print("second delete entity")
      EntityKill(tonumber(newest_revive_point))
    end
  else
    GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_SAVED", "1")

    -- Playerにreviveのアクションを追加する
    local player_entity = get_player_entity()
    local revive_action_model = EntityAddComponent2(player_entity, "LuaComponent", {
      script_damage_received = "mods/holy_mountain_revive_point/files/scripts/player/revive_action.lua",
    })
    print("add player : revivea_action.lua" .. tostring(revive_action_model))
    GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__REVIVE_ACTION_ID", tostring(revive_action_model))
  end

  -- 蘇生ポイントを保存
  GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__NEWEST_REVIVE_POSITION_X", tostring(pos_x))
  GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__NEWEST_REVIVE_POSITION_Y", tostring(pos_y - 1))
end
