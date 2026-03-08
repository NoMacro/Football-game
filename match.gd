extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#make the camera follow the player
	$Camera3D.look_at($player.position)

func _input(event):
	#esc button quits the game
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
