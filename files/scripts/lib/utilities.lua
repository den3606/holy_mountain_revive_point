function getPlayerEntity()
  local players = EntityGetWithTag("player_unit")
  if #players == 0 then
    return
  end

  return players[1]
end

function findPolymorphedPlayers()
  local nearby_polymorph = EntityGetWithTag("polymorphed") or {};
  local polymorphed_players = {};
  for _, entity in pairs(nearby_polymorph) do
    local game_stats = EntityGetFirstComponent(entity, "GameStatsComponent");
    if game_stats ~= nil then
      if ComponentGetValue2(game_stats, "is_player") == true then
        table.insert(polymorphed_players, entity);
      end
    end
  end
  return polymorphed_players;
end
