extends Node2D

signal body_collision

func _on_Area2D_area_entered(area):
	area.get_parent().get_parent().get_parent().die()
