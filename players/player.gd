extends CharacterBody3D

var speed = 6
var acceleration = 3
var RotationSpeed = 20

var direction = Vector3(0, 0, -1)
var InputDirection = Vector3(0, 0, -1)



@export var controlled: bool = false

func _ready() -> void:
	#sync_to_physics = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if controlled:
		LookForInput()
		

	#make sure player is on floor other wise gravity does its work :D
	if is_on_floor() and velocity.y:
		velocity.y = 0
	elif !is_on_floor():
		velocity.y += get_gravity().y
	
	
	move_and_slide()

func FindPlayerToPass():
	print("Passing the ball")
	var PlayersInfrontOfMe = null
	var DirectionCounter = -2
	var ComparedDirection = -2

	for p in get_parent().get_children():
		if p.controlled == false and position.distance_to(p.position) < 35:
			ComparedDirection = direction.dot(position.direction_to(p.position).normalized())
			if ComparedDirection > DirectionCounter:
				DirectionCounter = ComparedDirection
				PlayersInfrontOfMe = p

	return PlayersInfrontOfMe

func LookForInput():
	#look for movement keys
	InputDirection.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	InputDirection.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	InputDirection = InputDirection.normalized()
	velocity = InputDirection.normalized() * speed
	
	if InputDirection:
		#if there is input change direction towards the input
		direction = InputDirection
