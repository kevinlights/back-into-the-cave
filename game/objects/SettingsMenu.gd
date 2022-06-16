extends Control

onready var checkbox_fullscreen : CheckBox = $Center/TabContainer/Graphics/Grid/CheckBox_Fullscreen
onready var checkbox_vsync : CheckBox = $Center/TabContainer/Graphics/Grid/CheckBox_VSync
onready var option_star_density : OptionButton = $Center/TabContainer/Graphics/Grid/OptionButton_StarDensity
onready var option_glow_amount : OptionButton = $Center/TabContainer/Graphics/Grid/OptionButton_GlowAmount
onready var option_glow_quality : OptionButton = $Center/TabContainer/Graphics/Grid/OptionButton_GlowQuality
onready var option_msaa : OptionButton = $Center/TabContainer/Graphics/Grid/OptionButton_MSAA
onready var slider_bgm : HSlider = $Center/TabContainer/Audio/Grid/HSlider_BGM
onready var slider_sfx : HSlider = $Center/TabContainer/Audio/Grid/HSlider_SFX
onready var slider_vo : HSlider = $Center/TabContainer/Audio/Grid/HSlider_VO
onready var slider_ui : HSlider = $Center/TabContainer/Audio/Grid/HSlider_UI
onready var checkbox_subtitles : CheckBox = $Center/TabContainer/Audio/Grid/CheckBox_Subtitles
onready var button_left : Button = $Center/TabContainer/Controls/Grid/Button_Left
onready var button_right : Button = $Center/TabContainer/Controls/Grid/Button_Right
onready var button_forwards : Button = $Center/TabContainer/Controls/Grid/Button_Forwards
onready var button_backwards : Button = $Center/TabContainer/Controls/Grid/Button_Backwards
onready var button_jump : Button = $Center/TabContainer/Controls/Grid/Button_Jump
onready var button_back : Button = $Button_Back

var active : bool = true
var rebinding : bool = false
var rebinding_action : String

signal closed

func set_stuff() -> void:
	checkbox_fullscreen.pressed = Settings.fullscreen
	checkbox_vsync.pressed = Settings.vsync
	option_star_density.selected = Settings.star_density
	option_glow_amount.selected = Settings.glow_amount
	option_glow_quality.selected = Settings.glow_quality
	option_msaa.selected = Settings.msaa
	slider_bgm.value = Settings.volume_music
	slider_sfx.value = Settings.volume_sfx
	slider_vo.value = Settings.volume_vo
	slider_ui.value = Settings.volume_ui
	checkbox_subtitles.pressed = Settings.subtitles

func set_rebinding_labels() -> void:
	button_left.text = OS.get_scancode_string(Settings.get_key_scancode_for_action("left"))
	button_right.text = OS.get_scancode_string(Settings.get_key_scancode_for_action("right"))
	button_forwards.text = OS.get_scancode_string(Settings.get_key_scancode_for_action("up"))
	button_backwards.text = OS.get_scancode_string(Settings.get_key_scancode_for_action("down"))
	button_jump.text = OS.get_scancode_string(Settings.get_key_scancode_for_action("jump"))

func rebind_key(action_name : String, scancode : int) -> void:
	Settings.set_action_keybind(action_name, scancode)
	Settings.save_config()

func _on_CheckBox_Fullscreen_toggled(button_pressed : bool) -> void:
	Settings.fullscreen = button_pressed
	Settings.apply_settings()
	Settings.save_config()

func _on_CheckBox_VSync_toggled(button_pressed : bool) -> void:
	Settings.vsync = button_pressed
	Settings.apply_settings()
	Settings.save_config()

func _on_OptionButton_StarDensity_item_selected(index : int) -> void:
	Settings.star_density = index
	Settings.save_config()
	get_tree().call_group("game", "apply_star_quantity")

func _on_OptionButton_GlowAmount_item_selected(index : int) -> void:
	Settings.glow_amount = index
	Settings.save_config()
	get_tree().call_group("game", "apply_graphics_settings")

func _on_OptionButton_GlowQuality_item_selected(index : int) -> void:
	Settings.glow_quality = index
	Settings.save_config()
	get_tree().call_group("game", "apply_graphics_settings")

func _on_OptionButton_MSAA_item_selected(index : int) -> void:
	Settings.msaa = index
	Settings.apply_settings()
	Settings.save_config()

func _on_HSlider_BGM_value_changed(value : float) -> void:
	Settings.volume_music = value
	Settings.apply_volumes()
	Settings.save_config()

func _on_HSlider_SFX_value_changed(value : float) -> void:
	Settings.volume_sfx = value
	Settings.apply_volumes()
	Settings.save_config()

func _on_HSlider_VO_value_changed(value : float) -> void:
	Settings.volume_vo = value
	Settings.apply_volumes()
	Settings.save_config()

func _on_HSlider_UI_value_changed(value : float) -> void:
	Settings.volume_ui = value
	Settings.apply_volumes()
	Settings.save_config()

func _on_CheckBox_Subtitles_toggled(button_pressed : bool) -> void:
	Settings.subtitles = button_pressed
	Settings.save_config()

func _on_Button_Left_pressed() -> void:
	button_left.text = "..."
	rebinding_action = "left"
	rebinding = true

func _on_Button_Right_pressed() -> void:
	button_right.text = "..."
	rebinding_action = "right"
	rebinding = true

func _on_Button_Forwards_pressed() -> void:
	button_forwards.text = "..."
	rebinding_action = "up"
	rebinding = true

func _on_Button_Backwards_pressed() -> void:
	button_backwards.text = "..."
	rebinding_action = "down"
	rebinding = true

func _on_Button_Jump_pressed() -> void:
	button_jump.text = "..."
	rebinding_action = "jump"
	rebinding = true

func _on_Button_Back_pressed() -> void:
	active = false
	emit_signal("closed")

func _input(event : InputEvent) -> void:
	if not active: return
	# Rebinding?
	if rebinding and event is InputEventKey and event.pressed:
		rebind_key(rebinding_action, event.scancode)
		set_rebinding_labels()
		rebinding = false
		get_tree().set_input_as_handled()

func _ready() -> void:
	set_stuff()
	set_rebinding_labels()
