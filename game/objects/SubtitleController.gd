extends Node

const SUBTITLES_PATH : String = "res://data/subtitles.json"

const SCENE_AUDIO : Dictionary = {
	"scene1": preload("res://sounds/vo/scene1.ogg"),
	"scene2": preload("res://sounds/vo/scene2.ogg"),
	"scene3": preload("res://sounds/vo/scene3.ogg")
}

export (NodePath) var path_label_subtitle
onready var label_subtitle : Label = get_node(path_label_subtitle)

onready var audio : AudioStreamPlayer = $AudioStreamPlayer

onready var subtitles : Dictionary = load_subtitles_file(SUBTITLES_PATH)

var current_scene : String = ""

func load_subtitles_file(path : String) -> Dictionary:
	var file : File = File.new()
	file.open(path, File.READ)
	var contents : String = file.get_as_text()
	file.close()
	var json : Dictionary = parse_json(contents)
	return json

func get_subtitles_for_scene(scene_name : String) -> Array:
	return subtitles[scene_name]

func subtitle_is_current(subtitle : Dictionary) -> bool:
	var point : float = audio.get_playback_position()
	return point >= subtitle["start"] and point < subtitle["end"]

func get_current_subtitle() -> String:
	if Settings.subtitles == false:
		return ""
	if not current_scene in SCENE_AUDIO:
		return ""
	for subtitle in get_subtitles_for_scene(current_scene):
		if subtitle_is_current(subtitle):
			return subtitle["line"]
	return ""

func play_scene(scene_name : String) -> void:
	audio.stream = SCENE_AUDIO[scene_name]
	current_scene = scene_name
	audio.play()

func _on_Timer_UpdateSubtitle_timeout() -> void:
	label_subtitle.text = get_current_subtitle()
