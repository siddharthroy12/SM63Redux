tool
extends Area2D

onready var sweep_effect = $"/root/Singleton/Warp" 
export var sweep_direction : Vector2
export var spawn_location : Vector2
export var scene_path : String
export var size : Vector2 setget set_size

func set_size(new_size):
	$CollisionShape2D.shape.extents = new_size
	size = new_size

func _on_WarpZone_body_entered(_body):
	sweep_effect.warp(sweep_direction, spawn_location, scene_path)
