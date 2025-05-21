extends Node

var fa_oc = []
var fa_dc = []
var first_names = []
var last_names = []
var team_ocs = []
var team_dcs = []
var fa_scout = []
var team_scouts = []

func _ready():
	fa_oc = generate_ocs()
	fa_dc = generate_dcs()
	fa_scout = generate_scouts()
	assign_ocs()
	assign_dcs()
	assign_scouts()



func load_first_names():
	var file = FileAccess.open("res://JSON Files/FirstNames.json", FileAccess.READ)
	var first_names_data = JSON.new()
	first_names_data.parse(file.get_as_text())
	file.close()
	first_names = first_names_data.get_data()
	return first_names
	
func load_last_names():
	var file = FileAccess.open("res://JSON Files/LastNames.json", FileAccess.READ)
	var last_names_data = JSON.new()
	last_names_data.parse(file.get_as_text())
	file.close()
	last_names = last_names_data.get_data()
	return last_names

func generate_random_oc():
	var coach = {}
	first_names = load_first_names()
	last_names = load_last_names()
	
	var first_names_array = first_names.keys()
	var last_names_array = last_names.keys()
	var random_index = randi() % first_names_array.size()
	var boost_array = ["QB", "RB", "WR", "TE", "LT", "RT", "LG", "RG", "C"]
	var boost1_index = randi() % boost_array.size()
	coach["FirstName"] = first_names_array[random_index]
	coach["LastName"] = last_names_array[randi() % last_names_array.size()]
	coach["Boost1"] = boost_array[boost1_index]
	boost_array.erase(boost_array[boost1_index])
	var boost2_index = randi() % boost_array.size()
	coach["Boost2"] = boost_array[boost2_index]
	var focus = ["Pass", "Run"]
	var focus_index = randi() % focus.size()
	coach["Focus"] = focus[focus_index]
	var traits = ["Players Coach", "Practice Makes Perfect", "Safety First", "Youthful Spirit", "Clutch", "Rivalry", "Comeback Kid"]
	var trait_index = randi() % traits.size()
	coach["Trait"] = traits[trait_index]
	var ranks = ["Copper", "Bronze", "Silver", "Gold", "Platinum", "Diamond"]
	var rank_rng = randf()
	if rank_rng <= .4:
		coach["Rank"] = "Copper"
	elif rank_rng <= .7:
		coach["Rank"] = "Bronze"
	elif rank_rng <= .85:
		coach["Rank"] = "Silver"
	elif rank_rng <= .95:
		coach["Rank"] = "Gold"
	elif rank_rng <= .99:
		coach["Rank"] = "Platinum"
	else:
		coach["Rank"] = "Diamond"
	
	return coach

func generate_random_dc():
	var coach = {}
	first_names = load_first_names()
	last_names = load_last_names()
	
	var first_names_array = first_names.keys()
	var last_names_array = last_names.keys()
	var random_index = randi() % first_names_array.size()
	var boost_array = ["LE", "RE", "DT", "OLB", "MLB", "CB", "FS", "SS"]
	var boost1_index = randi() % boost_array.size()
	coach["FirstName"] = first_names_array[random_index]
	coach["LastName"] = last_names_array[randi() % last_names_array.size()]
	coach["Boost1"] = boost_array[boost1_index]
	boost_array.erase(boost_array[boost1_index])
	var boost2_index = randi() % boost_array.size()
	coach["Boost2"] = boost_array[boost2_index]
	var focus = ["Pass Stop", "Run Stop"]
	var focus_index = randi() % focus.size()
	coach["Focus"] = focus[focus_index]
	var traits = ["Players Coach", "Practice Makes Perfect", "Safety First", "Youthful Spirit", "Clutch", "Rivalry", "Closer"]
	var trait_index = randi() % traits.size()
	coach["Trait"] = traits[trait_index]
	var ranks = ["Copper", "Bronze", "Silver", "Gold", "Platinum", "Diamond"]
	var rank_rng = randf()
	if rank_rng <= .4:
		coach["Rank"] = "Copper"
	elif rank_rng <= .7:
		coach["Rank"] = "Bronze"
	elif rank_rng <= .85:
		coach["Rank"] = "Silver"
	elif rank_rng <= .95:
		coach["Rank"] = "Gold"
	elif rank_rng <= .99:
		coach["Rank"] = "Platinum"
	else:
		coach["Rank"] = "Diamond"
	coach["Team"] = "Free Agent"
	return coach

func generate_ocs():
	var ocs = []
	for i in range(500):
		ocs.append(generate_random_oc())
	return ocs

func generate_dcs():
	var dcs = []
	for i in range(500):
		dcs.append(generate_random_dc())
	return dcs

var team_names = [
	"New York Spartans", "Charlotte Beasts", "Philadelphia Suns", "DC Senators", "Columbus Hawks", "Milwaukee Owls", "Chicago Warriors", "Baltimore Bombers", "Oklahoma Tornadoes", "New Orleans Voodoo", "Omaha Ducks", "Memphis Pyramids", "Las Vegas Aces", "Oregon Sea Lions", "San Diego Spartans", "Los Angeles Stars", "Miami Pirates", "Boston Wildcats", "Tampa Wolverines", "Georgia Peaches", "Louisville Stallions", "Cleveland Blue Jays", "Indianapolis Cougars", "Detroit Motors", "Dallas Rebels", "Kansas City Badgers", "Houston Bulls", "Nashville Strings", "Seattle Vampires", "Sacramento Golds", "Albuquerque Scorpions", "Phoenix Roadrunners", "Free Agent"
]

func assign_ocs():
	for i in range(33):
		var team_name = team_names[i]
		if team_name != "Free Agent":
			var random_index = randi() % fa_oc.size()
			var selected_oc = fa_oc[random_index]
			selected_oc["Team"] = team_name
			team_ocs.append(selected_oc)
			fa_oc.erase(selected_oc)


func assign_dcs():
	for i in range(33):
		var team_name = team_names[i]
		if team_name != "Free Agent":
			var random_index = randi() % fa_dc.size()
			var selected_dc = fa_dc[random_index]
			selected_dc["Team"] = team_name
			team_dcs.append(selected_dc)
			fa_dc.erase(selected_dc)
			
func generate_scouts():
	var scouts = []
	for i in range(500):
		scouts.append(generate_random_scout())
	return scouts

func generate_random_scout():
	var scout = {}
	first_names = load_first_names()
	last_names = load_last_names()
	
	var first_names_array = first_names.keys()
	var last_names_array = last_names.keys()
	var random_index = randi() % first_names_array.size()
	var boost_array = ["QB", "RB", "WR", "TE", "LT", "RT", "LG", "RG", "C", "LE", "RE", "DT", "OLB", "MLB", "CB", "FS", "SS"]
	var boost1_index = randi() % boost_array.size()
	scout["FirstName"] = first_names_array[random_index]
	scout["LastName"] = last_names_array[randi() % last_names_array.size()]
	scout["Boost1"] = boost_array[boost1_index]
	boost_array.erase(boost_array[boost1_index])
	var boost2_index = randi() % boost_array.size()
	scout["Boost2"] = boost_array[boost2_index]
	boost_array.erase(boost_array[boost2_index])
	var boost3_index = randi() % boost_array.size()
	scout["Boost3"] = boost_array[boost3_index]
	var focus = ["Rating", "Potential"]
	var focus_index = randi() % focus.size()
	scout["Focus"] = focus[focus_index]
	var ranks = ["Copper", "Bronze", "Silver", "Gold", "Platinum", "Diamond"]
	var rank_rng = randf()
	if rank_rng <= .4:
		scout["Rank"] = "Copper"
	elif rank_rng <= .7:
		scout["Rank"] = "Bronze"
	elif rank_rng <= .85:
		scout["Rank"] = "Silver"
	elif rank_rng <= .95:
		scout["Rank"] = "Gold"
	elif rank_rng <= .99:
		scout["Rank"] = "Platinum"
	else:
		scout["Rank"] = "Diamond"
	if scout["Rank"] == "Copper":
		scout["Slots"] = 2
	elif scout["Rank"] == "Bronze":
		scout["Slots"] = 4
	elif scout["Rank"] == "Silver":
		scout["Slots"] = 6
	elif scout["Rank"] == "Gold":
		scout["Slots"] = 8
	elif scout["Rank"] == "Platinum":
		scout["Slots"] = 10
	elif scout["Rank"] == "Diamond":
		scout["Slots"] = 12
	scout["Team"] = "Free Agent"
	return scout

func assign_scouts():
	for i in range(33):
		var team_name = team_names[i]
		if team_name != "Free Agent":
			var random_index = randi() % fa_scout.size()
			var selected_scout = fa_scout[random_index]
			selected_scout["Team"] = team_name
			team_scouts.append(selected_scout)
			fa_scout.erase(random_index)
