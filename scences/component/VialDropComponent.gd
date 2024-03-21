extends Node

@export_range(0, 1) var drop_percent : float = .5
@export var vial_scence : PackedScene
@export var health_component : Node

func _ready():
	(health_component as HealthComponent).died.connect(on_died)
	

func on_died():
	if randf() > drop_percent:
		return 

	if vial_scence == null:
		return
		
	if not owner is Node2D:
		return
		
	var sqawn_position = (owner as Node2D).global_position
	var vial_instance = vial_scence.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = sqawn_position
