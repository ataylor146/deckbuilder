extends Node

const ENEMYHURT := preload("res://Sounds/enemy hurt.mp3")
const LOADGUN := preload("res://Sounds/cannon1,2,3,4.mp3")
const CELEBRATION := preload("res://Sounds/celebration.wav")

func sfx(stream: AudioStream, pitch_variation := 0.1) -> void:
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
