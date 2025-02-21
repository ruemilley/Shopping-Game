extends Sprite2D

@onready var grocery_icon = $GroceryIcon
@onready var aisle_label = $AisleLabel
@onready var aisle_label_2 = $AisleLabel2
@onready var aisle_label_3 = $AisleLabel3

@export var grocery_icon_texture := Texture2D
@export var text_line_1 := ""
@export var text_line_2 := ""
@export var text_line_3 := ""
@export var grocery_icon_position := Vector2(-27.75, 179.75)
@export var grocery_icon_scale := Vector2(0.106,0.106)

func _ready():
	grocery_icon.texture =  grocery_icon_texture 
	grocery_icon.position = grocery_icon_position
	grocery_icon.scale = grocery_icon_scale
	aisle_label.text = '[center]' + text_line_1 + '[/center]'
	aisle_label_2.text = '[center]' + text_line_2 + '[/center]'
	aisle_label_3.text = '[center]' + text_line_3 + '[/center]'
