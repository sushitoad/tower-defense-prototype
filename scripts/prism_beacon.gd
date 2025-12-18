extends Area2D

@export var attackSpeed: float = 1
@export var bulletSpeed: float = 100
@export var attackDamage: int = 10
@export var bullet: PackedScene
@export var bulletSpawnPos: Node2D
@export var buddyLines: Array[Line2D]
var nearbyBeaconDistance: float = 100
var attackRange: float
var enemiesInRange = Array()
var currentTarget: CharacterBody2D
var beacon: StaticBody2D
var potentialPrismBuddies: Array[StaticBody2D]
var prismBuddies: Array[StaticBody2D]

#line2Ds are local coordinates based on the line node's position
#I need to subtract the line2Ds global position from the target global position
# or from whatever position I want. Basically to get local its always -Line2D.global_position

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
	prismBuddies[1] = buddyTwo
	print(prismBuddies)
	var count: int = 0
	for buddy in prismBuddies:
		var line: Line2D = buddyLines[count]
		var start: Vector2 = Vector2.ZERO
		var end: Vector2 = Vector2.ZERO
		if buddy != null:
			start = beacon.global_position - line.global_position
			end = buddy.global_position - line.global_position
		line.set_point_position(0, start)
		line.set_point_position(1, end)
		count += 1

#end goal: once set, all 3 beacons have the same buddies
#this means that new beacons are checking to see if there is an open buddy slot
#if there is, they would want to look at the other buddy and see if they're in range
#if they're in range of both, draw a line to each, otherwise no line at all

#case: if there are two potential buddies that don't connect to each other
#this needs to see that they don't have buddies, and draw a line to the nearest one
#so in a sense this is only ever drawing one line unless the beacon it draws to has a buddy

func _on_prism_buddies_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("beacon") and body.beaconType == GlobalEnums.BeaconType.PRISM:
		potentialPrismBuddies.append(body)

func _on_prism_buddies_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		potentialPrismBuddies.remove_at(potentialPrismBuddies.find(body))
		#if prismBuddies.find(body) != -1:
		#	prismBuddies.remove_at(prismBuddies.find(body))
