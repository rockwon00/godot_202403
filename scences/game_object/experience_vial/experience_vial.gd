extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
#	rotation = direction_from_start.angle()
	rotation_degrees = rad_to_deg(direction_from_start.angle()) + 90
	


func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true


func on_area_entered(other_area: Area2D):
	# 함수를 호출하도록 예약, 함수는 현재 프레임의 나머지 부분이 처리 된 후에 실행 됨 
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	# tween의 모든 작업을 동시에 실행하도록 설정, 아래애서는 tween_method 와 tween_property가 병렬수행됨 
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .15).set_delay(.35)
	# 현재 작업을 완료한 후 다음 작업을 실행
	tween.chain()
	tween.tween_callback(collect)
	
	$RandomStreamPlayer2D.play_random()
