extends Node2D

enum State { LEFT, RIGHT }
@export var state: State = State.LEFT

@onready var deflector: StaticBody2D = $Deflector

func _ready() -> void:
    _apply_state()
    if has_node("ClickZone"):
        $ClickZone.input_event.connect(_on_click_zone_input_event)

func _on_click_zone_input_event(viewport, event, shape_idx) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _toggle()

func _toggle() -> void:
    if state == State.LEFT:
        state = State.RIGHT
    else:
        state = State.LEFT
    _apply_state()

func _apply_state() -> void:
    match state:
        State.LEFT:
            # déflecteur incliné vers la gauche
            deflector.rotation_degrees = -45.0
        State.RIGHT:
            # déflecteur incliné vers la droite
            deflector.rotation_degrees = 45.0
