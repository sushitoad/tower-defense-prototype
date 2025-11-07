extends Area2D

@export var attackSpeed: float = 1
@export var bulletSpeed: float = 100
@export var attackDamage: int = 10
@export var bullet: PackedScene
@export var bulletSpawnPos: Node2D
var attackRange: float
var enemiesInRange = Array()
var currentTarget: CharacterBody2D
var tower: StaticBody2D

func _ready() -> void:
	var circleShape: Shape2D = $CollisionShape2D.shape
	attackRange = circleShape.radius
	tower = get_parent()

func _process(delta: float) -> void:
	if !tower.isDestroyed:
		if currentTarget == null:
			$AttackTimer.stop()
			if !enemiesInRange.is_empty():
				var closestEnemy = enemiesInRange[0]
				for enemy in enemiesInRange:
						if position.distance_to(enemy.position) < position.distance_to(closestEnemy.position):
							closestEnemy = enemy
				currentTarget = closestEnemy
				currentTarget.on_death.connect(ForgetThisEnemy.bind(currentTarget))
				#print(currentTarget)
		elif currentTarget != null:
			if $AttackTimer.is_stopped():
				$AttackTimer.start(attackSpeed)
	else:
		if !$AttackTimer.is_stopped():
			$AttackTimer.stop()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if currentTarget == body:
			currentTarget = null
		ForgetThisEnemy(body)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRange.append(body)

func SpawnBullet():
	var newBullet
	newBullet = bullet.instantiate()
	add_child(newBullet)
	newBullet.parentTower = self
	newBullet.global_position = bulletSpawnPos.global_position
	newBullet.speed = bulletSpeed
	newBullet.damage = attackDamage
	newBullet.target = currentTarget
	newBullet.towerRange = attackRange

func ForgetThisEnemy(enemy: Node2D):
	enemiesInRange.remove_at(enemiesInRange.find(enemy))
	
