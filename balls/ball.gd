extends CharacterBody3D

const SPEED = 15

var direction = Vector3.ZERO

var player = null

func _physics_process(delta: float) -> void:
	# make sure ball is on the ground
	if is_on_floor() and velocity.y:
		velocity.y = 0
	elif !is_on_floor():
		velocity.y += get_gravity().y

	if player:
		#Puts the ball 2 meters infront of the player
		if player.velocity:
			#if the player is moving then put the ball infront of him
			direction = ((player.position + (player.direction * 0.8)) - position).normalized()
			velocity = direction * SPEED
		else:
			#otherwise stop the ball
			velocity = Vector3.ZERO

	move_and_slide()


func PlayerDetected(body: CharacterBody3D) -> void:
	#Player is trying to get the ball
	player = body
