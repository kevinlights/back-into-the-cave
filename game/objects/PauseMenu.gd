extends Control

onready var vbox_menu : VBoxContainer = $VBox_Menu
onready var settings_menu : Control = $SettingsMenu

var active : bool = false

func unpause() -> void:
	get_tree().paused = false
	active = false
	hide()

func pause() -> void:
	get_tree().paused = true
	active = true
	show()

func _on_Button_Resume_pressed() -> void:
	unpause()

func _on_Button_Settings_pressed() -> void:
	vbox_menu.hide()
	settings_menu.show()
	settings_menu.active = true

func _on_Button_Exit_pressed() -> void:
	get_tree().quit()

func _on_SettingsMenu_closed() -> void:
	vbox_menu.show()
	settings_menu.hide()
	settings_menu.active = false

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("pause") and active:
		unpause()
		get_tree().set_input_as_handled()
