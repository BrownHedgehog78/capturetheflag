local rankings = ctf_rankings.init()
local recent_rankings = ctf_modebase.feature_presets.recent_rankings(rankings)
local bounties = ctf_modebase.feature_presets.bounties(recent_rankings)
local teams = ctf_modebase.feature_presets.teams(rankings, recent_rankings)

local crafts = ctf_core.include_files(
	"crafts.lua"
)

local old_bounty_reward_func = ctf_modebase.bounties.bounty_reward_func
local old_get_next_bounty = ctf_modebase.bounties.get_next_bounty
ctf_modebase.register_mode("classic", {
	treasures = {
		["default:ladder_wood"] = {                max_count = 20, rarity = 0.3, max_stacks = 5},
		["default:torch" ] = {                max_count = 20, rarity = 0.3, max_stacks = 5},
		["default:cobble"] = {min_count = 45, max_count = 99, rarity = 0.4, max_stacks = 5},
		["default:wood"  ] = {min_count = 10, max_count = 60, rarity = 0.5, max_stacks = 4},

		["ctf_teams:door_steel"] = {rarity = 0.2, max_stacks = 3},

		["default:pick_steel"  ] = {rarity = 0.4, max_stacks = 3},
		["default:shovel_steel"] = {rarity = 0.4, max_stacks = 2},
		["default:axe_steel"   ] = {rarity = 0.4, max_stacks = 2},

		["ctf_melee:sword_steel"  ] = {rarity = 0.2  , max_stacks = 2},
		["ctf_melee:sword_mese"   ] = {rarity = 0.01 , max_stacks = 1},
		["ctf_melee:sword_diamond"] = {rarity = 0.001, max_stacks = 1},

		["ctf_ranged:pistol_loaded" ] = {rarity = 0.2 , max_stacks = 2},
		["ctf_ranged:rifle_loaded"  ] = {rarity = 0.2                 },
		["ctf_ranged:shotgun_loaded"] = {rarity = 0.05                },
		["ctf_ranged:smg_loaded"    ] = {rarity = 0.05                },

		["ctf_ranged:ammo"     ] = {min_count = 3, max_count = 10, rarity = 0.3 , max_stacks = 2},
		["default:apple"       ] = {min_count = 5, max_count = 20, rarity = 0.1 , max_stacks = 2},
		["ctf_healing:bandage" ] = {                               rarity = 0.2 , max_stacks = 1},

		["grenades:frag" ] = {rarity = 0.1, max_stacks = 1},
		["grenades:smoke"] = {rarity = 0.2, max_stacks = 2},
	},
	crafts = crafts,
	physics = {sneak_glitch = true, new_move = false},
	rankings = rankings,
	recent_rankings = recent_rankings,
	summary_ranks = {
		_sort = "score",
		"score",
		"flag_captures", "flag_attempts",
		"kills", "kill_assists", "bounty_kills",
		"deaths",
		"hp_healed"
	},

	on_mode_start = function()
		ctf_modebase.bounties.bounty_reward_func = bounties.bounty_reward_func
		ctf_modebase.bounties.get_next_bounty = bounties.get_next_bounty
	end,
	on_mode_end = function()
		ctf_modebase.bounties.bounty_reward_func = old_bounty_reward_func
		ctf_modebase.bounties.get_next_bounty = old_get_next_bounty
	end,
	on_new_match = function()
		teams.on_new_match()

		ctf_modebase.build_timer.start()

		give_initial_stuff.register_stuff_provider(function()
			return {"default:sword_stone", "default:pick_stone", "default:torch 15", "default:stick 5"}
		end)
	end,
	on_match_end = teams.on_match_end,
	team_allocator = teams.team_allocator,
	on_allocplayer = function(player, teamname)
		local tcolor = ctf_teams.team[teamname].color

		player:set_properties({
			textures = {ctf_cosmetics.get_colored_skin(player, tcolor)}
		})

		teams.on_allocplayer(player, teamname)
	end,
	on_leaveplayer = teams.on_leaveplayer,
	on_dieplayer = teams.on_dieplayer,
	on_respawnplayer = teams.on_respawnplayer,
	can_take_flag = teams.can_take_flag,
	on_flag_take = teams.on_flag_take,
	on_flag_drop = teams.on_flag_drop,
	on_flag_capture = teams.on_flag_capture,
	on_flag_rightclick = function() end,
	get_chest_access = teams.get_chest_access,
	on_punchplayer = teams.on_punchplayer,
	on_healplayer = teams.on_healplayer,
	calculate_knockback = function()
		return 0
	end,
})
