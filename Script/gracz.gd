extends CharacterBody3D

var ogSPEED
var SPEED = 3.0
var wyczerpanie = 0.45
var odpoczynek = 0.2
var superodpoczynek = 0.5
var SprintSPEED = 5.0
const JUMP_VELOCITY = 3.5


var stamina


func _ready():
	ogSPEED = SPEED
	stamina = get_node("/root/" + get_tree().current_scene.name+ "/dupa/stamina")

func _process(delta):
		if SPEED == SprintSPEED:
			stamina.value = stamina.value - wyczerpanie * delta
		if stamina.value == stamina.min_value:
			SPEED = ogSPEED
		if SPEED != SprintSPEED:
			if stamina.value < stamina.max_value:
				stamina.value = stamina.value + odpoczynek * delta
			if stamina.value == stamina.max_value:
				stamina.visible = false
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("gora") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("lewo", "prawo", "przod", "tyl")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		if Input.is_action_just_pressed("sprint"):
			stamina.visible = true
			SPEED = SprintSPEED
		if Input.is_action_just_released("sprint"):
			SPEED = ogSPEED
			
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
