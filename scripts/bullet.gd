extends RigidBody2D

var speed: float = 100
var damage: int = 10
var target: Node2D = null

func _physics_process(delta: float) -> void:
	linear_velocity = position.direction_to(target.position) * speed
