extends CharacterBody2D

@onready var damage_interval_timer = $DamageIntervalTimer

# 移动速度
const MAX_SPEED = 125
# 加速度
const ACCELERATION_SMOOTHING = 25

var number_colliding_bodies = 0

func _ready() -> void:
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)

# 获取玩家移动偏移量
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)

func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	# 基础移速
	var target_velocity = direction * MAX_SPEED
	# 添加加速度之后赋值给角色移动
	velocity = velocity.lerp(target_velocity,1 - exp(-delta * ACCELERATION_SMOOTHING))
	# 根据 velocity 移动该物体
	move_and_slide()
	
func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	$HealthComponent.damage(1)
	damage_interval_timer.start()
	print($HealthComponent.current_health)
	
func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1	

func on_damage_interval_timer_timeout():
	check_deal_damage()
