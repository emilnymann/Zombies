extends Node2D

onready var anim = $AnimationPlayer

func open():
	anim.play("Open")