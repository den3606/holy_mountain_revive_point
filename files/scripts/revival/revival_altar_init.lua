local function calc_cost()
  local revive_count = tonumber(GlobalsGetValue("holy_mountain_revive_point.revive_count", "0"))
  local revival_alter_cost = math.floor(ModSettingGet("holy_mountain_revive_point.REVIVAL_ALTAR_COST") + 0.5)
  local revival_type = ModSettingGet("holy_mountain_revive_point.REVIVAL_ALTAR_COST_TYPE")

  if revival_type == "addition" then
    return revival_alter_cost * (revive_count + 1)
  elseif revival_type == "exponentiation" then
    return revival_alter_cost * (2 ^ revive_count)
  end
end


local entity_id = GetUpdatedEntityID()
local itemcost_comp = EntityGetFirstComponent(entity_id, "ItemCostComponent")
local costsprite_comp = EntityGetComponent(entity_id, "SpriteComponent", "shop_cost")
local cost = calc_cost()

if (costsprite_comp ~= nil) then
  local comp = costsprite_comp[1]
  local offsetx = 6

  local text = tostring(cost)

  if (text ~= nil) then
    local textwidth = 0

    for i = 1, #text do
      local l = string.sub(text, i, i)

      if (l ~= "1") then
        textwidth = textwidth + 6
      else
        textwidth = textwidth + 3
      end
    end

    offsetx = textwidth * 0.5 - 0.5

    ComponentSetValue2(comp, "offset_x", offsetx)
  end
end

ComponentSetValue(itemcost_comp, "cost", tostring(cost))
