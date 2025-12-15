extends Area2D

@export var attackSpeed: float = 1
@export var bulletSpeed: float = 100
@export var attackDamage: int = 10
@export var bullet: PackedScene
@export var bulletSpawnPos: Node2D
var nearbyBeaconDistance: float = 100
var attackRange: float
var enemiesInRange = Array()
var currentTarget: CharacterBody2D
var beacon: StaticBody2D
var potentialPrismBuddies: Array[StaticBody2D]
var prismBuddies: Array[StaticBody2D]

func _ready() -> void:
	attackRange = $RangeShape2D.shape.radius
	nearbyBeaconDistance = $PrismBuddiesArea2D/NearbyBeaconRange2D.shape.radius
	beacon = get_parent()
	prismBuddies.resize(2)

func _process(delta: float) -> void:
	if !beacon.isDestroyed and !beacon.isBeingPlaced:
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
	if beacon.isBeingPlaced:
		UpdatePrismBuddies()

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
	newBullet.parentBeacon = self
	newBullet.global_position = bulletSpawnPos.global_position
	newBullet.speed = bulletSpeed
	newBullet.target = currentTarget
	newBullet.beaconRange = attackRange
	var damageModifier: float = (prismBuddies.size() + 1)
	newBullet.damage = attackDamage * damageModifier

func ForgetThisEnemy(enemy: Node2D):
	enemiesInRange.remove_at(enemiesInRange.find(enemy))

func UpdatePrismBuddies():
	var buddyOne: StaticBody2D
	var buddyTwo: StaticBody2D
	var closestPosition: Vector2 = Vector2(100000, 100000)
	for beacon in potentialPrismBuddies:
		if global_position.distance_to(beacon.global_position) < global_position.distance_to(closestPosition):
			buddyOne = beacon
			closestPosition = beacon.global_position
	closestPosition = Vector2(100000, 100000)
	for beacon in potentialPrismBuddies:
		if global_position.distance_to(beacon.global_position) < global_position.distance_to(closestPosition):
			if beacon != buddyOne:
				buddyTwo = beacon
				closestPosition = beacon.global_position
	if potentialPrismBuddies.size() == 1:
		buddyTwo = null
	elif potentialPrismBuddies.size() < 1:
		buddyOne = null
		buddyTwo = null
	prismBuddies[0] = buddyOne
	#this feels close but the buddyTwo assignment keeps breaking when I go from 2 buddies to 1
	prismBuddies[1] = buddyTwo
	print(prismBuddies)
	#under this conditional, find the two closest beacons (that aren't buddies already)
	#add them to prismBuddies and draw Line2Ds
		#instantiate a line for each buddy
		#free it if thee are less buddies than lines
		#update draw to point to current buddies each frame

func DrawLineToPrismBuddy(buddy: StaticBody2D):
	pass

func _on_prism_buddies_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("beacon") and body.beaconType == GlobalEnums.BeaconType.PRISM:
		potentialPrismBuddies.append(body)

func _on_prism_buddies_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		potentialPrismBuddies.remove_at(potentialPrismBuddies.find(body))
		#if prismBuddies.find(body) != -1:
		#	prismBuddies.remove_at(prismBuddies.find(body))
