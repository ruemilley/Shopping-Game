extends CanvasLayer

@onready var money_counter = $MoneyCounter
@onready var cart_counter = $CartCounter


# Called when the node enters the scene tree for the first time.
func _ready():
	update_money_counter_text(Global.budget_value)
	update_money_counter_text(Global.cart_value)


func update_money_counter_text(value):
	#the string details are string formatting. Pad to a minimum length of 5, round to two decimal places
	if value == Global.budget_value:
		money_counter.text = "[right]$" + str("%5.2f" % value)
	if value == Global.cart_value:
		cart_counter.text = "[right]$" + str("%4.2f" % value)
		if value == Global.cart_value and Global.cart_value > Global.budget_value:
			cart_counter.set("theme_override_colors/default_color", Color(255, 0, 0, 255))
			cart_counter.set("theme_override_colors/font_outline_color", Color(255, 255, 255, 255))
		elif value == Global.cart_value and Global.cart_value <= Global.budget_value:
			cart_counter.set("theme_override_colors/default_color", Color(255, 255, 255, 255))
			cart_counter.set("theme_override_colors/font_outline_color", Color(0, 0, 0, 255))
