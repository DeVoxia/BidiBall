extends Node2D

enum State { LEFT, STRAIGHT, RIGHT }
@export var state: State = State.LEFT

@onready var shape_left := $"BlockLeft/CollisionShape2D"
@onready var shape_right := $"BlockRight/CollisionShape2D"
@onready var shape_straight := $"BlockStraight/CollisionShape2D"

func _ready():
    _apply_state()
    if has_node("ClickZone"):
        $"ClickZone".input_event.connect(_on_click_zone_input_event)

func _on_click_zone_input_event(viewport, event, shape_idx):
    # Compatible souris et (émulation) tactile si activée dans les paramètres projet
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _cycle()

func _cycle():
    match state:
        State.LEFT:      state = State.STRAIGHT
        State.STRAIGHT:  state = State.RIGHT
        State.RIGHT:     state = State.LEFT
    _apply_state()

func _apply_state():
    # On désactive le "mur" de la branche choisie (donc elle s'ouvre),
    # et on active les murs des autres (elles se ferment).
    shape_left.disabled = not (state == State.LEFT)
    shape_straight.disabled = not (state == State.STRAIGHT)
    shape_right.disabled = not (state == State.RIGHT)
