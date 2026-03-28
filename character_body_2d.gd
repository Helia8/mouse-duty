extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	velocity = Vector2.ZERO

	velocity.x = Input.get_axis("ui_left", "ui_right") * 200
	velocity.y = Input.get_axis("ui_up", "ui_down") * 200

	move_and_slide()
