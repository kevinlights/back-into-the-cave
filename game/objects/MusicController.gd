extends Node

onready var TRACKS : Dictionary = {
	"opening": $Audio_Opening,
	"cave": $Audio_Cave
}

func play_track(track_name : String) -> void:
	for track_name in TRACKS:
		TRACKS[track_name].stop()
	if track_name in TRACKS:
		TRACKS[track_name].play()
