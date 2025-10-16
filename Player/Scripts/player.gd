class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://bknblw0b6rw3n")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var debug_enabled : bool = false
@export var move_speed : float = 150

var states : Array[ PlayerState ]
var current_state : PlayerState : 
	get : return states.front()
var previous_state : PlayerState : 
	get : return states[ 1 ]

var direction : Vector2 = Vector2.ZERO
var gravity_mulitplier : float = 1.0
var is_crouching : bool = false


func _ready() -> void:
	if debug_enabled:
		$Label.visible=true
	initialize_states()
	pass

func _unhandled_input( event: InputEvent ) -> void:
	change_state( current_state.handle_input( event ) )
	pass

func _process( _delta: float ) -> void:
	update_direction()
	change_state( current_state.process( _delta ) )
	pass

func _physics_process( _delta: float ) -> void:
	if direction.x < 0:
		$Sprite2D.flip_h=true
	else:
		$Sprite2D.flip_h=false
	velocity.y += get_gravity().y * _delta * gravity_mulitplier
	move_and_slide()
	change_state( current_state.physics_process( _delta ) )
	pass

func initialize_states() -> void:
	states = []

	for c in $States.get_children():
		if c is PlayerState:
			states.append( c )
			c.player = self
		pass
	
	if states.size() == 0:
		return
	
	for state in states:
		state.init()
	
	change_state( current_state )
	current_state.enter()
	if debug_enabled:
		$Label.text = current_state.name
	pass

func change_state( new_state : PlayerState ) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	states.resize( 3 )
	if debug_enabled:
		$Label.text = current_state.name
	pass

func update_direction() -> void:
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	pass

func add_debug_indicator( color : Color = Color.RED ) -> void:
	if !debug_enabled:
		return
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child( d )
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	d.queue_free()
	pass
