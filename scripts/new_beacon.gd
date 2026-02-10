extends AnimatableBody2D

signal on_destroyed
signal on_placed

@export var is_being_placed: bool = false

@export var nearbyBeaconRadius: float = 80
@export var maxHealth: int = 100
@export var allure: float = 10
@export var dimColor: Color = Color(1, 1, 1, 0.4)
@export var distanceNeededToPlace: float = 40
@export var beaconType: GlobalEnums.BeaconType
#don't forget to update beacon types and remove basic (keep charge for now)
var currentHealth: int
var isBeingPlaced: bool = false
var tooCloseToOthers: bool = false
var baseColor: Color

var nearbyBeacons: Array[AnimatableBody2D]

var nearbyBeaconShape: Shape2D

func _ready() -> void:
	nearbyBeaconShape = find_child("NearbyBeaconShape2D").shape
	nearbyBeaconShape.radius = nearbyBeaconRadius
	baseColor = $Sprite2D.modulate

func _physics_process(delta: float) -> void:
	if is_being_placed:
		global_position = get_global_mouse_position()

func _process(delta: float) -> void:
	if isBeingPlaced:
		var noneTooClose: bool = true
		for beacon in nearbyBeacons:
			var distanceNeeded: float = distanceNeededToPlace
			if beacon.beaconType == GlobalEnums.BeaconType.HEARTFIRE:
				distanceNeeded = distanceNeededToPlace * 2
			if global_position.distance_to(beacon.global_position) < distanceNeeded:
				#this section is missing something, the print statement is never triggering
				print("get away from meeeeee")
				tooCloseToOthers = true
				$Sprite2D.modulate = dimColor
				noneTooClose = false
		if noneTooClose:
			tooCloseToOthers = false
			$Sprite2D.modulate = baseColor

func OnPlaced():
	print(self.name + " was just placed :)")
	currentHealth = maxHealth
	isBeingPlaced = false
	on_placed.emit()

func TakeDamage(damage: int):
	currentHealth -= damage
	if currentHealth <= 0:
		currentHealth = 0
		on_destroyed.emit()
		#what if the destroyed beacons gave you a little charge back?
		if beaconType == GlobalEnums.BeaconType.HEARTFIRE:
			get_node("%LevelManager").GameEnd(false)
	else:
		pass
		#animPlayer.stop()
		#animPlayer.play("take_damage")

func _on_nearby_beacon_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("beacon") and body != self:
		nearbyBeacons.append(body)
		print(nearbyBeacons)


func _on_nearby_beacon_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		nearbyBeacons.remove_at(nearbyBeacons.find(body))
		print(nearbyBeacons)
