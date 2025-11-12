extends Node
class_name Game

signal score_changed(new_score: int)

var score: int = 0

func set_score(value: int) -> void:
	if score == value:
		return
	score = value
	score_changed.emit(score)

func add_score(delta: int) -> void:
	set_score(score + delta)

func reset_score() -> void:
	set_score(0)
