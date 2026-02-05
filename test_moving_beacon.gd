extends AnimatableBody2D

@export var is_being_placed: bool = false

#so maybe what's happening is that when the collision for the staticbody2D is activated
#it stops going off the area2ds, which maybe also work?
#I wonder what would happen if I keep the staticbodys disabled

func _physics_process(delta: float) -> void:
	if is_being_placed:
		global_position = get_global_mouse_position()
