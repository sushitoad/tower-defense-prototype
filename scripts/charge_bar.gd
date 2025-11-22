extends ProgressBar

signal chargeAmountChanged
var timeToCharge: float = 10
var chargeCap: int = 5
var numberOfCharges: int = 0
var chargeTowerBoost: float = 1
var currentCharge: float = 0

func _ready() -> void:
	max_value = timeToCharge
	value = 0
	timeToCharge = $"../..".timeToFullCharge
	chargeCap = $"../..".chargeMaxNumber

func _process(delta: float) -> void:
	if chargeTowerBoost < 1:
		chargeTowerBoost = 1
	if currentCharge >= max_value:
		if numberOfCharges < chargeCap:
			currentCharge = 0
			AddCharges(1)
	else:
		currentCharge += delta * chargeTowerBoost
	value = currentCharge

func AddCharges(chargeAmount: int):
	var chargesBefore: int = numberOfCharges
	numberOfCharges += chargeAmount
	#freezing charge bar at charge cap
	if numberOfCharges >= chargeCap:
		currentCharge = max_value
	#clamping the charge count from 0 to charge cap
	if numberOfCharges < 0:
		numberOfCharges = 0
	elif numberOfCharges > chargeCap:
		numberOfCharges = chargeCap
	#emitting signal (mainly for build UI to change charge icons)
	if chargesBefore != numberOfCharges:
		chargeAmountChanged.emit()
	#starting the count again if it was frozen and a charge is spent
	if chargesBefore >= chargeCap and chargesBefore > numberOfCharges:
		currentCharge = 0

func _on_basic_tower_button_pressed() -> void:
	AddCharges(-1)

func _on_charge_tower_button_pressed() -> void:
	AddCharges(-1)
