extends CanvasLayer

var day_label: Label
var energy_label: Label
var ap_label: Label
var tasks_label: Label
var events_label: Label
var darkness_overlay: ColorRect
var overlay_panel: ColorRect
var overlay_label: Label
var restart_button: Button
var game_over: bool = false

func _ready() -> void:
	layer = 10

	# Darkness overlay — rendered first so HUD panel sits on top
	darkness_overlay = ColorRect.new()
	darkness_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	darkness_overlay.color = Color(0.0, 0.0, 0.05, 0.82)
	darkness_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	darkness_overlay.visible = false
	add_child(darkness_overlay)

	# Stats panel
	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.position = Vector2(16, 16)
	add_child(panel)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	day_label = Label.new()
	day_label.add_theme_font_size_override("font_size", 17)
	vbox.add_child(day_label)

	energy_label = Label.new()
	energy_label.add_theme_font_size_override("font_size", 17)
	vbox.add_child(energy_label)

	ap_label = Label.new()
	ap_label.add_theme_font_size_override("font_size", 17)
	vbox.add_child(ap_label)

	tasks_label = Label.new()
	tasks_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(tasks_label)

	events_label = Label.new()
	events_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(events_label)

	# Win/lose overlay
	overlay_panel = ColorRect.new()
	overlay_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_panel.color = Color(0, 0, 0, 0.78)
	overlay_panel.visible = false
	add_child(overlay_panel)

	overlay_label = Label.new()
	overlay_label.set_anchors_preset(Control.PRESET_CENTER)
	overlay_label.add_theme_font_size_override("font_size", 36)
	overlay_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_label.position = Vector2(-200, -60)
	overlay_panel.add_child(overlay_label)

	restart_button = Button.new()
	restart_button.text = "Restart"
	restart_button.set_anchors_preset(Control.PRESET_CENTER)
	restart_button.position = Vector2(-60, 20)
	restart_button.add_theme_font_size_override("font_size", 22)
	restart_button.pressed.connect(_on_restart)
	overlay_panel.add_child(restart_button)

func _process(_delta: float) -> void:
	if game_over:
		return

	day_label.text = "Day: %d / %d" % [Global.current_day, Global.MAX_DAYS]
	energy_label.text = "Energy: %d%%" % [int(Global.energy)]

	var ap_text = "Actions: %d / %d" % [Global.action_points, Global.get_max_actions()]
	if Global.action_points == 0:
		ap_text += "  [NO ACTIONS]"
	ap_label.text = ap_text

	var done = Global.tasks_done_today.size()
	var total = Global.ALL_TASKS.size()
	tasks_label.text = "Tasks: %d / %d" % [done, total]

	# Events line
	var ev: Array = []
	if Global.rat_event_active:
		ev.append("RATS!")
	if Global.darkness_active:
		ev.append("DARK - flashlight: " + Global.flashlight_object)
	if Global.coldfront_active:
		var prot = " (boiler: %d/3)" % Global.boiler_charge
		ev.append("COLDFRONT" + prot)
	elif Global.boiler_charge > 0:
		ev.append("Boiler: %d/3" % Global.boiler_charge)
	events_label.text = " | ".join(ev)

	darkness_overlay.visible = Global.darkness_active

	if Global.energy <= 0:
		_show_overlay("POWER FAILURE\nYou didn't survive.")
	elif Global.current_day > Global.MAX_DAYS:
		_show_overlay("SHIFT COMPLETE\nYou made it 30 days!")

func _show_overlay(message: String) -> void:
	game_over = true
	overlay_label.text = message
	overlay_panel.visible = true

func _on_restart() -> void:
	game_over = false
	overlay_panel.visible = false
	Global.current_day = 1
	Global.energy = 100.0
	Global.tasks_done_today = []
	Global.next_spawn_point = ""
	Global.action_points = Global.DEFAULT_MAX_ACTIONS
	Global.rat_count = 0
	Global.rat_event_active = false
	Global.rat_escalation = 1.0
	Global.darkness_active = false
	Global.coldfront_active = false
	Global.boiler_charge = 0
	Global.flashlight_object = Global.FLASHLIGHT_OBJECTS[randi() % Global.FLASHLIGHT_OBJECTS.size()]
	get_tree().change_scene_to_file("res://scene1.tscn")
