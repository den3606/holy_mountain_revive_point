function reviveAction(player_entity_id)
  for _, damage_model in ipairs(EntityGetComponent(player_entity_id, "DamageModelComponent") or {}) do
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

      -- 一番近い聖なる山に通り抜けポイントを作る
      -- FIXME:リストはハードコーディングしているが、動的に取りたい
      local position_list = {{-512, 1024}, {-512, 2560}, {-512, 4608}, {-512, 6144}, {-512, 8192}, {-512, 10240}}

      local index_of_near = 0
      local min_distance = 0
      for k, v in pairs(position_list) do
        local dx = pos_x - v[1]
        local dy = pos_y - v[2]
        local distance = math.sqrt(dx * dx + dy * dy)

        if k == 1 then
          index_of_near = 1
          min_distance = distance
        elseif distance < min_distance then
          index_of_near = k
          min_distance = distance
        end
      end
      -- 穴開け用のbiomeをロードする
      LoadPixelScene("mods/holy_mountain_revive_point/files/biome_impl/temple/altar.png", "mods/holy_mountain_revive_point/files/biome_impl/temple/altar_visual.png", -512,
        position_list[index_of_near][2] - 40 + 300, "", true)
      LoadPixelScene("mods/holy_mountain_revive_point/files/biome_impl/temple/altar_right.png", "mods/holy_mountain_revive_point/files/biome_impl/temple/altar_right_visual.png", 0,
        position_list[index_of_near][2] - 40 + 300, "", true)

      -- 復活ポイントをロード
      EntityLoad("mods/holy_mountain_revive_point/files/entities/revive_point.xml", pos_x, pos_y)

      -- 復活ポイントに移動
      EntityApplyTransform(player_entity_id, pos_x, pos_y)
      GameSetCameraPos(pos_x, pos_y)
    end
  end
end
