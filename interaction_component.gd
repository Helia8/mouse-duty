extends Area2D

@onready var sprite = $InteractionPromptAnimatedSprite
signal interacted(body)
@export var auto_enable := true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.visible = false;
	if auto_enable:
		monitoring = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func interaction_area_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	sprite.visible = true
	pass # Replace with function body.


func interaction_area_exited(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	sprite.visible = false
	pass # Replace with function body.
	
func interact(body):
	emit_signal("interacted", body)
