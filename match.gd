extends Node3D

const CameraSpeed = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.HomePlayers = $home
	Globals.AwayPlayers = $away
	Globals.ball = $ball


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#make the camera follow the player
	$Camera3D.position = $Camera3D.position.move_toward(
		Vector3($ball.position.x, $Camera3D.position.y, $Camera3D.position.z), CameraSpeed * delta)
	$Camera3D.look_at($ball.position)
	$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _input(event):
	#esc button quits the game
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("ui_text_backspace"):
		get_tree().reload_current_scene()
	
	#Switch players
	if Input.is_action_just_pressed("pass"):
		if Globals.BallIsHome and Globals.PlayerWithBall:
			return
		var PlayersInfrontOfMe = null
		var DirectionCounter = -2
		var ComparedDirection = -2
		var ControlledPlayer: CharacterBody3D = null

		for p in $home.get_children():
			if p.controlled:
				ControlledPlayer = p
			
		for p in $home.get_children():
			if p.controlled == false:
				ComparedDirection = ControlledPlayer.direction.dot(position.direction_to(p.position).normalized())
				if ComparedDirection > DirectionCounter:
					DirectionCounter = ComparedDirection
					PlayersInfrontOfMe = p

		PlayersInfrontOfMe.controlled = true
		ControlledPlayer.controlled = false
		ControlledPlayer.velocity = Vector3.ZERO
		Globals.ControlledPlayer = PlayersInfrontOfMe
