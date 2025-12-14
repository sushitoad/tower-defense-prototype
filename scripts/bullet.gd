extends Area2D

var speed: float = 100
var damage: int = 10
var target: Node2D
var parentBeacon: Area2D
var beaconRange: float

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position + global_position.direction_to(target.global_position) * speed * delta
		if position.distance_to(parentBeacon.position) > beaconRange:
			queue_free()
	else:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		target.TakeDamage(damage)
		queue_free()
