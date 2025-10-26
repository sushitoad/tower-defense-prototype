extends CharacterBody2D

signal on_death

var currentTarget: Node2D
var isInRangeOfTarget: bool = false
@export var maxHealth: int = 40
var currentHealth: int
@export var moveSpeed: float = 10
@export var range: float = 20
@export var attackDamage: int = 10
@export var attackSpeed: float = 1.2
@export var hasFacing: bool = false

func _ready() -> void:
	currentHealth = maxHealth
	FindTarget()

func _physics_process(delta: float) -> void:
	if currentTarget != null:
		if global_position.distance_to(currentTarget.global_position) > range:
			velocity = global_position.direction_to(currentTarget.global_position) * moveSpeed
			isInRangeOfTarget = false
		else:
			velocity = Vector2.ZERO
			isInRangeOfTarget = true
	else:
		velocity = Vector2.ZERO
		isInRangeOfTarget = false
	
	move_and_slide()

func _process(delta: float) -> void:
	if hasFacing:
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x < 0:
			$AnimatedSprite2D.flip_h = false
	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("stand")
	if isInRangeOfTarget:
		if $AttackTimer.is_stopped():
			$AttackTimer.start(attackSpeed)
	elif !isInRangeOfTarget:
		$AttackTimer.stop()

func FindTarget():
	if currentTarget != null:
		currentTarget.on_destroyed.disconnect(FindTarget)
	var newTarget
	var closestTarget: Vector2 = Vector2(10000000000, 10000000000)
	var closestAllure: float = 1
	var targets = get_tree().get_nodes_in_group("tower")
	for tower in targets:
		if tower.isDestroyed:
			targets.remove_at(targets.find(tower))
	for tower in targets:
		if(tower.position.distance_to(position) / tower.allure) < (closestTarget.distance_to(position) / closestAllure):
			newTarget = tower
			closestTarget = tower.position
			closestAllure = tower.allure
	currentTarget = newTarget
	if currentTarget != null:
		currentTarget.on_destroyed.connect(FindTarget)
		print(currentTarget.name)
	else:
		print("no more targets")

func AttackTarget():
	if currentTarget != null:
		currentTarget.TakeDamage(attackDamage)
	#this might end up being an animation thing but for now it good
	#yes, because you can call functions in specific frames of an animation
	
func TakeDamage(damage: int):
	currentHealth -= damage
	print(currentHealth)
	if currentHealth <= 0:
		currentHealth = 0
		Die()

func Die():
	#emits signal that tells all targeting towers to remove this enemy
	on_death.emit()
	call_deferred("queue_free")
