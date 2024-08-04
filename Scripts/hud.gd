extends CanvasLayer

@onready var money_counter = $MoneyCounter
@onready var cart_counter = $CartCounter


# Called when the node enters the scene tree for the first time.
func _ready():
	update_money_counter_text(money_counter, Global.budget_value)
	update_money_counter_text(cart_counter, Global.cart_value)


func update_money_counter_text(counter, value):
	#the string details are string formatting. Pad to a minimum length of 5, round to two decimal places
	counter.text = "$" + str("%5.2f" % value)
