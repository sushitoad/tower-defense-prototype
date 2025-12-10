extends Area2D

var enemiesInRangeToBurn: Array[CharacterBody2D]
var burnedEnemies: Array[CharacterBody2D]
@export var attackSpeed: float = 1

@onready var beacon: StaticBody2D = get_parent()
@onready var circleShape: Shape2D = $RangeShape2D.shape

func _ready() -> void:
	$AttackTimer.wait_time = attackSpeed
	ActivateLightburnEffect()

func _on_body_entered(body: Node2D) -> void:
	# if its an enemy, add it to enemiesInRangeToBurn
	if body.is_in_group("enemy"):
		enemiesInRangeToBurn.append(body)
		print(enemiesInRangeToBurn)

func _on_body_exited(body: Node2D) -> void:
	# if its an enemy, remove it from enemiesInRangeToBurn
	if body.is_in_group("enemy"):
		enemiesInRangeToBurn.remove_at(enemiesInRangeToBurn.find(body))
		print(enemiesInRangeToBurn)

func ActivateLightburnEffect():
	$AttackTimer.start()

func _on_attack_timer_timeout() -> void:
	for enemy in enemiesInRangeToBurn:
		if burnedEnemies.find(enemy) != -1:
			print(str(enemy) + "'s burn counter is reset")
		else:
			burnedEnemies.append(enemy)
			print(str(enemy) + " started burning!")
