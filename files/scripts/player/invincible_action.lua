dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")

local executed_count = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") + 1
local player_entity_id = getPlayerEntity()

function init(entity)
  -- 点滅用alphaリセット
  ComponentSetValue2(entity, "alpha", 1)
  -- 無敵ON
  for _, damage_model in ipairs(EntityGetComponent(player_entity_id, "DamageModelComponent") or {}) do
    ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", true)
  end
end

local function flash_effect()
  local player_sprite_component_id = EntityGetFirstComponent(player_entity_id, "SpriteComponent", "character")
  local alpha = ComponentGetValue2(player_sprite_component_id, "alpha")
  ComponentSetValue2(player_sprite_component_id, "alpha", 1 - alpha)
end

local function invincible(executed_count)

  for _, damage_model in ipairs(EntityGetComponent(player_entity_id, "DamageModelComponent") or {}) do

    if executed_count == 24 then
      -- 無敵OFF
      ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
    end

    local max_hp = ComponentGetValue2(damage_model, "max_hp")
    ComponentSetValue2(damage_model, "hp", max_hp)
  end
end

invincible(executed_count)

flash_effect()
