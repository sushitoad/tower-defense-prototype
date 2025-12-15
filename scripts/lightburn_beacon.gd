extends Area2D

var enemiesInRangeToBurn: Array[CharacterBody2D]
var burnedEnemies: Array[CharacterBody2D]
@export var attackSpeed: float = 1
@export var burnDamagePerSecond: int = 5

@onready var beacon: StaticBody2D = get_parent()
@onready var circleShape: Shape2D = $RangeShape2D.shape

func _ready() -> void:
	$AttackTimer.wait_time = attackSpeed
	beacon.on_destroyed.connect(StopLightburnEffect)
	beacon.on_awoke.connect(ActivateLightburnEffect)
	#ActivateLightburnEffect()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToBurn.append(body)
		if burnedEnemies.find(body) == -1 and body.find_child("LightburnStatus") != null:
			burnedEnemies.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRangeToBurn.remove_at(enemiesInRangeToBurn.find(body))
		if burnedEnemies.find(body) != -1:
			burnedEnemies.remove_at(burnedEnemies.find(body))

func ActivateLightburnEffect():
	$AttackTimer.start()

func StopLightburnEffect():
	$AttackTimer.stop()

func _on_attack_timer_timeout() -> void:
	for enemy in enemiesInRangeToBurn:
		if burnedEnemies.find(enemy) != -1:
			enemy.ResetBurnCounter()
			#print(str(enemy) + "'s burn counter is reset")
		else:
			burnedEnemies.append(enemy)
			enemy.GetBurned(burnDamagePerSecond)
			print(str(enemy) + " started burning!")
