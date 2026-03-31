extends CharacterBody2D

var cur_button = ""

var reading_labels: Dictionary = {}

const READING_DATA = {
	"energy": {"task": "energy_reading", "label_text": "Solar output: %.1f kWh"},
	"wind":   {"task": "wind_reading",   "label_text": "Wind speed: %.1f km/h"},
	"temp":   {"task": "temp_reading",   "label_text": "Temperature: %.1f °C"},
	"meteo":  {"task": "meteo_reading",  "label_text": "Cloud cover: %d%%"},
}

func _ready() -> void:
	for key in READING_DATA:
		var lbl = Label.new()
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.visible = false
		add_child(lbl)
		reading_labels[key] = lbl

func _show_reading(key: String, area_node: Area2D) -> void:
	var data = READING_DATA[key]
	var lbl: Label = reading_labels[key]
	var val = randf_range(0.1, 99.9)
	if key == "meteo":
		lbl.text = data["label_text"] % [int(val)]
	else:
		lbl.text = data["label_text"] % [val]
	if "energy_reading" in Global.tasks_done_today:
		pass  # already done, text will say same value — that's fine
	lbl.position = area_node.position + Vector2(-30, -30)
	lbl.visible = true

func _hide_reading(key: String) -> void:
	reading_labels[key].visible = false

func _try_complete_reading(key: String) -> void:
	var task = READING_DATA[key]["task"]
	if task in Global.tasks_done_today:
		return  # already done, no cost
	if not Global.use_action():
		return  # out of actions
	Global.complete_task(task)
	_hide_reading(key)
	cur_button = ""

# --- Energy Reading ---
func _on_energy_reading_mouse_entered() -> void:
	cur_button = "energy"
	_show_reading("energy", get_parent().get_node("EnergyReading"))

func _on_energy_reading_mouse_exited() -> void:
	if cur_button == "energy": cur_button = ""
	_hide_reading("energy")

# --- Wind Reading ---
func _on_wind_reading_mouse_entered() -> void:
	cur_button = "wind"
	_show_reading("wind", get_parent().get_node("WindReading"))

func _on_wind_reading_mouse_exited() -> void:
	if cur_button == "wind": cur_button = ""
	_hide_reading("wind")

# --- Temperature Reading ---
func _on_temp_reading_mouse_entered() -> void:
	cur_button = "temp"
	_show_reading("temp", get_parent().get_node("TemperatureReading"))

func _on_temp_reading_mouse_exited() -> void:
	if cur_button == "temp": cur_button = ""
	_hide_reading("temp")

# --- Meteo Reading ---
func _on_meteo_reading_mouse_entered() -> void:
	cur_button = "meteo"
	_show_reading("meteo", get_parent().get_node("MeteoReading"))

func _on_meteo_reading_mouse_exited() -> void:
	if cur_button == "meteo": cur_button = ""
	_hide_reading("meteo")

# --- Exit ---
func _on_exit_menu_mouse_entered() -> void:
	cur_button = "exit"

func _on_exit_menu_mouse_exited() -> void:
	if cur_button == "exit": cur_button = ""

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		match cur_button:
			"exit":
				get_tree().change_scene_to_file("res://scene1.tscn")
			"energy":
				_try_complete_reading("energy")
			"wind":
				_try_complete_reading("wind")
			"temp":
				_try_complete_reading("temp")
			"meteo":
				_try_complete_reading("meteo")

func _process(_delta):
	pass
