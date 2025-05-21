extends Node

var drafts = {}

func generate_initial_drafts(sorted_teams):
	var years = [2024, 2025, 2026]
	var total_rounds = 7
	var picks_per_round = 32
	
	for year in years:
		var draft_order = {}
		for round in range(1, total_rounds + 1):
			for index in range(len(sorted_teams)):
				var pick_number = 1 + (round - 1) * picks_per_round + index
				draft_order[pick_number] = {
					"original_team": sorted_teams[index],
					"current_team": sorted_teams[index],
					"round": round,
					"pick_id": str(randi() % 100000000).pad_zeros(8),
					"Trade Value": 0
				}
		drafts[year] = draft_order

func update_draft_order(sorted_teams):
	var total_rounds = 7
	var picks_per_round = 32
	for year in drafts.keys():
		var updated_draft_order = {}
		var current_draft_order = drafts[year]
		
		for round in range(1, total_rounds + 1):
			for index in range(len(sorted_teams)):
				var pick_number = 1 + (round - 1) * picks_per_round + index
				var original_pick_number = find_original_pick_number(current_draft_order, sorted_teams[index], round)
				if original_pick_number != -1:
					updated_draft_order[pick_number] = {
						"original_team": current_draft_order[original_pick_number]["original_team"],
						"current_team": current_draft_order[original_pick_number]["current_team"],
						"round": round,
						"pick_id": current_draft_order[original_pick_number]["pick_id"]
					}
				else:
					continue
		drafts[year] = updated_draft_order

func find_original_pick_number(draft_order, team_name, round):
	for pick_number in draft_order.keys():
		if draft_order[pick_number]["round"] == round and draft_order[pick_number]["original_team"] == team_name:
			return pick_number
	return -1
