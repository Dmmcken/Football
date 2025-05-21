extends Node2D

var ocs = Coaches.fa_oc
var oc1 = []
var oc2 = []
var oc3 = []
var selected_team = GameData.selected_team_name

func _ready():
	remove_oc()
	assign_ocs()
	populate_labels()
	populate_cards()
	

func remove_oc():
	var current_ocs = Coaches.team_ocs
	for oc in current_ocs:
		if oc["Team"] == selected_team:
			oc["Team"] = "Free Agent"
			Coaches.fa_oc.append(oc)
			Coaches.team_ocs.erase(oc)

func assign_ocs():
	var eligible_ocs = []
	for oc in ocs:
		if oc["Rank"] == "Copper" or oc["Rank"] == "Bronze":
			eligible_ocs.append(oc)
	var oc1_index = randi() % eligible_ocs.size()
	oc1 = eligible_ocs[oc1_index]
	eligible_ocs.erase(oc1_index)
	var oc2_index = randi() % eligible_ocs.size()
	oc2 = eligible_ocs[oc2_index]
	eligible_ocs.erase(oc2_index)
	var oc3_index = randi() % eligible_ocs.size()
	oc3 = eligible_ocs[oc3_index]
	eligible_ocs.erase(oc3_index)

func populate_labels():
	var oc1_name = $OC1Name
	var oc1_rank = $OC1Rank
	var oc1_boost = $OC1Boost
	var oc1_focus = $OC1Focus
	var oc1_trait = $OC1Trait
	var oc1_trait_desc = $OC1TraitDesc
	oc1_name.text = "%s %s" % [oc1["FirstName"], oc1["LastName"]]
	oc1_rank.text = "Rank: %s" % oc1["Rank"]
	oc1_boost.text = "Boost 1: %s Boost 2: %s" % [oc1["Boost1"], oc1["Boost2"]]
	oc1_focus.text = "Focus: %s" % [oc1["Focus"]]
	oc1_trait.text = "Trait: %s" % [oc1["Trait"]]
	if oc1["Trait"] == "Players Coach":
		oc1_trait_desc.text = "Offensive players will sign team friendlier contracts."
	elif oc1["Trait"] == "Practice Makes Perfect":
		oc1_trait_desc.text = "Offensive player's ratings will increase faster during the season"
	elif oc1["Trait"] == "Safety First":
		oc1_trait_desc.text = "Offensive players are less likely to get injured"
	elif oc1["Trait"] == "Youthful Spirit":
		oc1_trait_desc.text = "Older offensive players will lose rating slower and be less likely to retire"
	elif oc1["Trait"] == "Clutch":
		oc1_trait_desc.text = "Offensive players receive a rating boost during the playoffs"
	elif oc1["Trait"] == "Rivalry":
		oc1_trait_desc.text = "Offensive players receive a rating boost against divisional rivals"
	elif oc1["Trait"] == "Comeback Kid":
		oc1_trait_desc.text = "Offensive players receive a rating boost when the team is trailing by two or more scores"
	var oc2_name = $OC2Name
	var oc2_rank = $OC2Rank
	var oc2_boost = $OC2Boost
	var oc2_focus = $OC2Focus
	var oc2_trait = $OC2Trait
	var oc2_trait_desc = $OC2TraitDesc
	oc2_name.text = "%s %s" % [oc2["FirstName"], oc2["LastName"]]
	oc2_rank.text = "Rank: %s" % oc2["Rank"]
	oc2_boost.text = "Boost 1: %s Boost 2: %s" % [oc2["Boost1"], oc2["Boost2"]]
	oc2_focus.text = "Focus: %s" % [oc2["Focus"]]
	oc2_trait.text = "Trait: %s" % [oc2["Trait"]]
	if oc2["Trait"] == "Players Coach":
		oc2_trait_desc.text = "Offensive players will sign team friendlier contracts."
	elif oc2["Trait"] == "Practice Makes Perfect":
		oc2_trait_desc.text = "Offensive player's ratings will increase faster during the season"
	elif oc2["Trait"] == "Safety First":
		oc2_trait_desc.text = "Offensive players are less likely to get injured"
	elif oc2["Trait"] == "Youthful Spirit":
		oc2_trait_desc.text = "Older offensive players will lose rating slower and be less likely to retire"
	elif oc2["Trait"] == "Clutch":
		oc2_trait_desc.text = "Offensive players receive a rating boost during the playoffs"
	elif oc2["Trait"] == "Rivalry":
		oc2_trait_desc.text = "Offensive players receive a rating boost against divisional rivals"
	elif oc2["Trait"] == "Comeback Kid":
		oc2_trait_desc.text = "Offensive players receive a rating boost when the team is trailing by two or more scores"
	var oc3_name = $OC3Name
	var oc3_rank = $OC3Rank
	var oc3_boost = $OC3Boost
	var oc3_focus = $OC3Focus
	var oc3_trait = $OC3Trait
	var oc3_trait_desc = $OC3TraitDesc
	oc3_name.text = "%s %s" % [oc3["FirstName"], oc3["LastName"]]
	oc3_rank.text = "Rank: %s" % oc3["Rank"]
	oc3_boost.text = "Boost 1: %s Boost 2: %s" % [oc3["Boost1"], oc3["Boost2"]]
	oc3_focus.text = "Focus: %s" % [oc3["Focus"]]
	oc3_trait.text = "Trait: %s" % [oc3["Trait"]]
	if oc3["Trait"] == "Players Coach":
		oc3_trait_desc.text = "Offensive players will sign team friendlier contracts."
	elif oc3["Trait"] == "Practice Makes Perfect":
		oc3_trait_desc.text = "Offensive player's ratings will increase faster during the season"
	elif oc3["Trait"] == "Safety First":
		oc3_trait_desc.text = "Offensive players are less likely to get injured"
	elif oc3["Trait"] == "Youthful Spirit":
		oc3_trait_desc.text = "Older offensive players will lose rating slower and be less likely to retire"
	elif oc3["Trait"] == "Clutch":
		oc3_trait_desc.text = "Offensive players receive a rating boost during the playoffs"
	elif oc3["Trait"] == "Rivalry":
		oc3_trait_desc.text = "Offensive players receive a rating boost against divisional rivals"
	elif oc3["Trait"] == "Comeback Kid":
		oc3_trait_desc.text = "Offensive players receive a rating boost when the team is trailing by two or more scores"

func populate_cards():
	match oc1["Rank"]:
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
	match oc2["Rank"]:
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
	match oc3["Rank"]:
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

func _on_oc_1_button_pressed():
	oc1["Team"] = selected_team
	Coaches.team_ocs.append(oc1)
	Coaches.fa_oc.erase(oc1)
	proceed_to_dc()

func _on_oc_2_button_pressed():
	oc2["Team"] = selected_team
	Coaches.team_ocs.append(oc2)
	Coaches.fa_oc.erase(oc2)
	proceed_to_dc()

func _on_oc_3_button_pressed():
	oc3["Team"] = selected_team
	Coaches.team_ocs.append(oc3)
	Coaches.fa_oc.erase(oc3)
	proceed_to_dc()

func proceed_to_dc():
	self.queue_free()
	var game_ui_scene = load("res://DC.tscn")
	var ui_scene_instance = game_ui_scene.instantiate()
	get_tree().root.add_child(ui_scene_instance)
	get_tree().current_scene = ui_scene_instance
