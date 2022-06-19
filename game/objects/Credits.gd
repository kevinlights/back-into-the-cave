extends Control

onready var button_back : Button = $Button_Back

var active : bool = true

signal closed

func _on_Button_Back_pressed() -> void:
	active = false
	emit_signal("closed")
