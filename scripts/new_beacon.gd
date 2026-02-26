extends AnimatableBody2D

signal on_destroyed
signal on_placed
signal update_nearby_beacons

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
	on_placed.connect(OnPlaced)
	nearbyBeaconShape = find_child("NearbyBeaconShape2D").shape
	nearbyBeaconShape.radius = nearbyBeaconRadius
	baseColor = $Sprite2D.modulate

func _process(delta: float) -> void:
	if isBeingPlaced:
		#this assumes that nearbyRadius is bigger than distanceNeededToPlace
		#i think I'm ok with that but I wanna remember
		for beacon in nearbyBeacons:
			var distanceNeeded: float = distanceNeededToPlace
			if beacon.beaconType == GlobalEnums.BeaconType.HEARTFIRE:
				distanceNeeded = distanceNeededToPlace * 2
			if global_position.distance_to(beacon.global_position) < distanceNeeded:
				if tooCloseToOthers == false:
					print("get away from meeeeee")
				tooCloseToOthers = true
				$Sprite2D.modulate = dimColor
			else:
				tooCloseToOthers = false
				$Sprite2D.modulate = baseColor

func OnPlaced():
	#print(self.name + " was just placed :)")
	currentHealth = maxHealth
	isBeingPlaced = false

func TakeDamage(damage: int):
	currentHealth -= damage
	if currentHealth <= 0:
		currentHealth = 0
		on_destroyed.emit()
		#what if the destroyed beacons gave you a little charge back?
		if beaconType == GlobalEnums.BeaconType.HEARTFIRE:
			get_node("%LevelManager").GameEnd(false)
		call_deferred("queue_free")
	else:
		pass
		#animPlayer.stop()
		#animPlayer.play("take_damage")

func _on_nearby_beacon_area_2d_body_entered(body: Node2D) -> void:
	#so basically, this is only working when the sun beacon is the moving body
	#because it is an animatableBody2D
	#so if I update multiple beacons to have that base type it should work?
	if body.is_in_group("beacon") and body != self:
		nearbyBeacons.append(body)
		update_nearby_beacons.emit()
		print(body.name + " nearby")

func _on_nearby_beacon_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("beacon"):
		nearbyBeacons.remove_at(nearbyBeacons.find(body))
		update_nearby_beacons.emit()
		print(body.name + " left")
