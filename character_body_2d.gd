extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var _animated_sprite = $AnimatedSprite2D


func _ready():
	if Global.next_spawn_point != "":
		var spawn = get_parent().get_node_or_null(Global.next_spawn_point)
		if spawn:
			print("spawn")
			global_position = spawn.global_position
		else:
			print("no spawn")
	Global.next_spawn_point = ""
	
	
func _physics_process(delta):
	velocity = Vector2.ZERO

	velocity.x = Input.get_axis("ui_left", "ui_right") * 200
	velocity.y = Input.get_axis("ui_up", "ui_down") * 200

	if (velocity.x != 0 || velocity.y != 0):
		_animated_sprite.play("walk")
	else :
		_animated_sprite.stop()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("my position is::")
	print(position);
	print("body pos is " )
	print(body.position)
	if body == self:
		Global.next_spawn_point = "BedroomEntrance"
		get_tree().change_scene_to_file("res://scene2.tscn")

	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	pass # Replace with function body.
