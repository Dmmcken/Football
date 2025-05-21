extends Node2D

var scouts = Coaches.fa_scout
var scout1 = []
var scout2 = []
var scout3 = []
var selected_team = GameData.selected_team_name

func _ready():
	remove_scout()
	assign_scouts()
	populate_labels()
	populate_cards()
	

func remove_scout():
	var current_scouts = Coaches.team_scouts
	for scout in current_scouts:
		if scout["Team"] == selected_team:
			scout["Team"] = "Free Agent"
			Coaches.fa_scout.append(scout)
			Coaches.team_scouts.erase(scout)

func assign_scouts():
	var eligible_scouts = []
	for scout in scouts:
		if scout["Rank"] == "Copper" or scout["Rank"] == "Bronze":
			eligible_scouts.append(scout)
	var scout1_index = randi() % eligible_scouts.size()
	scout1 = eligible_scouts[scout1_index]
	eligible_scouts.erase(scout1_index)
	var scout2_index = randi() % eligible_scouts.size()
	scout2 = eligible_scouts[scout2_index]
	eligible_scouts.erase(scout2_index)
	var scout3_index = randi() % eligible_scouts.size()
	scout3 = eligible_scouts[scout3_index]
	eligible_scouts.erase(scout3_index)

func populate_labels():
	var scout1_name = $Scout1Name
	var scout1_rank = $Scout1Rank
	var scout1_boost = $Scout1Boost
	var scout1_focus = $Scout1Focus
	var scout1_slots = $Scout1Slots
	scout1_name.text = "%s %s" % [scout1["FirstName"], scout1["LastName"]]
	scout1_rank.text = "Rank: %s" % scout1["Rank"]
	scout1_boost.text = "Boost 1: %s Boost 2: %s Boost 3: %s" % [scout1["Boost1"], scout1["Boost2"], scout1["Boost3"]]
	scout1_focus.text = "Focus: %s" % [scout1["Focus"]]
	scout1_slots.text = "Scouting Slots: %d" % [scout1["Slots"]]
	var scout2_name = $Scout2Name
	var scout2_rank = $Scout2Rank
	var scout2_boost = $Scout2Boost
	var scout2_focus = $Scout2Focus
	var scout2_slots = $Scout2Slots
	scout2_name.text = "%s %s" % [scout2["FirstName"], scout2["LastName"]]
	scout2_rank.text = "Rank: %s" % scout2["Rank"]
	scout2_boost.text = "Boost 1: %s Boost 2: %s Boost 3: %s" % [scout2["Boost1"], scout2["Boost2"], scout2["Boost3"]]
	scout2_focus.text = "Focus: %s" % [scout2["Focus"]]
	scout2_slots.text = "Scouting Slots: %d" % [scout2["Slots"]]
	var scout3_name = $Scout3Name
	var scout3_rank = $Scout3Rank
	var scout3_boost = $Scout3Boost
	var scout3_focus = $Scout3Focus
	var scout3_slots = $Scout3Slots
	scout3_name.text = "%s %s" % [scout3["FirstName"], scout3["LastName"]]
	scout3_rank.text = "Rank: %s" % scout3["Rank"]
	scout3_boost.text = "Boost 1: %s Boost 2: %s Boost 3: %s" % [scout3["Boost1"], scout3["Boost2"], scout3["Boost3"]]
	scout3_focus.text = "Focus: %s" % [scout3["Focus"]]
	scout3_slots.text = "Scouting Slots: %d" % [scout3["Slots"]]

func populate_cards():
	match scout1["Rank"]:
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
	match scout2["Rank"]:
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
	match scout3["Rank"]:
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

func _on_scout_1_button_pressed():
	scout1["Team"] = selected_team
	Coaches.team_scouts.append(scout1)
	Coaches.fa_scout.erase(scout1)
	proceed_to_seasonhome()

func _on_scout_2_button_pressed():
	scout2["Team"] = selected_team
	Coaches.team_scouts.append(scout2)
	Coaches.fa_scout.erase(scout2)
	proceed_to_seasonhome()

func _on_scout_3_button_pressed():
	scout3["Team"] = selected_team
	Coaches.team_scouts.append(scout3)
	Coaches.fa_scout.erase(scout3)
	proceed_to_seasonhome()

func proceed_to_seasonhome():
	self.queue_free()
	var game_ui_scene = load("res://SeasonHome.tscn")
	var ui_scene_instance = game_ui_scene.instantiate()
	get_tree().root.add_child(ui_scene_instance)
	get_tree().current_scene = ui_scene_instance
