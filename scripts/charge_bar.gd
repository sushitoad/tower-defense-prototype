extends ProgressBar

signal chargeAmountChanged
@export var timeToCharge: float = 10
@export var chargeCap: int = 5
var numberOfCharges: int = 0
@onready var chargeTimer: Timer = $ChargeTimer
var chargeTowerBoost: float = 1
#i think I just need to not use a timer for this so I can edit the speed in real time
var currentCharge: float = 0

func _ready() -> void:
	max_value = timeToCharge
	value = 0

func _process(delta: float) -> void:
	#value = timeToCharge - chargeTimer.time_left
	
	#this breaks when you reach max charges, I think it keeps giving you a 5th again immediately
	if chargeTowerBoost < 1:
		chargeTowerBoost = 1
	if currentCharge >= max_value:
		if numberOfCharges < chargeCap:
			currentCharge = 0
			AddCharges(1)
	else:
		currentCharge += delta * chargeTowerBoost
	value = currentCharge

func _on_charge_timer_timeout() -> void:
	pass #AddCharges(1)

func AddCharges(chargeAmount: int):
	var chargesBefore: int = numberOfCharges
	numberOfCharges += chargeAmount
	if numberOfCharges == chargeCap:
		#chargeTimer.stop()
		currentCharge = max_value
	if numberOfCharges < 0:
		numberOfCharges = 0
	elif numberOfCharges > chargeCap:
		numberOfCharges = chargeCap
	#if numberOfCharges < chargeCap and chargeTimer.is_stopped():
	#	chargeTimer.start()
	if chargesBefore != numberOfCharges:
		chargeAmountChanged.emit()
	print(str(numberOfCharges) + " charges")

func _on_basic_tower_button_pressed() -> void:
	AddCharges(-1)

func _on_charge_tower_button_pressed() -> void:
	AddCharges(-1)
