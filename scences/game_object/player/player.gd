extends CharacterBody2D

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent


var number_colliding_bodies = 0
var base_speed = 0

func _ready():
	base_speed = velocity_component.max_speed
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout) #강사추천 : 명시적으로 처리하는 별도의 함수를 사용하도록 해라
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()

func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)	
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func get_movement_vector():
	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)

func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped(): #충돌하는 물체의 수가 0이거나 타이머가 실행중인 경우
		return
	health_component.damage(1)
	damage_interval_timer.start()
	#print(health_component.current_health)
	
func update_health_display():
	health_bar.value = health_component.get_health_percent() 
	

func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()
	
	
func on_health_changed(): #시그널을 받아 건강 상태가 변동되면 작동할 기능
	GameEvents.emit_player_damaged()
	update_health_display()
	$RandomStreamPlayer2D.play_random()

func on_ability_upgrade_added(ability_upgrade : AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var _ability = ability_upgrade as Ability
		abilities.add_child(ability_upgrade.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)
