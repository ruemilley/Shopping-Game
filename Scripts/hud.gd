extends CanvasLayer

@onready var money_counter = $MoneyCounter
@onready var cart_counter = $CartCounter


# Called when the node enters the scene tree for the first time.
func _ready():
	update_money_counter_text(Global.budget_value)
	update_money_counter_text(Global.cart_value)


func update_money_counter_text(value):
	if value == Global.budget_value:
		money_counter.text = "$" + str("%5.2f" % value)
	if value == Global.cart_value:
		cart_counter.text = "$" + str("%5.2f" % value)
	#the string details are string formatting. Pad to a minimum length of 5, round to two decimal places
