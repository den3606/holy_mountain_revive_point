RegisterSpawnFunction(0xff7345e1, "spawn_revival_altar")

function spawn_revival_altar(x, y)
  EntityLoad("mods/holy_mountain_revive_point/files/entities/revival_altar.xml", x, y)
end

-- Override init
local default_init = init
function init(x, y, w, h)
  default_init(x, y, w, h)
  LoadPixelScene("mods/holy_mountain_revive_point/files/biome_impl/temple/altar_left.png", "", x, y - 40 + 300, "", true)
end
