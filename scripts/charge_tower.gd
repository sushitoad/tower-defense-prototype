extends Area2D

#reference to charge bar
var chargeBar: ProgressBar = null
#while this is not dormant or being placed, adds to a value in the charge bar called charge reduction
#slows enemies that enter the area 2d

func _ready() -> void:
	pass #chargeBar = get_node("/root/Test Scene/BuildUI/ChargeBar")
