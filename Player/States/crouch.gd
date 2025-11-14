class_name PlayerStateCrouch extends PlayerState
@onready var one_way_platform_shapecast: ShapeCast2D = $"../../OneWayPlatformShapecast"


@export var deceleration_rate : float = 10.0

@onready var collision_stand: CollisionShape2D = $"../../CollisionStand"
@onready var collision_crouch: CollisionShape2D = $"../../CrouchCollision"

func init() -> void:
	collision_crouch.disabled=true

func enter() -> void:
	#TODO Play animation
	player.animation_player.play("crouch")
	player.animation_player.seek(0.0)
	collision_crouch.disabled=false
	collision_stand.disabled=true
	pass

func exit() -> void:
	collision_stand.disabled=false
	collision_crouch.disabled=true
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
	player.velocity.x -= player.velocity.x * deceleration_rate * _delta
	if !player.is_on_floor():
		return fall
	elif player.direction.y <= 0.5:
		return idle
	return next_state
