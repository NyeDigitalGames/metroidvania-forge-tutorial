class_name PlayerStateCrouch extends PlayerState

func enter() -> void:
	#TODO Play animation
	player.is_crouching = true
	player.animation_player.play("crouch")
	pass

func exit() -> void:
	pass

func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		player.global_position.y += 1
		return fall
	return next_state

func process( _delta: float ) -> PlayerState:
	return next_state

func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	if !player.is_on_floor():
		return fall
	elif player.direction.y <= 0.5:
		player.is_crouching = false
		return idle
	return next_state
