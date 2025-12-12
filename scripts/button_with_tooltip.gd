extends Button

var tooltip: Label

func _ready() -> void:
	for child in find_children("*", "Label"):
		if child.name.contains("Tooltip"):
			tooltip = child
	mouse_entered.connect(ShowTooltip)
	mouse_exited.connect(HideTooltip)

func ShowTooltip():
	tooltip.visible = true

func HideTooltip():
	tooltip.visible = false
