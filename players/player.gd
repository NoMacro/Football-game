extends CharacterBody3D

var speed = 6
var acceleration = 3
var RotationSpeed = 20

var state = StateMachine.idle
var HasBall = false

var direction = Vector3(0, 0, -1)
var InputDirection = Vector3(0, 0, -1)

@export var controlled: bool = false
@export var away: bool = false

enum StateMachine{
	idle, attacking, defending, GettingBall, scoring
}

func _ready() -> void:
	#sync_to_physics = false
	if controlled:
		Globals.ControlledPlayer = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if controlled:
		LookForInput()

	if away:
		AwayAI()
	elif !controlled:
		HomeAI()

	#make sure player is on floor other wise gravity does its work :D
	if is_on_floor() and velocity.y:
		velocity.y = 0
	elif !is_on_floor():
		velocity.y += get_gravity().y
	move_and_slide()

func FindPlayerToPass():
	#finding players in my direction to pass the ball
	var PlayersInfrontOfMe = null
	var DirectionCounter = -2
	var ComparedDirection = -2

	for p in get_parent().get_children():
		if p != Globals.PlayerWithBall and position.distance_to(p.position) < 1000:
			ComparedDirection = direction.dot(position.direction_to(p.position).normalized())
			if ComparedDirection > DirectionCounter:
				DirectionCounter = ComparedDirection
				PlayersInfrontOfMe = p

	return PlayersInfrontOfMe


func AwayAI():
	if Globals.BallIsHome:
		if position.distance_to(Globals.ball.position) < 25:
			state = StateMachine.GettingBall
		else:
			state = StateMachine.defending
	else:
		if Globals.PlayerWithBall:
			if Globals.PlayerWithBall == self:
				state = StateMachine.scoring
			else:
				state = StateMachine.attacking
		else:
			if Globals.PrevPlayerWithBall == self:
				state = StateMachine.idle
			else:
				state = StateMachine.GettingBall

	match state:
		StateMachine.GettingBall:
				velocity = position.direction_to(Globals.ball.position) * speed
		StateMachine.idle:
			velocity = Vector3.ZERO
		StateMachine.defending:
			velocity = Vector3.ZERO
		StateMachine.attacking:
			velocity = Vector3.ZERO
		StateMachine.scoring:
			var NearestFriend: CharacterBody3D = GetNearestPlayer(position, Globals.AwayPlayers)
			var NearestEnemy: CharacterBody3D = GetNearestPlayer(position, Globals.HomePlayers)
			#print(position.distance_to(NearestEnemy.position))

			if position.distance_to(NearestEnemy.position) < 10:
				Globals.ball.PassBall(20)

			velocity = Vector3.ZERO



func HomeAI():
	if !Globals.BallIsHome or !Globals.PlayerWithBall:
		state = StateMachine.GettingBall
	else:
		state = StateMachine.idle

	match state:
		StateMachine.GettingBall:
				#velocity = position.direction_to(Globals.ball.position) * speed
				velocity = Vector3.ZERO
		StateMachine.idle:
			velocity = Vector3.ZERO
		StateMachine.attacking:
			pass
		StateMachine.defending:
			pass
		StateMachine.scoring:
			pass

func GetNearestPlayer(PlayerPos, players: Node3D):
	var NearestPlayer = null
	var DistanceCounter = 1000
	var ComparedDistance = 1000

	for p in players.get_children():
		#if p.controlled == false:
		if p != self:
		
			ComparedDistance = position.distance_to(p.position)
			if ComparedDistance < DistanceCounter:
				DistanceCounter = ComparedDistance
				NearestPlayer = p
	return NearestPlayer


func LookForInput():
	#look for movement keys
	InputDirection.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	InputDirection.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	InputDirection = InputDirection.normalized()
	velocity = InputDirection.normalized() * speed
	
	if InputDirection:
		#if there is input change direction towards the input
		direction = InputDirection
