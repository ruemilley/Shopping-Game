extends CanvasLayer

@onready var money_counter = $MoneyCounter

# Called when the node enters the scene tree for the first time.
func _ready():
	update_money_counter_text()


func update_money_counter_text():
	#the string details are string formatting. Pad to a minimum length of 5, round to two decimal places
	money_counter.text = "$" + str("%5.2f" % Global.budget_value)
