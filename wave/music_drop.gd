extends Node


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	drop_soundFX(load("res://Retro Action Loop #3.wav"))

func Random_soundFX_WithAtoms(SoundEffectArrat:Array,AudioVolume:float = 1.0, StartFrom:float = 0.0):
	#print("i was called")
	drop_soundFX_WithAtmos(SoundEffectArrat.pick_random(),AudioVolume, StartFrom)
	#print(SoundEffectArrat)

func drop_soundFX_WithAtmos(Sound:AudioStream,AudioVolume:float = 1.0, StartFrom:float = 0.0):
	var AudioBite = AudioStreamPlayer.new()
	var BiteStream = Sound
	add_child(AudioBite)
	AudioBite.set_bus("Atmos")
	AudioBite.set_stream(BiteStream)
	AudioBite.volume_db = AudioVolume
	AudioBite.pitch_scale = randf_range(0.95,1.05)
	AudioBite.play(StartFrom)
	await AudioBite.finished
	AudioBite.queue_free()
	
func drop_soundFX(Sound:AudioStream,AudioVolume:float = 1.0, StartFrom:float = 0.0):
	var AudioBite = AudioStreamPlayer.new()
	var BiteStream = Sound
	add_child(AudioBite)
	AudioBite.set_bus("SoundEffects")
	AudioBite.set_stream(BiteStream)
	AudioBite.volume_db = AudioVolume
	AudioBite.pitch_scale = randf_range(0.95,1.05)
	AudioBite.play(StartFrom)
	await AudioBite.finished
	AudioBite.queue_free()

func drop_soundFX_No_Pitch_Change(Sound:AudioStream,AudioVolume:float = 1.0, StartFrom:float = 0.0):
	var AudioBite = AudioStreamPlayer.new()
	var BiteStream = Sound
	add_child(AudioBite)
	AudioBite.set_bus("SoundEffects")
	AudioBite.set_stream(BiteStream)
	AudioBite.volume_db = AudioVolume
	AudioBite.pitch_scale = 1
	AudioBite.play(StartFrom)
	await AudioBite.finished
	AudioBite.queue_free()
