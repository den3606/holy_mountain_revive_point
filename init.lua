dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")
dofile_once("mods/holy_mountain_revive_point/files/scripts/player/revive_action.lua")

print("===========")
print("REVIVE POIT mod init")
print("===========")

ModLuaFileAppend("data/scripts/biomes/temple_altar_left.lua", "mods/holy_mountain_revive_point/files/scripts/biomes/temple_altar_left.lua")

local is_dead_poly_player = false

function OnPlayerSpawned(player_id)
  EntityAddComponent2(player_id, "LuaComponent", {
    script_damage_received = "mods/holy_mountain_revive_point/files/scripts/player/damage_received.lua",
  })
end

function OnWorldPreUpdate()
  local player_id = getPlayerEntity()
  -- polymorphの処理
  if player_id == nil then
    for _, player_id in ipairs(findPolymorphedPlayers()) do
      if EntityGetFirstComponent(player_id, "AnimalAIComponent") == nil and EntityGetFirstComponent(player_id, "PhysicsAIComponent") == nil and EntityGetFirstComponent(player_id, "WormAIComponent") ==
        nil and EntityGetFirstComponent(player_id, "AdvancedFishAIComponent") == nil then

        local damage_model_components = EntityGetComponent(player_id, "DamageModelComponent")
        if damage_model_components == nil or #damage_model_components == 0 then
          print("Error Missing DamageModelComponent")
        else
          for _, damage_model_component in ipairs(damage_model_components) do
            local is_saved = tonumber(GlobalsGetValue("holy_mountain_revive_point.is_saved", "0")) == 1
            if is_saved then
              ComponentSetValue(damage_model_component, "wait_for_kill_flag_on_death", "1")
              if tonumber(ComponentGetValue(damage_model_component, "hp")) < 0.04 then
                -- polymorphで死んだとき
                is_dead_poly_player = true
                GamePrintImportant("You have become a wandering sheep", "Wait for God's help", "mods/holy_mountain_revive_point/files/ui_gfx/decorations/3piece_sheep_msg.png")
                ComponentSetValue(damage_model_component, "hp", ComponentGetValue(damage_model_component, "max_hp"))
              end
            end
          end
        end
      end
    end
  else
    if is_dead_poly_player then
      reviveAction(player_id)
      is_dead_poly_player = false
    end
  end
end


print("===========")
print("REVIVE POIT mod init done")
print("===========")
