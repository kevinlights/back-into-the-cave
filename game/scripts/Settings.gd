extends Node

const FILENAME : String = "user://config.ini"
const REBINDABLE_KEYS : Array = ["up", "down", "left", "right", "jump"]

var fullscreen : bool
var vsync : bool
var star_density : int
var glow_amount : int
var glow_quality : int
var msaa : int
var volume_music : float
var volume_sfx : float
var volume_vo : float
var volume_ui : float
var subtitles : bool

func get_key_scancode_for_action(action_name : String) -> int:
	for event in InputMap.get_action_list(action_name):
		if event is InputEventKey:
			return event.scancode
	return -1

func clear_keybinds_for_action(action_name : String) -> void:
	for event in InputMap.get_action_list(action_name):
		if event is InputEventKey:
			InputMap.action_erase_event(action_name, event)

func add_keybind_to_action(action_name : String, scancode : int) -> void:
	var event : InputEventKey = InputEventKey.new()
	event.scancode = scancode
	InputMap.action_add_event(action_name, event)

func set_action_keybind(action_name : String, scancode : int) -> void:
	clear_keybinds_for_action(action_name)
	add_keybind_to_action(action_name, scancode)

func apply_settings() -> void:
	OS.window_fullscreen = fullscreen
	OS.vsync_enabled = vsync
	get_viewport().msaa = msaa

func set_bus_volume(bus_name : String, volume : float) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear2db(volume))

func apply_volumes() -> void:
	set_bus_volume("BGM", volume_music)
	set_bus_volume("SFX", volume_sfx)
	set_bus_volume("UI", volume_ui)
	set_bus_volume("VO", volume_vo)

func save_config() -> void:
	var config : ConfigFile = ConfigFile.new()
	config.set_value("graphics", "fullscreen", fullscreen)
	config.set_value("graphics", "vsync", vsync)
	config.set_value("graphics", "star_density", star_density)
	config.set_value("graphics", "glow_amount", glow_amount)
	config.set_value("graphics", "glow_quality", glow_quality)
	config.set_value("graphics", "msaa", msaa)
	config.set_value("audio", "volume_music", volume_music)
	config.set_value("audio", "volume_sfx", volume_sfx)
	config.set_value("audio", "volume_vo", volume_vo)
	config.set_value("audio", "volume_ui", volume_ui)
	config.set_value("audio", "subtitles", subtitles)
	for action_name in REBINDABLE_KEYS:
		var scancode : int = get_key_scancode_for_action(action_name)
		config.set_value("keybinds", action_name, scancode)
	config.save(FILENAME)

func load_config() -> void:
	var config : ConfigFile = ConfigFile.new()
	config.load(FILENAME)
	fullscreen = config.get_value("graphics", "fullscreen", false)
	vsync = config.get_value("graphics", "vsync", true)
	star_density = config.get_value("graphics", "star_density", 2)
	glow_amount = config.get_value("graphics", "glow_amount", 2)
	glow_quality = config.get_value("graphics", "glow_quality", 2)
	msaa = config.get_value("graphics", "msaa", 0)
	volume_music = config.get_value("audio", "volume_music", 1.0)
	volume_sfx = config.get_value("audio", "volume_sfx", 1.0)
	volume_vo = config.get_value("audio", "volume_vo", 1.0)
	volume_ui = config.get_value("audio", "volume_ui", 1.0)
	subtitles = config.get_value("audio", "subtitles", true)
	# Load keybindings
	for action_name in REBINDABLE_KEYS:
		var default_scancode : int = get_key_scancode_for_action(action_name)
		var scancode : int = config.get_value("keybinds", action_name, default_scancode)
		set_action_keybind(action_name, scancode)

func _enter_tree() -> void:
	load_config()
	apply_settings()
	apply_volumes()
