class_name PlayerStateRun extends PlayerState

func enter() -> void:
	#TODO Play animation
	player.animation_player.play("run")
	pass

func exit() -> void:
	next_state=null
	pass

func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		return jump
	return next_state

func process( _delta: float ) -> PlayerState:
	if player.direction.x == 0:
		return idle
	elif player.direction.y > 0.5:
		return crouch
	return next_state

func physics_process( _delta: float ) -> PlayerState:
	if !player.is_on_floor():
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
