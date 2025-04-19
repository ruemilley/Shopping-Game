extends RigidBody2D
@onready var rolling_sfx = $RollingSfx

func _process(delta):
	if linear_velocity.x != 0.0 and rolling_sfx.playing != true:
		rolling_sfx.playing = true
	if linear_velocity.x == 0.0 and rolling_sfx.playing == true:
		rolling_sfx.playing = false
