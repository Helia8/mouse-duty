extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var _animated_sprite = $AnimatedSprite2D
var current_interactable: Area2D = null

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

func _input(event):
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if event.keycode != KEY_E or current_interactable == null:
		return

	var tag = current_interactable.get_meta("interaction_tag", "")
	if tag == "boiler":
		_use_boiler()

func _use_boiler() -> void:
	if not Global.use_action():
		return  # out of actions
	Global.boiler_charge = mini(Global.boiler_charge + 1, Global.BOILER_MAX_CHARGE)
	# Darkness resolution
	if Global.darkness_active and Global.flashlight_object == "boiler":
		Global.resolve_darkness()

func _on_main_room_teleport_body_entered(body: Node2D) -> void:
	if body == self:
		Global.next_spawn_point = "MaintenanceEntrance"
		get_tree().change_scene_to_file("res://scene1.tscn")
