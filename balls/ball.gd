extends CharacterBody3D

const SPEED = 10
const FRICTION = 7
const DistanceInfrontPlayer = 0.8

const SHOOTSPEED = 25
const PASSSPEED = 20

var direction = Vector3.ZERO
var PositionInfrontPlayer = Vector3.ZERO

var player = null
var PrevPlayer = null


func _physics_process(delta: float) -> void:
	# make sure ball is on the ground
	if is_on_floor() and velocity.y:
		velocity.y = 0
	elif !is_on_floor():
		velocity.y += get_gravity().y * delta

	if player:
		FollowPlayer()
		CheckInput()
	else:
		velocity = velocity.move_toward(Vector3(0, velocity.y, 0), FRICTION * delta)

	move_and_slide()

func FollowPlayer():
		#Puts the ball .8 meters infront of the player
		PositionInfrontPlayer = player.position + (player.direction * DistanceInfrontPlayer)
		if player.velocity:
			#if the player is moving then put the ball infront of him
			#direction = ((player.position + (player.direction * DistanceInfrontPlayer)) - position).normalized()
			direction = position.direction_to(PositionInfrontPlayer)
			velocity = direction * SPEED
		else:
			#otherwise stop the ball
			if position.distance_to(PositionInfrontPlayer) > 0.1:
				direction = position.direction_to(PositionInfrontPlayer)
				velocity = direction * SPEED
			else:
				velocity = Vector3.ZERO

func CheckInput():
	if Input.is_action_just_pressed("shoot"):
		shoot(Vector3.ZERO)
	if Input.is_action_just_pressed("pass"):
		PassBall(Vector3.ZERO, Vector3.ZERO)

func shoot(vel: Vector3):
	if player.controlled:
		velocity += player.direction * SHOOTSPEED
		#velocity = vel
		player = null
		Globals.PlayerWithBall = null

		#PrevPlayer = null
		$MonitoringTimer.start()

#Will work on passing later 
func PassBall(vel: Vector3, dir: Vector3):
	if player.controlled:
		#if someone is conrolling the ball
		var p = player.FindPlayerToPass()
		#find the player to pass to
		if p:
			#get the direction to player and pass 
			velocity += position.direction_to(p.position).normalized() * PASSSPEED
			##velocity = vel
			player = null
			Globals.PlayerWithBall = null
			##PrevPlayer = null
			$MonitoringTimer.start()

func PlayerDetected(body: CharacterBody3D) -> void:
	#Player is trying to get the ball
	#if a player just got the ball there is a cooldown before anyone else can take it from himdswwwwwwwww
	if $MonitoringTimer.time_left == 0:
		$MonitoringTimer.start()
		player = body
	
		if !body.away:
			Globals.ControlledPlayer.controlled = false

			if PrevPlayer:
				#if someone else gets the ball, control that other player and put the previous player in idle
				PrevPlayer.controlled = false
				PrevPlayer.velocity = Vector3.ZERO
		
			PrevPlayer = body
			Globals.PlayerWithBall = body
			Globals.ControlledPlayer = body
			Globals.BallIsHome = true
			body.controlled = true

		else:
			Globals.BallIsHome = false


func _on_monitoring_timer_timeout() -> void:
	#Ball stays for atlest 2 sec (timer ends) untill another player can take itsd
	$PlayerDetect.monitoring = true
