extends AnimatableBody2D

@export var nearbyRadius: float = 80

var nearbyBeacons: Array[AnimatableBody2D]

var nearbyBeaconShape: Shape2D

func _ready() -> void:
	nearbyBeaconShape = find_child("NearbyBeaconShape2D").shape
	nearbyBeaconShape.radius = nearbyRadius

func _on_nearby_beacon_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		nearbyBeacons.append(body)
		print(nearbyBeacons)


func _on_nearby_beacon_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		nearbyBeacons.remove_at(nearbyBeacons.find(body))
		print(nearbyBeacons)
