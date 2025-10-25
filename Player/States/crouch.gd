class_name PlayerStateCrouch extends PlayerState
@onready var one_way_platform_shapecast: ShapeCast2D = $"../../OneWayPlatformShapecast"


func enter() -> void:
	#TODO Play animation
	player.animation_player.play("crouch")
	pass

func exit() -> void:
	pass

func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "jump" ):
		one_way_platform_shapecast.force_shapecast_update()
		if one_way_platform_shapecast.is_colliding():
			player.global_position.y += 4
			return fall
		return jump
	return next_state

#func process( _delta: float ) -> PlayerState:
	#return next_state

func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	if !player.is_on_floor():
		return fall
	elif player.direction.y <= 0.5:
		return idle
	return next_state
