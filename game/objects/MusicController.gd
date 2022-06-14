extends Node

onready var TRACKS : Dictionary = {
	"opening": $Audio_Opening
}

func play_track(track_name : String) -> void:
	if track_name in TRACKS:
		TRACKS[track_name].play()
