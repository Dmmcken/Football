extends Node2D

var dcs = Coaches.fa_dc
var dc1 = []
var dc2 = []
var dc3 = []
var selected_team = GameData.selected_team_name

func _ready():
	remove_dc()
	assign_dcs()
	populate_labels()
	populate_cards()
	

func remove_dc():
	var current_dcs = Coaches.team_dcs
	for dc in current_dcs:
		if dc["Team"] == selected_team:
			dc["Team"] = "Free Agent"
			Coaches.fa_dc.append(dc)
			Coaches.team_dcs.erase(dc)

func assign_dcs():
	var eligible_dcs = []
	for dc in dcs:
		if dc["Rank"] == "Copper" or dc["Rank"] == "Bronze":
			eligible_dcs.append(dc)
	var dc1_index = randi() % eligible_dcs.size()
	dc1 = eligible_dcs[dc1_index]
	eligible_dcs.erase(dc1_index)
	var dc2_index = randi() % eligible_dcs.size()
	dc2 = eligible_dcs[dc2_index]
	eligible_dcs.erase(dc2_index)
	var dc3_index = randi() % eligible_dcs.size()
	dc3 = eligible_dcs[dc3_index]
	eligible_dcs.erase(dc3_index)

func populate_labels():
	var dc1_name = $DC1Name
	var dc1_rank = $DC1Rank
	var dc1_boost = $DC1Boost
	var dc1_focus = $DC1Focus
	var dc1_trait = $DC1Trait
	var dc1_trait_desc = $DC1TraitDesc
	dc1_name.text = "%s %s" % [dc1["FirstName"], dc1["LastName"]]
	dc1_rank.text = "Rank: %s" % dc1["Rank"]
	dc1_boost.text = "Boost 1: %s Boost 2: %s" % [dc1["Boost1"], dc1["Boost2"]]
	dc1_focus.text = "Focus: %s" % [dc1["Focus"]]
	dc1_trait.text = "Trait: %s" % [dc1["Trait"]]
	if dc1["Trait"] == "Players Coach":
		dc1_trait_desc.text = "Defensive players will sign team friendlier contracts."
	elif dc1["Trait"] == "Practice Makes Perfect":
		dc1_trait_desc.text = "Defensive player's ratings will increase faster during the season"
	elif dc1["Trait"] == "Safety First":
		dc1_trait_desc.text = "Defensive players are less likely to get injured"
	elif dc1["Trait"] == "Youthful Spirit":
		dc1_trait_desc.text = "Older defensive players will lose rating slower and be less likely to retire"
	elif dc1["Trait"] == "Clutch":
		dc1_trait_desc.text = "Defensive players receive a rating boost during the playoffs"
	elif dc1["Trait"] == "Rivalry":
		dc1_trait_desc.text = "Defensive players receive a rating boost against divisional rivals"
	elif dc1["Trait"] == "Closer":
		dc1_trait_desc.text = "Defensive players receive a rating boost when the team is leading by two or more scores"
	var dc2_name = $DC2Name
	var dc2_rank = $DC2Rank
	var dc2_boost = $DC2Boost
	var dc2_focus = $DC2Focus
	var dc2_trait = $DC2Trait
	var dc2_trait_desc = $DC2TraitDesc
	dc2_name.text = "%s %s" % [dc2["FirstName"], dc2["LastName"]]
	dc2_rank.text = "Rank: %s" % dc2["Rank"]
	dc2_boost.text = "Boost 1: %s Boost 2: %s" % [dc2["Boost1"], dc2["Boost2"]]
	dc2_focus.text = "Focus: %s" % [dc2["Focus"]]
	dc2_trait.text = "Trait: %s" % [dc2["Trait"]]
	if dc2["Trait"] == "Players Coach":
		dc2_trait_desc.text = "Defensive players will sign team friendlier contracts."
	elif dc2["Trait"] == "Practice Makes Perfect":
		dc2_trait_desc.text = "Defensive player's ratings will increase faster during the season"
	elif dc2["Trait"] == "Safety First":
		dc2_trait_desc.text = "Defensive players are less likely to get injured"
	elif dc2["Trait"] == "Youthful Spirit":
		dc2_trait_desc.text = "Older defensive players will lose rating slower and be less likely to retire"
	elif dc2["Trait"] == "Clutch":
		dc2_trait_desc.text = "Defensive players receive a rating boost during the playoffs"
	elif dc2["Trait"] == "Rivalry":
		dc2_trait_desc.text = "Defensive players receive a rating boost against divisional rivals"
	elif dc2["Trait"] == "Closer":
		dc2_trait_desc.text = "Defensive players receive a rating boost when the team is leading by two or more scores"
	var dc3_name = $DC3Name
	var dc3_rank = $DC3Rank
	var dc3_boost = $DC3Boost
	var dc3_focus = $DC3Focus
	var dc3_trait = $DC3Trait
	var dc3_trait_desc = $DC3TraitDesc
	dc3_name.text = "%s %s" % [dc3["FirstName"], dc3["LastName"]]
	dc3_rank.text = "Rank: %s" % dc3["Rank"]
	dc3_boost.text = "Boost 1: %s Boost 2: %s" % [dc3["Boost1"], dc3["Boost2"]]
	dc3_focus.text = "Focus: %s" % [dc3["Focus"]]
	dc3_trait.text = "Trait: %s" % [dc3["Trait"]]
	if dc3["Trait"] == "Players Coach":
		dc3_trait_desc.text = "Defensive players will sign team friendlier contracts."
	elif dc3["Trait"] == "Practice Makes Perfect":
		dc3_trait_desc.text = "Defensive player's ratings will increase faster during the season"
	elif dc3["Trait"] == "Safety First":
		dc3_trait_desc.text = "Defensive players are less likely to get injured"
	elif dc3["Trait"] == "Youthful Spirit":
		dc3_trait_desc.text = "Older defensive players will lose rating slower and be less likely to retire"
	elif dc3["Trait"] == "Clutch":
		dc3_trait_desc.text = "Defensive players receive a rating boost during the playoffs"
	elif dc3["Trait"] == "Rivalry":
		dc3_trait_desc.text = "Defensive players receive a rating boost against divisional rivals"
	elif dc3["Trait"] == "Closer":
		dc3_trait_desc.text = "Defensive players receive a rating boost when the team is leading by two or more scores"

func populate_cards():
	match dc1["Rank"]:
		"Copper":
			$CopperOC1.visible = true
		"Bronze":
			$BronzeOC1.visible = true
		"Silver":
			$SilverOC1.visible = true
		"Gold":
			$GoldOC1.visible = true
		"Platinum":
			$Platinum.visible = true
		"Diamond":
			$DiamondOC1.visible = true
	match dc2["Rank"]:
		"Copper":
			$CopperOC2.visible = true
		"Bronze":
			$BronzeOC2.visible = true
		"Silver":
			$SilverOC2.visible = true
		"Gold":
			$GoldOC2.visible = true
		"Platinum":
			$Platinum.visible = true
		"Diamond":
			$DiamondOC2.visible = true
	match dc3["Rank"]:
		"Copper":
			$CopperOC3.visible = true
		"Bronze":
			$BronzeOC3.visible = true
		"Silver":
			$SilverOC3.visible = true
		"Gold":
			$GoldOC3.visible = true
		"Platinum":
			$Platinum.visible = true
		"Diamond":
			$DiamondOC3.visible = true

func _on_dc_1_button_pressed():
	dc1["Team"] = selected_team
	Coaches.team_dcs.append(dc1)
	Coaches.fa_dc.erase(dc1)
	proceed_to_seasonhome()

func _on_dc_2_button_pressed():
	dc2["Team"] = selected_team
	Coaches.team_dcs.append(dc2)
	Coaches.fa_dc.erase(dc2)
	proceed_to_seasonhome()

func _on_dc_3_button_pressed():
	dc3["Team"] = selected_team
	Coaches.team_dcs.append(dc3)
	Coaches.fa_dc.erase(dc3)
	proceed_to_seasonhome()

func proceed_to_seasonhome():
	self.queue_free()
	var game_ui_scene = load("res://Scouts.tscn")
	var ui_scene_instance = game_ui_scene.instantiate()
	get_tree().root.add_child(ui_scene_instance)
	get_tree().current_scene = ui_scene_instance
