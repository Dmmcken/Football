extends Node2D

var player_level = 1

var ocs = Coaches.fa_oc
var oc1 = []
var oc2 = []
var oc3 = []
var selected_team = GameData.selected_team_name

var dcs = Coaches.fa_dc
var dc1 = []
var dc2 = []
var dc3 = []

var scouts = Coaches.fa_scout
var scout1 = []
var scout2 = []
var scout3 = []

func _ready():
	assign_ocs()
	assign_dcs()
	assign_scouts()

func assign_ocs():
	var eligible_ocs_1 = []
	var eligible_ocs_2 = []
	var eligible_ocs_3 = []
	var slot_1_rank = ""
	var slot_2_rank = ""
	var slot_3_rank = ""
	var rng_1 = get_rng()
	var rng_2 = get_rng()
	var rng_3 = get_rng()
	
	if rng_1 <= .4:
		slot_1_rank = "Copper"
	elif rng_1 <= .57:
		slot_1_rank = "Bronze"
	elif rng_1 <= .7:
		slot_1_rank = "Silver"
	elif rng_1 <= .85:
		slot_1_rank = "Gold"
	elif rng_1 <= .95:
		slot_1_rank = "Platinum"
	else:
		slot_1_rank = "Diamond"
	
	if rng_2 <= .4:
		slot_2_rank = "Copper"
	elif rng_2 <= .57:
		slot_2_rank = "Bronze"
	elif rng_2 <= .7:
		slot_2_rank = "Silver"
	elif rng_2 <= .85:
		slot_2_rank = "Gold"
	elif rng_2 <= .95:
		slot_2_rank = "Platinum"
	else:
		slot_2_rank = "Diamond"
	
	if rng_3 <= .4:
		slot_3_rank = "Copper"
	elif rng_3 <= .57:
		slot_3_rank = "Bronze"
	elif rng_3 <= .7:
		slot_3_rank = "Silver"
	elif rng_3 <= .85:
		slot_3_rank = "Gold"
	elif rng_3 <= .95:
		slot_3_rank = "Platinum"
	else:
		slot_3_rank = "Diamond"
		
	for oc in ocs:
		if oc["Rank"] == slot_1_rank:
			eligible_ocs_1.append(oc)
	var oc1_index = randi() % eligible_ocs_1.size()
	oc1 = eligible_ocs_1[oc1_index]
	eligible_ocs_1.erase(oc1_index)
	print(oc1)
	for oc in ocs:
		if oc["Rank"] == slot_2_rank:
			eligible_ocs_2.append(oc)
	var oc2_index = randi() % eligible_ocs_2.size()
	oc2 = eligible_ocs_2[oc2_index]
	eligible_ocs_2.erase(oc2_index)
	print(oc2)
	for oc in ocs:
		if oc["Rank"] == slot_3_rank:
			eligible_ocs_3.append(oc)
	var oc3_index = randi() % eligible_ocs_3.size()
	oc3 = eligible_ocs_3[oc3_index]
	eligible_ocs_3.erase(oc3_index)
	print(oc3)

func assign_dcs():
	var eligible_dcs_1 = []
	var eligible_dcs_2 = []
	var eligible_dcs_3 = []
	var slot_1_rank = ""
	var slot_2_rank = ""
	var slot_3_rank = ""
	var rng_1 = get_rng()
	var rng_2 = get_rng()
	var rng_3 = get_rng()
	
	if rng_1 <= .4:
		slot_1_rank = "Copper"
	elif rng_1 <= .57:
		slot_1_rank = "Bronze"
	elif rng_1 <= .7:
		slot_1_rank = "Silver"
	elif rng_1 <= .85:
		slot_1_rank = "Gold"
	elif rng_1 <= .95:
		slot_1_rank = "Platinum"
	else:
		slot_1_rank = "Diamond"
	
	if rng_2 <= .4:
		slot_2_rank = "Copper"
	elif rng_2 <= .57:
		slot_2_rank = "Bronze"
	elif rng_2 <= .7:
		slot_2_rank = "Silver"
	elif rng_2 <= .85:
		slot_2_rank = "Gold"
	elif rng_2 <= .95:
		slot_2_rank = "Platinum"
	else:
		slot_2_rank = "Diamond"
	
	if rng_3 <= .4:
		slot_3_rank = "Copper"
	elif rng_3 <= .57:
		slot_3_rank = "Bronze"
	elif rng_3 <= .7:
		slot_3_rank = "Silver"
	elif rng_3 <= .85:
		slot_3_rank = "Gold"
	elif rng_3 <= .95:
		slot_3_rank = "Platinum"
	else:
		slot_3_rank = "Diamond"
		
	for dc in dcs:
		if dc["Rank"] == slot_1_rank:
			eligible_dcs_1.append(dc)
	var dc1_index = randi() % eligible_dcs_1.size()
	dc1 = eligible_dcs_1[dc1_index]
	eligible_dcs_1.erase(dc1_index)
	print(dc1)
	for dc in dcs:
		if dc["Rank"] == slot_2_rank:
			eligible_dcs_2.append(dc)
	var dc2_index = randi() % eligible_dcs_2.size()
	dc2 = eligible_dcs_2[dc2_index]
	eligible_dcs_2.erase(dc2_index)
	print(dc2)
	for dc in dcs:
		if dc["Rank"] == slot_3_rank:
			eligible_dcs_3.append(dc)
	var dc3_index = randi() % eligible_dcs_3.size()
	dc3 = eligible_dcs_3[dc3_index]
	eligible_dcs_3.erase(dc3_index)
	print(dc3)

func assign_scouts():
	var eligible_scouts_1 = []
	var eligible_scouts_2 = []
	var eligible_scouts_3 = []
	var slot_1_rank = ""
	var slot_2_rank = ""
	var slot_3_rank = ""
	var rng_1 = get_rng()
	var rng_2 = get_rng()
	var rng_3 = get_rng()
	
	if rng_1 <= .4:
		slot_1_rank = "Copper"
	elif rng_1 <= .57:
		slot_1_rank = "Bronze"
	elif rng_1 <= .7:
		slot_1_rank = "Silver"
	elif rng_1 <= .85:
		slot_1_rank = "Gold"
	elif rng_1 <= .95:
		slot_1_rank = "Platinum"
	else:
		slot_1_rank = "Diamond"
	
	if rng_2 <= .4:
		slot_2_rank = "Copper"
	elif rng_2 <= .57:
		slot_2_rank = "Bronze"
	elif rng_2 <= .7:
		slot_2_rank = "Silver"
	elif rng_2 <= .85:
		slot_2_rank = "Gold"
	elif rng_2 <= .95:
		slot_2_rank = "Platinum"
	else:
		slot_2_rank = "Diamond"
	
	if rng_3 <= .4:
		slot_3_rank = "Copper"
	elif rng_3 <= .57:
		slot_3_rank = "Bronze"
	elif rng_3 <= .7:
		slot_3_rank = "Silver"
	elif rng_3 <= .85:
		slot_3_rank = "Gold"
	elif rng_3 <= .95:
		slot_3_rank = "Platinum"
	else:
		slot_3_rank = "Diamond"
		
	for scout in scouts:
		if scout["Rank"] == slot_1_rank:
			eligible_scouts_1.append(scout)
	var scout1_index = randi() % eligible_scouts_1.size()
	scout1 = eligible_scouts_1[scout1_index]
	eligible_scouts_1.erase(scout1_index)
	print(scout1)
	for scout in scouts:
		if scout["Rank"] == slot_2_rank:
			eligible_scouts_2.append(scout)
	var scout2_index = randi() % eligible_scouts_2.size()
	scout2 = eligible_scouts_2[scout2_index]
	eligible_scouts_2.erase(scout2_index)
	print(scout2)
	for scout in scouts:
		if scout["Rank"] == slot_3_rank:
			eligible_scouts_3.append(scout)
	var scout3_index = randi() % eligible_scouts_3.size()
	scout3 = eligible_scouts_3[scout3_index]
	eligible_scouts_3.erase(scout3_index)
	print(scout3)

func get_rng():
	var t = player_level / 50
	var added = randf() / 2
	var rng = t + added
	print(rng)
	return rng

func _on_oc_pressed():
	activate_oc_graphics()
	populate_oc_labels()
	populate_oc_cards()

func activate_oc_graphics():
	$OCPanel.visible = true
	$Panel.visible = false

func populate_oc_labels():
	var oc1_name = $OCPanel/OC1Name
	var oc1_rank = $OCPanel/OC1Rank
	var oc1_boost = $OCPanel/OC1Boost
	var oc1_focus = $OCPanel/OC1Focus
	var oc1_trait = $OCPanel/OC1Trait
	var oc1_trait_desc = $OCPanel/OC1TraitDesc
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
	var oc2_name = $OCPanel/OC2Name
	var oc2_rank = $OCPanel/OC2Rank
	var oc2_boost = $OCPanel/OC2Boost
	var oc2_focus = $OCPanel/OC2Focus
	var oc2_trait = $OCPanel/OC2Trait
	var oc2_trait_desc = $OCPanel/OC2TraitDesc
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
	var oc3_name = $OCPanel/OC3Name
	var oc3_rank = $OCPanel/OC3Rank
	var oc3_boost = $OCPanel/OC3Boost
	var oc3_focus = $OCPanel/OC3Focus
	var oc3_trait = $OCPanel/OC3Trait
	var oc3_trait_desc = $OCPanel/OC3TraitDesc
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

func populate_oc_cards():
	match oc1["Rank"]:
		"Copper":
			$OCPanel/CopperOC1.visible = true
		"Bronze":
			$OCPanel/BronzeOC1.visible = true
		"Silver":
			$OCPanel/SilverOC1.visible = true
		"Gold":
			$OCPanel/GoldOC1.visible = true
		"Platinum":
			$OCPanel/Platinum.visible = true
		"Diamond":
			$OCPanel/DiamondOC1.visible = true
	match oc2["Rank"]:
		"Copper":
			$OCPanel/CopperOC2.visible = true
		"Bronze":
			$OCPanel/BronzeOC2.visible = true
		"Silver":
			$OCPanel/SilverOC2.visible = true
		"Gold":
			$OCPanel/GoldOC2.visible = true
		"Platinum":
			$OCPanel/Platinum.visible = true
		"Diamond":
			$OCPanel/DiamondOC2.visible = true
	match oc3["Rank"]:
		"Copper":
			$OCPanel/CopperOC3.visible = true
		"Bronze":
			$OCPanel/BronzeOC3.visible = true
		"Silver":
			$OCPanel/SilverOC3.visible = true
		"Gold":
			$OCPanel/GoldOC3.visible = true
		"Platinum":
			$OCPanel/Platinum.visible = true
		"Diamond":
			$OCPanel/DiamondOC3.visible = true

func _on_dc_pressed():
	activate_dc_graphics()
	populate_dc_labels()
	populate_dc_cards()

func activate_dc_graphics():
	$DCPanel.visible = true
	$Panel.visible = false

func populate_dc_labels():
	var dc1_name = $DCPanel/DC1Name
	var dc1_rank = $DCPanel/DC1Rank
	var dc1_boost = $DCPanel/DC1Boost
	var dc1_focus = $DCPanel/DC1Focus
	var dc1_trait = $DCPanel/DC1Trait
	var dc1_trait_desc = $DCPanel/DC1TraitDesc
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
	var dc2_name = $DCPanel/DC2Name
	var dc2_rank = $DCPanel/DC2Rank
	var dc2_boost = $DCPanel/DC2Boost
	var dc2_focus = $DCPanel/DC2Focus
	var dc2_trait = $DCPanel/DC2Trait
	var dc2_trait_desc = $DCPanel/DC2TraitDesc
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
	var dc3_name = $DCPanel/DC3Name
	var dc3_rank = $DCPanel/DC3Rank
	var dc3_boost = $DCPanel/DC3Boost
	var dc3_focus = $DCPanel/DC3Focus
	var dc3_trait = $DCPanel/DC3Trait
	var dc3_trait_desc = $DCPanel/DC3TraitDesc
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

func populate_dc_cards():
	match dc1["Rank"]:
		"Copper":
			$DCPanel/CopperOC1.visible = true
		"Bronze":
			$DCPanel/BronzeOC1.visible = true
		"Silver":
			$DCPanel/SilverOC1.visible = true
		"Gold":
			$DCPanel/GoldOC1.visible = true
		"Platinum":
			$DCPanel/Platinum.visible = true
		"Diamond":
			$DCPanel/DiamondOC1.visible = true
	match dc2["Rank"]:
		"Copper":
			$DCPanel/CopperOC2.visible = true
		"Bronze":
			$DCPanel/BronzeOC2.visible = true
		"Silver":
			$DCPanel/SilverOC2.visible = true
		"Gold":
			$DCPanel/GoldOC2.visible = true
		"Platinum":
			$DCPanel/Platinum.visible = true
		"Diamond":
			$DCPanel/DiamondOC2.visible = true
	match dc3["Rank"]:
		"Copper":
			$DCPanel/CopperOC3.visible = true
		"Bronze":
			$DCPanel/BronzeOC3.visible = true
		"Silver":
			$DCPanel/SilverOC3.visible = true
		"Gold":
			$DCPanel/GoldOC3.visible = true
		"Platinum":
			$DCPanel/Platinum.visible = true
		"Diamond":
			$DCPanel/DiamondOC3.visible = true

func _on_scout_pressed():
	activate_scout_graphics()
	populate_scout_labels()
	populate_scout_cards()

func activate_scout_graphics():
	$ScoutPanel.visible = true
	$Panel.visible = false

func populate_scout_labels():
	var scout1_name = $ScoutPanel/Scout1Name
	var scout1_rank = $ScoutPanel/Scout1Rank
	var scout1_boost = $ScoutPanel/Scout1Boost
	var scout1_focus = $ScoutPanel/Scout1Focus
	var scout1_slots = $ScoutPanel/Scout1Slots
	scout1_name.text = "%s %s" % [scout1["FirstName"], scout1["LastName"]]
	scout1_rank.text = "Rank: %s" % scout1["Rank"]
	scout1_boost.text = "Boost 1: %s Boost 2: %s Boost 3: %s" % [scout1["Boost1"], scout1["Boost2"], scout1["Boost3"]]
	scout1_focus.text = "Focus: %s" % [scout1["Focus"]]
	scout1_slots.text = "Scouting Slots: %d" % [scout1["Slots"]]
	var scout2_name = $ScoutPanel/Scout2Name
	var scout2_rank = $ScoutPanel/Scout2Rank
	var scout2_boost = $ScoutPanel/Scout2Boost
	var scout2_focus = $ScoutPanel/Scout2Focus
	var scout2_slots = $ScoutPanel/Scout2Slots
	scout2_name.text = "%s %s" % [scout2["FirstName"], scout2["LastName"]]
	scout2_rank.text = "Rank: %s" % scout2["Rank"]
	scout2_boost.text = "Boost 1: %s Boost 2: %s Boost 3: %s" % [scout2["Boost1"], scout2["Boost2"], scout2["Boost3"]]
	scout2_focus.text = "Focus: %s" % [scout2["Focus"]]
	scout2_slots.text = "Scouting Slots: %d" % [scout2["Slots"]]
	var scout3_name = $ScoutPanel/Scout3Name
	var scout3_rank = $ScoutPanel/Scout3Rank
	var scout3_boost = $ScoutPanel/Scout3Boost
	var scout3_focus = $ScoutPanel/Scout3Focus
	var scout3_slots = $ScoutPanel/Scout3Slots
	scout3_name.text = "%s %s" % [scout3["FirstName"], scout3["LastName"]]
	scout3_rank.text = "Rank: %s" % scout3["Rank"]
	scout3_boost.text = "Boost 1: %s Boost 2: %s Boost 3: %s" % [scout3["Boost1"], scout3["Boost2"], scout3["Boost3"]]
	scout3_focus.text = "Focus: %s" % [scout3["Focus"]]
	scout3_slots.text = "Scouting Slots: %d" % [scout3["Slots"]]

func populate_scout_cards():
	match scout1["Rank"]:
		"Copper":
			$ScoutPanel/CopperOC1.visible = true
		"Bronze":
			$ScoutPanel/BronzeOC1.visible = true
		"Silver":
			$ScoutPanel/SilverOC1.visible = true
		"Gold":
			$ScoutPanel/GoldOC1.visible = true
		"Platinum":
			$ScoutPanel/Platinum.visible = true
		"Diamond":
			$ScoutPanel/DiamondOC1.visible = true
	match scout2["Rank"]:
		"Copper":
			$ScoutPanel/CopperOC2.visible = true
		"Bronze":
			$ScoutPanel/BronzeOC2.visible = true
		"Silver":
			$ScoutPanel/SilverOC2.visible = true
		"Gold":
			$ScoutPanel/GoldOC2.visible = true
		"Platinum":
			$ScoutPanel/Platinum.visible = true
		"Diamond":
			$ScoutPanel/DiamondOC2.visible = true
	match scout3["Rank"]:
		"Copper":
			$ScoutPanel/CopperOC3.visible = true
		"Bronze":
			$ScoutPanel/BronzeOC3.visible = true
		"Silver":
			$ScoutPanel/SilverOC3.visible = true
		"Gold":
			$ScoutPanel/GoldOC3.visible = true
		"Platinum":
			$ScoutPanel/Platinum.visible = true
		"Diamond":
			$ScoutPanel/DiamondOC3.visible = true
