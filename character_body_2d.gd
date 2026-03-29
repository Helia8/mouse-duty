extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var _animated_sprite = $AnimatedSprite2D
var curr_interaction_area = ""
var current_interactable: Area2D = null
var is_interacting = false

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

func _process(delta):
	var interacted = Input.is_key_pressed(KEY_E)
	if (!interacted || is_interacting):
		return
	if curr_interaction_area == "computer":
		print("computer interacted")
		is_interacting = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		Global.next_spawn_point = "BedroomEntrance"
		get_tree().change_scene_to_file("res://scene2.tscn")

	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	pass # Replace with function body.


func _on_interaction_area_interacted_computer(body: Variant) -> void:
	curr_interaction_area = "computer"
	print("computer area")
	
	pass # Replace with function body.


func _on_maintenance_teleport_body_entered(body: Node2D) -> void:
	if body == self:
		Global.next_spawn_point = "MaintenanceEntrance"
		get_tree().change_scene_to_file("res://scene3.tscn")
	pass # Replace with function body.
