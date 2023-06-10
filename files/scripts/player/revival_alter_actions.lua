local Json = dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/jsonlua/json.lua")
local GLOBALS = dofile_once("mods/holy_mountain_revive_point/files/scripts/global_values.lua")
local revival_icon = dofile_once("mods/holy_mountain_revive_point/files/scripts/revival/revival_icon.lua")

local function override_holy_mountain_biome(revive_position_x, revive_position_y)
  -- 一番近い聖なる山に通り抜けポイントを作る
  -- FIXME:リストはハードコーディングしているが、動的に取りたい
  local position_list = {{-512, 1024}, {-512, 2560}, {-512, 4608}, {-512, 6144}, {-512, 8192}, {-512, 10240}}

  local index_of_near = 0
  local min_distance = 0
  for k, v in pairs(position_list) do
    local dx = revive_position_x - v[1]
    local dy = revive_position_y - v[2]
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
end

local function revived(revive_target_entity_id, revive_position)
  override_holy_mountain_biome(revive_position.x, revive_position.y)

  -- 復活ポイントに移動
  EntityApplyTransform(revive_target_entity_id, revive_position.x, revive_position.y)
  GameSetCameraPos(revive_position.x, revive_position.y)

  GamePrintImportant("$holy_mountain_end_point_revived", "$holy_mountain_end_point_revived_description")
  GlobalsSetValue(GLOBALS.KEYS.ENCODED_POSITION, "")

  -- Delete Area Damage
  while EntityGetWithName("workshop_altar") ~= 0 do
    EntityKill(EntityGetWithName("workshop_altar"))
  end

  -- 無敵時間(5f * 132 = 600f = 11s)
  EntityAddComponent2(revive_target_entity_id, "LuaComponent", {
    script_source_file = "mods/holy_mountain_revive_point/files/scripts/player/invincible_action.lua",
    call_init_function = true,
    execute_every_n_frame = 5,
    execute_times = 132,
  })

  -- Effects
  GamePlaySound("data/audio/Desktop/misc.bank", "misc/teleport_use", revive_position.x, revive_position.y)
  GameScreenshake(130)
  EntityLoad("mods/holy_mountain_revive_point/files/entities/revival_point_effect.xml", revive_position.x, revive_position.y)
  revival_icon.remove_ui_icon(revive_target_entity_id)
end

local function revive(revive_target_entity_id)
  for _, damage_model in ipairs(EntityGetComponent(revive_target_entity_id, "DamageModelComponent") or {}) do
    -- プレイヤー無敵化
    ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", true)

    local json = GlobalsGetValue(GLOBALS.KEYS.ENCODED_POSITION, "")
    if json == "" then
      -- 蘇生ポイントが上手くロードできなかった場合は無敵を解除する
      -- 諦めて死んでくれ
      ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
      return
    end

    GlobalsSetValue(GLOBALS.KEYS.HAS_BEEN_POLY_REVIVE, "1")

    local revive_position = Json.decode(string.gsub(json, "'", '"'))
    revived(revive_target_entity_id, revive_position)
  end
end

return {
  revive = revive,
}
