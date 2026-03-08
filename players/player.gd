extends CharacterBody3D

var speed = 6
var acceleration = 3
var RotationSpeed = 20

var direction = Vector3(0, 0, -1)
var MouseDirection = Vector2(0, 0)

func _ready() -> void:
	#sync_to_physics = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#find velocity
	velocity.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity = velocity.normalized() * speed
	
	move_and_slide()
