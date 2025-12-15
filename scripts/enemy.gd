extends CharacterBody2D

signal on_death

var currentTarget: Node2D
var isInRangeOfTarget: bool = false
var isCollidingWithBeacon: bool = false
var beaconInTheWay: StaticBody2D = null
var stuckPosition: Vector2
var collisionPatienceTimer: SceneTreeTimer = null
@export var maxHealth: int = 40
var currentHealth: int
@export var moveSpeed: float = 10
@export var minimumSpeed: float = 5
var speedReduction: float = 0
@export var range: float = 20
@export var attackDamage: int = 10
@export var attackSpeed: float = 1.2
@export var seeksHeartfire: bool
@export var hasFacing: bool = false
@export var collisionPatience: float = 3
var targetableBeacons: Array[StaticBody2D]

@onready var lightburnStatus: PackedScene = preload("res://scenes/StatusEffects/lightburn_status.tscn")
@onready var lightburnSprite: Sprite2D = $LightburnSprite2D
@onready var collisionShape = $CollisionShape2D.shape

func _ready() -> void:
	currentHealth = maxHealth
	FindTarget()

func _physics_process(delta: float) -> void:
	var totalSpeed: float = moveSpeed - speedReduction
	if totalSpeed < minimumSpeed:
		totalSpeed = minimumSpeed
	#print(str(self.name) + " speed is " + str(totalSpeed))
	if currentTarget != null:
		if global_position.distance_to(currentTarget.global_position) > range:
			velocity = global_position.direction_to(currentTarget.global_position) * totalSpeed
			isInRangeOfTarget = false
		else:
			velocity = Vector2.ZERO
			isInRangeOfTarget = true
	else:
		velocity = Vector2.ZERO
		isInRangeOfTarget = false
	
	var collided: bool = move_and_slide()
	if collided:
		var collision = get_last_slide_collision()
		if collision.get_collider().is_in_group("beacon"):
			beaconInTheWay = collision.get_collider()
			if !isCollidingWithBeacon and collisionPatienceTimer == null:
				collisionPatienceTimer = get_tree().create_timer(collisionPatience)
				collisionPatienceTimer.timeout.connect(CollisionPatienceTimeout)
				stuckPosition = global_position
			isCollidingWithBeacon = true
	else:
		if isCollidingWithBeacon:
			isCollidingWithBeacon = false
			beaconInTheWay = null

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
	#I think I need a find target behavior in the process function
		#I want it to update when a beacon wakes up nearby, they need to react in real time
		#the trick is making this lightweight in the process function

func FindTarget():
	if currentTarget != null:
		currentTarget.on_destroyed.disconnect(FindTarget)
	var newTarget
	#sets up dummy tower to compare against
	var closestTarget: Vector2 = Vector2(10000000000, 10000000000)
	var closestAllure: float = 1
	#creates array of towers and removes dormant ones
	var targets = get_tree().get_nodes_in_group("beacon")
	for beacon in targets:
		if beacon.isDestroyed or beacon.isBeingPlaced:
			targets.remove_at(targets.find(beacon))
	for beacon in targets:
		#weighs the search based on enemy personality
		var allureMultiplier: float = 1
		if seeksHeartfire:
			if beacon.beaconType == GlobalEnums.BeaconType.HEARTFIRE:
				allureMultiplier = 5
			else:
				allureMultiplier = 0.2
		else:
			if beacon.beaconType == GlobalEnums.BeaconType.HEARTFIRE:
				allureMultiplier = 0.4
			else:
				allureMultiplier = 1
		if beacon == beaconInTheWay and beacon == currentTarget:
			allureMultiplier = 200
		#compares beacon distances divided by allure (smaller value wins)
		var allureToCheck: float = beacon.allure * allureMultiplier
		if(beacon.global_position.distance_to(global_position) / allureToCheck) < (closestTarget.distance_to(global_position) / closestAllure):
			if !beacon.isDestroyed:
				newTarget = beacon
				closestTarget = beacon.global_position
				closestAllure = allureToCheck
	currentTarget = newTarget
	if currentTarget != null:
		currentTarget.on_destroyed.connect(FindTarget)
	else:
		print("no more targets")

func CollisionPatienceTimeout():
	#still not working but cool ideas
	var acceptableDistance: float = collisionShape.radius * 2
	if isCollidingWithBeacon and global_position.distance_to(stuckPosition) < acceptableDistance:
		currentTarget.on_destroyed.disconnect(FindTarget)
		currentTarget = beaconInTheWay
		currentTarget.on_destroyed.connect(FindTarget)
		print("fuck this beacon!")
	else: beaconInTheWay = null

func UpdateTargetableBeacons():
	pass #this will update the array targetableBeacons
	#get all beacons
	#if its not destroyed or being placed
	#if its not too far except heartfire
	#add it to targetable beacons

func AttackTarget():
	if currentTarget != null:
		currentTarget.TakeDamage(attackDamage)
	#this might end up being an animation thing but for now it good
	#yes, because you can call functions in specific frames of an animation
	
func TakeDamage(damage: int):
	currentHealth -= damage
	print (str(self.name) + " took " + str(damage) + " damage")
	if currentHealth <= 0:
		currentHealth = 0
		Die()

func Die():
	#emits signal that tells all targeting towers to remove this enemy
	on_death.emit()
	call_deferred("queue_free")

func GetBurned(burnDamage: int):
	if find_child("LightburnStatus") == null:
		var newStatus = lightburnStatus.instantiate()
		add_child(newStatus)
		newStatus.timeout.connect(TakeDamage.bind(burnDamage))
		newStatus.effect_end.connect(EndLightburnEffect)
		lightburnSprite.visible = true
	else:
		ResetBurnCounter()

func ResetBurnCounter():
	var burnStatus = $LightburnStatus
	if burnStatus != null:
		burnStatus.effectEndCounter = burnStatus.effectEndStartingValue

func EndLightburnEffect():
	lightburnSprite.visible = false
