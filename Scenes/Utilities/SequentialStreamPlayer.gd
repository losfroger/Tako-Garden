# Plays the sounds in order one after the other
extends AudioStreamPlayer

export(Array, AudioStream) var streams 

var numberStream = 0

func play_next() -> void:
	if numberStream < len(streams):
		stream = streams[numberStream]
		self.play(0.0)
		
		numberStream = min(len(streams), numberStream + 1)

