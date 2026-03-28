extends Area2D
@onready var sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.visible = false;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func near_computer_enter(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	sprite.visible = true
	print("true")
	pass # Replace with function body.


func near_computer_exit(body: Node2D) -> void:
	sprite.visible = false
	pass # Replace with function body.
