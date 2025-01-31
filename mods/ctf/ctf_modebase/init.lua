ctf_modebase = {
	-- Amount of maps that need to be played before a mode vote starts
	MAPS_PER_MODE        = 5,     ---@type integer

	-- Table containing all registered modes and their definitions
	modes                = {},    ---@type table

	-- Same as ctf_modebase.modes but in list form
	modelist             = {},    ---@type list

	-- Name of the mode currently being played. On server start this will be false
	current_mode         = false, ---@type string

	-- Players can hit, heal, etc
	match_started         = false, ---@type boolean

	-- Get the mode def of the current mode. On server start this will return false
	get_current_mode = function(self)
		return self.current_mode and self.modes[self.current_mode]
	end,

	-- Amount of matches played since this mode won the last vote
	current_mode_matches = 0,     ---@type integer

	-- taken_flags[Player Name] = list of team names
	taken_flags          = {},

	-- team_flag_takers[Team name][Player Name] = list of team names
	team_flag_takers     = {},

	-- flag_taken[Team Name] = Name of thief
	flag_taken           = {},

	--flag_captured[Team name] = true if captured, otherwise nil
	flag_captured        = {},

	-- mode feature presets
	feature_presets     = {},
}

ctf_gui.init()

ctf_core.include_files(
	"register.lua",
	"mode_functions.lua",
	"map_catalog.lua",
	"ranking_commands.lua",
	"summary.lua",
	"give_initial_stuff.lua",
	"treasure.lua",
	"flags/nodes.lua",
	"flags/taking.lua",
	"flags/huds.lua",
	"match.lua",
	"crafting.lua",
	"hpregen.lua",
	"respawn_delay.lua",
	"markers.lua",
	"bounties.lua",
	"build_timer.lua",
	"update_wear.lua",
	"mode_vote.lua",
	"skip_vote.lua"
)

ctf_modebase.feature_presets.recent_rankings = ctf_core.include_files("feature_presets/recent_rankings.lua")
ctf_modebase.feature_presets.bounties = ctf_core.include_files("feature_presets/bounties.lua")
ctf_modebase.feature_presets.teams = ctf_core.include_files("feature_presets/teams.lua")

if ctf_core.settings.server_mode == "play" then
	ctf_modebase.start_new_match()
end
