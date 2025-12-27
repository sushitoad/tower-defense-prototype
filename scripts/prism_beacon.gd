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
var hasTwoBuddies: bool = false

#line2Ds are local coordinates based on the line node's position
#I need to subtract the line2Ds global position from the target global position
# or from whatever position I want. Basically to get local its always -Line2D.global_position

func _ready() -> void:
	attackRange = $RangeShape2D.shape.radius
	nearbyBeaconDistance = $PrismBuddiesArea2D/NearbyBeaconRange2D.shape.radius
	beacon = get_parent()
	prismBuddies.resize(2)
	beacon.on_placed.connect(SetPrismBuddies)
	#these prism beacons that start in the scene refuse to add each other as buddies
	if Time.get_ticks_msec() < 2000:
		SearchForNearestBuddy()
		SetPrismBuddies()

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
		SearchForNearestBuddy()

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
	var damageModifier: float = 1
	for buddy in prismBuddies:
		if buddy != null:
			damageModifier += 1
	newBullet.damage = attackDamage * damageModifier

func ForgetThisEnemy(enemy: Node2D):
	enemiesInRange.remove_at(enemiesInRange.find(enemy))

func SearchForNearestBuddy():
	var closestBuddy: StaticBody2D = null
	var extraBuddy: StaticBody2D = null
	var closestPosition: Vector2 = Vector2(100000, 100000)
	for beacon in potentialPrismBuddies:
		if global_position.distance_to(beacon.global_position) < global_position.distance_to(closestPosition):
			extraBuddy = beacon.find_child("Area2D").prismBuddies[0]
			if extraBuddy != null:
				if potentialPrismBuddies.find(extraBuddy) != -1:
					closestBuddy = beacon
					closestPosition = beacon.global_position
			else:
				closestBuddy = beacon
				closestPosition = beacon.global_position
	if potentialPrismBuddies.size() == 1:
		extraBuddy = null
	elif potentialPrismBuddies.size() < 1:
		closestBuddy = null
		extraBuddy = null
	prismBuddies[0] = closestBuddy
	prismBuddies[1] = extraBuddy
	#print(prismBuddies)
	DrawLinesToBuddies()

#making the lines always under the beacons would be a nice touch
func DrawLinesToBuddies():
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

func SetPrismBuddies():
	#this is what happens when the prism beacon is placed, so its attached to a signal
	if prismBuddies[0] != null: 
		var buddyOne: Area2D = prismBuddies[0].find_child("Area2D")
		buddyOne.UpdatePrismBuddiesTo(beacon, prismBuddies[1])
		buddyOne.DrawLinesToBuddies()
		if buddyOne.prismBuddies[1] != null:
			buddyOne.hasTwoBuddies = true
	if prismBuddies[1] != null:
		var buddyTwo: Area2D = prismBuddies[1].find_child("Area2D")
		buddyTwo.UpdatePrismBuddiesTo(beacon, prismBuddies[0])
		buddyTwo.DrawLinesToBuddies()
		if buddyTwo.prismBuddies[1] != null:
			buddyTwo.hasTwoBuddies = true
		hasTwoBuddies = true
	print(prismBuddies)

func UpdatePrismBuddiesTo(one: StaticBody2D, two: StaticBody2D):
	prismBuddies[0] = one
	prismBuddies[1] = two

func _on_prism_buddies_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("beacon") and body.beaconType == GlobalEnums.BeaconType.PRISM:
		if !body.find_child("Area2D").hasTwoBuddies:
			potentialPrismBuddies.append(body)

func _on_prism_buddies_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		potentialPrismBuddies.remove_at(potentialPrismBuddies.find(body))
