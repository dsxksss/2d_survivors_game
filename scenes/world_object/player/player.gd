extends CharacterBody2D

# 移动速度
const MAX_SPEED = 125

# 加速度
const ACCELERATION_SMOOTHING = 25

# 基本受伤害扣血量
const BASE_HEALTH_DAMAGER = 1

# 伤害间隙计算时间器
@onready var damage_interval_timer = $DamageIntervalTimer
# 生命组件
@onready var health_component = $HealthComponent
# 碰撞组件
@onready var collision_area2D = $CollisionArea2D
# 生命条
@onready var health_bar:ProgressBar = $HealthBar

# 非玩家造成的身体碰撞数量
var number_colliding_bodies = 0

func _ready() -> void:
	# 当玩家身体被触发时
	collision_area2D.body_entered.connect(on_body_entered)
	# 当玩家身体被触发后离开触发时	
	collision_area2D.body_exited.connect(on_body_exited)
	# 当伤害检测器按时间检测时
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	# 当血量发生变化时
	health_component.health_changed.connect(on_health_changed)
	
	# 确保在游戏开始时就显示血量
	update_health_display()
	
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
	# 如果没有其他触碰玩家的对象、定时伤害检测器停止工作时，则不检查玩家是否死亡
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	# 玩家被攻击受到1点攻击
	health_component.damage(BASE_HEALTH_DAMAGER)
	# 重置伤害间隔计算时间
	damage_interval_timer.start()

func update_health_display():
	health_bar.value = health_component.get_health_percent()
		
func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1	

func on_damage_interval_timer_timeout():
	check_deal_damage()

func on_health_changed():
	update_health_display()
