extends ProgressBar

@export var timeToCharge: float = 10
var numberOfCharges: int = 0
@onready var chargeTimer: Timer = $ChargeTimer

func _ready() -> void:
	max_value = timeToCharge
	chargeTimer.wait_time = timeToCharge
	chargeTimer.start()

func _process(delta: float) -> void:
	value = timeToCharge - chargeTimer.time_left

func _on_charge_timer_timeout() -> void:
	AddCharges(1)

func AddCharges(chargeAmount: int):
	numberOfCharges += chargeAmount
	if numberOfCharges < 0:
		numberOfCharges = 0
	print(numberOfCharges)
	if numberOfCharges == 0:
		pass #hide the tower buttons

func _on_basic_tower_button_pressed() -> void:
	AddCharges(-1)

func _on_charge_tower_button_pressed() -> void:
	AddCharges(-1)
