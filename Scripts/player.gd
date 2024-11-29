extends CharacterBody2D


const SPEED := 600.0
const RUN_SPEED := 1000.0
const JUMP_VELOCITY := -600.0
const FALL_GRAVITY := 1800
const RUN_JUMP_VELOCITY := -900.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction


#interactions
const INTERACT_TEXT := "E to "
@onready var all_interactions = []
@onready var interaction_label = $InteractionComponents/InteractLabel

#inventory
@onready var inventory_ui = $Inventory

#other misc variables
@onready var animated_sprite = $AnimatedSprite2D
@onready var walk_sound = $WalkSound



func  _ready():
	Global.set_player_reference(self)
	await get_tree().create_timer(0.1).timeout
	$Camera2D.position_smoothing_enabled = true


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("walk_left", "walk_right")
	if direction and Global.dialogue_active == false:
		velocity.x = direction * SPEED
		if Input.is_action_pressed("run") and is_on_floor():
			velocity.x = direction * RUN_SPEED
			Global.is_running = true
		if is_on_floor() and !walk_sound.playing:
			walk_sound.pitch_scale = randf_range(.9, 1.1)
			#walk_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walk_sound.stop()
	# Add the gravity.
	
	#control animation
	if velocity.x != 0 and Global.is_running != true:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("run")
	
	#check if actively running
	if Input.is_action_just_released("run"):
		Global.is_running = false
	
	#check speed for movement in air
	if not is_on_floor():
		velocity.y += get_gravity(velocity) * delta
		animated_sprite.play("jump")
		if Global.is_running == true:
			velocity.x = direction * RUN_SPEED
			

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and Global.dialogue_active == false:
		if Global.is_running == true:
			velocity.y = RUN_JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
	
	if velocity.x < 0 and Global.dialogue_active == false:
		animated_sprite.flip_h = true
		Global.player_direction = true
		
	if velocity.x > 0 and Global.dialogue_active == false:
		animated_sprite.flip_h = false
		Global.player_direction = false
	
	if velocity.x == 0 and velocity.y == 0:
		animated_sprite.play("idle")
		
	#keep player from moving when screen is paused
	if get_tree().paused == true:
		animated_sprite.play("idle")
		velocity.x = 0
		velocity.y = 0
	
	if Global.dialogue_active == true:
		velocity.x = 0

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
	if all_interactions and Global.dialogue_active == false:
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
			"dialogue":
				var resource = load(cur_interaction.dialogue_resource)
				Global.dialogue_active = true
				DialogueManager.show_dialogue_balloon(resource, cur_interaction.interact_value)
			_:
				print("no matching interact value found.")
			
func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused
	
