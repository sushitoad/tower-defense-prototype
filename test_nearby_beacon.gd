extends Area2D

var nearbyBeacons: Array[StaticBody2D]

@onready var beacon_body: StaticBody2D = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("beacon") and !beacon_body.is_being_placed:
		nearbyBeacons.append(body)
		print(nearbyBeacons)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon") and !beacon_body.is_being_placed:
		nearbyBeacons.remove_at(nearbyBeacons.find(body))
		print(nearbyBeacons)
