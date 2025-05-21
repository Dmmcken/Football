extends Panel


@onready var left_team_name_label = $LeftTeamNameLabel
@onready var right_team_name_label = $RightTeamNameLabel
@onready var left_team_score_label = $LeftTeamScoreLabel
@onready var right_team_score_label = $RightTeamScoreLabel
@onready var down_to_go_label = $DownToGoLabel
@onready var time_label = $TimeLabel
@onready var last_play_label = $LastPlayLabel

func update_game_ui(game_state, last_play):
	left_team_name_label.text = str(game_state.team_left_name)
	right_team_name_label.text = str(game_state.team_right_name)
	left_team_score_label.text = str(game_state.team_left_score)
	right_team_score_label.text = str(game_state.team_right_score)
	down_to_go_label.text = str(game_state.down % " & " % game_state.to_go)
	time_label.text = str(game_state.time)
	last_play_label.text = last_play


