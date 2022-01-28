-- Override spawn_sampo_spot
local default_spawn_sampo_spot = spawn_sampo_spot
function spawn_sampo_spot(x, y)
  print("reset revive_point")
  GlobalsSetValue("holy_mountain_revive_point.is_saved", "0")
  default_spawn_sampo_spot(x, y)
end
