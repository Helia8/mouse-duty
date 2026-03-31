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
			global_position = spawn.global_position
	Global.next_spawn_point = ""
	_build_walk_animations()

func _build_walk_animations() -> void:
	var sf = SpriteFrames.new()
	for dir in ["walk_down", "walk_up", "walk_left", "walk_right"]:
		sf.add_animation(dir)
		sf.set_animation_loop(dir, true)
		sf.set_animation_speed(dir, 8.0)
		for i in range(8):
			var tex = load("res://sprites/walk/%s_%02d.png" % [dir, i]) as Texture2D
			if tex:
				sf.add_frame(dir, tex)
	_animated_sprite.sprite_frames = sf
	_animated_sprite.animation = "walk_down"

func _physics_process(_delta):
	var vx = Input.get_axis("ui_left", "ui_right")
	var vy = Input.get_axis("ui_up", "ui_down")
	velocity = Vector2(vx, vy) * 200

	if velocity.length() > 0:
		if abs(vx) >= abs(vy):
			_animated_sprite.play("walk_right" if vx > 0 else "walk_left")
		else:
			_animated_sprite.play("walk_down" if vy > 0 else "walk_up")
	else:
		_animated_sprite.stop()
	move_and_slide()

func _process(delta):
	var interacted = Input.is_key_pressed(KEY_E)
	if (!interacted || is_interacting):
		return
	if curr_interaction_area == "computer":
		print("computer interacted")
		get_tree().change_scene_to_file("res://MainMonitorMenu.tscn")
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
