extends Node2D

var selected_team = GameData.selected_team_name

var team_roster = Rosters.team_rosters[selected_team]

var selected_player = ""
var roster_array = []
var salary_request = 0
var years = 0

@onready var years_label = $Years
@onready var guaranteed_label = $GuaranteedYears
@onready var salary_label = $Salary
@onready var deal_label = $Deal

var contract_years = 0
var contract_guaranteed_years = 0
var contract_salary = 0
var resign_interest = 0
var resign_points = 100
var salary_change = 0
var offensive_coach_boost = 0
var defensive_coach_boost = 0

func _ready():
	roster_array = convert_roster_to_array()
	populate_fa_list("Pending/FreeAgents")
	check_offensive_coach()
	check_defensive_coach()
	
func populate_fa_list(container_path):
	var container = get_node(container_path)
	for child in container.get_children():
		child.queue_free()
	var position_label = Label.new()
	position_label.text = "Pending Free Agents"
	container.add_child(position_label)
	var fa_array = []
	for player in roster_array:
		fa_array.append(player)
	fa_array.sort_custom(func(a, b):
		return a["Rating"] > b["Rating"])
	for player in fa_array:
		if player["Remaining Contract"] == 1:
			var button_text = "%s %s %s OVR %d Age %d Potential %d" % [player["Position"], player["FirstName"], player["LastName"], player["Rating"], player["Age"], player["Potential"]]
			var player_button = Button.new()
			player_button.text = button_text
			player_button.name = player["PlayerID"]
			player_button.pressed.connect(self._on_PlayerButton_pressed.bind(player_button.name))
			container.add_child(player_button)

		
func compare_by_rating(player1, player2):
	if player1["Rating"] >= player2["Rating"]:
		return true
	else:
		return false

func convert_roster_to_array():
	var roster_array = []
	for player_data in team_roster:
		roster_array.append(player_data)
	return roster_array

func _on_PlayerButton_pressed(player_id):
	selected_player = player_id
	resign_points = 100
	salary_change = 0
	populate_contract_details(selected_player)

func populate_contract_details(selected_player):
	if selected_player == "":
		return
	var player2 = {}
	for player in roster_array:
		if player["PlayerID"] == selected_player:
			player2 = player
			break
	contract_salary = generate_salary(player2["Position"], player2["Rating"], player2["Potential"])
	salary_request = contract_salary
	var rng = int(player2["PlayerID"])
	rng *= 0.00000001
	if player2["Rating"] <= 65:
		rng -= .3
	elif player2["Rating"] <= 70:
		rng -= .2
	elif player2["Rating"] <= 75:
		rng -= .1
	elif player2["Rating"] >= 80:
		rng += .15
	elif player2["Rating"] >= 85:
		rng += .2
	elif player2["Rating"] >= 90:
		rng += .25
	elif player2["Rating"] >= 95:
		rng += .3
	if player2["Potential"] == 1:
		rng -= .2
	elif player2["Potential"] == 2:
		rng -= .1
	elif player2["Potential"] == 3:
		rng += .1
	elif player2["Potential"] == 4:
		rng += .15
	elif player2["Potential"] == 5:
		rng += .25
	if rng >= 1:
		rng = .99999
	if rng <= 0:
		rng = .0001 
	if player2["Age"] <= 30:
		var year_seed = int(str(player2["PlayerID"])[-1])
		if rng >=.75:
			if year_seed == 0:
				contract_years = 6
			elif year_seed == 1:
				contract_years = 2
			elif year_seed in [3, 4]:
				contract_years = 3
			elif year_seed in [6, 7, 8]:
				contract_years = 4
			elif year_seed in [5, 9, 2]:
				contract_years = 5
		elif rng >=.25:
			if year_seed == 0:
				contract_years = 1
			elif year_seed in [1, 2]:
				contract_years = 2
			elif year_seed in [3, 4]:
				contract_years = 3
			elif year_seed in [6, 7, 8]:
				contract_years = 4
			elif year_seed in [5, 9]:
				contract_years = 5
		else:
			if year_seed in [0, 9]:
				contract_years = 1
			elif year_seed in [1, 2]:
				contract_years = 2
			elif year_seed in [3, 4, 8]:
				contract_years = 3
			elif year_seed in [6, 7]:
				contract_years = 4
			elif year_seed in [5]:
				contract_years = 5
		
	elif player2["Age"] <= 35:
		if rng <= .5:
			contract_years = 3
		elif rng <= .75:
			contract_years = 2
		elif rng <= .9:
			contract_years = 4
		else:
			contract_years = 1
	else:
		if rng <= .5:
			contract_years = 2
		elif rng <= .75:
			contract_years = 1
		else:
			contract_years = 3

	if contract_years == 1:
		contract_guaranteed_years = 1
	elif contract_years == 2:
		if rng <= .5:
			contract_guaranteed_years = 2
		else:
			contract_guaranteed_years = 1
	elif contract_years == 3:
		if rng <= .45:
			contract_guaranteed_years = 1
		elif rng <= .9:
			contract_guaranteed_years = 2
		else:
			contract_guaranteed_years = 3
	elif contract_years == 4:
		if rng <= .3:
			contract_guaranteed_years = 1
		elif rng <= .8:
			contract_guaranteed_years = 2
		elif rng <= .95:
			contract_guaranteed_years = 3
		else:
			contract_guaranteed_years = 4
	elif contract_years == 5:
		if rng <= .15:
			contract_guaranteed_years = 1
		elif rng <= .35:
			contract_guaranteed_years = 2
		elif rng <= .8:
			contract_guaranteed_years = 3
		else:
			contract_guaranteed_years = 4
	else:
		if rng <= .05:
			contract_guaranteed_years = 1
		elif rng <= .2:
			contract_guaranteed_years = 2
		elif rng <= .6:
			contract_guaranteed_years = 3
		elif rng <= .9:
			contract_guaranteed_years = 4
		else:
			contract_guaranteed_years = 5
	resign_interest = int(str(player2["PlayerID"])[-3])
	if player2["Side"] == "Offense":
		match offensive_coach_boost:
			0:
				pass
			1:
				resign_points += 5
			2:
				resign_points += 8
			3:
				resign_points += 11
			4:
				resign_points += 14
			5:
				resign_points += 17
			6:
				resign_points += 20
	if player2["Side"] == "Defense":
		match defensive_coach_boost:
			0:
				pass
			1:
				resign_points += 5
			2:
				resign_points += 8
			3:
				resign_points += 11
			4:
				resign_points += 14
			5:
				resign_points += 17
			6:
				resign_points += 20
	resign_points += resign_interest
	set_contract_labels()
	check_deal()

func generate_salary(position, rating, potential):
	var minimum = .75
	var salary = 0
	if rating < 70:
		return minimum
	if position == "QB":
		var qb_min = 1
		var qb_max = 50
		if rating > 99:
			return 50
		elif rating >= 80:
			salary = 1 + (float(rating - 80) / (99 - 80)) * (50 - 15)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
		elif rating >= 70:
			salary = 1 + (float(rating - 70) / (80 - 70)) * (15 - 2.5)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
		else:
			return qb_min
	elif position == "RB":
		var min = 1
		var max = 14
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "WR":
		var min = 1
		var max = 22
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "TE":
		var min = 1
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "LT" or position == "RT":
		var min = 1
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "LG" or position == "RG":
		var min = 1
		var max = 13
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "C":
		var min = 1
		var max = 10
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "LE" or position == "RE":
		var min = 1
		var max = 25
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "DT":
		var min = 1
		var max = 20
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "OLB" or position == "MLB":
		var min = 1
		var max = 20
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "CB":
		var min = 1
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position == "SS" or position == "FS":
		var min = 1
		var max = 15
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	elif position in ["K", "P", "R"]:
		var min = 1
		var max = 8
		if rating > 99:
			return max
		else:
			salary = 1 + (float(rating - 70) / (99 - 70)) * (max - min)
			var pot_mult = potential_multiplier(potential)
			salary = salary * pot_mult
			return salary
	else:
		return minimum

func potential_multiplier(potential):
	if potential == 1:
		return .75
	elif potential == 2:
		return .9
	elif potential == 3:
		return 1
	elif potential == 4:
		return 1.1
	elif potential == 5:
		return 1.2
	else:
		return 1


func _on_resign_pressed():
	if resign_points < 100:
		return
	if selected_player == "":
		return
	var player_to_sign = {}
	for player in roster_array:
		if player["PlayerID"] == selected_player:
			player_to_sign = player
			break
	
	player_to_sign["Salary"] = contract_salary
	player_to_sign["Remaining Contract"] = contract_years + 1
	player_to_sign["Guaranteed Years"] = contract_guaranteed_years
	
	clear_labels()
	populate_fa_list("Pending/FreeAgents")




func _on_release_pressed():
	Rosters.team_rosters[selected_team] = roster_array
	get_tree().current_scene.queue_free()


func _on_roster_pressed():
	var root = get_tree().root
	var roster_scene = load("res://DepthChart.tscn")
	var roster_instance = roster_scene.instantiate()
	root.add_child(roster_instance)
	var current_scene = get_tree().current_scene

func _on_years_down_pressed():
	if contract_years <= 1:
		return
	if contract_years == contract_guaranteed_years:
		contract_years -= 1
		contract_guaranteed_years -= 1
		resign_points -= 10
		set_contract_labels()
		check_deal()
	else:
		contract_years -= 1
		resign_points -= 5
		set_contract_labels()
		check_deal()

func _on_years_up_pressed():
	if contract_years >= 6:
		return
	contract_years += 1
	resign_points += 5
	set_contract_labels()
	check_deal()

func _on_guaranteed_down_pressed():
	if contract_guaranteed_years <= 1:
		return
	contract_guaranteed_years -= 1
	resign_points -= 5
	set_contract_labels()
	check_deal()

func _on_guaranteed_up_pressed():
	if contract_guaranteed_years >= 6:
		return
	if contract_guaranteed_years >= contract_years:
		contract_guaranteed_years += 1
		contract_years += 1
		resign_points += 10
	else:
		contract_guaranteed_years += 1
		resign_points += 5
	set_contract_labels()
	check_deal()

func _on_salary_down_pressed():
	if salary_change <= -5:
		return
	salary_change -= 1
	if salary_change == 5:
		contract_salary = salary_request * 1.25
	elif salary_change == 4:
		contract_salary = salary_request * 1.2
	elif salary_change == 3:
		contract_salary = salary_request * 1.15
	elif salary_change == 2:
		contract_salary = salary_request * 1.1
	elif salary_change == 1:
		contract_salary = salary_request * 1.05
	elif salary_change == 0:
		contract_salary = salary_request
	elif salary_change == -1:
		contract_salary = salary_request * .95
	elif salary_change == -2:
		contract_salary = salary_request * .9
	elif salary_change == -3:
		contract_salary = salary_request * .85
	elif salary_change == -4:
		contract_salary = salary_request * .8
	elif salary_change == -5:
		contract_salary = salary_request * .75
	resign_points -= 5
	set_contract_labels()
	check_deal()

func _on_salary_up_pressed():
	if salary_change >= 5:
		return
	salary_change += 1
	if salary_change == 5:
		contract_salary = salary_request * 1.25
	elif salary_change == 4:
		contract_salary = salary_request * 1.2
	elif salary_change == 3:
		contract_salary = salary_request * 1.15
	elif salary_change == 2:
		contract_salary = salary_request * 1.1
	elif salary_change == 1:
		contract_salary = salary_request * 1.05
	elif salary_change == 0:
		contract_salary = salary_request
	elif salary_change == -1:
		contract_salary = salary_request * .95
	elif salary_change == -2:
		contract_salary = salary_request * .9
	elif salary_change == -3:
		contract_salary = salary_request * .85
	elif salary_change == -4:
		contract_salary = salary_request * .8
	elif salary_change == -5:
		contract_salary = salary_request * .75
	resign_points += 5
	set_contract_labels()
	check_deal()

func check_offensive_coach():
	for coach in Coaches.team_ocs:
		if coach["Team"] == selected_team:
			if coach["Trait"] == "Players Coach":
				match coach["Rank"]:
					"Copper":
						offensive_coach_boost = 1
					"Bronze":
						offensive_coach_boost = 2
					"Silver":
						offensive_coach_boost = 3
					"Gold":
						offensive_coach_boost = 4
					"Platinum":
						offensive_coach_boost = 5
					"Diamond":
						offensive_coach_boost = 6


func check_defensive_coach():
	for coach in Coaches.team_dcs:
		if coach["Team"] == selected_team:
			if coach["Trait"] == "Players Coach":
				match coach["Rank"]:
					"Copper":
						defensive_coach_boost = 1
					"Bronze":
						defensive_coach_boost = 2
					"Silver":
						defensive_coach_boost = 3
					"Gold":
						defensive_coach_boost = 4
					"Platinum":
						defensive_coach_boost = 5
					"Diamond":
						defensive_coach_boost = 6

func set_contract_labels():
	years_label.text = "Years: %d" % [contract_years]
	guaranteed_label.text = "Guaranteed: %d" % [contract_guaranteed_years]
	salary_label.text = "Salary: %.2f M" % [contract_salary]

func check_deal():
	if resign_points >= 100:
		deal_label.text = "Deal"
	else:
		deal_label.text = "No Deal"

func clear_labels():
	resign_interest = 100
	years_label.text = ""
	guaranteed_label.text = ""
	salary_label.text = ""
	deal_label.text = ""
	contract_years = 0
	contract_guaranteed_years = 0
	resign_interest = 0
	contract_salary = 0
	salary_change = 0
	offensive_coach_boost = 0
	defensive_coach_boost = 0
	salary_request = 0
	years = 0
