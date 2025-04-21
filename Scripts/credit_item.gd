extends VBoxContainer

@onready var item := $VBoxContainer/Item
@onready var author := $VBoxContainer/Author
@onready var link_button_1 := $Links/LinkButton1
@onready var link_button_2 := $Links/LinkButton2

@export var item_label : String
@export var author_label : String
@export var link_title_1 : String
@export var link_URI_1 : String
@export var link_title_2 : String
@export var link_URI_2 : String

# Called when the node enters the scene tree for the first time.
func _ready():
	item.text = item_label
	author.text = author_label
	link_button_1.text = link_title_1
	link_button_1.uri = link_URI_1
	link_button_2.text = link_title_2
	link_button_2.uri = link_URI_2
