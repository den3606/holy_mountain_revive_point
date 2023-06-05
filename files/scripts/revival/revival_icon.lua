local function add(target_entity_id)
  local children = EntityGetAllChildren(target_entity_id)
  for _, child in ipairs(children or {}) do
    if (EntityGetName(child) == "holy_mountain_revive_point_ui_icon") then
      return
    end
  end

  local icon_entity = EntityCreateNew("holy_mountain_revive_point_ui_icon")
  EntityAddComponent(icon_entity, "UIIconComponent", {
    name = "$status_holy_mountain_revive_point",
    description = "$statusdesc_holy_mountain_revive_point",
    icon_sprite_file = "mods/holy_mountain_revive_point/files/ui_gfx/holy_mountain_revive_point.png",
  })
  EntityAddChild(target_entity_id, icon_entity)
end

local function remove(target_entity_id)
  local children = EntityGetAllChildren(target_entity_id)
  for _, child in ipairs(children or {}) do
    if (EntityGetName(child) == "holy_mountain_revive_point_ui_icon") then
      EntityKill(child)
      return
    end
  end
end

return {
  add_ui_icon = add,
  remove_ui_icon = remove,
}
