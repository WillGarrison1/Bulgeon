extends CharacterBody2D

# Generic player stuff
var isMoving: bool = false
var isChargingAttack: bool = false # Is player charging up an attack
var isDoingAttack: bool = false
var lastDir: float = 1 # The last direction the player moved, used for deciding which way to roll
@onready var player = %Player

@export_category("Movement")
@export var maxSpeed: float
@export var acceleration: float
@export var jumpForce: float
@export var jumpHoldDur: float
@export var drag: float # Note: Currently drag only affects horizontal movement

var jumpCurrentHold=0.0

func handle_move(delta):
	if !isMoving:
		velocity.x /= (1+drag*delta)
	# Prevent player from moving when charging an attack or preforming an attack
	if !isChargingAttack and !isDoingAttack:
		# Apply drag only if the player isn't pressing move buttons
		if !isMoving:
			velocity.x /= (1+drag*delta)
			
		
		# Horizontal player movement
		var direction = Input.get_axis("move_left","move_right")
		
		# If the player is pressing move_left or move_right buttons
		if !player.isHurt:
			if direction:
				# Update velocity
				# Move toward increments the velocity by acceleration while also maxing it at maxSpeed
				velocity.x = direction*min(maxSpeed, abs(velocity.x)+acceleration)
				# Update last dir variable
				isMoving = true
				lastDir = direction
			else:
				isMoving = false
		else:
			isMoving = false
		
		# Player jump
		# Applies jump force until player releases or the jump hold excedes the max hold
		# (Jump hold is how long you can hold the jump button and it will keep applying the jump velocity and increasing it)
		if Input.is_action_pressed("jump"):
			if is_on_floor() or (jumpCurrentHold!=0 and jumpCurrentHold<jumpHoldDur):
				velocity.y = -jumpForce
				jumpCurrentHold += delta
		else:
			jumpCurrentHold = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
