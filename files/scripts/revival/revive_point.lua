dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")
local player_entity = get_player_entity()
local revive_point_entity = GetUpdatedEntityID()

local is_revived = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_REVIVED", "0")) == 1
local is_saved = tonumber(GlobalsGetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_SAVED", "0")) == 1

print(tostring(is_revived), tostring(is_saved))

if is_revived and is_saved then
  -- 蘇生ポイントにカメラとplayerを移動
  local pos_x, pos_y = EntityGetTransform(revive_point_entity)
  EntityApplyTransform(player_entity, pos_x, pos_y)
  GameSetCameraPos(pos_x, pos_y)

  for _, damage_model in ipairs(EntityGetComponent(player_entity, "DamageModelComponent") or {}) do
    -- HPをフルヘルスにする
    local max_hp = ComponentGetValue2(damage_model, "max_hp")
    ComponentSetValue2(damage_model, "hp", max_hp)

    -- 蘇生をリセット
    GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_REVIVED", "0")
    GlobalsSetValue("HOLY_MOUNTAIN_REVIVE_POINT__IS_SAVED", "0")

    -- 無敵解除
    ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
  end

  -- 蘇生チェックポイントを削除
  EntityKill(revive_point_entity)
end
