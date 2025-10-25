class_name PlayerStateFall extends PlayerState

@export var fall_gravity_mulitplier : float = 1.165
@export var coyote_time : float = 0.1
@export var jump_buffer_time : float = 0.1

var coyote_timer : float = 0.0
var buffer_timer : float = 0.0

func enter() -> void:
	#TODO Play animation
	await get_tree().physics_frame
	player.animation_player.play("fall")
	player.animation_player.pause()
	player.gravity_mulitplier = fall_gravity_mulitplier
	if player.previous_state == run:
		coyote_timer = coyote_time
	else:
		coyote_timer = 0.0
	pass

func exit() -> void:
	player.gravity_mulitplier = 1.0
	pass

func process( delta: float ) -> PlayerState:
	if coyote_timer > 0.0:
		coyote_timer = max(coyote_timer - delta, 0.0)
	if buffer_timer > 0:
		buffer_timer -= delta
	set_fall_frame()
	return null

func set_fall_frame() -> void:
	var frame : float = remap( player.velocity.y, 0.0, player.max_fall_speed, 0.0, 0.5 )
	player.animation_player.seek( frame, true)
	pass
	
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor():
		player.add_debug_indicator()
		if buffer_timer > 0:
			return jump
		return idle
	return next_state

func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		buffer_timer=jump_buffer_time
		if coyote_timer > 0:
			return jump
	elif _event.is_action_released("down"):
		return idle
	return next_state
