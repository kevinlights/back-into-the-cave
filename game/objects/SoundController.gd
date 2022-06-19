extends Node

onready var SOUNDS : Dictionary = {
	"coin": $Audio_Coin,
	"get_key": $Audio_GetKey,
	"jump": $Audio_Jump,
	"land": $Audio_Land,
	"miss": $Audio_Miss,
	"step": $Audio_Step
}

func play_sound(sound_name : String) -> void:
	if sound_name in SOUNDS:
		SOUNDS[sound_name].play()
	else:
		printerr("Sound %s does not exist" % sound_name)
