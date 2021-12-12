-- 画面移動までに時間がかかるため、ディレイをかけて回復させている
-- FIXME:setTimerチックな方法ではない形で完全に回復させる方法があれば、そっちに実装を変更したい
dofile_once("mods/holy_mountain_revive_point/files/scripts/lib/utilities.lua")

local player_entity =  GetUpdatedEntityID()

for _, damage_model in ipairs(EntityGetComponent(player_entity, "DamageModelComponent") or {}) do
  -- HPをフルヘルスにする
  local max_hp = ComponentGetValue2(damage_model, "max_hp")
  ComponentSetValue2(damage_model, "hp", max_hp)

  -- 無敵解除
  ComponentSetValue2(damage_model, "wait_for_kill_flag_on_death", false)
end
