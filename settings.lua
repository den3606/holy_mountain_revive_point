dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

local mod_id = "holy_mountain_revive_point" -- This should match the name of your mod's folder.
mod_settings_version = 2 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
	{
		id = "REVIVAL_ALTAR_COST",
		ui_name = "COST",
		ui_description = "Increase of cost When you used revival_altar",
		value_default = 100,
		value_min = 0,
		value_max = 400,
    value_display_multiplier = 1,
		value_display_formatting = "+ $0 cost / used",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
  {
    id = "REVIVAL_ALTAR_COST_TYPE",
    ui_name = "COST_TYPE",
    ui_description = "You can change the type of cost increase\nAddition: 100 -> 200 -> 300 -> 400...\nExponetiation(like perk_reroller): 100 -> 200 -> 400 -> 800...",
    value_default = "addition",
    values = { {"addition","Addition"}, {"exponentiation","Exponentiation"}},
    scope = MOD_SETTING_SCOPE_NEW_GAME,
  },
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )

end
