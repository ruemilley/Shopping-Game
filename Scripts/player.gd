extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0
const INTERACT_TEXT = "E to"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var all_interactions = []
@onready var interaction_label = $InteractionComponents/InteractLabel


func  _ready():
	update_interactions()


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play("idle")
	

	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()


# interaction methods: info pulled from this tutorial: https://www.youtube.com/watch?v=_57alDBagSY

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()
	
func update_interactions():
	if all_interactions:
		interaction_label.text = INTERACT_TEXT + all_interactions[0].interact_label
	else:
		interaction_label.text = ""
		

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"print_text": 
				print(cur_interaction.interact_value)
			"load_scene":
				get_tree().change_scene_to_file(cur_interaction.interact_value)
			_:
				print("no matching interact value found.")
			
