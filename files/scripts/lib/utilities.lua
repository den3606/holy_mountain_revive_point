function get_player_entity()
  local players = EntityGetWithTag("player_unit")
  if #players == 0 then
    return
  end

  return players[1]
end
