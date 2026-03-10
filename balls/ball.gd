extends CharacterBody3D

const SPEED = 10
const FRICTION = 7

var direction = Vector3.ZERO

var player = null
var PrevPlayer = null


func _physics_process(delta: float) -> void:
	# make sure ball is on the ground
	if is_on_floor() and velocity.y:
		velocity.y = 0
	elif !is_on_floor():
		velocity.y += get_gravity().y

	if player:
		FollowPlayer()
		CheckInput()
	else:
		velocity = velocity.move_toward(Vector3(0, velocity.y, 0), FRICTION * delta)

	move_and_slide()

func FollowPlayer():
		#Puts the ball .8 meters infront of the player
		if player.velocity:
			#if the player is moving then put the ball infront of him
			direction = ((player.position + (player.direction * 0.8)) - position).normalized()
			velocity = direction * SPEED
		else:
			#otherwise stop the ball
			velocity = Vector3.ZERO

func CheckInput():
	if Input.is_action_just_pressed("shoot"):
		shoot(Vector3.ZERO)

func shoot(vel: Vector3):
	if player.controlled:
		velocity += player.direction * 30
		#velocity = vel
		player = null
		PrevPlayer = null
		$MonitoringTimer.start()

func PlayerDetected(body: CharacterBody3D) -> void:
	#Player is trying to get the ball
	#if a player just got the ball there is a cooldown before anyone else can take it from himdswwwwwwwww
	if $MonitoringTimer.time_left == 0 and body != PrevPlayer:
		$MonitoringTimer.start()
		player = body
		PrevPlayer = body
		print("cought the ball")


func _on_monitoring_timer_timeout() -> void:
	$PlayerDetect.monitoring = true
	PrevPlayer = null
