extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const WALL_JUMP_VELOCITY_X = 300.0  # Horizontal propulsion for wall jump
const WALL_JUMP_VELOCITY_Y = -350.0  # Vertical propulsion for wall jump

# Wall Collision Checkers
@onready var ray_cast_left = $RayCast2DLeft
@onready var ray_cast_right = $RayCast2DRight

# Timer for wall jump cooldown
@onready var time = $Timer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variables to control jumps
var can_double_jump = false
var can_wall_jump = true  # Track if wall jump is allowed
var last_wall_touched = ""  # Track which wall was last touched: "left" or "right"

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
    # Connect the Timer signal to handle the wall jump cooldown
    time.connect("timeout", Callable(self, "_on_wall_jump_cooldown_timeout"))

func _physics_process(delta):
    # Apply gravity when not on the floor
    if not is_on_floor():
        velocity.y += gravity * delta

    # Reset double jump and wall jump when on the floor
    if is_on_floor():
        can_double_jump = true
        can_wall_jump = true  # Reset wall jump when grounded
        last_wall_touched = ""  # Reset the last wall jumped from

    # Handle jump logic
    if Input.is_action_just_pressed("jump"):
        # Double Jump when not touching a wall
        if ray_cast_left.is_colliding() == false and ray_cast_right.is_colliding() == false:
            if is_on_floor():
                velocity.y = JUMP_VELOCITY
            elif can_double_jump:
                velocity.y = JUMP_VELOCITY
                can_double_jump = false  # Disable further double jump

        # Wall Jump when touching a wall
        elif can_wall_jump:
            if ray_cast_left.is_colliding():
                if last_wall_touched != "left":  # Prevent jumping twice from the same wall
                    wall_jump("left")
            elif ray_cast_right.is_colliding():
                if last_wall_touched != "right":  # Prevent jumping twice from the same wall
                    wall_jump("right")

    # Get the input direction: -1 is left, 1 is right.
    var direction = Input.get_axis("move_left", "move_right")

    # Flip the sprite based on the direction
    if direction < 0:
        animated_sprite.flip_h = true
    elif direction > 0:
        animated_sprite.flip_h = false

    # Apply horizontal movement only when not wall-jumping
    if is_on_floor() or (!ray_cast_left.is_colliding() and !ray_cast_right.is_colliding()):
        velocity.x = direction * SPEED

    # Play the appropriate animations
    if is_on_floor():
        if direction == 0:
            animated_sprite.play("idle")
        else:
            animated_sprite.play("run")
    else:
        animated_sprite.play("jump")

    move_and_slide()

# Function to handle wall jump logic
func wall_jump(side):
    velocity.y = WALL_JUMP_VELOCITY_Y  # Jump up
    if side == "left":
        velocity.x = WALL_JUMP_VELOCITY_X  # Propel right
        animated_sprite.flip_h = false  # Face right
        last_wall_touched = "left"  # Track the last wall jumped from
    elif side == "right":
        velocity.x = -WALL_JUMP_VELOCITY_X  # Propel left
        animated_sprite.flip_h = true  # Face left
        last_wall_touched = "right"  # Track the last wall jumped from

    time.start(0.3)  # Start the cooldown (adjust duration as needed)
    can_wall_jump = false  # Disable further wall jump temporarily

# Called when the wall jump cooldown timer completes
func _on_wall_jump_cooldown_timeout():
    can_wall_jump = true  # Re-enable wall jumping after the cooldown