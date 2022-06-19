extends Control

onready var label_time : Label = $VBox/Label_Time
onready var label_deaths : Label = $VBox/Label_Deaths
onready var label_coins : Label = $VBox/Label_Coins
onready var anim_player : AnimationPlayer = $AnimationPlayer

func play_ending(minutes : int, seconds : int, deaths : int, coins : int) -> void:
	label_time.text = "Your time was %d %s, %d %s." % [minutes, "minute" if minutes == 1 else "minutes", seconds, "second" if seconds == 1 else "seconds"]
	label_deaths.text = "You died %d %s." % [deaths, "time" if deaths == 1 else "times"]
	label_coins.text = "You collected %d out of 15 coins." % coins
	anim_player.play("ending")
