extends Node

var season_stats = {}

func update_season_stats(game_stats):
	for PlayerID in game_stats.keys():
		var stats = game_stats[PlayerID]
		if not season_stats.has(PlayerID):
			season_stats[PlayerID] = stats.duplicate()
		else:
			for key in stats.keys():
				season_stats[PlayerID][key] += stats[key]
