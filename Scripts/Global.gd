extends Node

# --- Scene transition ---
var next_spawn_point: String = ""

# --- Day / Energy ---
var current_day: int = 1
var energy: float = 100.0
var tasks_done_today: Array = []

const MAX_DAYS: int = 30
const MAX_ENERGY: float = 100.0
const ENERGY_DRAIN_PER_DAY: float = 20.0
const ENERGY_PER_TASK: float = 12.0
const ALL_TASKS: Array = ["energy_reading", "wind_reading", "temp_reading", "meteo_reading"]

# --- Action points ---
var action_points: int = 5
const DEFAULT_MAX_ACTIONS: int = 5
const COLDFRONT_MAX_ACTIONS: int = 3
const DARKNESS_ENERGY_PER_ACTION: float = 4.0

# --- Rat event ---
var rat_count: int = 0
var rat_event_active: bool = false
var rat_escalation: float = 1.0   # grows after each event
const RAT_SPAWN_BASE_CHANCE: float = 0.6
const RAT_EVENT_THRESHOLD: int = 3

# --- Darkness event ---
var darkness_active: bool = false
var flashlight_object: String = "beanbag"  # object with flashlight today
const DARKNESS_CHANCE: float = 0.2
const FLASHLIGHT_OBJECTS: Array = ["beanbag", "boiler"]

# --- Coldfront event ---
var coldfront_active: bool = false
var boiler_charge: int = 0
const BOILER_MAX_CHARGE: int = 3
const BOILER_DECAY_CHANCE: float = 0.25
const COLDFRONT_CHANCE: float = 0.2

func _ready() -> void:
	flashlight_object = FLASHLIGHT_OBJECTS[randi() % FLASHLIGHT_OBJECTS.size()]

func get_max_actions() -> int:
	if coldfront_active and boiler_charge == 0:
		return COLDFRONT_MAX_ACTIONS
	return DEFAULT_MAX_ACTIONS

# Returns false if no actions remain (caller should block the interaction).
func use_action() -> bool:
	if action_points <= 0:
		return false
	action_points -= 1
	if darkness_active:
		energy = maxf(energy - DARKNESS_ENERGY_PER_ACTION, 0.0)
	return true

func resolve_darkness() -> void:
	darkness_active = false

func complete_task(task_name: String) -> void:
	if task_name in tasks_done_today:
		return
	tasks_done_today.append(task_name)
	energy = minf(energy + ENERGY_PER_TASK, MAX_ENERGY)

func all_tasks_done() -> bool:
	for t in ALL_TASKS:
		if not t in tasks_done_today:
			return false
	return true

func advance_day() -> void:
	# --- Resolve rat event on sleep ---
	if rat_event_active:
		rat_event_active = false
		rat_count = 0
		rat_escalation *= 1.5

	# --- Increment day & drain energy ---
	tasks_done_today = []
	current_day += 1
	energy = maxf(energy - ENERGY_DRAIN_PER_DAY, 0.0)

	# --- Determine new day's events ---

	# Rat spawning (using previous day's escalation)
	if randf() < RAT_SPAWN_BASE_CHANCE * rat_escalation:
		rat_count += 1
	if rat_count >= RAT_EVENT_THRESHOLD:
		rat_event_active = true

	# Darkness (flashlight stays at yesterday's object on event days)
	var prev_flashlight = flashlight_object
	var new_darkness = randf() < DARKNESS_CHANCE
	darkness_active = new_darkness
	if new_darkness:
		flashlight_object = prev_flashlight
	else:
		flashlight_object = FLASHLIGHT_OBJECTS[randi() % FLASHLIGHT_OBJECTS.size()]

	# Coldfront
	coldfront_active = randf() < COLDFRONT_CHANCE

	# Boiler decay
	if boiler_charge > 0 and randf() < BOILER_DECAY_CHANCE:
		boiler_charge -= 1

	# --- Refresh action points for new day ---
	action_points = get_max_actions()
