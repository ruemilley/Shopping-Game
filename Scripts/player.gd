extends CharacterBody2D


const SPEED := 600.0
const JUMP_VELOCITY := -600.0
const FALL_GRAVITY := 1800
const INTERACT_TEXT := "E to "

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction

@onready var all_interactions = []
@onready var interaction_label = $InteractionComponents/InteractLabel
@onready var inventory_ui = $Inventory


func  _ready():
	Global.set_player_reference(self)
	await get_tree().create_timer(0.1).timeout
	$Camera2D.position_smoothing_enabled = true


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity(velocity) * delta
		$AnimatedSprite2D.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		Global.player_direction = true
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false

		Global.player_direction = false
	
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play("idle")
		
		
	#keep player from moving when screen is paused
	if get_tree().paused == true:
		velocity.x = 0
		velocity.y = 0

	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
		
func get_gravity(velocity: Vector2):
	if velocity.y < 0:
		return gravity
	return FALL_GRAVITY


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
				Global.last_main_position = position
				get_tree().change_scene_to_file(cur_interaction.interact_value)
			"load_main":
				get_tree().change_scene_to_file(cur_interaction.interact_value)
			"item_pickup":
				get_parent().get_node(str(cur_interaction.interact_value)).pickup_item()
				Global.update_scene_items()
			_:
				print("no matching interact value found.")
			
func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused
	
