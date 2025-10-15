class_name PlayerStateIdle extends PlayerState

func enter() -> void:
	#TODO Play animation
	pass

func exit() -> void:
	pass

func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		return jump
	return next_state

func process( _delta: float ) -> PlayerState:
	if player.direction.x != 0:
		return run
	return next_state

func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	if !player.is_on_floor():
		return fall
	return next_state
