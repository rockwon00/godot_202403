extends Node2D

@export var end_screen_scene: PackedScene

func _ready():
	$%Player.health_component.died.connect(on_player_died)

#로직 주의!! 메인씬이 로드되는 과정을 다시 한번 복기 	
func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	
