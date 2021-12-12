dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")
local player_entity = get_player_entity()
local revive_point_entity = GetUpdatedEntityID()

local is_revived = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_REVIVED", "0")) == 1
local is_saved = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_SAVED", "0")) == 1

if is_revived and is_saved then
  -- 蘇生ポイントにカメラとplayerを移動
  local pos_x, pos_y = EntityGetTransform(revive_point_entity)
  EntityApplyTransform(player_entity, pos_x, pos_y)
  GameSetCameraPos(pos_x, pos_y)

  for _, damage_model in ipairs(EntityGetComponent(player_entity, "DamageModelComponent") or {}) do
    -- 蘇生をリセット
    GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_REVIVED", "0")
    GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_SAVED", "0")
  end

  EntityAddComponent2(player_entity, "LuaComponent", {
    execute_every_n_frame = 30,
    remove_after_executed = true,
    script_source_file = "mods/holy_mountain_revive_point/files/scripts/player/healing.lua",
  })
end
